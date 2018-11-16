package com.view.UI.challenge {
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	/**
	 *
	 * @author hunterxie
	 */
	public class ArenaRolePanel extends BasePanel {
		public static const SHOW_ARENA_ROLE_INFO:String="SHOW_ARENA_ROLE_INFO";

		public var headContainer:MovieClip;

		public var tf_name:TextField;

		public var tf_rank:TextField;

		public var tf_capacity:TextField;

		public var btn_fight:CommonBtn;


		/**
		 *
		 */
		public function ArenaRolePanel() {
			this.addEventListener(MouseEvent.CLICK, onclick);
			
			btn_fight.setNameTxt("挑  战");
			btn_fight.addEventListener(MouseEvent.CLICK, onFight);
		}

		protected function onFight(event:*):void {
			// TODO Auto-generated method stub

		}

		protected function onclick(event:*):void {
			this.event(SHOW_ARENA_ROLE_INFO);
		}
	}
}
