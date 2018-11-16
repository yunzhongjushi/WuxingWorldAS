package com.view.UI.friend {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.conn.ServerVO_5;
	import com.model.vo.friend.FriendListVO;
	import com.model.vo.friend.FriendVO;
	import com.view.BasePanel;
	import com.view.UI.loot.LootPanel;
	import com.view.UI.mail.MailPanel;
	import com.view.UI.playerEditor.PlayerEditorPanel;
	
	import flas.events.MouseEvent;
	
	import flash.events.Event;

	/**
	 * 好友面板
	 * @author 饶境
	 */
	public class FriendPanel extends BasePanel {
		public static const NAME:String="FriendPanel";
		public static function getShowName(vo:FriendVO):String{
			ServerVO_5.get_friend();
			return NAME;
		}
		private static const SINGLETON_MSG:String="single_FriendPanel_only";
		private static var instance:FriendPanel;
		public static function getInstance():FriendPanel {
			if(instance==null)
				instance=new FriendPanel();
			return instance as FriendPanel;
		}
		
		
		
		public var friendInfoBox:FriendInfoBox;
		public var friendList:FriendList;
		public var friendAddBox:FriendAddBox;
		
		public var friendListVO:FriendListVO;
		private var running_addFriendNickName:String;

		
		/**
		 *
		 *
		 */
		public function FriendPanel() {
			if(instance!=null)
				throw Error(SINGLETON_MSG);
			instance=this;
			
			init();
			
			friendListVO = FriendListVO.getInstance();
			friendListVO.addEventListener(FriendListVO.ADD_FRIEND_INFO, updateInfo);
			friendListVO.addEventListener(FriendListVO.UPDATE_FRIEND_INFO, updateInfo);
			
		}

		private function init():void {
			friendAddBox.close();
			friendInfoBox.close();
			
			friendAddBox.addEventListener(FriendAddBox.E_AddFriend, onAddFriend);
			friendList.addEventListener(FriendList.E_Close, close);
			friendList.addEventListener(FriendList.E_OPEN_ADD, onOpenAddBox);
			
			friendInfoBox.addEventListener(FriendInfoBox.E_SHOW_GUARD, onOpenGuardInfoPanel);

			this.addEventListener(MouseEvent.CLICK, onClick);

			this.addEventListener(Event.ADDED_TO_STAGE, handle_addToStage);
		}

		protected function handle_addToStage(event:Event):void {
			friendInfoBox.close();
		}

		private function onClick(e:*):void {
			if(e.target is FriendBar) {// 点击朋友条时
				var bar:FriendBar = e.target as FriendBar;
				if(bar.running_target==bar.btn_energy) {// 点击 *赠送* 
					bar.btn_energy.setUsed();
					EventCenter.event(ApplicationFacade.SHOW_PANEL, PlayerEditorPanel.NAME);
				}

				if(bar.running_target==bar) {// 点击 *整个条* 
					var vo:FriendVO = bar.running_vo as FriendVO;
					friendInfoBox.updateInfo(vo);
					this.addChild(friendInfoBox);
				}
			}
		}

		private function handle_btn_mail(e:Event):void {
			event("handle_btn_mail");
		}

		private function onAddFriend(e:ObjectEvent):void {
			var nickName:String  =e.data as String;
			running_addFriendNickName = nickName;
			ServerVO_5.add_friend(nickName); 
		}

		private function onOpenAddBox(e:ObjectEvent):void {
			this.addChild(friendAddBox);
			friendAddBox.updateInfo("");
		}

		/**
		 * 打开防守阵容面板
		 * @param e
		 */
		private function onOpenGuardInfoPanel(e:ObjectEvent):void {
			EventCenter.event(ApplicationFacade.SHOW_PANEL, LootPanel.getShowName(e.data as FriendVO));
		}

		/**
		 * 
		 * @param e
		 * 
		 */
		private function updateInfo(e:ObjectEvent):void {
			if(friendListVO.friendList.length>0){
				friendList.updateInfo(friendListVO.friendList);
			}else{
				this.addChild(friendAddBox);
				friendAddBox.updateInfo("没有找到“"+running_addFriendNickName+"”");
			}
		}
	}
}
