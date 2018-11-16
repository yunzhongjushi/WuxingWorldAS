package com.model.vo.skill.fight.event {
	import com.model.vo.fairy.FairyVO;
	import com.model.vo.skill.fight.FairySkillEffectVO;
	
	/**
	 * 受到的治疗信息
	 * @author hunterxie
	 */
	public class SkillCureVO{
		public static const NAME:String = "SkillCureVO";
		/**
		 * 受到的治疗
		 */
		public var cure:int;
		
		/**
		 * 来自于那个技能效果
		 */
		public var effect:FairySkillEffectVO;
		
		public var tarFairy:FairyVO;
		
		
		/**
		 * 受到的治疗信息
		 * @param hurt
		 * @param effect
		 */
		public function SkillCureVO(cure:int, effect:FairySkillEffectVO, tar:FairyVO) {
			this.cure = cure;
			this.effect = effect;
			this.tarFairy = tar;
		}
		
	}
}