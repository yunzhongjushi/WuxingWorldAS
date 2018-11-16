package com.model.vo.fairy {
	import com.model.vo.skill.BaseSkillVO;
	import com.model.vo.user.UserVO;

	public class UpgradeSkillVO {
		/**
		 * 技能最高等级
		 */
		public static const MAX_LEVLE:int=100;
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		/**
		 * 角色拥有的当前技能升级需要的五行元素量
		 */
		public function get currentResource():int{
			return userInfo.wuxingInfo.getResource(wuxing);
		}

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
		public static const STATE_NORMAL:String="STATE_NORMAL";
		public static const STATE_NOT_WUXING:String="STATE_NOT_ENOUGH";
		public static const STATE_COST_MONEY:String="STATE_COST_MONEY";

		public var fairyVO:BaseFairyVO;

		public var skillPosition:int; //1,2,3,4
		/**
		 * 是否
		 */
		public var state:String;

		private var skillVO:BaseSkillVO;
		
		public function get wuxing():int{
			return fairyVO.wuxing;
		}
		

		public function get skillLV():int{
			return skillVO.LV;
		}
		public var upgradeTime:int=0;

		/**
		 * 提示五行不足时，需要的五行量
		 */
		public var needWuxing:int=0;


		public function UpgradeSkillVO(fairyVO:BaseFairyVO, skillVO:BaseSkillVO, skillPosition:int) {
			this.fairyVO=fairyVO;
			this.skillPosition=skillPosition;
			this.skillVO=skillVO;

//			this.wuxing=fairyVO.wuxingInfo.myWuxing;
//			skillLV=skillVO.LV;
		}

		public function getCanIncreaseLV():Boolean {
			state = STATE_NORMAL;
			return currentResource>=getCost(skillLV, skillLV+upgradeTime);
		}

		/**
		 * 获取当前升级需要资源量
		 * @return 为0就是未觉醒
		 */
		public function get priceStr():String {
			var num:int = getCost(skillLV, skillLV);
			return num==0 ? "未觉醒" : String(num);
		}

		public function getTotalPrice():int {
			if(skillLV==0)
				return 0;
			return getCost(skillLV+upgradeTime, fairyVO.LV-1);
		}

		public function getUpgradeSkillCost():int {
			return getCost(skillLV, skillLV+upgradeTime-1);
		}

		/**
		 * 获取升级需要资源量
		 * @param fromLV	从基础级
		 * @param toLV		升到级目标级
		 * @return 为0就是未觉醒
		 */
		private function getCost(fromLV:int, toLV:int):int {
			var total:int=0;
			for(var i:int=skillLV; i<=toLV; i++) {
				total+=getUpgradeCost(i);
			}
			return total;
		}

		public function getTargetLV():int {
			return skillLV+upgradeTime;
		}

		public function setUpdateOne():void {
			state=STATE_NORMAL;
			upgradeTime++;
		}

		/**
		 * 
		 */
		public function setCostMoney():void {
			state = STATE_COST_MONEY;
			needWuxing = getCost(skillLV, skillLV)-currentResource;
		}

		public function setTotalUpgrade():void {
			state=STATE_COST_MONEY;
			needWuxing = getTotalPrice()-currentResource;
			upgradeTime=fairyVO.LV-skillLV;
		}

		public function doneTotalUpgrade():void {
			FairyListVO.getFairy(fairyVO.ID).upgradeSkillLV(skillPosition, fairyVO.LV);
		}

		public function getIsCostMoney():Boolean {
			if(state==STATE_COST_MONEY) {
				return true;
			}
			return false;
		}

		public function getCanUpdate():Boolean {
			return (skillLV+upgradeTime<MAX_LEVLE)&&(skillLV+upgradeTime<fairyVO.LV)&&skillVO.LV!=0;
		}

		public function getIsMaxLV():Boolean {
			return (skillLV>=MAX_LEVLE)
		}

		/**
		 *
		 * @param lv 升级到哪个等级, 0->1时, Lv=1;
		 * @return
		 *
		 */
		public static function getUpgradeCost(lv:int):int {
			// 消耗值为：50*K+50*1.05^（K-1）
			return Math.ceil(50*lv+50*Math.pow(1.05, lv-1));
		}
	}
}
