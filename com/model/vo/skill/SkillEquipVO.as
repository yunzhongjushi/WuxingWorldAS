package com.model.vo.skill {
	
	
	/**
	 * 
	 * @author hunterxie
	 */
	public class SkillEquipVO {
		/**
		 * 
		 */
		public var skill:UserSkillVO;
		
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
		public function SkillEquipVO(id:int, lv:int) {
//			this.skill = new ItemVO(id);
			
			this.isOpen = id==-1;
			this.isEquip = id>0;
		}
	}
}
