package com.model.vo.altar {
	import com.model.event.EventCenter;
	import com.model.vo.tip.BuyResourceTipVO;
	import com.model.vo.tip.TipVO;

	/**
	 * 元素抽宝箱不够的时候，让玩家确认用钻石兑换
	 * @author hunterxie
	 */
	public class AltarTipVO extends BuyResourceTipVO {
		public var buyItem:int;

		public var buyType:int;

		public function AltarTipVO(wuxing:int, num:int, buyItem:int, buyType:int) {
			super(wuxing, num);

			this.buyItem=buyItem;

			this.buyType=buyType;
		}
		
	}
}
