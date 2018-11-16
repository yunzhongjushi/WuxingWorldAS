package com.model.vo.animation {
	import com.model.vo.chessBoard.QiuPoint;
	
	import flas.geom.Point;
	
	/**
	 * 
	 * @author hunterxie
	 * 
	 */
	public class LightningShowVO {
		public var point1:Point;
		public var point2:Point;
		/**
		 * 延迟多久出现
		 */
		public var delayTime:Number;
		public var showTime:Number=0.4;
		
		/**
		 * 闪电颜色，默认淡蓝色
		 */
		public var color:uint=0xddeeff;
		
		/**
		 * 五行类型
		 */
		public var kind:int;
		
		/**
		 * 
		 * @param point1
		 * @param point2
		 * @param delay
		 * @param color
		 * 
		 */
		public function LightningShowVO(point1:Point, point2:Point, delay:Number=0, kind:int=0) {
			this.point1=point1;
			this.point2=point2;
			this.kind=kind;
			if(kind==QiuPoint.KIND_GRAY){
//				trace("!!!此处不应该是连锁闪电，应该是正行/整列的条状闪电！");
			}
			this.delayTime=delay;
		}
	}
}