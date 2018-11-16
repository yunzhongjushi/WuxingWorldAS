package com.view.UI.shop {
	import com.model.vo.shop.VIPVO;
	import com.model.vo.user.UserVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flas.events.MouseEvent;

	public class ShopMainPanel extends BasePanel {
		public static const E_BACK:String="E_BACK";

		public static const E_VIP:String="E_VIP";

		public static const SHOP_NAME:String="商城";

		private function get userInfo():UserVO {
			return UserVO.getInstance();
		}

		public var btn_function:CommonBtn;

		public var arr_title:MovieClip;

		public var board_vip_lv:MovieClip;
		public var cover_vip_title:MovieClip;

		public function ShopMainPanel() {
			this.addEventListener(Event.ADDED_TO_STAGE, handle_add);
			btn_function.addEventListener(MouseEvent.CLICK, handle_click);

			btn_function.setNameTxt("特 权");
			cover_vip_title.visible=false;
			arr_title.gotoAndStop(SHOP_NAME);
		}

		protected function handle_add(e:Event):void {
			board_vip_lv.visible=true;
			board_vip_lv["tf_lv"].text=String(VIPVO.getInstance().data.lv);
		}

		public function handle_click(e:*):void {
			switch(btn_function.tf_name.text) {
				case "特 权":
					event(E_VIP);
					break;
				case "返 回":
					event(E_BACK);
					break;
			}
		}

		public function updateInfo(name:Object=null, isShowBack:Object=null):void {
			if(name==null) {
				name=SHOP_NAME;
			}
			arr_title.gotoAndStop(name);

			if(isShowBack && isShowBack==true) {
				btn_function.setNameTxt("返 回");
				board_vip_lv.visible = false;
			} else {
				btn_function.setNameTxt("特 权");
				board_vip_lv.visible = true;
			}
		}

	}
}
