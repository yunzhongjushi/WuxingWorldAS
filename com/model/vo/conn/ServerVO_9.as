package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.vo.WuxingVO;
	import com.model.vo.mail.MailVO;
	
	/**
	 * 发送邮件
	 */
	public class ServerVO_9{
		
		public static const LOAD_SHOW:String = "正在收取物品...";
		
		public static var ID:int = 0x09;
		/**
		 * 返回请求是否成功
		 */
		public var returnCode:Boolean = true;
		private var isSuccess:Boolean;
		
		public function ServerVO_9(obj:Object) {
			this.returnCode = obj.returnCode==1?true:false;
			if(obj["rs"]){
				isSuccess=true;
			}else{
				isSuccess=false;
			}
		}
		public function getIsSuccess():Boolean{
			return isSuccess;
		}
		/**
		 * 发送给server
		 * @return 
		 */
		/*nickName:String 		//收件人的昵称
		title:String 			//邮件标题
		content:String		//邮件内容
		energy: String		//附带活力值
		itemId1~ itemId5: String	//附件1～5的物品代码
*/
		public static function  getSendInfo(mail:MailVO):Boolean{
			return MainNC.getInstance().sendInfo(ID,
				{
					nickName:mail.receiver,
					title:mail.title,
					content:mail.content,
					energy:mail.energy,
					itemId1:mail.getItemID(0),
					itemId2:mail.getItemID(1),
					itemId3:mail.getItemID(2),
					itemId4:mail.getItemID(3),
					itemId5:mail.getItemID(4)
				},
				LOAD_SHOW);
		}
	}
}
