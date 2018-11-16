package com.view.UI.friend {
	import com.model.vo.friend.FriendVO;
	import com.model.vo.item.ItemVO;
	import com.view.UI.button.FriendEnergyButton;
	import com.view.UI.item.ItemBarMiddle;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flas.events.MouseEvent;
	import flash.text.TextField;
	
	import listLibs.ITouchPadBar;

	public class FriendBar extends MovieClip implements ITouchPadBar {
		public static const BTN_ENERGY:String="BTN_ENERGY";
		public var btn_bar:MovieClip
		public var btn_energy:FriendEnergyButton
		//
		public var tf_name:TextField;
		public var tf_achi_point:TextField;
		public var header:ItemBarMiddle;

		public var running_vo:FriendVO

		public function FriendBar() {
			super();

			this.addEventListener(MouseEvent.CLICK, handle_click);
			this.addEventListener(MouseEvent.MOUSE_MOVE, handle_click);
		}

		public var running_target:MovieClip;

		protected function handle_click(e:*):void {
			switch(e.type) {
				case MouseEvent.CLICK:
					if(btn_energy.getBounds(this).contains(this.mouseX, this.mouseY)) {
						running_target=btn_energy
					} else {
						running_target=this;
					}
					if(btn_energy.visible==false||btn_energy.isReadyToUse==false) {
						e.stopImmediatePropagation();
					}
					break;
			}
		}
		
		private function onUpdate(e:Event=null):void{
			tf_name.text=String(running_vo.nickName)
			tf_achi_point.text=String(running_vo.getTrophiesStr());
			btn_energy.visible=running_vo.canPuzzle;
			
			header.updateInfo(new ItemVO(30000));
		}

		public function updateInfo(_vo:*):void {
			if(running_vo){
				if(running_vo!=_vo){
					running_vo.removeEventListener(FriendVO.UPDATE_FRIEND_INFO, onUpdate);
					running_vo = _vo;
					running_vo.addEventListener(FriendVO.UPDATE_FRIEND_INFO, onUpdate);
				}
			}
			onUpdate();
		}
	}
}
