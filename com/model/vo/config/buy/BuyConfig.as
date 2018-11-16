package com.model.vo.config.buy{
	import com.model.vo.BaseObjectVO;
	
	/**
	 * 资源购买配置信息
	 * @author hunterxie
	 */
	public class BuyConfig extends BaseObjectVO {
		public static const NAME:String = "BuyInfo";
		public static const SINGLETON_MSG:String = "single_BuyInfo_only";
		protected static var instance:BuyConfig;
		
		public static function getInstance():BuyConfig{
			if ( instance == null ) instance = new BuyConfig();
			return instance;
		}
		
		public static function updateObj(info:Object):BuyConfig{
			getInstance().updateObj(info);
			return instance;
		}
		
		/**
		 * 
		 */
		public var times:Array = BaseObjectVO.getClassArray(BuyResourceConfigVO);
		
		/**
		 * 
		 */
		public var resources:Array = BaseObjectVO.getClassArray(BuyResourceConfigVO);
		
		
		/**
		 * 
		 * 
		 */
		public function BuyConfig(info:Object=null) {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			if(!info){
				info = BaseInfo.buyInfo;//JSON.parse(String(LoadProxy.getLoadInfo("buyInfo.json")));
			}
			instance.updateObj(info);
		}
		
		/**
		 * 时间不足时获取购买对应的钻石数量
		 * @param num	数量
		 */
		public static function getTimeBuyInfo(num:int):int{
			return getInstance().getPrice(instance.times, num);
		}
		
		/**
		 * 资源不足时获取购买对应的钻石数量
		 * @param num	数量
		 */
		public static function getResourceBuyInfo(num:int):int{
			return getInstance().getPrice(instance.resources, num);
		}
		
		private function getPrice(arr:Array, num:int):int{
			var price:int = 0;
			var now:BuyResourceConfigVO = arr[arr.length-1];
			if(num < now.min){
				for(var i:int=0; i<arr.length-2; i++){
					var temp:BuyResourceConfigVO = arr[i] as BuyResourceConfigVO;
					if(num>=temp.min && num<=temp.max){
						now = temp;
						break;
					}
				}
			}
			
			price = Math.floor(now.total+Math.ceil((num-now.min)/now.price));
			return price;
		}
	}
}
