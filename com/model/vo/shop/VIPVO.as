package com.model.vo.shop {
	import com.model.event.ObjectEvent;
	import com.model.vo.config.vip.VIPConfig;
	import com.model.vo.config.vip.VIPConfigVO;
	import com.model.vo.user.UserVO;
	
	import flas.events.EventDispatcher;
	

	/**
	 * 
	 * @author hunterxie
	 * 
	 */
	public class VIPVO extends EventDispatcher{
		public static const NAME:String="VIPVO";
		private static const SINGLETON_MSG:String="single_VIPVO_only";
		private static var instance:VIPVO;
		public static function getInstance():VIPVO {
			if(instance==null) instance=new VIPVO();
			return instance as VIPVO;
		}
		
		public static const UPDATE_VIP_INFO:String = "UPDATE_VIP_INFO";
		
		public function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		/**
		 * 当前等级对应的VIP配置XML
		 */
		public var data:VIPConfigVO

		/**
		 * 下一级还需要的充值金额
		 */
		public var upgradeRemain:int;

		/**
		 * 下一级还需要的充值金额
		 */
		public var nextCharge:int;

		/**
		 * 下一级等级
		 */
		public var nextLV:int;

		
		/**
		 * 
		 * @param totalCharge
		 * 
		 */		
		public function VIPVO() {
			if(instance!=null) throw Error(SINGLETON_MSG);
			instance=this;
			
			userInfo.on(UserVO.UPDATE_USER_INFO, this, updateInfo);
		}
		
		public function updateInfo(e:ObjectEvent=null):void{
			var templv:int = data ? data.lv : 0;
			this.data = VIPConfig.getGameVIPLVByGold(userInfo.totalCharge);
			var next:VIPConfigVO = VIPConfig.getGameVIPByLV(data.lv+1);
			
			if(next) {
				nextLV = next.lv;
				nextCharge = next.chager;
			} else {
				nextLV = -1;
				nextCharge = userInfo.totalCharge;
			}
			
			upgradeRemain = nextCharge-userInfo.totalCharge;
			
			if(data.lv>templv){
				event(UPDATE_VIP_INFO);
			}
		}
	}
}
