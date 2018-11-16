package com.view.UI.tip {
	import com.model.vo.config.guide.GuideTipPoint;
	
	import flash.display.MovieClip;

	public class QuickChangeTip extends MovieClip {
		private static var pool:Array = [];
		 
		public static function getQuickChangeTip(point:GuideTipPoint):QuickChangeTip{
			var mc:QuickChangeTip;
			if(pool.length){
				mc = pool.shift();
			}else{
				mc = new QuickChangeTip();
			}
			point.setChessboardPoint();
			mc.x = point.x;
			mc.y = point.y;
			mc.rotation = point.rotation; 
			return mc;
		}
		public static function push(mc:QuickChangeTip):void{
			pool.push(mc);
		}
		public function QuickChangeTip() {
		}
	}
}
