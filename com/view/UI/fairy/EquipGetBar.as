package com.view.UI.fairy {
	import com.model.vo.level.LevelVO;
	import com.view.touch.CommonBtn;
	import com.view.UI.level.MapLevelBar;

	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	import listLibs.ITouchPadBar;

	public class EquipGetBar extends Sprite implements ITouchPadBar {
		public var levelVO:LevelVO;
		public var btn_go_level:CommonBtn
		public var icon_level:MapLevelBar;
		public var tf_level_name:TextField;
		public var tf_lock_label:TextField;

		public function EquipGetBar() {
			this.addEventListener(MouseEvent.CLICK, handle_click);
			btn_go_level.setNameTxt("前  往");
		}

		protected function handle_click(e:*):void {
			if(e.target==this) {
				if(btn_go_level.getBounds(this).contains(this.mouseX, this.mouseY)) {
					return;
				}
			}
			e.stopImmediatePropagation();
		}

		public function updateInfo(vo:*):void {
			if(vo&&vo is LevelVO) {
				levelVO=vo as LevelVO;
				tf_level_name.text="等待完成" //rVO.name; 
				trace("[待完成] see EquipGetBar");
				if(levelVO.isOpen) {
					btn_go_level.visible=true;
					tf_lock_label.visible=false;
				} else {
					btn_go_level.visible=false;
					tf_lock_label.visible=true;
				}
				icon_level.levelVO = levelVO;
			}
		}
	}
}
