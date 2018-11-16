package com.model.vo.config.wuxing {
	import com.model.vo.BaseObjectVO;
	
	/**
	 * 关卡等级相关配置信息
	 * @author hunterxie
	 */
	public class WuxingLVConfigVO extends BaseObjectVO {
		
		/**
		 * 对应等级
		 */
		public var lv:int = 1;
		/**
		 * 对应升级前提
		 */
		public var trigger:Array = BaseObjectVO.getClassArray(WuxingLVTriggerConfigVO);
		/**
		 * 对应容量
		 */
		public var capacity:int = 1;
		/**
		 * 对应三消得分
		 */
		public var clear_3:int = 1;
		
		
		/**
		 * 所有等级相关配置信息
		 */
		public function WuxingLVConfigVO(info:Object=null) {
		}
		
	}
}
