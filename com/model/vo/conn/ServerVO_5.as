package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.vo.friend.FriendListVO;

	/**
	 * 好友相关
	 */
	public class ServerVO_5{
		/** 协议号 */
		public static const ID:int=0x05;
		/**
		 * 二级协议添加好友
		 */
		public static const CODE_ADD_FRIEND:int = 0x01;
		/**
		 * 二级协议获取好友
		 */
		public static const CODE_GET_FRIEND:int = 0x02;

		/**
		 * 
		 * @param obj
		 * 
		 */		
		public function ServerVO_5(obj:Object) {
			switch(obj.code) {
				case CODE_GET_FRIEND:
					FriendListVO.updateInfoByServer(obj);
					break;
				case CODE_ADD_FRIEND:
					FriendListVO.updateAddFriend(obj);
					break;
			}
		}
		/**
		 * 添加好友
		 * @param nickName
		 */
		public static function add_friend(nickName:String):void {
			MainNC.getInstance().sendInfo(ID, {code:CODE_ADD_FRIEND, nickName:nickName}, "正在添加好友...");
		}

		/**
		 * 获取好友
		 */
		public static function get_friend():void {
			MainNC.getInstance().sendInfo(ID, {code:CODE_GET_FRIEND}, "正在获取好友...");
		}
	}
}
