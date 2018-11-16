package com.view.UI.item {
	import com.model.vo.item.ItemVO;
	import com.view.BaseImgBar;

	import flash.text.TextField;

	public class ItemBarLarger extends BaseImgBar {
		private var running_vo:ItemVO

		public var tf_label:TextField;

		public function ItemBarLarger() {
			super();
		}

		public function updateInfoFromVO(_vo:*):void {
			if(_vo==null) {
				this.visible=false;
				return;
			}
			this.visible=true;
			running_vo=_vo as ItemVO;
			tf_label.text=running_vo.num+"";
			updateClass(running_vo.data.icon);
		}
	}
}
