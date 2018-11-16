package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.vo.WuxingVO;
	
	/**
	 * 删除邮件
	 */
	public class ServerVO_10{
		
		public static const LOAD_SHOW:String = "正在删除邮件...";
		
		public static var ID:int = 0x0a;
		/**
		 * 返回请求是否成功
		 */
		public var returnCode:Boolean = true;
		private var deletedArr:Object;
	
		public function ServerVO_10(obj:Object) {
			this.returnCode = obj.returnCode==1?true:false;
			deletedArr=obj as Object;
		}
		public function getIsSuccess():*{
			var ct:int=0;
			var id:int;
			var isSuccess:Boolean;
			for(var i:String in deletedArr){
				var key:String = i
				var index:int = key.search("mailId:");
				if(index==0){
					key=key.slice(7);
					return parseInt(key);
				}
			}
			return null;
		}
		/**
		 * 发送给server
		 * @return 
		 */
		public static function  getSendInfo(mailIDArr:Array):Boolean{
			return MainNC.getInstance().sendInfo(ID,{mailNum:mailIDArr},LOAD_SHOW);
		}
	}
}
