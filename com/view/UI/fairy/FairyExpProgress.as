package com.view.UI.fairy {
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class FairyExpProgress extends MovieClip {

		public var tf_progress:TextField;
		public var mc_cover:MovieClip;

		public function FairyExpProgress() {
		}

		public function updateInfo(cur:int, total:int):void {
			mc_cover.x = ((total-cur)/total-1)*mc_cover.width;
			tf_progress.text = (total-cur)+" / "+total;
		}
		
		public function updateLVUP():void{
			TweenLite.to(mc_cover, 0.3, {x:0, onComplete:lvupOver});
		}
		
		private function lvupOver():void{
			mc_cover.x = -mc_cover.width;
		}
	}
}
