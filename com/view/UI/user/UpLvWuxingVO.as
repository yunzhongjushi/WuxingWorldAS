package com.view.UI.user {
	import com.model.vo.WuxingVO;
	import com.model.vo.user.UserVO;
	import com.model.vo.tip.BuyResourceTipVO;
	
	/**
	 * 升级五行模块需要购买资源的提示框信息
	 * @author hunterxie
	 */
	public class UpLvWuxingVO extends BuyResourceTipVO{
		public static const UPDATE_WUXING_LV:String = "UPDATE_WUXING_LV";
		
		/**
		 * 需要升级的五行模块
		 */
		public var wuxingMode:int;
		
		/**
		 * 购买升级五行模块缺少的元素
		 * @param wuxing
		 * @param num
		 */
		public function UpLvWuxingVO(wuxing:int, num:int) {
			super(wuxing, num);
			
			this.wuxingMode = wuxing;
			this.info = "您需要购买所缺的"+wuxingNum+"点"+WuxingVO.getHtmlWuxing(wuxing)+"元素来升级你的"+WuxingVO.getHtmlWuxing(wuxing)+"模块吗？";
		}
	}
}
