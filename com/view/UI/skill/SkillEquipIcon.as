package com.view.UI.skill{
	import com.model.vo.skill.SkillEquipVO;
	
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author hunterxie
	 * 
	 */
	public class SkillEquipIcon extends Sprite{
		
		public var mc_lock:Sprite;
		
		public var mc_item:SkillIcon;
		
		public var mc_open:Sprite;
		
		public var skillInfo:SkillEquipVO;
		
		/**
		 * 
		 * 
		 */
		public function SkillEquipIcon() {
//			mc_lock.visible = false;
			mc_open.visible = false;
			mc_item.visible = false;
			
			this.mouseChildren = false;
		}
		
		/**
		 * 
		 * @param vo
		 * 
		 */
		public function updateInfo(vo:SkillEquipVO):void{
			skillInfo = vo;
			mc_item.updateInfo(vo.skill);
		}
	}
}
