package {
	import com.controller.FightCommand;
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.WebParams;
	import com.model.vo.tip.LoadingVO;
	import com.view.DebugPanel;
	import com.view.StarlingContainer;
	import com.view.UI.MainPanel;
	import com.view.UI.animation.AnimationPanel;
	import com.view.UI.animation.GuideMissionContainer;
	import com.view.UI.chessboard.ChessboardPanel;
	import com.view.UI.tip.GuidePanel;
	import com.view.UI.tip.LoadingPanel;
	import com.view.mediator.container.PanelContainerMediator;
	import com.view.mediator.container.TipContainerMediator;
	
	import flas.display.Sprite;
	import flas.display.StageAlign;
	import flas.display.StageScaleMode;
	import flas.events.Event;
	import flas.events.MouseEvent;
	import flas.geom.Rectangle;
	
	import starling.core.Starling;
	
	public class WuxingWorldBase extends Sprite {
		private static const SINGLETON_MSG:String="single_WuxingWorldBase_only";
		private static var instance:WuxingWorldBase;
		public static function getInstance():WuxingWorldBase{
			if ( instance == null ) instance=new WuxingWorldBase();
			return instance;
		}
		
		
//		public var mc_logo:MovieClip;
		
		public var debugPanel:DebugPanel;
		public var mainView:MainPanel;
		public var animationPanel:AnimationPanel;
		public var guideMissionContainer:GuideMissionContainer;
//		public var bigMap:WorldMap;
		public var panelContainer:PanelContainerMediator;
		public var tipContainer:TipContainerMediator;
		/** 是否有面板正打开，用于地图层判定是否响应鼠标 */
		public static function get isPanelOpen():Boolean{
			return instance.panelContainer!=null && instance.tipContainer!=null && Boolean(instance.panelContainer.numChildren+instance.tipContainer.numChildren);
		}
		
		public var starlingInitializationComplete:Boolean = false;
		/**
		 * 是否(网页)loading结束，更新web参数
		 */
		public var loadInitializationComplete:Boolean = false;
		public var _starling:Starling;
		
		
		public function WuxingWorldBase():void {
//			if (instance != null)
//				throw Error(SINGLETON_MSG);
			instance=this;
			
			if(stage) initnew();
			else addEventListener(Event.ADDED_TO_STAGE, initnew);
			
//			if(MainVO.localTest) this.backMC.gotoAndPlay(2);
//			对全局事件的相关侦听，所有子面板的冒泡事件都会到达这层
//			this.addEventListener(MouseEvent.MOUSE_DOWN, onPressOutside);
//			this.addEventListener(MouseEvent.MOUSE_UP, onReleaseOutside);
//		private function onPressOutside(e:*):void{
//			sendNotification(ApplicationFacade.ON_PRESS_OUTSIDE);
//		}
//		private function onReleaseOutside(e:*):void{
//			sendNotification(ApplicationFacade.ON_RELEASE_OUTSIDE);
//		}
			
			EventCenter.on(LoadingPanel.FIRST_LOADING_OVER, this, showLoginPanel);
		}
		
		private function initnew(e:*=null):void{
			removeEventListener(Event.ADDED_TO_STAGE, initnew);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			BaseInfo.setFullScreen(stage.stageWidth,stage.stageHeight);
			BaseInfo.setFullScreen(stage.fullScreenWidth,stage.fullScreenHeight);
			
//			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
//			Starling.handleLostContext = true;//ios和mac设false，android设true，睡眠后开启会重新渲染上下文，消耗大量内存
			_starling = new Starling(StarlingContainer, stage, new Rectangle(0, 0, BaseInfo.fullScreenWidth, BaseInfo.fullScreenHeight));
//			_starling.viewPort = ;
			_starling.antiAliasing = 1;
			_starling.enableErrorChecking = false;
			_starling.start();
			_starling.addEventListener("rootCreated", starlingInit);
			
//			if(mc_logo){
//				mc_logo.x = (BaseInfo.fullScreenWidth-mc_logo.width)/2;
//				mc_logo.y = (BaseInfo.fullScreenHeight-mc_logo.height)/2;
//			}
			
//			我的active是这么处理的：
//			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
//			this._starling.start();
//			
//			deactive是这么处理的：
//			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
//			NativeApplication.nativeApplication.executeInBackground = true;
//			this._starling.stop();
		}
		
		private function starlingInit(e:*=null):void{
			starlingInitializationComplete = true;
			if(loadInitializationComplete) init();
		}
		
		public function loadInit(info:Object):void{
			WebParams.updateInfo(info);
//			WebParams.updateInfo(ExternalInterface.call("getUrlParamsNew"));
			loadInitializationComplete = true;
			if(starlingInitializationComplete) init();
		}
		
		public function init(e:*=null):void{
			this.addEventListener(MouseEvent.CLICK, onStageMouse);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouse);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouse);
			this.addEventListener(MouseEvent.MOUSE_OVER, onStageMouse);
			this.addEventListener(MouseEvent.MOUSE_UP, onStageMouse);
			this.addEventListener(MouseEvent.ROLL_OUT, onStageMouse);
			this.addEventListener(MouseEvent.ROLL_OVER, onStageMouse);
			
//			if(mc_logo) removeChild(mc_logo);
			if(stage.fullScreenWidth<960 || stage.fullScreenWidth>1280 || stage.fullScreenHeight<640 || stage.fullScreenHeight>768 ){
				stage.scaleMode = StageScaleMode.EXACT_FIT;
			}
			
//			bigMap = new WorldMap;
//			bigMap.visible = false;
//			bigMap.y = stage.stageHeight-bigMap.height;
//			this.addChild(bigMap);
			
			StarlingContainer.getInstance().initMap();									//地图层
			this.addChild(mainView=MainPanel.getInstance());							//基础信息+按钮层
			this.addChild(panelContainer=PanelContainerMediator.getInstance());			//面板层
			this.addChild(animationPanel=AnimationPanel.getInstance());					//动画层
			this.addChild(guideMissionContainer=GuideMissionContainer.getInstance());	//引导层
			this.addChild(tipContainer=TipContainerMediator.getInstance());				//提示层
			if(BaseInfo.isShowDebug){
				this.addChild(debugPanel=DebugPanel.getInstance());						//调试面板层
				DebugPanel.traceInfo("fullScreen:"+stage.fullScreenWidth+":"+stage.fullScreenHeight+"	"+"stage:"+stage.stageWidth+":"+stage.stageHeight);
			}
			
			ChessboardPanel.getInstance();												//棋盘包含在解谜+战斗面板中，在面板层弹出
			FightCommand.getInstance();
			
			if(BaseInfo.isTestFirstLoading){
				LoadingVO.showLoadingInfo("准备进入游戏......", true, "准备进入游戏......");
			}else{
				showLoginPanel();
			}
		}
		
		protected function onStageMouse(event:*):void{
			if(GuidePanel.getInstance().parent && 
				(event.type==MouseEvent.MOUSE_DOWN || event.type==MouseEvent.CLICK) &&
				!tipContainer.contains(event.target)){//专为引导层准备的点击事件
				GuidePanel.getInstance().onc(event);
			}
			event.stopImmediatePropagation();
		}
		
		/**
		 * 展示登录面板、自动登录开始
		 */
		public function showLoginPanel(e:ObjectEvent=null):void{
			mainView.visible=true;
			mainView.showBG();
			mainView.mc_loginPanel.checkLogin();
		}
	}
}