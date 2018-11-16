package com.model.vo.level {
	import com.model.vo.BaseObjectVO;

	/**
	 * 存储的关卡基本信息
	 * @author hunterxie
	 */
	public class LevelSaveVO extends BaseObjectVO{
		public var ID:int;
		/**
		 * 过关得分
		 */
		public var maxScore:int = 0;
		/**
		 * 是否获得星星1（过关获得）
		 */
		public var star1:Boolean = false;
		/**
		 * 是否获得星星2
		 */
		public var star2:Boolean = false;
		/**
		 * 是否获得星星3
		 */
		public var star3:Boolean = false;
		/**
		 * 当日闯关次数
		 */
		public var todayCross:int = 0;
		/**
		 * 总闯关次数
		 */
		public var totalCross:int = 0;
		
		public function get isCrossed():Boolean{
			return star1;
		}
		
		/**
		 * 高级关卡作为产出对应五行资源的等级
		 */
		public var wuxingLV:int = 0;
		
//		public var chooseSkills:Array;
		
//		public var chooseFairys:Array;
		
		
		
		
		
		public function LevelSaveVO(info:Object=null) {
			super(info);
		}

		override public function updateObj(info:Object):void{
			super.updateObj(info);
			
		}
	}
}
