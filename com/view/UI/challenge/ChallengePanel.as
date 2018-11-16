package com.view.UI.challenge {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.utils.ColorFactory;
	import com.view.BasePanel;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class ChallengePanel extends BasePanel{
		public static const NAME:String = "ChallengePanel";
		public static const SINGLETON_MSG:String="single_ChallengePanel_only";
		protected static var instance:ChallengePanel;
		public static function getInstance():ChallengePanel{
			if ( instance == null ) instance=new ChallengePanel();
			return instance as ChallengePanel;
		}
		
		public var btn_0:MovieClip;
		public var btn_1:MovieClip;
		public var btn_2:MovieClip;
		public var btn_3:MovieClip;
		public var btn_4:MovieClip;
		
		public function ChallengePanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			for(var i:int=0; i<5; i++){
				var btn:MovieClip = this["btn_"+i];
				btn.gotoAndStop(i+1);
				btn.mc_light.gotoAndStop(i+1);
				btn.mouseChildren = false;
//				if(i>1){
//				btn.filters = [ColorFactory.getGrayFilter()];
//				btn.mouseEnabled = btn.mouseChildren = false;
//				}
				
				btn.addEventListener(MouseEvent.MOUSE_DOWN, onclick);
				btn.addEventListener(MouseEvent.MOUSE_UP, onclick);
				btn.addEventListener(MouseEvent.MOUSE_OUT, onclick);
				btn.addEventListener(MouseEvent.CLICK, onclick);
			}
			
			EventCenter.on(ApplicationFacade.SHOW_PANEL, this, onShow);
		}
		private function onShow(e:ObjectEvent):void{
			e.data==ChallengePanel.NAME && updateInfo();
		}
		
		protected function onclick(event:*):void{
			switch(event.type){
				case MouseEvent.MOUSE_DOWN:
					event.target.mc_light.visible = true;
					break;
				case MouseEvent.MOUSE_UP:
				case MouseEvent.MOUSE_OUT:
					event.target.mc_light.visible = false;
					break;
				case MouseEvent.CLICK:
							close();
					switch(event.target){
						case btn_0:
							EventCenter.event(ApplicationFacade.SHOW_PANEL, ChallengeJin.NAME);
							break;
						case btn_1:
							EventCenter.event(ApplicationFacade.SHOW_PANEL, ChallengeMu.NAME);
							break;
						case btn_2:
		//					EventCenter.event(ApplicationFacade.SHOW_PANEL, ChallengeTu.NAME);
							break;
						case btn_3:
							EventCenter.event(ApplicationFacade.SHOW_PANEL, ChallengeShui.NAME);
							break;
						case btn_4:
							EventCenter.event(ApplicationFacade.SHOW_PANEL, ChallengeHuo.NAME);
							break;
					}
					break;
			}
		}
		
		public function updateInfo():void{
			
		}
	}
}
