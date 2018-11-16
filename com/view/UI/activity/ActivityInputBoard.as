package com.view.UI.activity {
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	import flash.text.TextField;

	public class ActivityInputBoard extends BasePanel {
		public function ActivityInputBoard() {
			btn_cancel.setNameTxt("取 消")
			btn_ok.setNameTxt("确 定")
			this.addEventListener(MouseEvent.CLICK, handle_click);
		}

		public function handle_click(e:*):void {
			switch(e.target) {
				case btn_cancel:
					this.close();
					break;
				case btn_ok:
					event(E_INPUT, tf_input.text);
					this.close();
					//							getFnByName(E_ADD).call(null,sendObj);
					break;
			}
		}
		//****************   以上为模板，请勿随意改动。   *******************************
		//Function Names
		public static const E_INPUT:String="E_INPUT";
		//Event Names
		//场景含有组件
		public var btn_cancel:CommonBtn;
		public var btn_ok:CommonBtn;
		public var tf_input:TextField;


	}
}
