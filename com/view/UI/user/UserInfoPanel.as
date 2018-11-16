package com.view.UI.user {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.config.shop.ShopItemConfigVO;
	import com.model.vo.user.UserVO;
	import com.view.BaseImgBar;
	import com.view.BasePanel;
	import com.view.UI.ResourcePanel;
	import com.view.UI.SettingPanel;
	import com.view.UI.shop.ShopPanel;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	
	/**
	 * 用户基本信息面板，包括头像名字、经验、钻石、资源
	 * @author hunterxie
	 */
	public class UserInfoPanel extends BasePanel {
		public static const NAME:String = "UserInfoPanel";
		public static const SINGLETON_MSG:String="single_UserInfoPanel_only";
		protected static var instance:UserInfoPanel;
		public static function getInstance():UserInfoPanel{
			if ( instance == null ) instance=new UserInfoPanel();
			return instance as UserInfoPanel;
		}

		
		public var mc_myInfo:BaseImgBar;
		public var tf_nickName:TextField;
		public var tf_exp:TextField;
		public var tf_gold:TextField;
		public var bg_gold:Sprite;
		public var btn_addGold:Sprite;
		public var tf_energy:TextField;
		public var bg_live:Sprite;
		public var btn_addLive:Sprite;
		public var tf_starNum:TextField;
		public var bg_star:Sprite;
		public var tf_LV:TextField;
		public var mc_exp:MovieClip;
		public var mc_userInfo:MovieClip;
		public var mc_firends:MovieClip;
		public var mc_wuxingPanel:MovieClip;
		public var mc_fairyPanel:MovieClip;
		
		public var mc_resource:ResourcePanel;
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		public function UserInfoPanel() { 
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			tf_nickName.mouseEnabled = false;
			tf_LV.mouseEnabled = false;
			tf_exp.mouseEnabled = false;
			tf_energy.mouseEnabled = false;
			bg_live.addEventListener(MouseEvent.CLICK, onBuyLive);
			btn_addLive.addEventListener(MouseEvent.CLICK, onBuyLive);
			tf_gold.mouseEnabled = false; 
			bg_gold.addEventListener(MouseEvent.CLICK, onBuyGold);
			btn_addGold.addEventListener(MouseEvent.CLICK, onBuyGold);
			
			mc_resource.addEventListener(MouseEvent.CLICK, onShowWuxing);
			mc_myInfo.buttonMode = true;
			mc_myInfo.img_container.scaleX = mc_myInfo.img_container.scaleY = 0.85;
			mc_myInfo.addEventListener(MouseEvent.CLICK, onShowUserInfo);
			
			userInfo.on(UserVO.UPDATE_USER_INFO, this, updateInfo);
			mc_resource.init(userInfo.wuxingInfo);
			
			EventCenter.on(ApplicationFacade.SHOW_PANEL, this, onClosePanel);
		}
		
		private function onClosePanel(e:ObjectEvent):void{
			if(e.data==UserInfoPanel.NAME){
				updateInfo();
			}
		}
		 
		public function updateInfo(e:ObjectEvent=null):void{
			tf_nickName.text=userInfo.nickName;
			tf_gold.text = String(userInfo.gold);
			tf_energy.text = userInfo.energy+"/"+userInfo.energy_max;
			
			var expPer:Number = Math.round((1-(userInfo.EXP_max-userInfo.EXP_cu)/(userInfo.EXP_max-userInfo.EXP_last))*100)/100;
			tf_exp.text = String(userInfo.EXP_cu);//+"/"+userInfo.EXP_max;
//				trace("升级需要经验:"+(userInfo.EXP_max-userInfo.EXP_cu), 
//				"当前等级所需总经验:"+(userInfo.EXP_max-userInfo.EXP_last), 
//				"经验进度条百分比:"+expPer); 
			mc_exp.mc_cover.x = -Math.floor(mc_exp.mc_cover.width*(1-expPer));
			
			tf_LV.text = userInfo.LV+"级";
			
			if(userInfo.visualURL.indexOf("http")!=-1){
				mc_myInfo.updateURL(userInfo.visualURL);
			}else{
				mc_myInfo.updateClass(userInfo.visualURL);
			}
		}
		
		/**
		 * 打开商城购买钻石界面
		 * @param e
		 */
		private function onBuyGold(e:*):void{
			EventCenter.event(ApplicationFacade.SHOW_PANEL, ShopPanel.getShowName(ShopItemConfigVO.TYPE_GOLD));
		}
		
		/**
		 * 打开商城购买精力值界面
		 * @param e
		 */
		private function onBuyLive(e:*):void{
			EventCenter.event(ApplicationFacade.SHOW_PANEL, ShopPanel.getShowName());
		}
		
		public function onShowWuxing(e:*):void{
			EventCenter.event(ApplicationFacade.SHOW_PANEL, WuxingInfoPanel.getShowName());
		}
		
		public function onShowUserInfo(e:*):void{
			EventCenter.event(ApplicationFacade.SHOW_PANEL, SettingPanel.NAME);
		}
	}
}