package com.view.UI.tip {
	import com.model.vo.user.UserVO;

	public class TipNotEnoughResourceVO {
		public static const NOT_ENOUGH_ENERGY:String = "NOT_ENOUGH_ENERGY";
		public static const NOT_ENOUGH_GOLD:String = "NOT_ENOUGH_GOLD";
		public static const NOT_ENOUGH_WUXING:String = "NOT_ENOUGH_WUXING";
		public static const NOT_ENOUGH_TIME:String = "NOT_ENOUGH_TIME";
		public static const NOT_ENOUGH_FAIRY:String = "NOT_ENOUGH_FAIRY";
		public static const NOT_HAS_FAIRY:String = "NOT_HAS_FAIRY";
		
		public static function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		public function TipNotEnoughResourceVO() {
			
		}
		
//		/**
//		 * 判断是否有足够钻石
//		 * @param goldNum
//		 * @return 
//		 */
//		public static function judgeGold(goldNum:int):Boolean	{
//			if(userInfo.gold<goldNum){
//				TipVO.showChoosePanel(new TipVO(("您的钻石不足", "您的钻石不足，请去商城购买！", TipNotEnoughResourceVO.NOT_ENOUGH_GOLD));
//				return false;
//			}
//			return true;
//		}
	}
}
