package com.view.UI.chessboard {
	import com.model.vo.item.ItemListVO;
	import com.model.vo.item.ItemVO;
	
	import flas.display.Sprite;
	import flas.events.MouseEvent;

	/**
	 * 
	 * @author hunterxie
	 */
	public class BoardSkillPanel extends Sprite{
		public var tf_skill_0:*;
		public var tf_skill_1:*;
		public var tf_skill_2:*;
		public var tf_skill_3:*;
		
		public var mc_skill_0:*;
		public var mc_skill_1:*;
		public var mc_skill_2:*;
		public var mc_skill_3:*;
		
		private var skills:Array = [1002, 1003, 1004, 1005];
		
		
		/**
		 * 
		 *  
		 */
		public function BoardSkillPanel() {
			for(var i:int=0; i<4; i++){
				var mc:* = this["mc_skill_"+i];
				mc.buttonMode = true;
				mc.skillID = skills[i];
				mc.addEventListener(MouseEvent.CLICK, onSkillUse);
			}
		}
		
		private function onSkillUse(e:*):void{
			var skillID:int = e.target["skillID"];
		}
		
		public function updateInfo():void{
			for(var i:int=0; i<4; i++){
				var item:ItemVO = ItemListVO.getItemByTempID(skills[i]);
				this["tf_skill_"+i].text = item.num;
			}
		}
	}
}
