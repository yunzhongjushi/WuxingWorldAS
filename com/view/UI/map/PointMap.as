package com.view.UI.map {
	import com.model.vo.WuxingVO;
	import com.model.vo.level.LevelVO;
	import com.utils.ColorFactory;
	import com.utils.PoolFactory;
	
	import flas.filters.GlowFilter;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	/**
	 * 
	 * @author hunterxie
	 */	
	public class PointMap extends MovieClip{
		public var tf_num:TextField;
		public var mc_star_1:MovieClip;
		public var mc_star_2:MovieClip;
		public var mc_star_3:MovieClip;
		
		public var id:int=0;
		public var wuxing:int=0;
		
		public var vo:LevelVO;
		
		public static function getNew():PointMap{
			return PoolFactory.getPoolInfo(PointMap) as PointMap;
		}
		
		private static var sample:PointMap;
		private static var sampleBP:BitmapData;
		public static function getBitmap(id:int=0):BitmapData{
			if(!sample){
				sample = new PointMap;
			}
			if(sampleBP){
				return sampleBP;
			}
			sample.init(id);
			sampleBP = MyClass.getMovieBitmapData(sample);
			return sampleBP;
		}
		
		
		
		/**
		 * 
		 * 
		 */
		public function PointMap() {
			buttonMode=true;
			this.mouseChildren=false;
			
		}
		
		public function init(id:int):Boolean{
			this.id = id;
			wuxing = Math.floor(id/5)%5;
			gotoAndStop(WuxingVO.getWuxing(wuxing));
			tf_num.text = String(id);
			return true;
		}
		
		public function updateInfo(vo:LevelVO):void{
			this.vo = vo;
			this.mouseEnabled = false;
			
			var i:int=1;
			while(i<=3){
				var star:MovieClip = this["mc_star_"+i];
				star.filters = i<=vo.maxStarNum ? [] : [ColorFactory.getGrayFilter()];
				i++;
			}
			if(vo.isOpen){
				filters = [new GlowFilter(WuxingVO.getColor(wuxing))];
				this.mouseEnabled = true;
			}else{
				filters=[ColorFactory.getGrayFilter()];
				this.mouseEnabled = false;
			}
		}
		
		public function remove():void{
			if(this.parent){
				this.parent.removeChild(this);
				PoolFactory.setPoolObj(PointMap, this);
			}
		}
	}
}