package com.model.vo.skill.fight.event {
	import com.model.vo.fairy.FairyVO;
	import com.model.vo.skill.fight.FairySkillEffectVO;
	
	/**
	 * 技能抵抗信息
	 * @author hunterxie
	 */
	public class SkillResistVO{	
		public static const NAME:String = "SkillResistVO";	
		/**
		 * 来自于那个技能效果
		 */
		public var effect:FairySkillEffectVO;
		
		public var tarFairy:FairyVO;
		
		
		/**
		 * 技能抵抗信息
		 * @param hurt
		 * @param effect
		 */
		public function SkillResistVO(effect:FairySkillEffectVO, tar:FairyVO) {
			this.effect = effect;
			this.tarFairy = tar;
		}
		
	}
}