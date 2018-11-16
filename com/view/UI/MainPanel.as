package com.view.UI {
	import com.model.ApplicationFacade;
	import com.greensock.TweenLite;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.user.UserVO;
	import com.view.BasePanel;
	import com.view.UI.animation.GuideMissionContainer;
	import com.view.UI.main.MainButtonPanel;
	import com.view.UI.tip.GuidePanel;
	import com.view.UI.user.UserInfoPanel;
	
	import flas.display.StageAlign;
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * 
	 * @author hunterxie
	 */
	public class MainPanel extends BasePanel {
		public static const NAME:String = "MainPanel";
		public static const SINGLETON_MSG:String="single_MainPanel_only";
		protected static var instance:MainPanel;
		public static function getInstance():MainPanel{
			if ( instance == null ) instance=new MainPanel();
			return instance;
		}
		
		public static const FIGHT_START_SIMPLE:String="FIGHT_START_SIMPLE";
		public static const FIGHT_START_MULTIPLE:String="FIGHT_START_MULTIPLE";
		
		public var mc_loginPanel:LoginPanel;
		public var mc_userInfoPanel:UserInfoPanel;
		public var mc_mainButtonPanel:MainButtonPanel;
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		/**
		 * 首次登录成功
		 */
		private var loginSuccess:Boolean = false;
		
		
		/**
		 * 
		 * 
		 */
		public function MainPanel() {
			super(false);
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this; 
			
			this.visible = false;
			this.alignInfo = StageAlign.BOTTOM;
			mc_userInfoPanel.visible=false;
			mc_mainButtonPanel.visible=false;
			
			EventCenter.on(ApplicationFacade.UPDATE_USER_INFO, this, updateUserInfo);
			EventCenter.on(ApplicationFacade.GUIDE_BIG_MAP_ENTER, this, onStart);
			EventCenter.on(ApplicationFacade.CONNECT_SUCCESS, this, onStartFirst);
		}
		
//		override public function set x(value:Number):void{
//			trace(this, this.x, this.y);
//		}
		
		public function updateUserInfo(e:ObjectEvent=null):void{
			mc_userInfoPanel.updateInfo();
		}
		
		/** 
		 * 已有登录用户进入游戏
		 * @param event
		 */
		public function onStartFirst(event:ObjectEvent):void{
			if(!loginSuccess){
				loginSuccess = true;
				mc_bg.visible = false;
				mc_loginPanel.visible = false;
				if(userInfo.getGuide(GuidePanel.newUserPassNum)==0 && BaseInfo.isTestPlot){
					for(var i:int=0; i<GuidePanel.newUserPassNum; i++){
						userInfo.guides[i]=0;
					}
					EventCenter.event(ApplicationFacade.GUIDE_MISSION_SHOW, GuideMissionContainer.CutsceneTitle);
				}
				EventCenter.event(ApplicationFacade.GUIDE_BIG_MAP_ENTER);
			}
		}
		public function onStart(e:ObjectEvent=null):Boolean{
			mc_userInfoPanel.visible=true;
			mc_mainButtonPanel.visible=true;
			if(!mc_mainButtonPanel.showBtns) mc_mainButtonPanel.onSetting();
			updateUserInfo();
			return true;
		}
		
		protected function onRoleChooseOver(event:*):void {
			visible=false;
		}
		
		public function showBG():void{
			this.mc_bg.alpha = 0;
			TweenLite.to(mc_bg, 1, {alpha:1, onComplete:showOver});
			function showOver():void{
				
			}
		}
	}
}