package com.model.vo.config.shop{
	import com.model.vo.BaseObjectVO;
	
	/**
	 * 商城配置信息
	 * @author hunterxie
	 */
	public class ShopConfig extends BaseObjectVO {
		public static const NAME:String = "ShopConfig";
		public static const SINGLETON_MSG:String = "single_ShopConfig_only";
		protected static var instance:ShopConfig;
		
		public static function getInstance():ShopConfig{
			if ( instance == null ) instance = new ShopConfig();
			return instance;
		}
		
		public static function updateObj(info:Object):ShopConfig{
			getInstance().updateObj(info);
			return instance;
		}
		
		
		/**
		 * 商城数据变动，更新数据事件
		 */
		public static const UPDATE_SHOP_INFO:String = "UPDATE_SHOP_INFO";
		/**
		 * 商店只在第一次开启时获取数据，进行更新
		 */
		public static var running_isInit:Boolean=true;
		
		/**
		 * 钻石
		 */
		public var golds:Array = BaseObjectVO.getClassArray(ShopItemConfigVO);
		/**
		 * 资源
		 */
		public var res:Array = BaseObjectVO.getClassArray(ShopItemConfigVO);
		/**
		 * 物品
		 */
		public var items:Array = BaseObjectVO.getClassArray(ShopItemConfigVO);
		/**
		 * 总物品列表
		 * TODO:放到箱子中整体出售会更加符合当前习惯，可以买了送的说明
		 */
		public var total:Array;
		
		
		/**
		 * 
		 * 
		 */
		public function ShopConfig(info:Object=null) {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			if(!info){
				info = BaseInfo.shopInfo;//JSON.parse(String(LoadProxy.getLoadInfo("shopInfo.json")));
			}
			instance.updateObj(info);
			total = [];
			total = items.concat(golds);
			total = items.concat(res);
			total = items.concat(items);
		}
		
		public function dispatchUpdate():void{
			event(UPDATE_SHOP_INFO);
		}
		
		
	}
}
