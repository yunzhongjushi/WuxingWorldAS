package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.event.EventCenter;
	import com.model.vo.user.UserVO;
	
	/**
	 * 钻石信息更新
	 * @author hunterxie
	 */
	public class ServerVO_198{
		public static var ID:int = 0xc6;
		/**
		 * 返回请求是否成功
		 */
		public var returnCode:Boolean = true;
		
		/**
		 * 钻石信息更新
		 * 一级协议：0xc6
		 参数：空
		 返回：money:int;//当前剩余钻石数量
		 returnCode:int;//0:失败，1：成功
		 */
		public function ServerVO_198(obj:Object) {
			EventCenter.traceInfo("更新玩家钻石:"+obj.money);
			if(obj.hasOwnProperty("money")){
				UserVO.getInstance().gold = parseInt(obj.money);
				UserVO.getInstance().dispatchUpdate();
			}
			
			this.returnCode = obj.returnCode==1?true:false;
		}
		
		/**
		 * 发送给server
		 * @return 
		 */
		public static function  sendInfo():void{
//			UserVO.getInstance().gold = 55;
//			UserVO.getInstance().dispatchUpdate();
			MainNC.getInstance().sendInfo(ID, {kind:""});
		}
	}
}

