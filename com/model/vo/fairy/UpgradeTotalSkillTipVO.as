package com.model.vo.fairy {
	import com.model.event.EventCenter;
	import com.model.vo.WuxingVO;
	import com.model.vo.item.ItemResourceVO;
	import com.model.vo.tip.BuyResourceTipVO;
	import com.model.vo.tip.TipVO;

	public class UpgradeTotalSkillTipVO extends BuyResourceTipVO {
		public function UpgradeTotalSkillTipVO(vo:ItemResourceVO) {
			super(vo.data.wuxing, vo.num);
		}
	}
}
