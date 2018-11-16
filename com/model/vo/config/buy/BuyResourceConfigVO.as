package com.model.vo.config.buy{
	import com.model.vo.BaseObjectVO;
	
	
	/**
	 * 购买(时间/资源)配置信息
	 * @author hunterxie
	 */
	public class BuyResourceConfigVO extends BaseObjectVO{
		public var id:int = 0;
		
		/**范围下限*/
		public var min:int = 0;
		/**范围上限*/
		public var max:int = 0;
		/**范围下限*/
		public var total:int = 0;
		/**资源单价*/
		public var price:int = 0;
		
		
		/**
		 * 
		 * @param info
		 */
		public function BuyResourceConfigVO(info:Object=null):void{
			super(info);
		}
	}
}