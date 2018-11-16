package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.event.EventCenter;

	/**
	 * 请求加点
	 * @author hunterxie
	 */
	public class ServerVO_92 extends ServerWuxingPropertyVO{
		public static var ID:int = 0x5c;
		/**
		 * 返回请求是否成功
		 */
		public var returnCode:Boolean = true;
		
		public var isUseGold:Boolean;
		
		/**
		 * 请求加点
		 * 一级协议：0x5c
			参数：
			attr:[0,0,0,0,0];//0:金，1:木，2:土，3:水，4火:
			返回：
			attr:[0,0,0,0,0];//当前分配好的五行属性点：[金，木，土，水，火]
			attrNum:int;//当前剩余可分配点数
			returnCode:int;//0:失败，1：成功
		 */
		public function ServerVO_92(obj:Object) {
			super(obj);
			this.returnCode = obj.returnCode==1?true:false;
			switch(obj.returnCode){
				case 0:
					break;
				case 1:
					break;
				case 2:
					EventCenter.traceInfo("配置文件读取错误");
					break;
				case 3:
					EventCenter.traceInfo("扣除钻石失败");
					break;
				case 4:
					EventCenter.traceInfo("可用属性点数不够");
					break;
				case 4:
					EventCenter.traceInfo("扣资源失败");
					break;
			}
		}
		
		/**
		 * 发送给server
		 * @param money	是否使用钻石补上缺少的资源
		 */
		public static function sendInfo(arr:Array, money:Boolean=false):void{
			MainNC.getInstance().sendInfo(ID, {attr:arr, isCostMoney:money?1:0});//0:arr[0],1:arr[1],2:arr[2],3:arr[3],4:arr[4]
		}
	}
}
