package com.model.vo.config.altar {
	import com.model.vo.BaseObjectVO;
	
	/**
	 * 祭坛抽取类型(五行/钻石)配置
	 * @author hunterxie
	 */
	public class AltarKindConfigVO extends BaseObjectVO{
		/**免费抽取次数上限*/
		public var freeTime:int;
		/**免费抽取次数恢复间隔*/
		public var freeCD:int;
		/**首次抽奖配置*/
		public var first:AltarExtractConfigVO;
		/**抽一次配置*/
		public var one:AltarExtractConfigVO;
		/**抽十配置*/
		public var ten:AltarExtractConfigVO;
		
		public function AltarKindConfigVO(info:Object=null):void {
			super(info);
		}
	}
}
