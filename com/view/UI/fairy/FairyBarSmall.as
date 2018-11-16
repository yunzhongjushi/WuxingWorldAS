package com.view.UI.fairy {
	import com.model.vo.fairy.BaseFairyVO;
	import com.view.BaseImgBar;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	import listLibs.ITouchPadBar;


	/**
	 * 精灵列表中的精灵头像
	 * @author hunterxie
	 */
	public class FairyBarSmall extends BaseImgBar implements ITouchPadBar {
		public var tf_lv:TextField;
		public var arr_fairy_star_small:MovieClip;
		public var arr_fairy_frame:MovieClip;
		public var fairy_bar_small_mask:MovieClip;
		public var mc_glow:MovieClip;
		
		public var running_vo:BaseFairyVO;

		public function onSelecte():void {
			mc_glow.visible=true;
		}
		public function onUnselecte():void {
			mc_glow.visible=false;
		}


		public function FairyBarSmall() {
			super();
			onUnselecte();
			this.mouseChildren=false;
		}

		public function updateInfo(_vo:*):void {
			if(_vo is BaseFairyVO) {
				if(running_vo) {
					running_vo.removeEventListener(BaseFairyVO.FAIRY_INFO_UPDATE, refresh);
				}
				running_vo=_vo as BaseFairyVO;
				running_vo.addEventListener(BaseFairyVO.FAIRY_INFO_UPDATE, refresh);
				refresh();
			}
		}

		private function refresh(e:Event=null):void {
			updateClass(running_vo.nickName+"head");
			tf_lv.text=String(running_vo.LV);
			arr_fairy_frame.gotoAndStop(running_vo.wuxing);
			updateStrengthLV(running_vo.starLV);
		}

		public function updateStrengthLV(lv:int):void {
			var showStar:int=Math.floor((lv+2)/2);
			arr_fairy_star_small.gotoAndStop(Math.min(showStar, 5));
			itemImg.mask=fairy_bar_small_mask;
		}
	}
}
