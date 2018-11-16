package com.model.vo.conn {

	public class BaseAskVO{
		/** 协议号 */
		public var cmd:int = 0;
		/** 子协议号 */
		public var code:int = 0;
		
		public var description:String = "描述";
		/**
		 * 后台请求时提示的文字信息</br>
		 * 如果有就出现loding面板
		 */
		public var loadingInfo:String = "";
		
		public function getJson():String{
			return JSON.stringify(this);
		}
		
		public function BaseAskVO() {
			
		}
	}
}
