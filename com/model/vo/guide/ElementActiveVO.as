package com.model.vo.guide {
	import com.model.vo.chessBoard.QiuPoint;
	import com.view.UI.chessboard.ChessboardPanel;
	import com.view.UI.user.WuxingInfoPanel;
	
	import flas.events.EventDispatcher;
	import flas.geom.Point;

	/**
	 * 五行模块激活事件VO
	 * @author hunterxie
	 */
	public class ElementActiveVO extends EventDispatcher{
		public static const NAME:String = "ElementActiveVO";
		public static const SINGLETON_MSG:String="single_ElementActiveVO_only";
		protected static var instance:ElementActiveVO;
		public static function getInstance():ElementActiveVO{
			if ( instance == null ) instance=new ElementActiveVO();
			return instance as ElementActiveVO;
		}
		
		public static const SHOW_ELEMENT_ACTIVE:String = "ElementActiveVO";
		
		/**
		 * 
		 */
		public var wuxing:int;
		
		public var point:Point;
		
		public var tarPoint:Point;
		
		public function ElementActiveVO() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
		}
		
		public static function show(point:QiuPoint):void{
			getInstance().wuxing = point.kind;
			instance.point = ChessboardPanel.getQiuGlobalPoint(point);
			instance.tarPoint = WuxingInfoPanel.getFragmentPoint(point.showKind);
			instance.event(SHOW_ELEMENT_ACTIVE);
		}
	}
}
