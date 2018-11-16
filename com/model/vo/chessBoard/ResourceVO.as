package com.model.vo.chessBoard {
	

	/**
	 * 单独消除的一个资源
	 * @author hunterxie
	 */
	public class ResourceVO {
		
		/**
		 * 玩家棋盘技能生效，把计算出来的量加到原始量中
		 */
		public function addNum():void{
			_num = finalNum;
			num_add = 0;
			num_per = 1;
		}
		
		/**
		 * 资源数量，不可变，如需变化在额外增量里面设置
		 */
		public function get num():uint{
			return _num;
		}
		private var _num:uint;
		
		/**
		 * 通过技能（被动/buff）作用后的增量
		 */
		public var num_add:int = 0;
		/**
		 * 通过技能（被动/buff）作用后的增量百分比，不能小于-1，否则资源获得量就为负数了
		 */
		public var num_per:Number = 1;
		/**
		 * 最终得到的资源数量,计算后的总量
		 */
		public function get finalNum():uint{
			var tempNum:int = (_num+num_add)*num_per;
			if(tempNum<0) tempNum=0;
			return tempNum;
		}
		
		/**
		 * 连消数量，不可变
		 */
		public function get sequenceNum():uint{
			return _sequenceNum;
		}
		private var _sequenceNum:uint;
		
		
		/**
		 * 通过交换得到的重复消除数（如连续x次交换消除火棋子）
		 */
		public function get exchangeSameNum():uint{
			return _exchangeSameNum;
		}
		private var _exchangeSameNum:uint;
		
		
		private var clearVO:SingleClearVO;
		/**
		 * 消除的球触发位置，匹配消除就为中心位置
		 */
		public function get point():QiuPoint{
			return clearVO.tarPoint;
		}
		/**
		 * 资源/棋子类型
		 */
		public function get kind():int{
			return clearVO.kind;
		}
		
		/**
		 * 消除的类型：0：下落消除；1：交换消除；2：技能消除；
		 */
		public function get clearKind():int{
			return clearVO.clearKind;
		}
		/**
		 * 消除个数，不可变
		 */
		public function get clearNum():uint{
			return clearVO.clearNum;
		}
		
		/** 获取消除棋子中有“合成”buff的增加层数 */
		public function getMergeNum():uint{
			return clearVO.getMergeNum();	
		}
		
		
		
		
		/**
		 * 一次消除携带的资源，资源获得量数据
		 * @param clearVO		消除棋子信息
		 * @param num			收集得分数量
		 * @param sequenceNum	连消数量
		 * @param same			连续相同颜色交换消除数量（如连续2次交换消除火元素）
		 */
		public function ResourceVO(clearVO:SingleClearVO, num:uint, sequenceNum:uint, same:uint) {
			this.clearVO = clearVO;
			this._num = num;
			this.num_add = 0;
			this._sequenceNum = sequenceNum;
			this._exchangeSameNum = same;
//			if(same==2){//调试用寻找消除条件
//				trace("连色消==2");
//			}
		}

		
	}
}
