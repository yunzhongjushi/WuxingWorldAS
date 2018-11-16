package com.view.UI.fairy {
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.fairy.UpgradeSkillVO;
	import com.model.vo.skill.BaseSkillVO;
	import com.view.BaseImgBar;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;

	public class FairySkillBar extends BaseImgBar {
		/**
		 * 技能等级显示底板
		 */
		public var fairySkillBar_LV_Board:MovieClip;

		public var fairySkillBar_Mask:MovieClip;

		public function FairySkillBar() {
			super();

			this.setChildIndex(fairySkillBar_LV_Board, this.numChildren-2);

			this.setChildIndex(tf_label, this.numChildren-1);

			this.mouseChildren=false;

			this.itemImg.mask=fairySkillBar_Mask;
		}

		public var running_vo:BaseSkillVO;

		public var position:int;

		public var fairyVO:BaseFairyVO;

		public function initPosition(posi:int):void {
			position=posi;
		}

		public function updateInfo(vo:BaseSkillVO, fairyVO:BaseFairyVO=null, isShowLV:Boolean=true):void {
			if(vo) {
				if(running_vo) {
					running_vo.removeEventListener(BaseSkillVO.SKILL_INFO_UPDATE, refresh);
				}
				running_vo=vo;
//				running_vo.addEventListener(BaseSkillVO.SKILL_INFO_UPDATE, refresh);
			}
			this.fairyVO=fairyVO;

			tf_label.visible=fairySkillBar_LV_Board.visible=isShowLV;

			refresh();
		}

		private function refresh(e:Event=null):void {
//			if(fairyVO == null || running_vo == null) return;

			updateClass(running_vo.icon);

			tf_label.text=String(running_vo.LV)

		}

		public function showEmpty():void {
			clear()

			tf_label.visible=false;
			fairySkillBar_LV_Board.visible=false;

			running_vo=null;
		}
	}
}
