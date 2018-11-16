package com.view.UI.tip {
	import com.model.vo.item.ItemVO;
	import com.view.UI.item.ItemBarMiddle;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import listLibs.ITouchPadBar;


	public class RewardBar extends MovieClip implements ITouchPadBar {
		public var itemBar:ItemBarMiddle;
		public var tf_name:TextField;

		public var rVO:ItemVO

		public function RewardBar() {
			super();
			this.mouseChildren=false;
		}

		public function updateInfo(_vo:*):void {
			rVO=_vo as ItemVO
			itemBar.updateInfo(rVO);
			tf_name.text=rVO.data.label+" +"+rVO.num;
		}
	}
}