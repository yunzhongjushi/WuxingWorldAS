package com.model.logic {
	import com.model.event.ObjectEvent;
	import com.model.vo.WuxingVO;
	import com.model.vo.user.FightUserVO;
	import com.model.vo.skill.BaseSkillVO;
	import com.model.vo.skill.fight.FairySkillVO;
	
	import flas.utils.Timer;

	public class FairyAI {
		public var roleInfo:FightUserVO;
		
		public var skillUseTimer:Timer;

		public function FairyAI(vo:FightUserVO) {
			this.roleInfo=vo;
			skillUseTimer = new Timer(3000, action);//延迟3秒再行动让玩家有缓冲时间看到电脑做决策了
			skillUseTimer.start();
//			roleInfo.wuxingInfo.on(WuxingVO.WUXING_RESOURCE_UPDATE, action);
		}

		public function action(e:Timer):void { //e:ObjectEvent):void{
			var useSkill:FairySkillVO;
			for(var i:int=0; i<roleInfo.boardSkills.length; i++) {
				var skill:FairySkillVO=roleInfo.boardSkills[i] as FairySkillVO;
				if(skill.useKind==BaseSkillVO.USE_KIND_ACTIVE&&skill.resourceFulfilJudge(roleInfo.wuxingInfo)) {
					if(!useSkill) {
						useSkill=skill;
					} else if(useSkill.power<skill.power) {
						useSkill=skill;
					}
				}
			}

		}
	}
}
