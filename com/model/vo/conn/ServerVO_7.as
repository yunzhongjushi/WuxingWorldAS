package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.vo.WuxingVO;
	
	/**
	 * 标记邮件为已读
	 */
	public class ServerVO_7{
		
		public static const LOAD_SHOW:String = " ";
		
		public static var ID:int = 0x07;
		public var returnCode:Boolean = true;
		private var deletedArr:Object;
		public var isSuccess:Boolean;
		
		public function ServerVO_7(obj:Object) {
			this.returnCode = obj.returnCode==1?true:false;
			if(obj["rs"]){
				isSuccess=true;
			}else{
				isSuccess=false;
			}
//			MainNC.closeLodingPanel(LOAD_SHOW);
		}
		public function getIsSuccess():Boolean{
			return isSuccess;
		}
		/**
		 * 发送给server
		 * @return 
		 */
		public static function  getSendInfo(cmdObj:Object):Boolean{
			return MainNC.getInstance().sendInfo(ID,cmdObj);
		}
	}
}
