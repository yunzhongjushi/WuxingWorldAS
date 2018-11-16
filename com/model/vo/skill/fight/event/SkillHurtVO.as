package com.model.vo.skill.fight.event {
	import com.model.vo.fairy.FairyVO;
	import com.model.vo.skill.fight.FairySkillEffectVO;
	
	/**
	 * 受到的伤害信息
	 * @author hunterxie
	 */
	public class SkillHurtVO{
		public static const NAME:String = "SkillHurtVO";
		/**
		 * 受到的伤害
		 */
		public var hurt:int;
		
		/**
		 * 来自于那个技能效果
		 */
		public var effect:FairySkillEffectVO;
		
		/**
		 * 谁受到的伤害
		 */
		public var tarFairy:FairyVO;
		
		public var info:String;
		
		
		/**
		 * 受到的伤害信息
		 * @param hurt
		 * @param effect
		 */
		public function SkillHurtVO(hurt:int, effect:FairySkillEffectVO, tar:FairyVO) {
			this.hurt = hurt;
			this.effect = effect;
			this.tarFairy = tar;
			this.info = effect.skill.name+":"+hurt;
		}
		
	}
}