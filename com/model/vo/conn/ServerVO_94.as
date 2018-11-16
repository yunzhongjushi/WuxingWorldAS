package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.vo.WuxingVO;
	import com.model.vo.user.UserVO;
	import com.view.UI.user.ResetWuxingPointVO;
	
	/**
	 * 请求钻石洗点
	 * @author hunterxie
	 */
	public class ServerVO_94 extends ServerWuxingPropertyVO{
		public static var ID:int = 0x5e;
		/**
		 * 返回请求是否成功
		 */
		public var returnCode:Boolean = true;
		
		private static function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		/**
		 * 请求钻石洗点
		 * 一级协议：0x5e
			参数：
			kind:int;//0:金，1:木，2:土，3:水，4火:，5:全洗
			
			返回：
			attr:[0,0,0,0,0];//当前分配好的五行属性点：[金，木，土，水，火]
			attrNum:int;//当前剩余可分配点数
			 returnCode:int;//0:失败，1：成功
		 */
		public function ServerVO_94(obj:Object) {
			super(obj);
			userInfo.gold = obj.gold;
			this.returnCode = obj.returnCode==1?true:false;
		}
		
		/**
		 * 发送给server
		 * @return 
		 */
		public static function  sendInfo(vo:ResetWuxingPointVO):void{
//			if(BaseInfo.isTestLogin){
//				switch(vo.wuxing){
//					case 0:
//					case 1:
//					case 2:
//					case 3:
//					case 4:
//						userInfo.allPoint += userInfo.wuxingInfo.getWuxingProperty(vo.wuxing)-1;
//						userInfo.wuxingInfo.setProperty(vo.wuxing, 1);
//						break;
//					case 5:
//						for(var i:int=0; i<5; i++){
//							userInfo.allPoint += userInfo.wuxingInfo.getWuxingProperty(i)-1;
//							userInfo.wuxingInfo.setProperty(i, 1);
//						}
//						break;
//				}
//			}else{
				MainNC.getInstance().sendInfo(ID, {kind:vo.wuxing});
//			}
		}
	}
}
