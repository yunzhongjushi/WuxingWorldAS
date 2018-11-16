package com.view.UI.fight {
	import com.model.vo.skill.fight.FairySkillVO;
	import com.view.BaseImgBar;
	
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * 战斗中精灵面板上的(带图标)倒计时
	 * @author hunterxie
	 */ 
	public class SkillCountDownIcon extends BaseImgBar{
		public var skill:FairySkillVO;
		
		public var tf_num:TextField;
		
		public function SkillCountDownIcon() {
			super();
			itemImg.mask = mc_mask;
		}
		
		/**
		 * 更新技能倒计时状态
		 * @param vo		技能VO
		 * @param turnNum	倒计时回合，到0施放
		 */
		public function updateInfo(vo:FairySkillVO):void{
			if(!skill || skill.ID!=vo.ID){
				if(skill) skill.removeEventListener(FairySkillVO.CD_INFO_UPDATE, updateCount);
				skill = vo;
				skill.addEventListener(FairySkillVO.CD_INFO_UPDATE, updateCount);
				itemImg.scaleX = itemImg.scaleY = 0.2;
				this.updateClass(vo.icon);
			}
			
			this.tf_num.text = String(vo.nowCD);
		}
		
		private function updateCount(e:Event):void{
			this.tf_num.text = String(skill.nowCD);
		}
	}
}
