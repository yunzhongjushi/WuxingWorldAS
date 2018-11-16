package com.view.UI.fairy {
	import com.model.vo.fairy.BaseFairyVO;
	import com.view.BaseImgBar;
	import com.view.BasePanel;
	
	import flash.display.MovieClip;
	
	import listLibs.ITouchPadBar;

	public class FairyBarMiddle extends BaseImgBar implements ITouchPadBar {

		public var running_vo:BaseFairyVO

		public var arr_wuxing_icon:MovieClip;

		public var arr_fairy_type:MovieClip;

		public var arr_fairy_star_middle:MovieClip;
		
		public var mc_lvUp:MovieClip;


		public function FairyBarMiddle() {
			this.setChildIndex(arr_wuxing_icon, this.numChildren-1);
			this.setChildIndex(arr_fairy_type, this.numChildren-1);
			
			mc_lvUp.visible = false;
		}


		public function updateInfo(_vo:*):void {
			if(_vo is BaseFairyVO) {
				running_vo=_vo as BaseFairyVO;
			}

			updateClass(running_vo.nickName+"154");
			arr_wuxing_icon.gotoAndStop(running_vo.wuxing); 
			arr_fairy_type.gotoAndStop(running_vo.data.fightkind);
			var showStar:int=(running_vo.starLV+2)/2 
			arr_fairy_star_middle.gotoAndStop(Math.min(showStar, 5));
		}
		
		public function updateLvUP():void{
			mc_lvUp.gotoAndPlay(2);
		}
	}
}
