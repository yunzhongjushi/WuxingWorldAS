
package com.view.UI.button
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class LeafButton2 extends MovieClip
	{
		
		public var tf_label_1:TextField;
		public var tf_label_2:TextField;
		public var arr_label:MovieClip;
		
		public function LeafButton2()
		{
			this.mouseChildren=false;
		}
		private var index:int;
		/**
		 * 1：黄钻特权
		 * 2：新手礼包 
		 * 3：升级礼包
		 * 4：每日礼包
		 * @param index
		 */		
		public function setTf(index:int):void{
			this.index = index;
			arr_label.gotoAndStop(index*2-1);
		}
		public function turnOn():void{
			arr_label.gotoAndStop(index*2-1);
			this.gotoAndStop(2);
		} 
		public function turnOff():void{ 
			arr_label.gotoAndStop(index*2);
			this.gotoAndStop(1);
		}
	}
} 