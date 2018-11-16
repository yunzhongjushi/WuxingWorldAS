package com.model.vo.tip{
	import com.model.vo.WuxingVO;
	import com.model.vo.config.buy.BuyConfig;
	import com.model.vo.user.UserVO;
	
	/**
	 * 需要购买缺少的单个五行资源的提示框信息；
	 * 用户确认后会模拟资源扣除和钻石扣除（本地模拟）；
	 * @author hunterxie
	 */
	public class BuyResourceTipVO extends TipVO{
		/**
		 * 需要购买的元素五行
		 */
		public var wuxing:int;
		
		/**
		 * 购买需要的钻石数量
		 */
		public var goldNum:int = 0;
		
		/**
		 * 需要购买的资源数量
		 */
		public var wuxingNum:int = 0;
		
		/**
		 * 确认资源扣除完毕
		 */
		public var isConfirmSuccess:Boolean = false;
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		/**
		 * 购买缺少的单个五行元素
		 * @param wuxing
		 * @param num
		 */
		public function BuyResourceTipVO(wuxing:int, num:int) {
			this.wuxing = wuxing;
			this.wuxingNum = num;
			this.goldNum = BuyConfig.getResourceBuyInfo(num);
			
			super("您需要更多的资源"+WuxingVO.getHtmlWuxing(wuxing)+"元素",
				"您需要购买所缺的"+wuxingNum+"点"+WuxingVO.getHtmlWuxing(wuxing)+"元素吗？",
				"",
				goldNum+"钻石");
		}
		
		override public function confirm():Boolean{
//			if(BaseInfo.isTestLogin){
				if(UserVO.testAddGold(-this.goldNum)){
					userInfo.wuxingInfo.setResource(wuxing, 0);
					isConfirmSuccess = true;
				}
//			}
				return isConfirmSuccess;
		}
	}
}
