package com.view.UI.mail {
	import com.model.vo.mail.MailVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;

	import flash.display.MovieClip;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	public class MailInfoBox extends BasePanel {


		public function MailInfoBox() {
			super();

			btn_delete.setNameTxt("删 除");
			btn_reply.setNameTxt("回 复");

			this.addEventListener(MouseEvent.CLICK, handle_click);
		}

		public function handle_click(e:*):void {
			switch(e.target) {
				case btn_cover:
					this.close();
					break;
				case btn_delete:
					event(E_Delete, rMailVO);
					this.close();
					break;
				case btn_reply:

					var mailVO:MailVO=MailVO.genFriendMail("", rMailVO.sender);

					event(E_Reply, mailVO);

					break;
			}
		}
		//****************   以上为模板，请勿随意改动。   ********************
		//Function Names
		public static const E_Delete:String="E_Delete";
		public static const E_Reply:String="E_Reply";
		public static const E_GetAttachment:String="E_GetAttachment";
		//Event Names
		public static const TEMP:String="TEMP";
		//场景含有组件

		public var tf_messageWords:TextField;

		public var tf_attacment_label:TextField;
		public var tf_attacment:TextField;

		public var tf_sender:TextField;
		public var tf_content:TextField;
		public var btn_cover:MovieClip;
		public var btn_delete:CommonBtn;
		public var btn_reply:CommonBtn;
		public var mc_cover:MovieClip;
		//
		private var rMailVO:MailVO;

		//
		public function updateInfo(mailVO:MailVO):void {
			rMailVO=mailVO;
			if(rMailVO.getIsContainItem()) {
			} else {
			}
			tf_messageWords.text=rMailVO.title
			tf_content.text=rMailVO.getMailContentStr()
			tf_sender.text=rMailVO.getSenderStr()

			if(rMailVO.attachmentStr.length) {
				tf_attacment_label.visible=tf_attacment.visible=true;
				tf_attacment.text=rMailVO.attachmentStr;
			} else {
				tf_attacment_label.visible=tf_attacment.visible=false;
			}
		}
	}
}
