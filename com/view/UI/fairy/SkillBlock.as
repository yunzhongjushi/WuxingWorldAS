package com.view.UI.fairy {
	import com.model.event.ObjectEvent;
	import com.model.vo.WuxingVO;
	import com.model.vo.conn.ServerVO_68;
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.fairy.FairyListVO;
	import com.model.vo.fairy.UpgradeSkillTipVO;
	import com.model.vo.fairy.UpgradeSkillVO;
	import com.model.vo.skill.BaseSkillVO;
	import com.model.vo.tip.TipVO;
	import com.utils.TimerFactory;
	import com.view.BasePanel;
	import com.view.UI.ResourceIcon;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;

	public class SkillBlock extends BasePanel {
		public function SkillBlock() {
			super();
			this.addEventListener(MouseEvent.CLICK, onTouch);
		}


		public var rUpskillVO:UpgradeSkillVO;

		public var pic_skill:FairySkillBar
		public var btn_up:MovieClip;
		public var pl_skill:ResourceIcon;
		
		/**
		 * 是否点击升级后的冷却中
		 */
		public var onUpdating:Boolean = false;


		public function updateInfo(fairyVO:BaseFairyVO, skillVO:BaseSkillVO, position:int):void {
			if(rUpskillVO) {
				rUpskillVO.fairyVO.removeEventListener(BaseFairyVO.FAIRY_INFO_UPDATE, refresh);
			}
			fairyVO.addEventListener(BaseFairyVO.FAIRY_INFO_UPDATE, refresh);

			rUpskillVO=new UpgradeSkillVO(fairyVO, skillVO, position);
			pic_skill.updateInfo(skillVO, fairyVO);
			refresh();
			showEmpty(true);
		}

		public function showEmpty(open:Boolean=false):void {
			this.visible=open; 
		}

		private function refresh(e:ObjectEvent=null):void {
			pl_skill.updateInfo(WuxingVO.getWuxing(rUpskillVO.fairyVO.wuxing), rUpskillVO.priceStr);
			// 更新 升级按钮
			if(rUpskillVO.getCanUpdate()) {
				btn_up.gotoAndStop(1);
			} else {
				btn_up.gotoAndStop(2);
			}
		}

		protected function handle_timer(event:*=null):void {
			onUpdating = false;
			ServerVO_68.upgrade_skill(rUpskillVO);
		}

		private function onTouch(e:*):void {
			switch(e.target) {
				case btn_up:
					if(btn_up.currentFrame==2) return;

					if(rUpskillVO.getCanIncreaseLV()) {
						rUpskillVO.setUpdateOne();
						FairyListVO.testLevelupSkill(rUpskillVO);
						TimerFactory.once(500, this, handle_timer);//设定连点升级的延迟500ms
						onUpdating = true;
					} else {
						TimerFactory.clear(this, handle_timer);
						ServerVO_68.upgrade_skill(rUpskillVO);// 资源不够，先把之前升级的次数提交
						rUpskillVO.setCostMoney();// 变更状态，
						trace("- 五行不足，需要五行数量：", rUpskillVO.needWuxing);
						TipVO.showChoosePanel(new UpgradeSkillTipVO(rUpskillVO));//升级技能需要资源不足，弹出提示
					}
					break;
			}
		}

		public function sendOnekeyUp():void {
			if(rUpskillVO.skillLV==0)
				return;
			rUpskillVO.setTotalUpgrade();
			ServerVO_68.upgrade_skill(rUpskillVO);
			rUpskillVO.doneTotalUpgrade();
		}
	}
}
