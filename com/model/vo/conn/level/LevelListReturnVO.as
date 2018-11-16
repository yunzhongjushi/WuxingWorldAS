package com.model.vo.conn.level {
	import com.conn.MainNC;
	import com.model.vo.BaseObjectVO;
	import com.model.vo.level.LevelSaveVO;

	/**
	 * server返回的闯关列表信息
	 * @author hunterxie
	 * 
	 */
	public class LevelListReturnVO extends BaseObjectVO{
		public static var ID:int = 0x8a;
		
		public var levels:Object = {cls:LevelSaveVO};
		public var jsonInfo:Object;
		
		public function LevelListReturnVO(info:Object=null) {
			super(info);
			this.jsonInfo = info;
		}
		
		/**
		 * 发送给server请求获取闯关列表
		 */
		public static function sendInfo():void{
			MainNC.getInstance().sendInfo(ID, {});
		}
	}
}
