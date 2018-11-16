package com.model.vo.conn {
	import com.conn.MainNC;
	
	/**
	 * 升级玩家技能
	 * @author hunterxie
	 */
	public class ServerVO_108{
		public static var ID:int = 0x6c;
		
		/**
		 * 本次操作的技能ID
		 */
		private var tempSkill:int;
		
		/**
		 * 升级玩家技能
		 * 一级协议：0x6c
			参数：
			id：int；//技能id
			返回：
			result:int;//0:未拥有技能；1：技能已满级，2成功
		 */
		public function ServerVO_108(obj:Object) {
			trace(obj.result+"__0:未拥有技能；1：技能已满级，2成功");
		}
		
		/**
		 * 发送给server
		 * @param id 升级的技能id
		 */
		public static function sendInfo(id:int):void{
			MainNC.getInstance().sendInfo(ID, {id:id});
		}
	}
}
