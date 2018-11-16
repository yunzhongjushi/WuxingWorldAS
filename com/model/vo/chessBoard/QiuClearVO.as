package com.model.vo.chessBoard {
	
	/**
	 * 一次行动消除的内容,包括整盘判断、移动、技能
	 * @author hunterxie
	 */
	public class QiuClearVO {
		/**
		 * 整盘判断/下落消除
		 */
		public static const QIU_CLEAR_ALL:int = 0;
		/**
		 * 通过交换消除
		 */
		public static const QIU_CLEAR_EXCHANGE:int = 1;
		/**
		 * 通过技能消除
		 */
		public static const QIU_CLEAR_SKILL:int = 2;
		
		/**
		 * 消除数组，多个数组并行消除
		 * @see com.model.vo.chessBoard.SingleClearVO
		 */
		public var clearArr:Array=[];
		
		/**
		 * 交换的第一个球，如果是整盘判断就为null
		 */
		private var changePoint1:QiuPoint;
		/**
		 * 交换的第二个球，如果是整盘判断就为null
		 */
		private var changePoint2:QiuPoint;
		
		/**
		 * 消除类型0：下落消除；1：交换消除；2：技能消除；
		 */
		public var clearKind:int = 0;
		
//		public var sequenceClearNum:int;
		
		/**
		 * 独立ID，用于获取后续触发技能数据
		 */
		public var ID:Number;
		
		public function get scoreInfo():String{
			var str:String = "";
//			for(var i:int=0; i<clearArr.length; i++){
//				var vo:SingleClearVO = clearArr[i];
//				str+=vo.kind+"_"+vo.
//			}
			return str;
		}
		
		
		
		/**
		 * 一次移动/整盘判断的消除信息
		 * @param kind		消除类型
		 * @param point		交换球1
		 * @param tarPoint	交换球2
		 */
		public function QiuClearVO(kind:int, point1:QiuPoint=null, point2:QiuPoint=null) {
			this.clearKind = kind;
			this.changePoint1 = point1;
			this.changePoint2 = point2;
			this.ID = Math.random();
		}
		
		/**
		 * 设置消除数组，并且根据长连规则产生技能球数组
		 * @param arr
		 */
		public function addClear(arr:Array):void{
			var point:QiuPoint;
			if(changePoint1 && changePoint2){//优先考虑交换的球
				for(var i:int=0; i<arr.length; i++){
					point = arr[i] as QiuPoint;
					if((point.r==changePoint1.r && point.l==changePoint1.l) || (point.r==changePoint2.r && point.l==changePoint2.l)){
						break;
					}
				}
			}
//			else{
//				point = arr[2] as QiuPoint;
//			}
			
			var sameVO:SingleClearVO=null;
			for (var k:int=0; k<clearArr.length; k++) {
				var vo:SingleClearVO = clearArr[k] as SingleClearVO;
				if(vo.judgeSame(arr)){
					if(sameVO){//如果已经合入到之前的数组，就把这个数组也合入之前数组，然后把当前的删掉
						sameVO.concatSame(vo.clearArr);
						clearArr.splice(k,1);
						k--;
					}else{
						sameVO = vo;
						sameVO.concatSame(arr);
					}
				}
			}
			if(!sameVO){
				clearArr.push(new SingleClearVO(this.clearKind, arr, point));
			}
		}
	}
}