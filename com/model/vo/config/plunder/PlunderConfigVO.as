package com.model.vo.config.plunder {
	import com.model.vo.BaseObjectVO;
	import com.model.vo.item.ItemBaseVO;

	/**
	 * 具体掠夺配置信息
	 * @author hunterxie
	 */
	public class PlunderConfigVO extends BaseObjectVO{
		/**等级*/
		public var lv:int;
		/**等级对应名称*/
		public var title:String;
		/**等级对应描述*/
		public var description:String;
		/**等级所需得分*/
		public var score:int;
		/**达到等级后的奖励信息*/
		public var rewards:Array = BaseObjectVO.getClassArray(ItemBaseVO);
		/**下一级信息*/
		public var next:PlunderConfigVO;
		
		public function PlunderConfigVO(info:Object=null):void{
			super(info);
		}
	}
}
