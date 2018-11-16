package com.view.UI.tip {
	import com.model.vo.config.guide.GuideTipPoint;
	
	import flash.display.MovieClip;

	/**
	 * 交换提示引导
	 * @author hunterxie
	 */
	public class ExchangeTip extends MovieClip {
		private static var pool:Array = [];
		
		public static function getExchangeTip(point:GuideTipPoint):ExchangeTip{
			var mc:ExchangeTip;
			if(pool.length){
				mc = pool.shift();
			}else{
				mc = new ExchangeTip();
			}
			point.setChessboardPoint();
			mc.x = point.x;
			mc.y = point.y;
			mc.rotation = point.rotation; 
			return mc;
		}
		public static function push(mc:ExchangeTip):void{
			pool.push(mc);
		}
		public function ExchangeTip() {
		}
	}
}
