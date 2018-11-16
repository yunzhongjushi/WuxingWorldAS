package  com.view.UI.fairy{
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class StarLevelPanel extends Sprite{
		/**
		 * 星星不满足时是否显示灰色星星
		 */
		public var isShowGray:Boolean = true;
		
		public var mc_star_0:MovieClip;
		public var mc_star_1:MovieClip;
		public var mc_star_2:MovieClip;
		public var mc_star_3:MovieClip;
		public var mc_star_4:MovieClip;
		
		
		
		
		/**
		 * 星级显示面板（最多五星）
		 */
		public function StarLevelPanel(){
			
		}
		
		/**
		 * @param num
		 * @param gray	星星不满足时是否显示灰色星星
		 */
		public function showStar(num:int, gray:Boolean=false):void{
			for(var i:int=0; i<5; i++){
				var mc:MovieClip = this["mc_star_"+i];
				
				if(this.contains(mc)) removeChild(mc);
				if(i<num || gray){
					addChild(mc);
				}
				mc.gotoAndStop(i<num?1:2);
			}
		}
	}
}
