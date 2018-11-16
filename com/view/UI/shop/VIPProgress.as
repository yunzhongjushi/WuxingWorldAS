package com.view.UI.shop
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	

	public class VIPProgress extends MovieClip
	{
		
		public var tf_percent:TextField;
		
		public var mc_cover:MovieClip;
		
		public function VIPProgress()
		{
		}
		
		public function updateInfo(cur:int,target:int):void
		{
			tf_percent.text = String(cur) + "/" + String(target);
			
			var percent:Number = cur / target;
			
			mc_cover.x = (percent - 1) * mc_cover.width;
		}
	}
} 