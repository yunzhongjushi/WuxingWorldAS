package com.view.UI.loot {
	import com.model.vo.conn.ServerVO_193;
	import com.model.vo.loot.LootOpponentVO;
	import com.model.vo.loot.LootVO;
	import com.model.vo.tip.TipVO;
	import com.model.vo.user.UserVO;
	import com.view.BasePanel;
	import com.view.UI.fairy.FairyBarSmall;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class LootOpponentPanel extends BasePanel {
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		
		public function LootOpponentPanel() {
			btn_match.setNameTxt("下一个");
			btn_match.setNameTxt("掠 夺");
			this.addEventListener(MouseEvent.CLICK, handle_click);
		}

		public function handle_click(e:*):void {
			switch(e.target) {
				case btn_match:
					ServerVO_193.getSendGetMatchInfo();
					break;
				case btn_loot:
					this.close();
					
					var oppoVO:LootOpponentVO = e.data as LootOpponentVO
					ServerVO_193.getSendStartLoot(oppoVO.playerID);
					break;
			}
		}

		//****************   以上为模板，请勿随意改动。   *******************************

		//Event Names
		//场景含有组件
		public var btn_match:CommonBtn;

		public var btn_loot:CommonBtn;

		public var tf_match_cost:TextField;
		
		public var mc_fairyBG:MovieClip;

		public var tf_opponent:TextField

		public var tf_time:TextField;

		public var tf_win_trophies:TextField

		public var tf_lost_trophies:TextField

		public var tf_loot_jin:TextField;

		public var tf_loot_mu:TextField;

		public var tf_loot_tu:TextField;

		public var tf_loot_shui:TextField;

		public var tf_loot_huo:TextField;

		public var fairyBar_1:FairyBarSmall;

		public var fairyBar_2:FairyBarSmall;

		public var fairyBar_3:FairyBarSmall;

		//
		private var running_vo:LootOpponentVO;

		private var running_lootVO:LootVO;

		public function updateInfo(oppoVO:LootOpponentVO=null, lootVO:LootVO=null):void {
			if(oppoVO!=null) {
				set_running_vo(oppoVO);
			}
			if(lootVO!=null) {
				set_running_lootVO(lootVO);
			}
		}

		public function update():void {
			if(running_lootVO) {
				tf_time.text=running_lootVO.getMatchCountdown()
				if(running_lootVO.getIsMatchCountdownOver()&&this.parent) {
					running_vo=null;
					TipVO.showChoosePanel(new TipVO("匹配超时", "没有发布命令，匹配结束！\n请重新匹配"));
				}
			}
		}

		private function set_running_vo(oppoVO:LootOpponentVO):void {
			running_vo=oppoVO;

			tf_opponent.text=running_vo.oppoName
			tf_loot_jin.text=String(running_vo.getResource(0))
			tf_loot_mu.text=String(running_vo.getResource(1))
			tf_loot_tu.text=String(running_vo.getResource(2))
			tf_loot_shui.text=String(running_vo.getResource(3))
			tf_loot_huo.text=String(running_vo.getResource(4))
			tf_win_trophies.text=String(running_vo.getWin())
			tf_lost_trophies.text=String(running_vo.getLost())

//					fairyBar_1.updateInfo(running_vo.getFairyVO(LootOpponentVO.POS_1));
//					fairyBar_2.updateInfo(running_vo.getFairyVO(LootOpponentVO.POS_2));
//					fairyBar_3.updateInfo(running_vo.getFairyVO(LootOpponentVO.POS_3));
		}

		private function set_running_lootVO(lootVO:LootVO):void {
			running_lootVO=lootVO;
			tf_match_cost.text=running_lootVO.getMatchCostDescription()
			running_lootVO.newMatchTime();
			tf_time.text=running_lootVO.getMatchCountdown();
		}

	}
}
