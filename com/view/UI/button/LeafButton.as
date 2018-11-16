package com.view.UI.button {
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * 
	 * @author hunterxie
	 * 
	 */
	public class LeafButton extends MovieClip {
		public var kind:String = "";

		public var tf_label_1:TextField;
		public var tf_label_2:TextField;

		public function LeafButton() {
			this.mouseChildren=false;
		}

		public function setTf(textObj:Object):void {
			kind = tf_label_1.text = tf_label_2.text = String(textObj);
		}

		public function turnOn():void {
			tf_label_1.visible=true;
			tf_label_2.visible=false;
			this.gotoAndStop(2);
		}

		public function turnOff():void {
			tf_label_1.visible=false;
			tf_label_2.visible=true;
			this.gotoAndStop(1);
		}
	}
}
