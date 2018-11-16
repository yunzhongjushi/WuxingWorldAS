package com.view.UI.loot {
	import com.view.BasePanel;
	import com.view.UI.fairy.FairyInfoBoard;
	import com.view.touch.CommonBtn;
	
	import flash.display.MovieClip;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	public class LootSummonPanel extends BasePanel {
		public function LootSummonPanel() {
			tf_title.text="召唤守护兽"
			tf_cost.text="消耗：100火元素"
			btn_summon.setNameTxt("召 唤");
			this.addEventListener(MouseEvent.CLICK, handle_click);
		}

		public function handle_click(e:*):void {
			switch(e.target) {
				case btn_summon:
					this.close();
					event(E_SUMMON, fairyInfoBoard.rFairyVO);
					break;
				case btn_close:
					this.close();
//							getFnByName(E_CLOSE).call();
					break;
			}
		}

		public static const E_SUMMON:String="E_SUMMON";

		public var btn_summon:CommonBtn;

		public var fairyInfoBoard:FairyInfoBoard;
		public var mc_cover:MovieClip;
		public var tf_title:TextField;
		public var tf_cost:TextField;


		public function updateInfo(voList:Array):void {
			if(voList.length>=1) {
				this.addChild(fairyInfoBoard);
			} else {
				fairyInfoBoard.close();
			}
		}
	}
}
