package com.model.vo {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	
	import flas.events.EventDispatcher;

	/**
	 * 小红点提示事件
	 * @author hunterxie
	 * 
	 */
	public class PanelPointShowVO extends EventDispatcher{
		public static const NAME:String="PanelPointShowVO";
		private static const SINGLETON_MSG:String="single_PanelPointShowVO_only";
		private static var instance:PanelPointShowVO;
		public static function getInstance():PanelPointShowVO{
			if ( instance == null ) instance=new PanelPointShowVO();
			return instance as PanelPointShowVO;
		}
		
		/**
		 * 小红点提示事件
		 * @see com.model.vo.PanelPointShowVO
		 */
		public static const SHOW_PANEL_POINT_GUIDE:String="SHOW_PANEL_POINT_GUIDE";
		
		
		public var kind:String = "";
		
		public var isShow:Boolean = false;
		
		/**
		 * 按钮体系中展示小红点
		 * @param name		需要显示的面板名
		 * @param isShow	是否展示小红点
		 */
		public function PanelPointShowVO() {
			
		}
		
		public static function showPointGuide(name:String, isShow:Boolean):void{
			getInstance().kind = name; 
			instance.isShow = isShow;
			instance.event(PanelPointShowVO.SHOW_PANEL_POINT_GUIDE);
		}
	}
}
