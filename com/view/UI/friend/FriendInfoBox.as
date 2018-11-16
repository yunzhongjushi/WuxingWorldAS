package com.view.UI.friend {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.friend.FriendVO;
	import com.model.vo.item.ItemVO;
	import com.view.BasePanel;
	import com.view.UI.achievement.AchievementPanel;
	import com.view.UI.item.ItemBarMiddle;
	import com.view.UI.mail.MailPanel;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.text.TextField;

	public class FriendInfoBox extends BasePanel {
		public var btn_invite:CommonBtn;
		public var btn_beInvite:CommonBtn;
		
		public function FriendInfoBox() {
			btn_achievement.setNameTxt("成  就");
			btn_achievement.on(MouseEvent.CLICK, this, onAchieve);
			
			btn_write.setNameTxt("写邮件");
			btn_write.on(MouseEvent.CLICK, this, onWrite);
			
			btn_invite.setNameTxt("邀  战");
			
			btn_beInvite.setNameTxt("接受邀战");
		}

		public function onWrite(e:*):void {
			EventCenter.event(ApplicationFacade.SHOW_PANEL, MailPanel.getShowName(friendVO.nickName));
		}

		public function onAchieve(e:*):void {
			EventCenter.event(ApplicationFacade.SHOW_PANEL, AchievementPanel.getShowName(friendVO));
		}
		//****************   以上为模板，请勿随意改动。   *******************************
		//Function Names 
		public static const E_SHOW_GUARD:String="E_SHOW_GUARD";
		//场景含有组件
		public var header:ItemBarMiddle;
		public var btn_write:CommonBtn;
		public var btn_achievement:CommonBtn;
		public var tf_nickName:TextField;
		public var tf_lv:TextField;
		public var tf_achiPoint:TextField
		//
		private var friendVO:FriendVO;

		public function updateInfo(vo:FriendVO):void {
			if(friendVO){
				if(friendVO==vo){
					friendVO.removeEventListener(FriendVO.UPDATE_FRIEND_INFO, onUpdate);
					friendVO = vo;
					friendVO.addEventListener(FriendVO.UPDATE_FRIEND_INFO, onUpdate);
				}
			}
			onUpdate();
		}
		private function onUpdate(e:ObjectEvent=null):void{
			tf_nickName.text = friendVO.nickName
			tf_lv.text = friendVO.getLevelStr();
			tf_achiPoint.text = friendVO.getAchiPointStr();
			
			header.updateInfo(new ItemVO(30000));
			
			this.btn_beInvite.visible = friendVO.isInvite;
		}
	}
}
