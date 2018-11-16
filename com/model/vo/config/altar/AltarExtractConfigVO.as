package com.model.vo.config.altar {
	import com.model.vo.BaseObjectVO;

	/**
	 * 祭坛抽奖具体配置
	 * @author hunterxie
	 */
	public class AltarExtractConfigVO extends BaseObjectVO{
		/**在商城中显示的物品ID*/
		public var shopID:int;
		/**对应花费种类*/
		public var costKind:int;
		/**对应花费数量*/
		public var costNum:int;
		
		/**奖励ID列表*/
		public var rewards:Array;
		
		public function AltarExtractConfigVO(info:Object=null):void {
			super(info);
		}
	}
}
