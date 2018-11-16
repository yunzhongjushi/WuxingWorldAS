package com.view.UI.common {
	import com.model.vo.skill.fight.FairySkillVO;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 勾选按钮
	 * @author hunterxie
	 */
	public class SwitchBtn extends MovieClip {
		public var tf_name:TextField;
		public var tf_name_inactive:TextField;

		public var isActive:Boolean;
		public var isTick:Boolean;

		public function SwitchBtn() {
			this.mouseChildren=false;
			this.addEventListener(MouseEvent.CLICK, handle_terminate);
		}

		public function setup(isActive:Boolean):void {
			this.isActive=isActive;
			if(isActive) {
				isTick=false;
				tf_name.visible=true;
				tf_name_inactive.visible=false;
			} else {
				this.gotoAndStop(3);
				tf_name.visible=false;
				tf_name_inactive.visible=true;
			}
			tf_name_inactive.text=tf_name.text;
		}

		protected function handle_terminate(e:*):void {
			if(isActive==false) {
				e.stopImmediatePropagation();
			} else {
				showTick(!isTick);
			}
		}

		public function showTick(isTick:Boolean):void {
			if(isActive==false)
				return;
			this.isTick=isTick;
			if(isTick) {
				this.gotoAndStop(2);
			} else {
				this.gotoAndStop(1);
			}
		}
	}
}
