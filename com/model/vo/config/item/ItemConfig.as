package com.model.vo.config.item{
	import com.model.vo.BaseObjectVO;
	
	/**
	 * 物品配置信息
	 * @author hunterxie
	 */
	public class ItemConfig extends BaseObjectVO {
		public static const NAME:String = "ItemInfo";
		public static const SINGLETON_MSG:String = "single_ItemInfo_only";
		protected static var instance:ItemConfig;
		
		public static function getInstance():ItemConfig{
			if ( instance == null ) instance = new ItemConfig();
			return instance;
		}
		
		public static function updateObj(info:Object):ItemConfig{
			getInstance().updateObj(info);
			return instance;
		}
		/**
		 * 添加了精灵、技能等的总信息 
		 */		
		public static var allItem:Object = {};
		public static function setItem(vo:ItemConfigVO):void{
			allItem[vo.id] = vo;
		}
		/**
		 * 通过原始ID获取物品配置信息
		 * @param id
		 */
		public static function getItemConfigByID(id:int=0):ItemConfigVO{
			getInstance();
			return allItem[id];
		}
		/**
		 * 根据五行+阶级+位置获取装备ID
		 * @param wuxing	五行
		 * @param equipLV	阶级
		 * @param position	装备位置
		 * @return 
		 */
		public static function getEquipID(wuxing:int, equipLV:int, position:int):int{
			for(var i:int=0; i<getInstance().items.length; i++){
				var vo:ItemConfigVO = instance.items[i] as ItemConfigVO;
				if(ItemConfigVO.judgeIsEquip(vo.id) && 
					vo.wuxing==wuxing && 
					vo.equipInfo.equipLevel==equipLV && 
					vo.equipInfo.position==position){
					return vo.id;
				}
			}
			return 0;
		}
		
		/**
		 * 
		 */
		public var items:Array = BaseObjectVO.getClassArray(ItemConfigVO);
		
		
		/**
		 * 
		 * 
		 */
		public function ItemConfig(info:Object=null) {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			if(!info){
				info = BaseInfo.itemInfo;//JSON.parse(String(LoadProxy.getLoadInfo("itemInfo.json")));
//				updateByXML(BaseInfo.itemInfo);
			}
			instance.updateObj(info);
		}
	}
}
