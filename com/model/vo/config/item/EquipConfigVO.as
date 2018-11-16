package com.model.vo.config.item{
	import com.model.vo.BaseObjectVO;
	import com.model.vo.WuxingVO;
	
	
	/**
	 * 物品配置信息
	 * @author hunterxie
	 */
	public class EquipConfigVO extends BaseObjectVO{
		/**装备位置：1，2，3，4，5，6*/		
		public var position:int;
		/**装备等级*/		
		public var equipLevel:int;
		/**精灵等级需求*/		
		public var needLevel:int;
		/**增加血量*/		
		public var addHP:int;
		/**增加攻击力*/		
		public var addAP:int;
		/**增加防御力*/		
		public var addDP:int;
		/**是否能够强化*/		
		public var canStrengthen:int;
		
		
		
		/**
		 * 
		 * @param info
		 */
		public function EquipConfigVO(info:Object=null):void{
			super(info);
		}
		
		/**
		 * 
		 */		
//		public function updateByXML(data:XML):void{
//			this.needLevel = int( data.@needLevel );
//			this.equipLevel = int( data.@property1 );
//			this.slotIndex = int( data.@property2 );
//			this.addHP = int(data.@property3);
//			this.addAP = int(data.@property4);
//			this.addDP = int(data.@property5);
//			this.canStrengthen = int(data.@canStrengthen);
//		}
	}
}