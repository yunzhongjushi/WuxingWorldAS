package com.model.vo.conn {
	

	/**
	 * 更新成就信息
	 */
	public class ServerVO_8 {
		public static var ID:int=0x08;
		public var returnCode:Boolean=true;
		private var deletedArr:Object;
		public var info:Object;



		public function ServerVO_8(obj:Object) {
			info = obj;
			//new AchievementConfigVO(obj);
			ServerVO_199.updateData(info);
		}

		public function getCode():Object {
			return info["code"];
		}
	}
}
