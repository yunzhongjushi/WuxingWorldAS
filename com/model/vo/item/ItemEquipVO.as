package com.model.vo.item {

	
	/**
	 * 
	 * @author hunterxie
	 */
	public class ItemEquipVO {
		/**
		 * 
		 */
		public var item:ItemVO;
		
		/**
		 * 是否激活
		 */
		public var isOpen:Boolean = false;
		
		/**
		 * 是否装备
		 */
		public var isEquip:Boolean = false;
		
		/**
		 * 装备栏
		 * @param id	
		 * @param lv	等级
		 */
		public function ItemEquipVO(id:int, lv:int) {
//			this.item = new ItemVO(id);
			
			this.isOpen = id==-1;
			this.isEquip = id>0;
		}
	}
}
