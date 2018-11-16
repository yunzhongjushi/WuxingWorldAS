
package com.model.vo.conn
{
	import com.conn.MainNC;
	import com.model.vo.WuxingVO;
	
	/**
	 * 获取成就信息
	 */
	public class ServerVO_181{
		public static var ID:int = 0xb5;
		public var returnCode:Boolean = true;
		private var deletedArr:Object;
		public var info:Object;
		
		
		public function ServerVO_181(obj:Object) {
			info=obj;
		}
		public function getInfo():Object{
			return info;
		}
		/**
		 * 发送给server
		 * @return 
		 */
		public static function  firstTimeGetQuestInfo(playerID:int):Boolean{
			return MainNC.getInstance().sendInfo(ID, {});
		}
	}
}
