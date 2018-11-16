package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.vo.WuxingVO;
	import com.model.vo.user.UserVO;
	import com.view.UI.user.ResetWuxingPointVO;
	
	/**
	 * 请求元素洗点
	 * @author hunterxie
	 */
	public class ServerVO_90 extends ServerWuxingPropertyVO{
		public static var ID:int = 0x5a;
		/**
		 * 返回请求是否成功
		 */
		public var returnCode:Boolean = true;
		
		private static function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		/**
		 * 请求元素洗点
		 * 一级协议：0x5a
			参数：
			kind:int;//0:金，1:木，2:土，3:水，4火:
			返回：
			attr:[0,0,0,0,0];//当前分配好的五行属性点：[金，木，土，水，火]
			attrNum:int;//当前剩余可分配点数
			returnCode:int;//0:失败，1：成功
		 */
		public function ServerVO_90(obj:Object) {
			super(obj);
			this.returnCode = obj.returnCode==1?true:false;
				trace(returnCode?"洗点成功":"洗点失败");
		}
		
		/**
		 * 发送给server
		 * @return 
		 */
		public static function  sendInfo(vo:ResetWuxingPointVO, money:Boolean=true):void{
//			if(BaseInfo.isTestLogin){
//				UserVO.testAddResource(vo.wuxing, -vo.wuxingNum);
//				userInfo.allPoint += userInfo.wuxingInfo.getWuxingProperty(vo.wuxing)-1;
//				userInfo.wuxingInfo.setProperty(vo.wuxing, 1);
//				UserVO.testAddGold(-vo.goldNum);
//			}else{
				MainNC.getInstance().sendInfo(ID, {kind:vo.wuxing, isCostMoney:money?1:0});
//			}
			
		}
	}
}
