package com.model.vo.config.wuxing {
	import com.model.vo.BaseObjectVO;

	public class WuxingLVTriggerConfigVO extends BaseObjectVO{
		/**
		 * 前提ID
		 * 1：userLV 			需要用户等级
		 * 2：selfWuxingUse		需要消耗自身五行
		 * 3：shengWuxingUse	需要消耗生我五行
		 */
		public var id:int=0;
		
		/**
		 * 需要的数量
		 */
		public var num:int=0;
		
		public function WuxingLVTriggerConfigVO(info:Object=null) {
			super(info);
		}
	}
}
