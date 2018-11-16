package com.view.UI.tip {
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * 带美女的引导文字框
	 * @author hunterxie
	 */
	public class GuideFairy extends Sprite{
		public var tf_info:TextField;
		
		public var mc_bg:Sprite;
		
		public function GuideFairy() {
			
		}
		/**
		 * 更新文字调整框的长度
		 * @param info
		 */
		public function updateInfo(info:String):void{
			tf_info.text = info;
			if(info.length>20){
				tf_info.width = info.length*6+5;
				mc_bg.width = tf_info.width+100;
			}else{
				tf_info.width = 120;
				mc_bg.width = 300;
			}
		}
	}
}
