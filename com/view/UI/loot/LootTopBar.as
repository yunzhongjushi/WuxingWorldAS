package com.view.UI.loot {
	import com.model.vo.friend.FriendVO;

	import flash.display.MovieClip;
	import flash.text.TextField;

	import listLibs.ITouchPadBar;

	public class LootTopBar extends MovieClip implements ITouchPadBar {
		public var tf_rank:TextField;
		public var tf_name:TextField;
		public var tf_level:TextField;
		public var tf_trophies:TextField;
		//
		private var _running_vo:FriendVO

		//
		public function LootTopBar() {
			super();
		}

		public function updateInfo(_vo:*):void {
			if(_vo==null) {
				this.visible=false;
				return;
			}
			running_vo=_vo as FriendVO;
			this.visible=true;
		}

		public function set running_vo(_vo:FriendVO):void {
			_running_vo=_vo
			tf_rank.text=String(_running_vo.rank)
			tf_name.text=String(_running_vo.nickName)
			tf_level.text=String(_running_vo.getLevelStr())
			tf_trophies.text=String(_running_vo.trophies)
		}

		public function get running_vo():FriendVO {
			return _running_vo
		}
		//场景元素
		public var tf_count:TextField;
		public var itemPicArr:MovieClip;
	}
}
