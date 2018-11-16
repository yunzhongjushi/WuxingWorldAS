package com.model.vo.fairy {
	import com.model.vo.BaseObjectVO;

	/**
	 * 用于保存的精灵关键信息
	 * @author hunterxie
	 */
	public class FairySaveVO extends BaseObjectVO{
		/**
		 * 精灵ID
		 */
		public var ID:int = 0;
		
		/**
		 * 模版ID
		 */
		public var originID:int = 0;
		
		/**
		 * 当前经验值
		 */
		public var EXP_cu:int;
		
		/**
		 * 等级
		 */
		public var LV:int;
		
		/**
		 * 强化等级
		 */
		public var intensLV:int = 0;
		
		/**
		 * 星级
		 */
		public var starLV:int = 0;
		
		/**
		 * 精灵在列表中的位置，前3位为出战精灵
		 */
		public var position:int = 0;
		
		/**
		 * 装备列表
		 */
		public var equips:Array = [];
		
		/**
		 * 技能列表
		 */
		public var skills:Array = [];
		
		
		
		/**
		 * 
		 * 
		 */
		public function FairySaveVO(info:Object=null) {
			super(info);
		}
		
		public function updateByServer(pet:Object):FairySaveVO{
			this.originID = pet.PetTemplateID;
			this.EXP_cu = pet.PetExp;
			this.starLV = pet.IntensifyID;
			this.intensLV = pet.AdvancedLv;
			this.position = pet.Place;
			this.skills = pet.SkillLV;
			this.skills = pet.equip;
			return this;
		}
	}
}
