package com.model.vo.config.shop {
	import com.model.vo.BaseObjectVO;
	import com.model.vo.WuxingVO;
	import com.model.vo.config.item.ItemConfig;
	import com.model.vo.config.item.ItemConfigVO;
	
	
	/**
	 * 物品配置信息
	 * @author hunterxie
	 * <record templateID="1" canUse="1" canDelete="0" canSell="1"/>
	 */
	public class ShopItemConfigVO extends BaseObjectVO {
		/**物品id*/
		public var id:String;
		
		/**物品模版ID*/
		public function get itemID():int {
			return _itemID;
		}
		public function set itemID(value:int):void {
			_itemID=value;
			data = ItemConfig.getItemConfigByID(value);
		}
		public var _itemID:int;
		/**包含的物品模版*/
		public var data:ItemConfigVO;
		
		/**物品名，配置中展示给配置人员看*/
		public var label:String;
		
		/**物品价格*/
		public var price:int=1;
		/**库存数量，少于0将不再出售*/
		public var stockCount:int=0;
		/**空、推荐、热销、打折*/
		public var bannerType:String;
		/**开卖时间*/
		public var startTime:String;
		/**结束时间*/
		public var endTime:String;
			
		
		
		public function ShopItemConfigVO(info:Object=null):void {
			super(info);
		}
		
		/**
		 * 是否是用RMB购买的商品
		 * @return 
		 */
		public function get isCash():Boolean {
			return (buyType==BUY_TYPE_RMB);
		}
		
		
		/**
		 * 购买需要消耗类型：1钻石，2资源，3现金
		 */
		public var buyType:int=1;
		public function get buyTypeStr():String{
			switch(buyType) {
				case BUY_TYPE_RMB:
					return "RMB";
				case BUY_TYPE_RESOURCE:
					return WuxingVO.getWuxing(data.wuxing);
				case BUY_TYPE_GOLD:
					return "钻";
			}
			return "null";
		}
		
		/**钻石购买切页*/
		public static const TYPE_GOLD:int=1;
		/**物品购买切页*/
		public static const TYPE_ITEM:int=2;
		/**五行资源购买切页*/
		public static const TYPE_RESOURCE:int=3;
		/**消耗品购买切页*/
		public static const TYPE_COMSUME:int=4;
		
		/**商品类型：消耗钻石购买*/
		public static const BUY_TYPE_GOLD:int = 1;
		/**商品类型：消耗资源购买*/
		public static const BUY_TYPE_RESOURCE:int = 2;
		/**商品类型：消耗RMB购买(只有钻石)*/
		public static const BUY_TYPE_RMB:int = 3;
	}
}
