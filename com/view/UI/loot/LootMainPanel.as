package com.view.UI.loot {
	import com.model.vo.conn.ServerVO_193;
	import com.model.vo.loot.LootVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class LootMainPanel extends BasePanel {
		public function LootMainPanel() {
			btn_match.setNameTxt("开始掠夺");
			this.addEventListener(MouseEvent.CLICK, handle_click);
		}

		public function handle_click(e:*):void {
			switch(e.target) {
				case btn_match:
					ServerVO_193.getSendGetMatchInfo();
					break;
				case btn_top:
					event(E_TOP);
					break;
			}
		}
		//****************   以上为模板，请勿随意改动。   *******************************
		public static const E_TOP:String="E_TOP";
		//Event Names
		//场景含有组件
		public var tf_trophies:TextField
		public var tf_extraLoot:TextField
		public var tf_protectTime:TextField
		public var tf_matchCost:TextField
		public var btn_top:MovieClip
		public var mc_boardBG:MovieClip;
//		public var level_1:PuzzleLevelBar;
//		public var level_2:PuzzleLevelBar;
//		public var level_3:PuzzleLevelBar;
//		public var level_4:PuzzleLevelBar;
//		public var level_5:PuzzleLevelBar;
		public var btn_mode:CommonBtn;
		public var btn_next:CommonBtn;
		public var btn_match:CommonBtn;
		//
		private var lootVO:LootVO;

		public function updateInfo(lootVO:LootVO):void {
			this.lootVO=lootVO;
			update();
		}

		public function update():void {
			tf_extraLoot.text=lootVO.getExtraDescription();
			tf_protectTime.text=lootVO.getProtectDescription();
			tf_trophies.text=String(lootVO.rank);
			tf_matchCost.text=lootVO.getMatchCostDescription();
		}

	}
}
