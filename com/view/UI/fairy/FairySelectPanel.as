package com.view.UI.fairy {
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;

	import flash.display.MovieClip;
	import flas.events.MouseEvent;

	public class FairySelectPanel extends BasePanel {

		public var fairy0:MovieClip;

		public var fairy1:MovieClip;

		public var fairy2:MovieClip;

		public var btn_OK:CommonBtn;

		public function FairySelectPanel() {
			btn_OK.addEventListener(MouseEvent.CLICK, onOK);
		}

		protected function onOK(event:*):void {
			// TODO Auto-generated method stub

		}
	}
}
