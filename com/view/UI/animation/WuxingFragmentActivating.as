package com.view.UI.animation {
	import com.model.ApplicationFacade;
	import com.greensock.TweenLite;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.WuxingVO;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.guide.ElementActiveVO;
	import com.view.BasePanel;
	import com.view.UI.user.WuxingInfoPanel;
	
	import flas.events.Event;
	import flas.geom.Point;
	import flas.utils.utils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * 五行元素激活动画
	 * @author hunterxie
	 */
	public class WuxingFragmentActivating extends BasePanel{
		public static const NAME:String = "WuxingFragmentActivating";
		public static const SINGLETON_MSG:String="single_WuxingFragmentActivating_only";
		protected static var instance:WuxingFragmentActivating;
		public static function getInstance():WuxingFragmentActivating{
			if ( instance == null ) instance=new WuxingFragmentActivating();
			return instance as WuxingFragmentActivating;
		}
		
		public static const SHOW_ACTIVATING:String = "SHOW_ACTIVATING";
		
		public var fragmentMovie:MovieClip;
		
//		public var fragment:Sprite = new Sprite;
//		public var fragmentImg:Bitmap = new Bitmap;
//		private var fragmentPositionArr:Array = [new Point(-61,-107), new Point(-77,-116), new Point(-87,-111), new Point(-95,-111), new Point(-88,-116)];
//		
//		public var fragment_bg:Sprite = new Sprite;
//		public var fragment_bg_Img:Bitmap = new Bitmap;
//		private var fragment_bgPositionArr:Array = [new Point(-246,-282), new Point(-269,-269), new Point(-269,-269), new Point(-269,-269), new Point(-269,-269)];
		
		private var tarFragment:Sprite;
		
		private var showVO:ElementActiveVO;
		
		public function WuxingFragmentActivating() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			cover_bg = utils.getDefinitionByName("cover");
			cover_bg.width = 960;
			cover_bg.height = 640;
			addChild(cover_bg);
			
//			fragment.addChild(fragmentImg);
//			fragmentImg.smoothing = true;
//			addChild(fragment);
//			fragmentImg.bitmapData = utils.getDefinitionByName("Fragment_金");
//			fragmentImg.x = -fragmentImg.width/2;
//			fragmentImg.y = -fragmentImg.height/2;
			// = utils.getDefinitionByName("Fragment_金");
//			fragment.filters = [ColorFactory.getTone(0xffffff)];
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdd);
			
			showVO = ElementActiveVO.getInstance();
			showVO.on(ElementActiveVO.SHOW_ELEMENT_ACTIVE, this, showMovie);
		}
		
		public function onAdd(e:*):void{
			if(this.stage){
				cover_bg.width = stage.stageWidth;
				cover_bg.height = stage.stageHeight;
			}
		}
		
		private function showMovie(e:ObjectEvent):void{
			if(!fragmentMovie){
				fragmentMovie = utils.getDefinitionByName("WuxingPropertyActivating");
				fragmentMovie.addEventListener("fragmentMovePosition", fragmentMoveOver); 
				fragmentMovie.addEventListener("movePosition", activeMoveOver);
				fragmentMovie.addEventListener("playOver", activeEnd); 
			}
			fragmentMovie.nowWuxing = WuxingVO.getWuxing(showVO.wuxing); 
			fragmentMovie.gotoAndPlay(2);
//			fragmentMovie.mc_property.x = point.x;
//			fragmentMovie.mc_property.y = point.y;
			addChild(fragmentMovie);
			
			cover_bg.alpha = 0;
			TweenLite.to(cover_bg, 1, {alpha:1});
			
//			cover_bg.alpha = 0;
//			TweenLite.to(cover_bg, 1.5, {alpha:1});
			
//			fragmentImg.bitmapData = utils.getDefinitionByName("Fragment_"+wuxing);
//			fragment.x = point.x;
//			fragment.y = point.y;
//			fragment.scaleX = fragment.scaleY = 0.38;
//			fragment.alpha = 1;
//			fragment.rotation = -WuxingVO.getWuxing(wuxing)*72;
//			TweenLite.to(fragment, 1, {delay:1.2, x:cover.width/2, y:cover.height/2, scaleX:2, scaleY:2, onComplete:fragmentMoveOver});
			
//			tarFragment = utils.getDefinitionByName("Fragment_"+wuxing);
			this.event(SHOW_ACTIVATING);
		}
		
		/**
		 * 五行展示模块从棋子位置放大移动到中间
		 */
		private function fragmentMoveOver(e:*=null):void{
			EventCenter.event(ApplicationFacade.SHOW_PANEL, WuxingInfoPanel.getShowName()); //五行展示模块到达正中间
			TweenLite.to(cover_bg, 0.5, {alpha:0});
//			TweenLite.to(fragment, 0.5, {delay:0.5, x:showVO.tarPoint.x, y:showVO.tarPoint.y, scaleX:0, scaleY:0, onComplete:activeMoveOver});
		}
		
		/**
		 * 
		 * 
		 */
		private function activeMoveOver(e:*=null):void{ 
//			tarFragment.x = showVO.tarPoint.x;
//			tarFragment.y = showVO.tarPoint.y;
//			tarFragment.scaleX = tarFragment.scaleY = 0;
//			addChild(tarFragment);
			TweenLite.to({}, 0.3, {onComplete:activeShow});
		}
		
		/**
		 * 
		 * 
		 */
		private function activeShow():void{ 
//			TweenLite.to(fragment, 1, {alpha:0, onComplete:activeEnd});
			EventCenter.event(ApplicationFacade.FRAGMENT_ACTIVATING_OVER, showVO.wuxing);//五行展示模块展示完毕，接下来进行五行面板展示
		}
		private function activeEnd(e:*=null):void{ 
			if(this.parent){
				this.parent.removeChild(this);
			}
		}
	}
}
