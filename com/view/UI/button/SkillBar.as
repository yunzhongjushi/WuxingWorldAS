package com.view.UI.button
{
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class SkillBar extends MovieClip
	{
		public var tf_label:TextField;
		public function SkillBar()
		{
			this.mouseChildren=false;
		}
		public function setTf(textObj:Object):void{
			tf_label.text = String(textObj);
		}
	}
}