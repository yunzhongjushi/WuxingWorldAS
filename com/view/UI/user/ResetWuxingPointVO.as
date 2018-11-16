package com.view.UI.user {
	import com.model.vo.WuxingVO;
	import com.model.vo.config.buy.BuyConfig;
	import com.model.vo.tip.TipVO;
	import com.model.vo.user.UserVO;

	public class ResetWuxingPointVO extends TipVO{
		public static const RESET_POINT:String = "RESET_POINT";
		public static const RESET_All_POINT:String = "RESET_All_POINT";
		
		public static const KIND_GOLD:String = "KIND_GOLD";
		public static const KIND_RESOURCE:String = "KIND_RESOURCE";
		
		
		public var wuxing:int;
		
		public var goldNum:int = 0;
		
		public var wuxingNum:int = 0;
		
		public var kindChoose:String = KIND_GOLD;
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		public function ResetWuxingPointVO(wuxing:int, kind:String=KIND_GOLD) {
			super("五行模块洗点");
			kindChoose = kind;
			
			this.wuxing = wuxing;
			this.key = RESET_POINT;
			
			var wuxingStr:String = wuxing>=5 ? "" : WuxingVO.getHtmlWuxing(wuxing);
			if(wuxing==5){
				var arr:Array = userInfo.wuxingInfo.getWuxingPropertyArr();
				for(var i:int=0; i<arr.length; i++){
					if(arr[i]>1){
//						goldNum+=arr[i]-1;
						goldNum += BuyConfig.getResourceBuyInfo(userInfo.wuxingInfo.getMaxResource(i));
					}
				}
				this.info = "你要消耗"+goldNum+"点钻石重置所有五行模块吗？";
				return;
			}
			if(userInfo.wuxingInfo.getWuxingProperty(wuxing)==1){
				return;
			}
			if(kind==KIND_GOLD){
				goldNum = BuyConfig.getResourceBuyInfo(userInfo.wuxingInfo.getMaxResource(wuxing));
				info = "您要消耗"+goldNum+"钻石重置"+wuxingStr+"模块吗!";
			}else if(kind==KIND_RESOURCE){
				wuxingNum = userInfo.wuxingInfo.getMaxResource(wuxing);
				info = "消耗"+wuxingNum+"点"+wuxingStr+"元素重置"+wuxingStr+"模块.";
				var userWuxingNum:int = userInfo.wuxingInfo.getResource(wuxing);
				if(userWuxingNum<wuxingNum){
					var tempNum:int = wuxingNum-userWuxingNum
					goldNum = BuyConfig.getResourceBuyInfo(tempNum);
					info+="\n您需要购买所缺的"+tempNum+"点"+wuxingStr+"元素!";
					wuxingNum = userWuxingNum;
				}
			}
			if(this.goldNum>0){
				this.btn1 = goldNum+"钻石";
			}
		}
		
		
		override public function confirm():Boolean{
			if(!UserVO.testAddGold(-goldNum)){
				return false;
			}
			
			if(kindChoose==ResetWuxingPointVO.KIND_GOLD){//钻石洗点
				switch(wuxing){
					case 0:
					case 1:
					case 2:
					case 3:
					case 4:
						userInfo.allPoint += userInfo.wuxingInfo.getWuxingProperty(wuxing)-1;
						userInfo.wuxingInfo.setProperty(wuxing, 1);
						break;
					case 5:
						for(var i:int=0; i<5; i++){
							userInfo.allPoint += userInfo.wuxingInfo.getWuxingProperty(i)-1;
							userInfo.wuxingInfo.setProperty(i, 1);
						}
						break;
				}
			}else if(kindChoose==ResetWuxingPointVO.KIND_RESOURCE){//元素洗点
				UserVO.testAddResource(wuxing, -wuxingNum);
				userInfo.allPoint += userInfo.wuxingInfo.getWuxingProperty(wuxing)-1;
				userInfo.wuxingInfo.setProperty(wuxing, 1);
			}
			return true;
		}
	}
}
