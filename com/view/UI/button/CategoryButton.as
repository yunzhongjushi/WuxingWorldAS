package com.view.UI.button
{
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class CategoryButton extends MovieClip
	{
		public var tf_label_1:TextField;
		public var tf_label_2:TextField;
		public function CategoryButton()
		{
			this.mouseChildren=false;
		}
		public function setTf(textObj:Object):void{
			tf_label_1.text = String(textObj);
			tf_label_2.text = String(textObj);
		}
		public function turnOn():void{
			
			tf_label_1.visible = true;
			 
			tf_label_2.visible = false;
			
			this.gotoAndStop(1);
		}
		public function turnOff():void{
			
			tf_label_1.visible = false; 
			
			tf_label_2.visible = true;
			
			this.gotoAndStop(2);
		}
	}
} 