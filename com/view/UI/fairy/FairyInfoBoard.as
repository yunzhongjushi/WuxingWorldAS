package com.view.UI.fairy {
	import com.model.vo.WuxingVO;
	import com.model.vo.config.item.ItemConfig;
	import com.model.vo.conn.ServerVO_68;
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.fairy.FairyListVO;
	import com.model.vo.fairy.LevelupFairyVO;
	import com.model.vo.fairy.StrengthenFairyVO;
	import com.model.vo.fairy.UpgradeTotalSkillTipVO;
	import com.model.vo.item.FairyEquipVO;
	import com.model.vo.item.ItemListVO;
	import com.model.vo.item.ItemResourceVO;
	import com.model.vo.item.ItemVO;
	import com.model.vo.skill.BaseSkillVO;
	import com.model.vo.tip.TipVO;
	import com.model.vo.user.UserVO;
	import com.utils.TimerFactory;
	import com.view.BasePanel;
	import com.view.UI.ResourceIcon;
	import com.view.mediator.fairy.UplevelFairyTipVO;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	import flas.geom.Point;
	
	import flash.events.Event;
	import flash.text.TextField;

	public class FairyInfoBoard extends BasePanel {
		//===================== 精灵信息 =========================
		/**
		 * 精灵头像框
		 */
		public var fairyBarMiddle:FairyBarMiddle
		/**
		 * 文本：名称
		 */
		public var tf_name:TextField;
		/**
		 * 文本：血量
		 */
		public var tf_hp:TextField;
		/**
		 * 文本：攻击力
		 */
		public var tf_atk:TextField;
		/**
		 * 文本：防御力
		 */
		public var tf_def:TextField;
		/**
		 * 文本：战力
		 */
		public var tf_fight:TextField;
		/**
		 * 装备框 0-5
		 */
		public var equipment_0:FairyEquipmentBar;
		public var equipment_1:FairyEquipmentBar;
		public var equipment_2:FairyEquipmentBar;
		public var equipment_3:FairyEquipmentBar;
		public var equipment_4:FairyEquipmentBar;
		public var equipment_5:FairyEquipmentBar;

		/**
		 * 文本：等级
		 */
		public var tf_lv:TextField;
		/**
		 * 经验进度条
		 */
		public var progress_exp:FairyExpProgress;
		/**
		 * 功能：喂养
		 */
		public var btn_uplevel_fairy:CommonBtn;
		/**
		 * 功能：强化
		 */
		public var btn_strengthen:CommonBtn;
		/**
		 * 功能：升阶
		 */
		public var btn_upgrade_fairy:CommonBtn;
		/**
		 * 便签：升级价格
		 */
		public var pl_levelup:ResourceIcon;
		/**
		 * 碎片进度条
		 */
		public var progress_piece:FairyPieceProgress;
		/**
		 * 强化VO
		 */
		private var rStrengthVO:StrengthenFairyVO;

		private var rLevelupFairyVO:LevelupFairyVO;

		//===================== 技能栏 =========================
		/**
		 * 技能框 1-4
		 */
		public var skillBar_0:SkillBlock
		public var skillBar_1:SkillBlock
		public var skillBar_2:SkillBlock
		public var skillBar_3:SkillBlock
		/**
		 * 功能：一键升级全部技能
		 */
		public var btn_upTotal:CommonBtn;
		/**
		 * 一键升级全部技能价格
		 */
		public var pl_upTotal:ResourceIcon;
		/**
		 * 技能信息提示框
		 */
		public var fairySkillInfo:FairySkillInfo;

		/**
		 * 物品列表VO
		 *
		 */
		public function get itemListVO():ItemListVO {
			return ItemListVO.getInstance()
		}
		
		public var totalCost:int = 0;
		
		
		
		

		/**
		 * 精灵信息面板（主面板中间）
		 *
		 * 
		 * 
		 * 
		 * 
		 */
		public function FairyInfoBoard() {
			this.addEventListener(Event.ADDED_TO_STAGE, handle_add);
			FairyListVO.getInstance().addEventListener(FairyListVO.UPDATE_FAIRYS_INFO, refreshVO);
		}

		protected function refreshVO(e:Event):void {
			if(rFairyVO) {
				rFairyVO.removeEventListener(BaseFairyVO.FAIRY_INFO_UPDATE, refresh);
				rFairyVO=FairyListVO.getFairy(rFairyVO.ID);
				if(rFairyVO) {
					rFairyVO.addEventListener(BaseFairyVO.FAIRY_INFO_UPDATE, refresh);
					refresh()
				}
			}
		}

		/**
		 * 初始化
		 * @param e
		 */
		private function handle_add(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, handle_add);

			btn_upgrade_fairy.setNameTxt("进  阶");
			btn_strengthen.setNameTxt("强  化");
			btn_uplevel_fairy.setNameTxt("升  级");
			btn_upTotal.setNameTxt("一键升级");

			var equipBar:FairyEquipmentBar;
			for(var j:int=0; j<=5; j++) {
				equipBar=this["equipment_"+j] as FairyEquipmentBar;
				equipBar.stateCover.visible=false;
			}

			this.removeChild(fairySkillInfo);

			this.addEventListener(MouseEvent.CLICK, handle_click);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onSkillInfo);
			this.addEventListener(MouseEvent.MOUSE_UP, onSkillInfo);
			this.addEventListener(MouseEvent.MOUSE_OUT, onSkillInfo);
		}

		protected function onSkillInfo(e:*):void {
			if(e.target is FairySkillBar) {
				switch(e.type) {
					case MouseEvent.MOUSE_DOWN:
						var bar:FairySkillBar = e.target as FairySkillBar;
						fairySkillInfo.updateInfo(bar.running_vo);
						fairySkillInfo.y = bar.localToGlobal(new Point(x, bar.y)).y-140;
						this.addChild(fairySkillInfo);
						break;
					case MouseEvent.MOUSE_UP:
					case MouseEvent.MOUSE_OUT:
						if(fairySkillInfo.parent)
							this.removeChild(fairySkillInfo);
						break;
				}
			}
		}

		/**
		 * 按键打开功能面板
		 * @param e
		 */
		private function handle_click(e:*):void {
			switch(e.target) {
				case btn_upgrade_fairy:
					ServerVO_68.upgrade_fairy(rFairyVO);
					break;
				case btn_strengthen:
					ServerVO_68.strengthen_fairy(rStrengthVO);
					refresh();
					break;
				case btn_uplevel_fairy:
					if(rLevelupFairyVO.getCanIncrease()) {
						rLevelupFairyVO.setAdd();
						FairyListVO.testLevelupFairy(rLevelupFairyVO);
						TimerFactory.once(500, this, handle_timer);//设定连点升级的延迟500ms
					} else {
						TimerFactory.clear(this, handle_timer);
						upFairy();// 资源不够，先把之前升级的次数提交
						rLevelupFairyVO.doneAdd();
						rLevelupFairyVO.setCostMoney();// 变更状态，
						upFairy();
					}
					break;
				case btn_upTotal:
					var skillBar:SkillBlock
					for(var i:int=0; i<4; i++) {
						skillBar=this["skillBar_"+i] as SkillBlock;
						if(skillBar.onUpdating) {
							return;
						}
					}
					var cur:int = currentResource;
					if(totalCost<=cur) {
						sendOnekeyup();
					} else {
						trace("- 五行不足，需要五行数量：", totalCost-cur);
						TipVO.showChoosePanel(new UpgradeTotalSkillTipVO(new ItemResourceVO(wuxing+10, totalCost-cur)));
					}
					break;
			}
		}
		
		private function upFairy():void{
			if(rLevelupFairyVO.isCostMoney) {
				var nowWuxing:int=UserVO.getInstance().wuxingInfo.getResource(rLevelupFairyVO.fairyVO.wuxing);
				trace("- 五行不足，需要五行数量：", rLevelupFairyVO.fairyVO.needExp-nowWuxing);
				TipVO.showChoosePanel(new UplevelFairyTipVO(rLevelupFairyVO.fairyVO.needExp-nowWuxing, rLevelupFairyVO));
			} else {
				if(rLevelupFairyVO.upgradeTime==0)
					return;
				ServerVO_68.uplevel_fairy(rLevelupFairyVO.fairyVO.ID, rLevelupFairyVO.upgradeTime, false);
			}
		}

		protected function handle_timer(event:*=null):void {
			upFairy();
			rLevelupFairyVO.doneAdd();
		}

		public function sendOnekeyup():void {
			var skillBar:SkillBlock
			for(var i:int=0; i<4; i++) {
				skillBar=this["skillBar_"+i] as SkillBlock;
				skillBar.sendOnekeyUp();
			}
		}
		/**
		 * 当前显示的精灵VO
		 */
		public var rFairyVO:BaseFairyVO;
		public function get wuxing():int{
			return rFairyVO.wuxing;
		}
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		public var nowFairyLV:int = 0;
		public var nowFairyID:int = 0;
		/**
		 * 角色拥有的当前技能升级需要的五行元素量
		 */
		public function get currentResource():int{
			return userInfo.wuxingInfo.getResource(wuxing);
		}

		/**
		 * 更新数据
		 * @param vo
		 */
		public function updateVO(vo:BaseFairyVO):void {
			if(vo) {
				if(rFairyVO) {
					rFairyVO.removeEventListener(BaseFairyVO.FAIRY_INFO_UPDATE, refresh);
				}
				rFairyVO = vo;
				rFairyVO.addEventListener(BaseFairyVO.FAIRY_INFO_UPDATE, refresh);
				refresh();

				rLevelupFairyVO = new LevelupFairyVO(rFairyVO);
			}
		}
		/**
		 * 使用中的FairyEquipVO
		 */
		private var tempEquipArr:Array=[new FairyEquipVO, new FairyEquipVO, new FairyEquipVO, new FairyEquipVO, new FairyEquipVO, new FairyEquipVO];

		/**
		 * 更新面板
		 * @param e
		 */
		public function refresh(e:Event=null):void {
			if(rFairyVO) {
				fairyBarMiddle.updateInfo(rFairyVO);

				// 属性
				tf_name.text=rFairyVO.nickName;
				tf_lv.text=String(rFairyVO.LV);
				tf_hp.text=String(rFairyVO.HP_max);
				tf_atk.text=String(rFairyVO.finalAP);
				tf_def.text=String(rFairyVO.finalDP);
				
				if(nowFairyID==rFairyVO.ID && nowFairyLV<rFairyVO.LV){
					fairyBarMiddle.updateLvUP();
					progress_exp.updateLVUP();
				}else{
					progress_exp.updateInfo(rFairyVO.needExp, rFairyVO.needTotalExp);
				}
				nowFairyID = rFairyVO.ID;
				nowFairyLV = rFairyVO.LV;

				// 技能
				totalCost = 0;
				for(var i:int=0; i<4; i++) {
					var skillBar:SkillBlock = this["skillBar_"+i] as SkillBlock;
					var skillVO:BaseSkillVO = rFairyVO.baseSkillArr[i] as BaseSkillVO;
					if(skillVO) {
						skillBar.updateInfo(rFairyVO, skillVO, i);
						totalCost += skillBar.rUpskillVO.getTotalPrice();
					} else {
						skillBar.showEmpty();
						continue;
					}

					skillBar.updateInfo(rFairyVO, skillVO, i);
					totalCost += skillBar.rUpskillVO.getTotalPrice();
				}
				
				btn_upTotal.visible = totalCost>0;
				pl_upTotal.visible = totalCost>0;
				pl_upTotal.updateInfo(WuxingVO.getWuxing(rFairyVO.wuxing), String(totalCost));

				// 装备
				for(var j:int=0; j<=5; j++) {
					var equipBar:FairyEquipmentBar = this["equipment_"+j] as FairyEquipmentBar;
					var tempID:int=ItemConfig.getEquipID(rFairyVO.wuxing, rFairyVO.intensLV, j);
					var vo:FairyEquipVO=ItemListVO.getEquipVO(tempID);
					if(!vo) {
						vo = (tempEquipArr[j] as FairyEquipVO).updateInfo(tempID);
					}
					equipBar.updateInfo(j, vo, rFairyVO, rFairyVO.equipArray[j]);
				}

				btn_upgrade_fairy.setEnable(false);
				if(rFairyVO.intensLV<BaseInfo.EQUIP_UPGRADE_MAX && rFairyVO.equipArray.length==6) {
					btn_upgrade_fairy.setEnable(true);
					var equipFairyVO:FairyEquipVO;
					for(var k:int=0; k<rFairyVO.equipArray.length; k++) {
						equipFairyVO=rFairyVO.equipArray[k] as FairyEquipVO;
						if(equipFairyVO==null) {
							btn_upgrade_fairy.setEnable(false);
						}
					}

				}
				// 升级按钮 
				pl_levelup.updateInfo(WuxingVO.getWuxing(rFairyVO.wuxing), rFairyVO.needExp>0?String(rFairyVO.needExp):"最高等级");
//				if(rFairyVO.needExp > 0){
//					tf_levelup.text = "升级消耗："+String(rFairyVO.needExp)+" "+rFairyVO.wuxing+"元素";
//				}else{
//					tf_levelup.text = "已达最高等级" 
//				}

				// 强化
				rStrengthVO=new StrengthenFairyVO(rFairyVO, ItemListVO.getItemByTempID(rFairyVO.data.mergeID))
				progress_piece.updateInfo(rStrengthVO.getMergeNum(), rStrengthVO.getCostMeger());
//				tf_piece_require.text = "需要达到 "+rStrengthVO.getNeedFairyLV()+" 级"; 
				btn_strengthen.setEnable(rStrengthVO.getCanStrengthen());
			}
		}
	}
}