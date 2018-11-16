package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.vo.WuxingVO;
	
	/**
	 * 请求获取玩家信息
	 * @author hunterxie
	 */
	public class ServerVO_93{
		public static var ID:int = 0x5d;
		
		/**
		 * 请求获取玩家信息
		 * 一级协议：0x5d
			参数：
			
			返回：
		 */
		public function ServerVO_93(obj:Object) {
			
		}
		
		/**
		 * 发送给server
		 * @return 
		 */
		public static function sendInfo():void{
			MainNC.getInstance().sendInfo(ID, {});
		}
	}
}
