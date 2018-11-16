package com.model.vo.animation {
	import flas.geom.Point;
	
	public class InfoShowVO {
		public var info:String;
		public var point:Point;
		public var color:int;
		public var infoScale:Number;
		/**
		 * 持续时间（秒）
		 */
		public var continuedTime:int;
		public var delay:Number;
		
		/**
		 * @param info
		 * @param point
		 * @param color
		 * @param scale
		 * @param time
		 * @param delay
		 */
		public function InfoShowVO(info:String, point:Point, color:int, scale:Number=1, time:Number=1, delay:Number=0) {
			this.info = info;
			this.point = point;
			this.color = color;
			this.infoScale = scale;
			this.continuedTime = time;
			this.delay = delay;
		}
	}
}