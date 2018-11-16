package com.view.UI.fairy
{
	import com.model.vo.skill.BaseSkillVO;
	import com.view.BasePanel;
	
	import flash.events.Event;
	import flash.text.TextField;
	/**
	 * 技能面板 
	 * @author CC5
	 * 
	 */
	public class FairySkillInfo extends BasePanel
	{
		
		public var tf_name:TextField;
		
		public var tf_lv:TextField;
		
		public var tf_des:TextField;
		
		
		public function FairySkillInfo()
		{
			
			
		}
		private var running_vo:BaseSkillVO; 
		
		/**
		 * 更新数据 
		 * @param skillVO
		 * @param fairyVO
		 * @param skillUpgradeVO
		 * 
		 */		
		public function updateInfo(skillVO:BaseSkillVO):void
		{
			running_vo = skillVO;
			
			refresh();
		} 
		/**
		 * 更新面板 
		 * @param e
		 * 
		 */		
		private function refresh(e:Event = null):void
		{
			
			tf_name.text = running_vo.name;
			
			tf_lv.text = "等级 " + running_vo.LV
			
			tf_des.text = running_vo.describe
			
		}
		
	}
}