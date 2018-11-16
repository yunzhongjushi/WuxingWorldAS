package com.model.vo.conn {
	import com.conn.MainNC;

	/**
	 *  qq黄钻
	 */
	public class ServerVO_210 {
		public static const LOAD_GET_INFO:String="正在领取奖励...";

		public static var ID:int=0xd2;
		public var returnCode:Boolean=true;
		private var deletedArr:Object;
		public var info:Object;


		public function ServerVO_210(obj:Object) {
			info=obj

		}

		public function getInfo():Object {
			return info;
		}

		/**
		 * 获取升级奖励
		 */
		public static function getLevelupGift(lv:String):void {
			MainNC.getInstance().sendInfo(ID, {lv:lv}, LOAD_GET_INFO);
		}
	}
}
