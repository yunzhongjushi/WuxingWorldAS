package com.view.UI.mail {
	import com.model.vo.item.ItemVO;
	import com.model.vo.mail.MailVO;
	import com.view.BasePanel;
	import com.view.UI.item.ItemBarLarger;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;

	public class MailAttachmentBox extends BasePanel {
//		public var tf_title:TextField;
//		public var tf_content:TextField;




		public function MailAttachmentBox() {
			super();

			btn_ok.tf_name.text="接 收"
		}

		public function handle_click(e:*):void {
			switch(e.target) {
				case btn_ok:
					event(E_GetAttachment, mailVO);
					break;
			}
		}
		//****************   以上为模板，请勿随意改动。   *******************************
		//Function Names
		public static const E_GetAttachment:String="E_GetAttachment";
		//
		public var btn_ok:CommonBtn;

		public var item_1:ItemBarLarger;
		public var item_2:ItemBarLarger;
		public var item_3:ItemBarLarger;
		public var item_4:ItemBarLarger;
		public var item_5:ItemBarLarger;
		public var item_6:ItemBarLarger;
		private const energyItemID:int=101;
		//

		private var mailVO:MailVO;

		private function reset():void {
			for(var j:int=1; j<=6; j++) {
				var item:ItemBarLarger=this["item_"+j]
				item.updateInfoFromVO(null);
			}
		}

		public function updateInfo(mailVO:MailVO):void {
			reset();
			var index:int=1;
			var item:ItemBarLarger;
			this.mailVO=mailVO;
			if(mailVO.energy>0) {
				item=this["item_"+index] as ItemBarLarger;
				item.updateInfoFromVO(mailVO.getEnergyItemVO());
				index++;
			}
			for(var i:int=0; i<mailVO.itemArr.length; i++) {
				var itemVO:ItemVO=mailVO.itemArr[i] as ItemVO;
				item=this["item_"+index] as ItemBarLarger;
				item.updateInfoFromVO(itemVO);
				index++;
			}
		}
	}
}
