package com.model.vo.item {
	import com.model.vo.BaseObjectVO;

	public class ItemBaseVO extends BaseObjectVO{
		public static const UPDATE_ITEM_INFO:String = "UPDATE_ITEM_INFO";
		/**
		 * 原始ID
		 */
		public var _templateID:int;
		
		public var _itemID:int;
		
		/**
		 * 数量
		 */
		public var num:int;
		
		
		public function ItemBaseVO(id:int=0, num:int=0){
			this._templateID = id;
			this.num = num;
		}
	}
}
