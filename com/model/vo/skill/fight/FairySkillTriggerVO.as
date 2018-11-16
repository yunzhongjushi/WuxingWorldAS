package com.model.vo.skill.fight {
	import com.model.vo.config.skill.SkillEffectTriggerConfigVO;
	import com.model.vo.fairy.FairyVO;
	import com.model.vo.skill.BaseSkillVO;
	import com.model.vo.skill.SkillTriggerVO;

	public class FairySkillTriggerVO extends SkillTriggerVO{
		/**
		 * 参照目标1
		 */
		private var targetFairy:FairyVO;
		/**
		 * 参照目标2
		 */
		private var targetFairy2:FairyVO;
		
		
		
		public function FairySkillTriggerVO(info:SkillEffectTriggerConfigVO, skill:FairySkillVO) {
			super(info, skill);
		}
		
		/**
		 * 前提判断,精灵是否满足触发条件
		 * @param tarF
		 * @param tarF2
		 * @return 
		 */
		public function judgeFairyTrigger(tarF:FairyVO, tarF2:FairyVO):Boolean{
			switch(this.data.refer){
				case BaseSkillVO.REFER_KIND_25:
					if(this.skill is FairyBuffVO){
						return judgeT((this.skill as FairyBuffVO).collect, this.data.value);
					}
					break;
				case BaseSkillVO.REFER_KIND_27:
					return tarF.getRefer(this.data.refer,this.data.value)==1; 
					break;
				case BaseSkillVO.REFER_KIND_28:
					return tarF.getRefer(this.data.refer,this.data.value)==1;
					break;
			}
			var compare1:Number = tarF.getRefer(this.data.refer,this.data.referKind);
			var compare2:Number = this.data.value;
			if(tarF2){
				compare2 += tarF2.getRefer(this.data.refer2,this.data.referKind2)*this.data.percent;
			}
			return judgeT(compare1, compare2);
		}
	}
}
