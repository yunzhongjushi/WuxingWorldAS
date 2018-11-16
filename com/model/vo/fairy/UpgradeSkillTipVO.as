package com.model.vo.fairy {
	import com.model.event.EventCenter;
	import com.model.vo.WuxingVO;
	import com.model.vo.tip.BuyResourceTipVO;
	import com.model.vo.tip.TipVO;

	public class UpgradeSkillTipVO extends BuyResourceTipVO {
		public var vo:UpgradeSkillVO

		public function UpgradeSkillTipVO(vo:UpgradeSkillVO) {
			super(vo.wuxing, vo.needWuxing);
			this.vo = vo;
		}
	}
}
