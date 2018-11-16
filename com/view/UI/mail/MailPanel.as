package com.view.UI.mail {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.proxy.mail.MailProxy;
	import com.model.vo.conn.ServerVO_10;
	import com.model.vo.conn.ServerVO_6;
	import com.model.vo.conn.ServerVO_7;
	import com.model.vo.conn.ServerVO_9;
	import com.model.vo.mail.MailVO;
	import com.view.BasePanel;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * 信件面板
	 * @author 饶境
	 */
	public class MailPanel extends BasePanel {
		public static const NAME:String="MailPanel";
		public static function getShowName(name:String="", refresh:Boolean=false):String{
			if(name){
				instance.onOpenWriter(name);
			}else if(refresh){
				//收邮件
			}
			return NAME;
		}
		private static const SINGLETON_MSG:String="single_MailPanel_only";
		private static var instance:MailPanel;
		public static function getInstance():MailPanel {
			if(instance==null)
				instance=new MailPanel();
			return instance as MailPanel;
		}

		/**
		 *收取附件
		 */
		public static const GET_ATTACHMENT:String="GET_ATTACHMENT";



		public var mailProxy:MailProxy;
		public var mailList:MailList;
		public var writer:MailWriter;
		public var mailInfoBox:MailInfoBox;

		public var tf_title:TextField;
		public var mail_bg:MovieClip;
		//running
		private var running_vo:MailVO;
		private var running_markList:Array=[];

		private var running_isWrite:Boolean;

		/**
		 *
		 *
		 */
		public function MailPanel() {
			if(instance!=null)
				throw Error(SINGLETON_MSG);
			instance=this;
			init();
			this.addEventListener(Event.ADDED_TO_STAGE, handle_add);
			this.addEventListener(Event.REMOVED_FROM_STAGE, handle_remove);
			
			mailProxy = MailProxy.getInstance();
			mailProxy.on(MailProxy.MAIL_RECEIVE_INFO, this, updateInfo);
			
			
//			ServerVO_6.on(ApplicationFacade.SERVER_INFO_OBJ, this, openMailContent);
		}

		protected function handle_remove(e:Event):void {
			onMark();
		}

		protected function handle_add(e:Event):void {
			if(running_isWrite) {
				tf_title.visible = mail_bg.visible = false;
				btn_close.visible=false;
			} else {
				tf_title.visible = mail_bg.visible = true;
				btn_close.visible=true;
			}

			running_isWrite=false;
		}

		private function init():void {
			running_isWrite=false;
			writer.close();
			mailInfoBox.close();

			mailList.addEventListener(MailList.E_Close, onClose);
			
			mailInfoBox.addEventListener(MailInfoBox.E_Delete, onDeleteMail);
			mailInfoBox.addEventListener(MailInfoBox.E_Reply, onReply);
			mailInfoBox.addEventListener(MailInfoBox.E_GetAttachment, onGetAttachment);
			// 
			writer.addEventListener(MailWriter.E_Send, onSend);
			writer.addEventListener(MailWriter.E_Close, onClose);
			this.addEventListener(MouseEvent.CLICK, onMailBar);
		}

		private var tOpenMailVO:MailVO;

		private function onMailBar(e:*):void {
			if(e.target is MailBar) {
				var bar:MailBar = e.target as MailBar;
				tOpenMailVO = bar.running_vo as MailVO;

				if(tOpenMailVO.getIsContainItem()) {
					getAttachment(tOpenMailVO);
				} else {
					openMailContent()
				}
			}
		}

		public function openMailContent():void {
			if(tOpenMailVO) {
				mailInfoBox.updateInfo(tOpenMailVO);
				running_markList.push(tOpenMailVO);
				tOpenMailVO.isRead=true;
				mailList.refreshVOList();
				addChild(mailInfoBox);

				tOpenMailVO.getAttachment();
				tOpenMailVO=null;
			}
		}

		private function onClose(e:ObjectEvent):void {
			onMark();
			close();
		}

		private function onDeleteMail(e:ObjectEvent):void {
			var mailVO:MailVO=e.data as MailVO
			if(mailVO==null) {
				trace("* onDeleteMail: mailID=null");
				return
			}
			var deleteArr:Array=[mailVO.mailID];
			onMark();
			ServerVO_10.getSendInfo(deleteArr);
			updateInfoByDelete(mailVO.mailID)
		}

		private function onReply(e:ObjectEvent):void {
			addChild(writer);
			var mailVO:MailVO=e.data as MailVO
			writer.updateInfo(mailVO);
		}

		private function onSend(e:ObjectEvent):void {
			var mailVO:MailVO=e.data as MailVO
			onMark();
			ServerVO_9.getSendInfo(mailVO);
		}

		private function onGetAttachment(e:ObjectEvent):void {
			var mailVO:MailVO=e.data as MailVO
			running_vo=mailVO;
			onMark();
			ServerVO_6.getSendInfo(mailVO);
		}

		//回调函数
		//外调函数
		/**
		 * 更新数据
		 * @param voList
		 *
		 */
		public function updateInfo():void {
			running_isWrite=false;
			addChild(mailList);
			mailList.updateInfo(mailProxy.mailList);
		}

		/**
		 * 收到来自好友面板的请求，只打开写邮件面板
		 */
		public function onOpenWriter(receiver:String):void {

			running_isWrite=true;

			mailList.close();
			this.addChild(writer);
			var mailVO:MailVO=MailVO.genFriendMail("", receiver);
			writer.updateInfo(mailVO, true);
		}

		public function updateInfoByDelete(mailID:int):void {
			var i:int
			for(i=0; i<mailProxy.mailList.length; i++) {
				var one:MailVO=mailProxy.mailList[i] as MailVO;
				if(one.mailID==mailID) {
					if(mailProxy.mailList.length==1) {
						mailProxy.mailList.pop();
					} else {
						mailProxy.mailList.splice(i, 1);
					}
				}
			}
			updateInfo();
		}

		public function directOpenMailInfoBox():void {
			mailInfoBox.updateInfo(null);
		}

		public function getAttachment(mailVO:MailVO):void {
			event(GET_ATTACHMENT, mailVO);
			updateInfo();
		}


		public function onGiveEnerygToFriend(mailVO:MailVO):void {
			ServerVO_9.getSendInfo(mailVO);
		}

		private function onMark():void {
			if(running_markList.length==0) {
				return;
			}
			for(var i:int=0; i<running_markList.length; i++) {
				var mail:MailVO=running_markList[i] as MailVO
				var id:int=mail.mailID;
				if(true==mail.isRead) {
					ServerVO_7.getSendInfo({id:id});
				}
			}
			running_markList=[];
		}

		private function getVOofRunning(mailId:int):MailVO {
			for(var i:int=0; i<mailProxy.mailList.length; i++) {
				var vo:MailVO=mailProxy.mailList[i] as MailVO;
				if(vo.mailID==mailId) {
					return vo;
				}
			}
			return null;
		}
	}
}
