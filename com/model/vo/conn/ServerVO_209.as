package com.model.vo.conn {
	import com.conn.MainNC;

	/**
	 *  qq黄钻
	 */
	public class ServerVO_209 {
		public static const LOAD_GET_INFO:String="正在领取奖励...";

		public static var ID:int=0xd1;
		public var returnCode:Boolean=true;
		private var deletedArr:Object;
		public var info:Object;


		public function ServerVO_209(obj:Object) {

			info=obj

			MainNC.closeLodingPanel(LOAD_GET_INFO);

		}

		public function getInfo():Object {
			return info;
		}
		/**
		 * 获取每日奖励
		 * @return
		 */
		private static var DAILY:int=1;

		public static function getDailyGift():void {
			MainNC.getInstance().sendInfo(ID, {type:DAILY}, LOAD_GET_INFO);
		}

		/**
		 * 获取新手奖励
		 */
		private static var NEW_GIFT:int=2;

		public static function getNewGift():void {
			MainNC.getInstance().sendInfo(ID, {type:NEW_GIFT}, LOAD_GET_INFO);
		}
	}
}
