package com.view.UI.skill {
	import com.model.vo.skill.UserSkillVO;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flas.events.MouseEvent;
	import flash.text.TextField;
	

	/**
	 * 
	 * @author hunterxie
	 */
	public class SkillChooseBtn extends Sprite{
		
		public var tf_name:TextField;
		
		public var lv:int;
		
		public var skillInfo:UserSkillVO;
		
		/**
		 * 选择的技能标识
		 */
		public var mc_chooseCover:MovieClip;
		
		/**
		 * 未开启标识
		 */
		public var mc_disable:MovieClip;
		
		/**
		 * 是否选中
		 * @return 
		 */
		public function get isChoose():Boolean{
			return _isChoose;
		}
		public function set isChoose(value:Boolean):void{
			_isChoose = value;
			mc_chooseCover.visible = value;
		}
		private var _isChoose:Boolean = false;
		
		
		
		/**
		 * 
		 * 
		 */
		public function SkillChooseBtn(skill:UserSkillVO=null):void{
			this.mouseChildren = false;
			mc_chooseCover.visible = false;
			tf_name.text = "未激活";
			
			if(skill) updateInfo(skill);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:*):void{
			this.isChoose = !this.isChoose;
		}		

		public function updateInfo(skill:UserSkillVO=null):void{
			this.skillInfo = skill;
			if(skill){
				tf_name.text = skill.name;
				mc_disable.visible = false;
//				this.skillInfo.removeEventListener(UserSkillVO.CD_INFO_UPDATE, onUpdateCD);
			}else{
				tf_name.text = "未激活";
				mc_disable.visible = true;
			}
		}
		
		protected function onUpdateCD(event:Event):void{
			// TODO Auto-generated method stub
			
		}
	}
}
