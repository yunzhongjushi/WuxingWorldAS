package com.view.UI.tip {
	import flash.display.MovieClip;
	import flas.geom.Point;

	public class GuideFocusTip extends MovieClip {
		private static var pool:Array = [];
		
		public static function getGuideFocusTip(point:Point):GuideFocusTip{
			var mc:GuideFocusTip;
			if(pool.length){
				mc = pool.shift();
			}else{
				mc = new GuideFocusTip();
			}
			mc.x = point.x;
			mc.y = point.y;
			return mc;
		}
		public static function push(mc:GuideFocusTip):void{
			pool.push(mc);
		}
		public function GuideFocusTip() {
		}
	}
}
