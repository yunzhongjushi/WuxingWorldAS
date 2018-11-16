package com.view.UI.loot {
	import com.model.event.ObjectEvent;
	import com.model.vo.loot.LootOpponentVO;
	import com.view.BasePanel;
	import com.view.UI.fairy.FairyBarSmall;

	import flash.display.MovieClip;
	import flas.events.MouseEvent;

	public class LootGuardInfoPanel extends BasePanel {
		public function LootGuardInfoPanel() {

		}

		public var fairyBar_1:FairyBarSmall
		public var fairyBar_2:FairyBarSmall
		public var fairyBar_3:FairyBarSmall

		private var running_vo:LootOpponentVO;

		public function updateInfo(lootOppoVO:LootOpponentVO):void {
			set_running_vo(lootOppoVO);
		}

		private function set_running_vo(vo:LootOpponentVO):void {
			running_vo=vo;
		}
	}
}
