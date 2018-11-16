package com.model.vo.fairy {

	public class FightFairyVO extends FairyVO{
		/**
		 * 大技能准备好
		 */
		public static var BIG_SKILL_PREPARED:String = "BIG_SKILL_PREPARED";
		
		/** 战斗中附加加的精灵等级 */
		public var LV_add:int;
		
		/** 等级 */
		override public function get LV():int{
			return _LV+LV_add;
		}
		
		
		
		
		/**
		 * 大技能是否准备好(收集五行)
		 */
		public function get bigSkillPrepared():Boolean{
			return false;
		}
		
		
		
		/**
		 * 战斗中的精灵数据，在FairyVO基础上增加了战斗属性，如当前伤害、附带伤害等等
		 * 
		 */
		public function FightFairyVO() {
			
		}
		
		public function reset():void{
			this.LV_add = 0;
			this.HP_max_add = 0;
			this.AP_add = 0;
			this.AP_per = 0;
			this.EXP_per = 0;
		}
	}
}
