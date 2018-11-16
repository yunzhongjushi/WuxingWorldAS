package com.model.vo.item {
	import com.model.vo.BaseObjectVO;
	import com.model.vo.config.item.ItemConfig;
	import com.model.vo.config.item.ItemConfigVO;


	/**
	 *
	 * @author hunterxie
	 *
	 */
	public class ItemVO extends BaseObjectVO {
		/**
		 * 基础数据，方便本地缓存
		 */
		public var baseItemVO:ItemBaseVO=new ItemBaseVO;
		/**物品数量*/
		public function get num():int {
			return baseItemVO.num;
		}
		public function set num(value:int):void {
			baseItemVO.num=value;
			event(ItemBaseVO.UPDATE_ITEM_INFO, true);
		}
		/**物品ID*/
		public function get itemID():int {
			return baseItemVO._itemID;
		}
		public function set itemID(value:int):void {
			baseItemVO._itemID=value;
		}
		/**模板ID*/
		public function get templateID():int {
			return baseItemVO._templateID;
		}
		public function set templateID(value:int):void {
			baseItemVO._templateID=value;
			this.data = ItemConfig.getItemConfigByID(templateID);
			if(data==null) {
				trace("* 警告：物品配置没找到！ID为:", templateID)
				this.data = ItemConfig.getItemConfigByID(1000);
			}
		}

		/**
		 * 模版数据
		 */
		public var data:ItemConfigVO;

		/**
		 * 使用数量， 用于消耗时
		 */
		public var useItemNum:int;
		/**
		 * 模拟使用数量， 用于消耗时
		 */
		public var useItemNumSim:int;



		
		/**
		 * 返回一个物品的ItemVO
		 * @param templateID
		 * @param num
		 * @param itemID
		 */
		public static function getItemVO(templateID:int, num:int=-1, itemID:int=-1):ItemVO {
			if(ItemConfigVO.judgeIsEquip(templateID)){
				return new FairyEquipVO(templateID, num, itemID);
			}
			return new ItemVO(templateID, num, itemID);
		}
		
		
		/**
		 *
		 * @param templateID	模版ID
		 * @param num			数量
		 * @param id			物品ID
		 */
		public function ItemVO(templateID:int, num:int=-1, id:int=-1) {
			if(templateID!=0) {
				this.templateID=templateID; 
			}
			this.num=num;
			this.itemID=itemID;
		}
	}
}
