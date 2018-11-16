package com.view.UI.mail {
	import com.model.event.ObjectEvent;
	import com.model.vo.mail.MailVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;

	import flash.display.MovieClip;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	public class MailWriter extends BasePanel {
		public function MailWriter() {
			super();
			btn_send.setNameTxt("发 送");
			this.addEventListener(MouseEvent.CLICK, handle_click);
		}

		public function handle_click(e:*):void {
			switch(e.target) {
				case btn_send:
					var mailVO:MailVO=MailVO.genFriendMail(tf_writer.text, mailVO.receiver);
					event(E_Send, mailVO);
					this.close();
					if(isFromFriendOpen) {
						event(E_Close);
					}
					break
				case btn_cover:
					this.close();
					break;
			}
		}

		override public  function close(e:*=null):void {
			if(isFromFriendOpen) {
				event(E_Close);
			}
			isFromFriendOpen=false;
		}
		//****************   以上为模板，请勿随意改动。   *******************************
		//Function Names
		public static const E_Close:String="E_Close";
		public static const E_Send:String="E_Send";
		//场景含有组件
		public var tf_writer:TextField
		public var btn_send:CommonBtn
		public var btn_cover:MovieClip


		public var mailVO:MailVO;
		public var isFromFriendOpen:Boolean;

		public function updateInfo(mailVO:MailVO, isFromFriendOpen:Boolean=false):void {
			this.mailVO=mailVO
			tf_writer.text=mailVO.content;
			this.isFromFriendOpen=isFromFriendOpen;
		}

	}
}

