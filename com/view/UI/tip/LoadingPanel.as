package com.view.UI.tip {
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.tip.LoadingVO;
	import com.model.vo.tip.TipVO;
	import com.utils.TimerFactory;
	import com.view.BasePanel;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;

	
	/**
	 * 开机动画
	 * @author hunterxie
	 */
	public class LoadingPanel extends BasePanel {
		public static const NAME:String = "LoadingPanel";
		public static const SINGLETON_MSG:String="single_LoadingPanel_only";
		protected static var instance:LoadingPanel;
		public static function getInstance():LoadingPanel{
			if ( instance == null ) instance=new LoadingPanel();
			return instance as LoadingPanel;
		}
		
		
		/**
		 * 展示首次进入游戏进度条
		 */
		public static const FIRST_LOADING_OVER:String = "FIRST_LOADING_OVER";
		
		/**
		 * 加载
		 */
		public var mc_loading:MovieClip;
		/**
		 * 等待后台读取数据
		 */
		public var mc_waiting:MovieClip;
		
		/**
		 * 超时计时毫秒数
		 */
		public var outLoadingTimeNum:int = 2500;
		
		/**
		 * 展示时不可见loading条的毫秒数
		 */
		public var firstHideTimeNum:int = 2000;
		
		
		public var tf_info:TextField;
		
		private var rollSpeed:int = 4;
		private var keyList:Array = [];
		/**
		 * 是否首次加载
		 */
		private var isFirstLoading:Boolean = false;
		
		public var vo:LoadingVO;
		
		/**
		 * 
		 * 
		 */
		public function LoadingPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			mc_loading.visible = false;
			mc_waiting.visible = true;
			mc_waiting.x = mc_loading.x = BaseInfo.fullScreenWidth/2;
			mc_waiting.y = mc_loading.y = BaseInfo.fullScreenHeight/2;
			
			if(cover_bg){
				tf_info.x = (BaseInfo.fullScreenWidth - tf_info.width)/2;
				tf_info.y = cover_bg.height-72;
			}
			
			this.addEventListener(Event.ADDED_TO_STAGE, addToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, addToStage);
			
			LoadingVO.getInstance().on(LoadingVO.SHOW_LOADING, this, updateInfo);
		}
		
		public function addToStage(e:Event):void{
			switch(e.type){
				case Event.ADDED_TO_STAGE:
					this.addEventListener(Event.ENTER_FRAME, onFrame);
					break;
				case Event.REMOVED_FROM_STAGE:
					this.removeEventListener(Event.ENTER_FRAME, onFrame);
					break;
			}
		}
		
		private function onOutLoading(e:*):void{
			if(keyList.length>0 && !isFirstLoading){
				TipVO.showChoosePanel(new TipVO("连接超时", "连接超时，您要重新发送请求吗!", vo.key));
			}
			keyList = []; 
			close();
		}
		
		private function onFirstHide(e:*):void{
			this.alpha = 1;
		}
		
		public function onFrame(e:Event):void{
			if(isFirstLoading){
				mc_loading.rotation += rollSpeed;
			}else{
				mc_waiting.rotation += rollSpeed;
			}
		}
		
		
		/**
		 * 显示首次进入前的loading（移动设备初始化时间比较长）
		 */
		private function showFirst():void{
			isFirstLoading = true;
			mc_waiting.visible = false;
			mc_loading.visible = true;
			this.addEventListener(MouseEvent.CLICK, onLoadOver);
			mc_loading.addEventListener("playOver", onFirstEnd);
		}
		
		/**
		 * 首次初始化结束，进入展示动画
		 */
		private function onLoadOver(e:*=null):void{
			this.removeEventListener(MouseEvent.CLICK, onLoadOver);
			
			isFirstLoading = false;
			mc_loading.play();
		}
		
		/**
		 * 首次加载动画播放完毕，关闭loading
		 * @param e
		 */
		private function onFirstEnd(e:Event=null):void{
			mc_loading.visible = false;
			mc_waiting.visible = true;
			keyList = [];
			mc_loading.removeEventListener("playOver", onFirstEnd);
			
			close();
			EventCenter.event(LoadingPanel.FIRST_LOADING_OVER);
		}
		
		public function updateInfo(e:ObjectEvent):void{
			if(!BaseInfo.isTestRequest){
				close();
				return;
			}
			this.vo = e.data as LoadingVO;
			tf_info.text = vo.info;
			if(vo.key==LoadingVO.SHOW_LOADING){
				showFirst();
				return;
			}
			if(vo.showJudge){
				keyList.push(vo.key);
				this.alpha = 0;
				TimerFactory.once(outLoadingTimeNum, this, onOutLoading);
				TimerFactory.once(firstHideTimeNum, this, onFirstHide);
			}else{
				var index:int=keyList.indexOf(vo.key);
				if(index!=-1){
					keyList.splice(index,1);
				}
				if(keyList.length==0){
					close();
				}
			}
		}
		override public function close(e:*=null):void{
			TimerFactory.clear(this, onOutLoading);
			TimerFactory.clear(this, onFirstHide);
			super.close(e);
		}
		
		
//		private function getRolling(mc:MovieClip):BitmapData{
//			var rect:Rectangle = mc.getRect(mc);
//			rect.width+=20;
//			rect.height+=20;
//			rect.left-=10;
//			rect.top-=10;
//			var bmd:BitmapData=new BitmapData(rect.width, rect.height, true, 0);
//			bmd.draw(mc, new Matrix(1,0,0,1, -rect.left, -rect.top));
//			
//			return bmd;
//		}
	}
}
