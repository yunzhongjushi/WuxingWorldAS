package com.view.UI.activity {
	import com.model.vo.activity.SignItemVO;
	import com.view.BaseImgBar;

	import flash.display.MovieClip;
	import flash.text.TextField;

	import listLibs.ITouchPadBar;

	public class SignBar extends BaseImgBar implements ITouchPadBar {
		public var running_vo:SignItemVO;

		public function SignBar() {
			super();
		}

		public function updateInfo(_vo:*):void {
			if(_vo==null) {
				this.visible=false;
				return;
			}

			if(_vo is SignItemVO) {
				this.visible=true;
				running_vo=_vo as SignItemVO;
				tf_label.text=String("x"+running_vo.itemNum)
				signBoardArr.gotoAndStop(running_vo.status)
				if(running_vo.status==SignItemVO.SIGNED) {
					sign_SignBoard.visible=true;
				} else {
					sign_SignBoard.visible=false;
				}
				updateClass(running_vo.data.icon);
				addChildAt(sign_SignBoard, this.numChildren-1);
			}
		}
		//场景元素
		public var sign_SignBoard:MovieClip;
		public var signBoardArr:MovieClip;
	}
}
