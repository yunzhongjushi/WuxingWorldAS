package com.view.UI.fairy
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class FairyPieceProgress extends MovieClip
	{
		
		public var tf_progress:TextField;
		
		public var mc_cover:MovieClip;
		
		public function FairyPieceProgress()
		{
			super();
		}
		
		public function updateInfo(cur:int, total:int):void
		{
			tf_progress.text = cur + " / "+total;
			mc_cover.x = ( Math.min(0, Number( cur/total )- 1) ) * mc_cover.width ;
		}
	}
}