package com.view.UI.common
{
			import com.model.vo.skill.fight.FairySkillVO;
			import com.view.BasePanel;
			
			import flash.text.TextField;
			
			public class SkillInfoBoard extends BasePanel
			{
				public var tf_description:TextField
				//
				private var _running_vo:FairySkillVO;
				public function SkillInfoBoard()
				{
				}
				public function updateInfo(skillVO:FairySkillVO):void{
					set_running_vo(skillVO)
				}
				public function set_running_vo(vo:FairySkillVO):void{
					_running_vo = vo;
					tf_description.text = "xxx xxx xxx"
				}
			}
		}