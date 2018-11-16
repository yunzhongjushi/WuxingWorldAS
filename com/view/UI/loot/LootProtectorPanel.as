package com.view.UI.loot {
	import com.model.vo.loot.LootVO;
	import com.view.BasePanel;
	import com.view.UI.fairy.FairyBarSmall;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	import flash.text.TextField;

	public class LootProtectorPanel extends BasePanel {
		public function LootProtectorPanel() {
			btn_feed.setNameTxt("鼓 舞");
			fairyChanger_1.setNameTxt("召 唤");
			fairyChanger_2.setNameTxt("更 换");
			fairyChanger_3.setNameTxt("更 换");

			this.addEventListener(MouseEvent.CLICK, handle_click);
		}

		public function handle_click(e:*):void {
			switch(e.target) {
				case fairyChanger_1:
					running_pos=LootVO.POS_1;
					event(E_CHANGE, running_pos);
					break;
				case fairyChanger_2:
					running_pos=LootVO.POS_2;
					event(E_CHANGE, running_pos);
					break;
				case fairyChanger_3:
					running_pos=LootVO.POS_3;
					event(E_CHANGE, running_pos);
					break;
				case btn_feed:
					if(running_vo.getIsFeedable()) {
						event(E_FEED);
					}
					break;
			}
		}

		//****************   以上为模板，请勿随意改动。   *******************************
		//Function Names
		public static const E_CHANGE:String="E_CHANGE";
		public static const E_FEED:String="E_FEED";
		//Event Names
		//场景含有组件

		public var btn_feed:CommonBtn
		public var fairyChanger_1:CommonBtn;
		public var fairyChanger_2:CommonBtn;
		public var fairyChanger_3:CommonBtn;
		public var tf_feed_label:TextField
		public var tf_protector_label:TextField
		public var fairyBar_1:FairyBarSmall
		public var fairyBar_2:FairyBarSmall
		public var fairyBar_3:FairyBarSmall

		//
		private var running_vo:LootVO;
		private var running_pos:String


		public function updateInfo(lootVO:LootVO):void {
			set_running_vo(lootVO);
			update()
		}

		public function update():void {
			tf_feed_label.text=running_vo.getFeedLabel()
		}

		private function set_running_vo(vo:LootVO):void {
			running_vo=vo;
			tf_protector_label.text=vo.getFairyVO(LootVO.POS_1).getPerformanceDescription()
//					fairyBar_1.updateInfo(running_vo.getFairyVO(LootVO.POS_1));
//					fairyBar_2.updateInfo(running_vo.getFairyVO(LootVO.POS_2));
//					fairyBar_3.updateInfo(running_vo.getFairyVO(LootVO.POS_3)); 
			running_pos=running_vo.getDefaultShowPos();

		}
	}
}
