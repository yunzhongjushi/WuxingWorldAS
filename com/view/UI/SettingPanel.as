package com.view.UI {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.GameSO;
	import com.model.vo.SettingVO;
	import com.model.vo.user.UserVO;
	import com.view.BaseImgBar;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * 
	 * @author hunterxie
	 */
	public class SettingPanel extends BasePanel {
		public static const NAME:String = "SettingPanel";
		public static const SINGLETON_MSG:String="single_SettingPanel_only";
		protected static var instance:SettingPanel;
		public static function getInstance():SettingPanel {
			if(instance==null)
				instance=new SettingPanel(); 
			return instance as SettingPanel;
		}
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		public var mc_myInfo:BaseImgBar;

		public var settingVO:SettingVO = SettingVO.getInstance();

		public var btn_changeHead:CommonBtn;

		public var btn_changeNickname:CommonBtn;

		public var btn_sound:MovieClip;

		public var btn_music:MovieClip;
		
		public var tf_nickName:TextField;
		
		public var tf_friayMaxLV:TextField;
		
		public var tf_LV:TextField;
		
		public var tf_ID:TextField;
		


		/**
		 * 设置面板
		 */
		public function SettingPanel() {
			if(instance!=null) throw Error(SINGLETON_MSG);
			instance=this; 

			this.alignInfo = ALIGN_MIDDLE;
			
			btn_changeHead.visible = false;
			btn_changeHead.setNameTxt("开  启");
			btn_changeHead.addEventListener(MouseEvent.CLICK, onClick);
			
			btn_changeNickname.visible = false;
			btn_changeNickname.setNameTxt("开  启");
			btn_changeNickname.addEventListener(MouseEvent.CLICK, onClick);
			
			btn_sound.buttonMode = true;
			btn_sound.addEventListener(MouseEvent.CLICK, onClick);
			btn_music.buttonMode = true;
			btn_music.addEventListener(MouseEvent.CLICK, onClick);
			
//			userInfo.addEventListener(UserVO.UPDATE_USER_INFO, updateInfo);
			
			EventCenter.on(ApplicationFacade.SHOW_PANEL, this, onShowPanel);
		}
		
		private function onShowPanel(e:ObjectEvent):void{
			if(e.data==SettingPanel.NAME){
				updateInfo();
			}
		}

		protected function onClick(event:*):void {
			switch(event.currentTarget) {
				case btn_changeHead:
					break;
				case btn_changeNickname:
					break;
				case btn_sound:
					settingVO.isSoundOpen = !settingVO.isSoundOpen;
					btn_sound.gotoAndStop(settingVO.isSoundOpen ? 1 : 2);
					break;
				case btn_music:
					settingVO.isMusicOpen = !settingVO.isMusicOpen;
					btn_music.gotoAndStop(settingVO.isMusicOpen ? 1 : 2);
					break;
				default:
					break;
			}
			GameSO.save();
		}
		
		public function updateInfo(e:ObjectEvent=null):void{
			tf_nickName.text = userInfo.nickName;
//			mc_myInfo.updateURL(userInfo.visualURL);
			
			if(userInfo.visualURL.indexOf("http")!=-1){
				mc_myInfo.updateURL(userInfo.visualURL);
			}else{
				mc_myInfo.updateClass(userInfo.visualURL);
			}
			
			tf_LV.text = userInfo.LV+"级";
			tf_nickName.text = userInfo.nickName;
			tf_friayMaxLV.text = String(userInfo.fairyMaxLV);
			tf_ID.text = String(userInfo.userID);
			
			btn_sound.gotoAndStop(settingVO.isSoundOpen?1:2);
			btn_music.gotoAndStop(settingVO.isMusicOpen?1:2);
		}

//		public function updateInfo():void {
//			btn_sound.gotoAndStop(settingVO.isSoundOpen?1:2);
//			btn_music.gotoAndStop(settingVO.isMusicOpen?1:2);
//		}

	}
}
