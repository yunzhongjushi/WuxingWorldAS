package com.model.vo.conn {
	import com.model.vo.BaseObjectVO;

	public class BaseReturnVO extends BaseObjectVO{
		/** 返回结果</br>
		 * 0：成功</br>
		 * 其他：失败
		 */
		public var ret:int;
		
		public function get isSuccess():Boolean{
			return ret==0;
		}
		
		public var serverInfo:Object;
		public function BaseReturnVO(info:Object=null) {
			serverInfo = info;
			super(info);
		}
	}
}
