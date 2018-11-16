package com.view.UI.friend {

	import com.view.BasePanel;
	import com.view.touch.CommonBtn;

	import flash.events.Event;

	import flas.events.MouseEvent;
	import flash.text.TextField;

	public class FriendAddBox extends BasePanel {
		public var btn_add:CommonBtn
		public var tf_nickName:TextField;
		public var tf_warning:TextField;
		public var btnPool:Array;

		public function FriendAddBox() {
			super();
			btn_add.setNameTxt("添 加");
			this.addEventListener(MouseEvent.CLICK, handle_click);
			this.addEventListener(Event.REMOVED_FROM_STAGE, handle_remove);
		}

		protected function handle_remove(e:Event):void {
			isShowTip=false;
		}
		public static const E_AddFriend:String="E_AddFriend";

		public function handle_click(e:*):void {
			switch(e.target) {
				case btn_add:
					event(E_AddFriend, getInputName());
					close();
					break;
				case tf_nickName:
					if(isShowTip==false) {
						isShowTip=true;
						tf_nickName.text="";
						tf_nickName.alpha=1;
					}
					break;
			}
		}

		private function getInputName():String {
			if(isShowTip==false) {
				return "";
			}
			return tf_nickName.text;
		}

		private var isShowTip:Boolean=false;

		public function updateInfo(str:String):void {
			tf_warning.text=str;
			if(isShowTip==false) {
				tf_nickName.text="点击输入"
				tf_nickName.alpha=0.8;
			}
		}
	}
}
