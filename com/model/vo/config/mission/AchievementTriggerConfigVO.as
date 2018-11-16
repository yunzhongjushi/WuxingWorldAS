package com.model.vo.config.mission {
	import com.model.vo.BaseObjectVO;

	public class AchievementTriggerConfigVO extends BaseObjectVO {
		/**
		 * 成就类型
		 */
//		private var kind:int;
		
		/**
		 * 所属类型Id（钻石、金属性、4消、5连消、金精灵......）
		 */
		public var tarID:int;
		
		/**
		 * 目标值
		 */
		public var tarNum:int;
		
		/**
		 * 成就目标类型
		 */
		public var tarKind:int;
		
		
		public function AchievementTriggerConfigVO(info:Object=null):void{
			super(info);
		}
		
		public function updateByXML(info:XML):void{
//			this.kind 		= info.@CondictionType;
			this.tarID 		= info.@CondictionID;
			this.tarKind	= info.@Para1;
			this.tarNum		= info.@Para2;
		}
	}
}
