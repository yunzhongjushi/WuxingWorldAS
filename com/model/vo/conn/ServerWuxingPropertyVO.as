package com.model.vo.conn {
	import com.model.proxy.BaseConnProxy;
	import com.model.vo.user.UserVO;

	/**
	 * 服务器过来的更新五行属性点+可分配属性点+五行资源数据包
	 * @author hunterxie
	 */
	public class ServerWuxingPropertyVO extends BaseConnProxy{
		protected static var instance:ServerWuxingPropertyVO;
		public static function getInstance():ServerWuxingPropertyVO{
			if ( instance == null ) instance=new ServerWuxingPropertyVO();
			return instance;
		}
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		/**
		 * 当前剩余属性点
		 */
		public var nowWuxing:Array = [];
		/**
		 * 当前剩余可分配属性点
		 */
		public var attrNum:int = 0;
		
		/**
		 * 服务器过来的更新五行属性点+可分配属性点数据包
attr:[0,0,0,0,0];//当前分配好的五行属性点：[金，木，土，水，火]
attrNum:int;//当前剩余可分配点数
returnCode:int;//0:失败，1：成功

		 */
		public function ServerWuxingPropertyVO(obj:Object=null) {
			if(!obj || !obj.attr) return;
			nowWuxing = obj.attr;
			this.attrNum = obj.attrNum;
			
			userInfo.allPoint = attrNum;
			
			for(var i:int=0; i<nowWuxing.length; i++){
				userInfo.wuxingInfo.setProperty(i, nowWuxing[i]);
				userInfo.wuxingInfo.setResource(i, obj.res[i]);
			}
		}
	}
}
