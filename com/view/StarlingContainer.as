package com.view{
	import com.greensock.TweenLite;
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.view.UI.chessboard.PuzzlePanel;
	import com.view.UI.fight.FightPanel;
	import com.view.UI.map.BigMapS;
	
	import flas.geom.Point;
	import flas.utils.utils;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	
	
	public class StarlingContainer extends Sprite {
		public static const SINGLETON_MSG:String="single_StarlingContainer_only";
		protected static var instance:StarlingContainer;
		public static function getInstance():StarlingContainer{
			if ( instance == null ) instance=new StarlingContainer();
			return instance;
		}
		
		public function get map():BigMapS{
			if(!_map){
				initMap();
			}
			return _map;
		}
		public var _map:BigMapS;
		
		public function StarlingContainer() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
//			this.addEventListener(TouchEvent.TOUCH, onTouchedSprite);
//			stage.addEventListener(starling.events.Event.ENTER_FRAME,onFrame);
			
			
			EventCenter.on(ApplicationFacade.SHOW_PANEL_SUCCESS, this, onShowPanel);
			EventCenter.on(BasePanel.CLOSE_PANEL, this, onPanelClose);
			EventCenter.on(ApplicationFacade.GUIDE_BIG_MAP_ENTER, this, updateInfo);
		}
		
		/**
		 * 凡是有面板打开就禁止响应地图点击
		 */
		private function onShowPanel(e:ObjectEvent):void{
			this.deactive();
			if(e.data==FightPanel.NAME || e.data==PuzzlePanel.NAME){
				this.hideMap();
			}
		}
		
		/**
		 * 当有面板关闭时判断是否所有面板都关闭，是就打开地图响应
		 */
		private function onPanelClose(e:ObjectEvent):void{
			if((e.data==FightPanel.NAME || e.data==PuzzlePanel.NAME) && this.isFirstShow){
				this.showMap();
			}
			if(!WuxingWorldBase.isPanelOpen){
				this.active();
			}
		}
		
		/**
		 * 初始化所有地图背景
		 */
		public function initMap():void{
			if(_map) return; 
			
			var mapInfoArr:Array = [];
			for(var i:int=0; i<22; i++){//22行
				mapInfoArr[i] = [];
				for(var j:int=0; j<4; j++){//4列
					mapInfoArr[i][j] = Texture.fromBitmapData(utils.getDefinitionByName("Map"+i+"_"+j+".jpg"));
				}
			}
			_map = BigMapS.getInstance();
			_map.init(BaseInfo.fullScreenWidth, BaseInfo.fullScreenHeight, mapInfoArr);
			hideMap();
			
			EventCenter.on(ApplicationFacade.GUIDE_MISSION_SHOW, this, hideMap);
		}
		
		public function deactive():void{
			if(map && map.isActive){
				map.deactive();
				map.flatten();
			}
		}
		public function active():void{
			TweenLite.to({}, 0.05, {onComplete:activeExcute});
		}
		private function activeExcute():void{
			map.active();
			map.unflatten();
		}
		
		public var isFirstShow:Boolean = false;
		public function showMap():void{
			addChild(map);
			if(!isFirstShow) isFirstShow = true;
		}
		public function hideMap():void{
			if(map && this.contains(map))	removeChild(map);
		}
		
		public function updateInfo(e:ObjectEvent):void{
			map.updateInfo();
			showMap();
		}
		
		private function onTouchedSprite(e:TouchEvent):void{
			var touch:Touch = e.getTouch(stage); 
			var pos:Point = Point.changePoint(touch.getLocation(stage)); 
			//			trace ( touch.phase , pos);
			
			switch(touch.phase){
				case "hover":
					break;
				case "began":
					break;
				case "ended":
					break;
				case "moved":
					break;
			}
		}
		
	}
}
