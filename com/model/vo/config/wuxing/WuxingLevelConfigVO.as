package com.model.vo.config.wuxing {
	import com.model.vo.BaseObjectVO;
	
	/**
	 * 关卡等级相关配置信息
	 * @author hunterxie
	 */
	public class WuxingLevelConfigVO extends BaseObjectVO {
		
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
		 * 对应资源增长速度（小时）
		 */
		public var increase:int = 1;
		
		
		/**
		 * 所有等级相关配置信息
		 */
		public function WuxingLevelConfigVO(info:Object=null) {
		}
		
	}
}
