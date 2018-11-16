package com.view.UI.main {
	import com.model.ApplicationFacade;
	import com.greensock.TweenLite;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.PanelPointShowVO;
	import com.model.vo.task.taskListVO;
	import com.model.vo.user.UserVO;
	import com.view.BasePanel;
	import com.view.UI.SettingPanel;
	import com.view.UI.achievement.AchievementPanel;
	import com.view.UI.activity.SignPanel;
	import com.view.UI.altar.AltarPanel;
	import com.view.UI.challenge.ChallengePanel;
	import com.view.UI.fairy.FairyPanel;
	import com.view.UI.friend.FriendPanel;
	import com.view.UI.item.ItemPanel;
	import com.view.UI.loot.LootPanel;
	import com.view.UI.mail.MailPanel;
	import com.view.UI.playerEditor.PlayerEditorPanel;
	import com.view.UI.shop.ShopPanel;
	import com.view.UI.task.TaskPanel;
	import com.view.UI.tip.MopupPanel;
	import com.view.UI.user.WuxingInfoPanel;
	import com.view.touch.TouchButton;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;

	/**
	 * 主界面按钮面板
	 * @author hunterxie
	 */
	public class MainButtonPanel extends BasePanel{
		public static const NAME:String = "MainButtonPanel";
		public static const SINGLETON_MSG:String="single_MainButtonPanel_only";
		protected static var instance:MainButtonPanel;
		public static function getInstance():MainButtonPanel{
			if ( instance == null ) instance=new MainButtonPanel();
			return instance as MainButtonPanel;
		}
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		/**
		 * 
		 */
		public var showBtns:Boolean = false;
		private function getBtnShow(name:String):Boolean{
			return userInfo.getOpenBtn(name) && showBtns;
		}
		
		public var btn_btnBox:MovieClip;
		
		public var btn_PK:TouchButton;//TODO 竞技场面板
		public var btn_fairyPanel:TouchButton;
		public var btn_wuxingPanel:TouchButton;
		public var btn_firends:TouchButton;
		public var btn_system:TouchButton;
		public var btn_mission:TouchButton;
		public var btn_item:TouchButton;
		public var btn_shop:TouchButton;
		public var btn_altar:TouchButton;
		
		public var btn_loot:TouchButton;
		public var btn_playerEditor:TouchButton;
		
		public var btn_sign:TouchButton;
		public var btn_achievement:TouchButton;
		public var btn_mail:TouchButton;
		
		/**
		 * 是否显示，没有开启的功能就不显示
		 */
		private var visiteShow:Object = {};
		
		private var btns:Array = [];
		
		private var pointShowVO:PanelPointShowVO;
		
		
		public function MainButtonPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this; 
			
			btn_PK.panelName = ChallengePanel.NAME;
			btn_fairyPanel.panelName = FairyPanel.NAME;
			btn_wuxingPanel.panelName = WuxingInfoPanel.NAME;
			btn_firends.panelName = FriendPanel.NAME;
			btn_system.panelName = SettingPanel.NAME;
			btn_mission.panelName = TaskPanel.NAME;
			btn_item.panelName = ItemPanel.NAME;
			btn_shop.panelName = ShopPanel.NAME;
			btn_altar.panelName = AltarPanel.NAME;
			btn_achievement.panelName = AchievementPanel.NAME;
			btn_mail.panelName = MailPanel.NAME;
			btn_loot.panelName = LootPanel.NAME;
			btn_sign.panelName = SignPanel.NAME;
			btn_playerEditor.panelName = PlayerEditorPanel.NAME;
//			btn_loot.panelName = TipFairyPanel.NAME;
			btn_loot.panelName	= MopupPanel.NAME;
			
			for(var i:int=0; i<this.numChildren; i++){
				var btn:TouchButton = this.getChildAt(i) as TouchButton;
				if(btn){
					btn.visible = getBtnShow(btn.panelName);
					btns.push(btn);
					btns[btn.panelName] = btn;
				}
			}
			
			btn_btnBox.mc_showPoint.visible=false;
			btn_btnBox.addEventListener(MouseEvent.CLICK, onSetting);
			
			this.addEventListener(MouseEvent.CLICK, onclick);
			
			pointShowVO = PanelPointShowVO.getInstance();
			pointShowVO.on(PanelPointShowVO.SHOW_PANEL_POINT_GUIDE, this, updatePointShow);
			
			EventCenter.on(ApplicationFacade.QUEST_INFO_UPDATE, this, onQuestUpdate);
		}
		
		private function onQuestUpdate(e:ObjectEvent):void{
			if(taskListVO.canGetReward) {
				PanelPointShowVO.showPointGuide(AchievementPanel.NAME, true);
				PanelPointShowVO.showPointGuide(TaskPanel.NAME, true);
			}
		}
		
		private function onclick(e:*):void{
			if(e.target is TouchButton)
				EventCenter.event(ApplicationFacade.SHOW_PANEL, e.target.panelName);
		}
		
		public function onSetting(e:*=null):void{
			showBtns = !showBtns;
			
			btn_btnBox.gotoAndStop(showBtns?2:1);
			for(var i:int=0; i<btns.length; i++){
				var btn:TouchButton = btns[i] as TouchButton;
				btn.visible = getBtnShow(btn.panelName);
			}
		}
		
		/**
		 * 激活某个按钮的展示
		 * @param vo
		 */
		public function updateBtnShow(panelName:String):void{
			var btn:TouchButton = btns[panelName] as TouchButton;
			if(btn){
				userInfo.setOpenBtn(btn.panelName);
				btn.isOpen = true;
				btn.scaleX = btn.scaleY = 0;
				TweenLite.to(btn, 0.8, {scaleX:1, scaleY:1});
			}
			if(!showBtns) onSetting();
		}
		
		/**
		 * 更新小红点展示状态
		 * @param vo
		 */
		public function updatePointShow(e:ObjectEvent):void{
			if(btns[pointShowVO.kind]){
				btns[pointShowVO.kind].mc_showPoint.visible = pointShowVO.isShow;
			}
			for(var i:int=0; i<btns.length; i++){
				var btn:TouchButton = btns[i] as TouchButton;
				if(btn.panelName && btn.mc_showPoint.visible){
					btn_btnBox.mc_showPoint.visible=true;
					return;
				}
			}
			btn_btnBox.mc_showPoint.visible=false;
		}
	}
}
