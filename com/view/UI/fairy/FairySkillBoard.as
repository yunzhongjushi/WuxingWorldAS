package com.view.UI.fairy {
	import com.model.event.ObjectEvent;
	import com.model.vo.conn.ServerVO_68;
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.fairy.FairyListVO;
	import com.model.vo.fairy.UpgradeSkillTipVO;
	import com.model.vo.fairy.UpgradeSkillVO;
	import com.model.vo.skill.BaseSkillVO;
	import com.model.vo.tip.TipVO;
	import com.utils.TimerFactory;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.text.TextField;

	/**
	 * 技能面板
	 * @author hunterxie
	 */
	public class FairySkillBoard extends BasePanel {

		public var fairySkillBar:FairySkillBar

		public var tf_name:TextField;

		public var tf_lv:TextField;

		public var tf_current:TextField;

		public var tf_next:TextField;

		public var tf_cost:TextField;

		public var tf_energy:TextField;

		public var btn_upgrade:CommonBtn;


		public function FairySkillBoard() {
			this.addEventListener(MouseEvent.CLICK, handle_click);
			btn_upgrade.setNameTxt("升  级");
		}

		/**
		 *  发送消息：升级技能
		 *
		 * 设定连点升级的延迟500ms
		 * @param event
		 *
		 */
		protected function handle_timer(event:*=null):void {
			FairyListVO.testLevelupSkill(running_upgradeVO);
		}

		/**
		 * 发送消息：升级技能
		 *
		 * 设定连点升级的延迟500ms
		 * @param e
		 *
		 */
		protected function handle_click(e:*):void {
			switch(e.target) {
				case btn_upgrade:

					if(running_upgradeVO.getCanIncreaseLV()) {
						FairyListVO.testLevelupSkill(running_upgradeVO);
						TimerFactory.once(500, this, handle_timer);
					} else {
						TimerFactory.clear(this, handle_timer);

						/**
						 * 在tryIncreaseLV()后
						 *
						 * 如果资源足够升级，则将state设置为STATE_NORMAL
						 * 计时器到期后，会将 state = STATE_NORMAL 的升级技能消息发送出去
						 *
						 * 如果不够升级，则将state设置为STATE_NOT_ENOUGH
						 * 直接将 state = STATE_NOT_ENOUGH 的升级技能消息发送出去
						 *
						 * 之后通过applyCostMoney(), 将state变更为STATE_COST_MONEY
						 * 直接将 state = STATE_COST_MONEY 的升级技能消息发送出去，打开是否支付钻石的弹窗
						 *
						 */
						ServerVO_68.upgrade_skill(running_upgradeVO);	// 资源不够，先把之前升级的次数提交
						running_upgradeVO.setCostMoney();				// 变更状态，
						trace("- 五行不足，需要五行数量：", vo.needWuxing);
						TipVO.showChoosePanel(new UpgradeSkillTipVO(running_upgradeVO));//升级技能需要资源不足，弹出提示
					}
					break;
			}
		}


		private var running_vo:BaseSkillVO;

		private var running_fairyVO:BaseFairyVO;

		private var running_upgradeVO:UpgradeSkillVO;

		/**
		 * 更新数据
		 * @param skillVO
		 * @param fairyVO
		 * @param skillUpgradeVO
		 *
		 */
		public function updateInfo(skillVO:BaseSkillVO, fairyVO:BaseFairyVO, skillUpgradeVO:UpgradeSkillVO):void {
			running_vo=skillVO;

			if(running_fairyVO) {
				running_fairyVO.removeEventListener(BaseFairyVO.FAIRY_INFO_UPDATE, refresh);
			}

			running_fairyVO=fairyVO;

			running_fairyVO.addEventListener(BaseFairyVO.FAIRY_INFO_UPDATE, refresh);

			fairySkillBar.updateInfo(running_vo, running_fairyVO, false);

			running_upgradeVO=skillUpgradeVO;

			refresh();
		}

		/**
		 * 更新面板
		 * @param e
		 *
		 */
		private function refresh(e:ObjectEvent=null):void {

			tf_name.text=running_vo.name;

			tf_lv.text="等级 "+running_vo.LV

			tf_current.text=running_vo.describe //"无视魔免，敌方全体英雄沉默，持续5秒。不够长怎么办，加长他。";

			tf_next.text=running_vo.describe //"无视魔免，敌方全体英雄沉默，持续5秒。不够长怎么办，加长他。"; 

			var wuxing:String=running_upgradeVO.wuxing;

			tf_cost.text=running_upgradeVO.getCost()+wuxing+"元素";

			tf_energy.text=running_upgradeVO.currentWuxing+wuxing+"元素";

			if(running_upgradeVO.getCanUpdate()) {
				btn_upgrade.setEnable(true);
			} else {
				btn_upgrade.setEnable(false);
			}

			// 升至最高级
			if(running_upgradeVO.getIsMaxLV()) {
				tf_next.text="该技能已达到最高等级。";
				tf_cost.text="不可升级";
			}
		}

	}
}
