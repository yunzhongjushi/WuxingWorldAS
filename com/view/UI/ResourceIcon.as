package com.view.UI {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class ResourceIcon extends MovieClip{
		public var tf_num:TextField;
		
		public var mc_bg:Sprite;
		
		public function ResourceIcon() {
			stop();
		}
		
		/**
		 * 
		 * @param kind
		 * @param str 
		 * @param isShowBG
		 */
		public function updateInfo(kind:String, str:String, isShowBG:Boolean=true):void{
			this.gotoAndStop(kind);
			this.tf_num.htmlText = str;
			this.mc_bg.visible = isShowBG;
		}
	}
}
