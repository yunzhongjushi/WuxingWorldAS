package com.model.vo.fairy {
	import com.model.vo.item.ItemVO;
	import com.model.vo.user.UserVO;

	/**
	 *	升级精灵
	 * @author CC5
	 */
	public class LevelupFairyVO {
		public static const MAX_LV:int=100;

		public var fairyVO:BaseFairyVO;
		public var lv:int;

		public function LevelupFairyVO(fairyVO:BaseFairyVO) {
			this.fairyVO=fairyVO;
			upgradeTime=0;
			isCostMoney=false;
			lv=fairyVO.LV;
		}

		public function getCanIncrease():Boolean {
			return (fairyVO.LV<MAX_LV)&&UserVO.getInstance().wuxingInfo.getResource(fairyVO.wuxing)>=fairyVO.needExp;
		}
		public var upgradeTime:int;

		public function setAdd():void {
			upgradeTime++;
			isCostMoney=false;
		}

		public function doneAdd():void {
			upgradeTime=0;
			lv=fairyVO.LV;
			isCostMoney=false;
		}
		public var isCostMoney:Boolean

		public function setCostMoney():void {
			upgradeTime=0;
			isCostMoney=true;
		}
	}
}
