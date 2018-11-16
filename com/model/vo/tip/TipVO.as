package com.model.vo.tip {
	import com.model.event.EventCenter;
	
	import flas.events.EventDispatcher;

	/**
	 * 
	 * @author hunterxie
	 */
	public class TipVO extends EventDispatcher{
		protected static var instance:TipVO;
		public static function getInstance():TipVO{
			if (instance==null) instance=new TipVO(""); 
			return instance;
		}
		
		/**
		 * 展示一个提示面板
		 */
		public static const TIP_PANEL_SHOW:String = "TIP_PANEL_SHOW";
		
		/**
		 * 展示一个选择面板
		 */
		public static const TIP_CHOOSE_PANEL_SHOW:String = "TIP_CHOOSE_PANEL_SHOW";
		
		public static const TIP_PANEL_CONFIRM:String = "TIP_PANEL_CONFIRM";
		
		public static const TIP_PANEL_CANCEL:String = "TIP_PANEL_CANCEL";
		
		public var title:String;
		
		public var info:String;
		
		public var key:Object;
		
		/** 按钮1 */
		public var btn1:String = "确  定";
		/** 按钮2 */
		public var btn2:String = "取  消";
		
		public var choosed:int = 0;
		
		
		/**
		 * 
		 * @param info
		 * @param key
		 * @param arr	按钮选择数组，一般为二选一
		 */
		public function TipVO(title:String, info:String="", key:Object="", btn1:String="确  定", btn2:String="取  消") {
			this.title = title;
			this.info = info;
			this.key = key;
			this.btn1 = btn1;
			this.btn2 = btn2;
		}
		
		public function confirm():Boolean{
			this.choosed = 1;
			return true;
		}
		
		/**
		 * 通知面板层(解耦)展示选择面板
		 * @param title
		 * @param info
		 * @param key
		 * @param btn1
		 * @param btn2
		 */
		public static function showChoosePanel(vo:TipVO):void {
			getInstance().event(TipVO.TIP_CHOOSE_PANEL_SHOW, vo);
		}
		
		/**
		 * 通知面板层(解耦)展示提示面板
		 * @param title
		 * @param info
		 * @param key
		 */
		public static function showTipPanel(vo:TipVO):void {
			getInstance().event(TipVO.TIP_PANEL_SHOW, vo);
		}
	}
}
