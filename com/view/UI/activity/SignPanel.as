package com.view.UI.activity {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.PanelPointShowVO;
	import com.model.vo.activity.SignInfoVO;
	import com.model.vo.activity.SignItemVO;
	import com.model.vo.conn.ServerVO_194;
	import com.model.vo.conn.ServerVO_195;
	import com.model.vo.task.TaskRewardVO;
	import com.view.BasePanel;
	import com.view.UI.tip.RewardTipPanel;
	
	import flas.events.MouseEvent;
	
	import flash.text.TextField;

	/**
	 * 签到奖励面板
	 * @author raojing
	 */
	public class SignPanel extends BasePanel {
		public static const NAME:String="SignPanel";
		private static const SINGLETON_MSG:String="single_SignPanelPanel_only";
		private static var instance:SignPanel;
		public static function getInstance():SignPanel {
			if(instance==null)
				instance=new SignPanel();
			return instance;
		}

		public var serverVO_195:ServerVO_195;
		public var serverVO_194:ServerVO_194;
		
		/**
		 * 
		 * 
		 */		
		public function SignPanel() {
			if(instance!=null)
				throw Error(SINGLETON_MSG);
			instance=this;
			this.addEventListener(MouseEvent.CLICK, handle_onBar);
			
			EventCenter.on(ApplicationFacade.SHOW_PANEL, this, onShow);
			
			serverVO_195 = ServerVO_195.getInstance();
			serverVO_195.on(ApplicationFacade.SERVER_INFO_OBJ, this, updateInfo);
			
			serverVO_194 = ServerVO_194.getInstance();
			serverVO_194.on(ApplicationFacade.SERVER_INFO_OBJ, this, update194);
		}
		
		private function update194(e:ObjectEvent):void{
			PanelPointShowVO.showPointGuide(SignPanel.NAME, false);
			markIsOK();
			var reward:TaskRewardVO = new TaskRewardVO;
			reward.itemVOList.push(running_signVO);
			RewardTipPanel.showReward(reward, RewardTipPanel.TITLE_REWARD);
		}
		
		
		private function onShow(e:ObjectEvent):void{
			if(e.data==SignPanel.NAME){
				ServerVO_195.get_sign_info();
			}
		}
		/**
		 *
		 */
		public static const GET_INFO:String="GET_INFO";

		
		public var tf_month:TextField;
		public var tf_times:TextField;
		public var signListPanel:SignListPanel
		//
		public var isLoad:Boolean=false;
		//running
		private var running_tag:int;

		private var mSignInfo:SignInfoVO;

		/**
		 *
		 *
		 */
		private function init():void {
			
		}

		private function handle_onBar(e:*):void {
			if(e.target is SignBar) {
				var bar:SignBar = e.target as SignBar;
				running_signVO = bar.running_vo;

				if(running_signVO.status==SignItemVO.AVAILABLE) {
					ServerVO_194.sign_up();
				}
			}
		}
		private var updateFnArr:Array=[];

		/**
		 * 外调函数
		 * @param infoVO
		 */
		public function updateInfo(e:ObjectEvent):void {
			if(serverVO_195.signInfoVO.canGetReward) {
				PanelPointShowVO.showPointGuide(SignPanel.NAME, true);
			}
			mSignInfo = e.data as SignInfoVO;
			signListPanel.updateInfo(mSignInfo.getSignBarVoList());

			tf_times.text = String(mSignInfo.markNO);
			tf_month.text = String((new Date()).month+1);
		}

		public function open():void {
			if(!isLoad) {
				event(GET_INFO);
			} else {
			}
		}
		public var running_signVO:SignItemVO;

		public function markIsOK():void {
			running_signVO.updateSign();
			signListPanel.updateInfo(mSignInfo.getSignBarVoList());
			
			tf_times.text = String(running_signVO.signID);
			tf_month.text = String((new Date()).month+1);
		}
	}
}
