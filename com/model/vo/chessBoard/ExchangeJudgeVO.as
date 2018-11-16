package com.model.vo.chessBoard {

	public class ExchangeJudgeVO {
		public var canClear1:Boolean = false;
		public var canClear2:Boolean = false;
		/**
		 * 用于记录可消除棋子，棋子地址作为参数名
		 */
		private var clearInfo:Object = {};
		
		/**
		 * 是否有可消除的棋子，用于判断是否可交换
		 */
		public function get hasClear():Boolean{
			return canClear1 || canClear2;
		}
		
		public function ExchangeJudgeVO(qiu:QiuPoint=null) {
			if(qiu){
				clearInfo[qiu] = true;
			}
		}
		
		public function getCanClear(qiu:QiuPoint):Boolean{
			return Boolean(clearInfo[qiu]);
		}
		public function setCanClear(qiu:QiuPoint, num:int):void{
			clearInfo[qiu] = true;
			this["canClear"+num] = true;
		}
	}
}
