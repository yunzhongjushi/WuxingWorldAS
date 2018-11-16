package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.vo.WuxingVO;
	import com.model.vo.mail.MailVO;
	
	/**
	 * 收取附件
	 */
	public class ServerVO_6{
		
		public static const LOAD_SHOW:String = "正在收取物品...";
		
		public static var ID:int = 0x06;
		private var mailID:int;
		private var isSuccess:Boolean;
		
		public function ServerVO_6(obj:Object) {
			mailID=0;
			for(var i:String in obj){
				var index:int = i.search("mailId");
				if(index!=-1){
					mailID = parseInt(i.substr(7));
				}
			}
		}
		public function getIsSuccess():Boolean{
			return isSuccess;
		}
		public function getMailId():int{
			return mailID;
		}
		/**
		 * 发送给server
		 * @return 
		 */
		public static function  getSendInfo(mailVO:MailVO):Boolean{
			return MainNC.getInstance().sendInfo(ID,{mailId:mailVO.mailID,attachIndex:0},LOAD_SHOW);
		}
	}
}
