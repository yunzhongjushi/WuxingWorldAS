package com.view.UI.fairy {
	import com.model.event.ObjectEvent;
	import com.model.vo.fairy.BaseFairyVO;
	import com.view.touch.CommonBtn;
	
	import flash.events.Event;
	
	import flash.display.MovieClip;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	public class TipFairyShowPanel extends MovieClip {
		public var mc_bg:MovieClip;

		public var mc_head:TipFairyBar;
		public var tf_description:TextField;

		public var tipFairyLabel:MovieClip;
		public var btn_ok:CommonBtn;
		
		private var mStep:int;

		public function TipFairyShowPanel() {
			btn_ok.setNameTxt("确定");
			btn_ok.addEventListener(MouseEvent.CLICK, handle_click);
		}

		protected function handle_click(e:*):void {
			if(mStep==1) {
				mStep=2;
				btn_ok.visible=false;
				tf_description.visible=false;
				tipFairyLabel.visible=false;
				this.gotoAndPlay(44+1);
			}
		}

		public function updateInfo(fairyVO:BaseFairyVO):void {
			mc_head.updateInfo(fairyVO);

			tipFairyLabel.tf_name.text = fairyVO.nickName;
//			tf_description.text				= description;

			mStep=1;
			btn_ok.visible=true;
			tf_description.visible=true;
			tipFairyLabel.visible=true;
			this.addEventListener(Event.ENTER_FRAME, handle_ef);
			this.gotoAndPlay(1);
		}

		protected function handle_ef(e:Event):void {
			if(this.currentFrame==44) {
				this.gotoAndPlay(1)
			}
			if(this.currentFrame==59) {
				this.stop();
			}
			if(this.isPlaying==false) {
				if(mStep==2&&this.parent) {
					this.removeEventListener(Event.ENTER_FRAME, handle_ef);
					this.dispatchEvent(new ObjectEvent(TipFairyPanel.PANEL_END_SHOW));
				}
			}
		}
	}
}