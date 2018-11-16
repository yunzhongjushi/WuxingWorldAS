package com.view.mediator.fairy {
	import com.model.event.EventCenter;
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.fairy.LevelupFairyVO;
	import com.model.vo.tip.BuyResourceTipVO;
	import com.model.vo.tip.TipVO;

	public class UplevelFairyTipVO extends BuyResourceTipVO {
		public var vo:LevelupFairyVO

		public function UplevelFairyTipVO(num:int, vo:LevelupFairyVO) {
			super(vo.fairyVO.wuxing, num);
			this.vo=vo;
		}
	}
}
