package com.model.vo.tip
{

	public class MopupBarVO
	{
		public static const STATE_HIDE:String = "hide";
		public static const STATE_SHOW_ITEM:String = "show_item";
		public static const STATE_SHOW:String = "show";
		
		/**
		 * 当前扫荡序数 
		 */		
		public var mopupNO:int;
		/**
		 * 奖励物品列表 
		 */		
		public var itemArr:Array;
		/**
		 * 奖励资源的数量 
		 */		
		public var addWuxing:Array;
		/**
		 * 奖励的人物经验 
		 */		
		public var addExp:int;
		/**
		 * 状态
		 * hide：隐藏
		 * show_item：演示奖励出现
		 * show：显示 
		 */		
		public var state:String
		
		/**
		 *  
		 * @param no		扫荡的序数
		 * @param itemArr	该次扫荡获得的物品列表
		 * @param addExp	获得的经验
		 * @param addWuxing	获得的五行，[10,10,10,10,10]
		 * 
		 */		
		public function MopupBarVO(no:int,itemArr:Array, addExp:int, addWuxing:Array)
		{
			this.mopupNO = no;
			this.itemArr = itemArr;
			this.addWuxing = addWuxing;
			this.addExp = addExp;
			this.state = STATE_HIDE;
		}
		public function setShowBar():void{
			this.state = STATE_SHOW;
		}
		public function setShowItem():void{ 
			this.state = STATE_SHOW_ITEM;
		}
	}
}