package com.model.vo.chessBoard {
	
	/**
	 * 棋盘技能生效信息
	 * @author hunterxie
	 */
	public class BoardSkillActiveVO extends QiuClearVO{
		/**
		 * 两个球消除的时间间隔（秒）
		 */
		public var interval:Number;
		
		/**
		 * 技能效果对应ID，用于展示效果：消除、变色、生成棋子、添加buff
		 */
		public var id:int;
		
		public var vo:QiuClearVO
		
		public var lv:int=0;
		
		
		/**
		 * 生效的原始位置，用于展示动画
		 * @return 
		 */
		public function get originalPoint():QiuPoint{
			return _originalPoint;
		}
		public function set originalPoint(value:QiuPoint):void{
			_originalPoint = value;
		}
		private var _originalPoint:QiuPoint;
		
		
		
		/**
		 * 技能消除信息
		 * @param id		技能id
		 * @param interval	延迟展示时间
		 * @param tar		技能所在位置（球的位置）	
		 * @param lv		技能等级
		 */
		public function BoardSkillActiveVO(id:int, interval:Number, tar:QiuPoint, lv:int) {
			super(QiuClearVO.QIU_CLEAR_SKILL);
			this.id = id;
			this.interval = interval;
			this.originalPoint = tar;
			this.lv = lv;
		}

		/**
		 * 添加技能造成的单方向消除数组，用于展示技能动画；
		 * 而不是所有技能造成的消除都放到一个数组，这样就无法展示十字消（从起点到终点的距离）
		 * @param arr
		 * @param opoint	原点，如果存在就把这个点添加到数组开头，如果不传就用技能触发点
		 */
		public function addSkillSingleClear(arr:Array, opoint:QiuPoint=null, last:QiuPoint=null):void{
			//			for(var i:int=0; i<arr.length; i++){
			//				clearArr.push(new SingleClearVO(this.clearKind, [arr[i]]));//单个获取
			//			}
			clearArr.push(new SingleClearVO(this.clearKind, arr, opoint?opoint:originalPoint, last));//单个获取
		}
	}
}