package com.model.vo.chessBoard {
	import com.model.vo.config.skill.SkillEffectConfigVO;
	import com.utils.ArrayFactory;

	/**
	 * 单个类型的棋子消除信息
	 * @author hunterxie
	 */
	public class SingleClearVO {
		/**
		 * 消除类型
		 */
		public var clearKind:int;
		
		/**
		 * 消除数组
		 * @see com.model.vo.QiuPoint
		 */
		public var clearArr:Array=[];
		public function get clearNum():int{
			return clearArr.length;
		}
		
		/** 获取消除棋子中“合成”buff的总层数(不包括目标棋子)+消除数 */
		public function getMergeNum():uint{
			var num:int = clearNum-2;
			for(var i:int=0; i<clearArr.length; i++){
				var point:QiuPoint = clearArr[i] as QiuPoint;
				if(point.showBuff1 && point.showBuff1.checkEffectID(SkillEffectConfigVO.board_effect_39)){
					num += point.showBuff1.effectTime;
				}
			}
			return num;
		}
		
		/**
		 * 作为闪电技能展示的目标点(从原点开始)
		 */
		private var _lastPoint:QiuPoint;
		public function get lastPoint():QiuPoint{
			if(_lastPoint) return _lastPoint;
			return clearArr[clearArr.length-1];
		}
		
		public var clearResource:ResourceVO;
		
		
		/**
		 * 消除的中心点/技能原点
		 */
		public var tarPoint:QiuPoint;
		
		/**
		 * 消除的棋子类型，多个棋子类型是一样的
		 * @return 
		 */
		public function get kind():int{
			return tarPoint.showKind;
		}
		
		
		/**
		 * 单个类型的棋子消除信息，一次判断中可能会有多个消除，所有有焦点的消除都合并到一个
		 * @param clearKind	消除的棋子类型
		 * @param arr	棋子数组			如果是null说明是模拟精灵资源增长
		 * @param point	消除的中心位置
		 * @param last	闪电技能展示的目标点(从原点开始)
		 */
		public function SingleClearVO(clearKind:int, arr:Array, point:QiuPoint, last:QiuPoint=null) {
			this.clearKind = clearKind;
			this.tarPoint = point;
			if(arr) concatSame(arr);
			this._lastPoint = last;
//			if(last && last.r==7 && last.l==3){
//				trace("SingleClearVO:",last.r,last.l)
//			}
		}
		
		/**
		 * 所有有相同焦点的匹配消除都合并到一个，并且覆盖生成的技能球
		 * @param arr
		 */
		public function concatSame(arr:Array):void{
			ArrayFactory.merge(clearArr, arr);
			
			if(clearArr.length>3){//长连生成新球，通用处理成第三个位置
				if(!tarPoint){
					tarPoint = clearArr[2];//TODO
				}
			}else if(!tarPoint){
				tarPoint = clearArr[Math.floor(clearArr.length/2)];
			}
		}
		
		
		/**
		 * 是否跟之前数组有相同点（两个可消组最多只有一个交叉点）；
		 * @param arr	传入一个消除数组
		 * @return 		
		 */
		public function judgeSame(arr:Array):Boolean{
			for (var j:int=0; j<arr.length; j++) {
				var point:QiuPoint = arr[j] as QiuPoint;
				if(clearArr.some(function(item:QiuPoint, index:int, arr:Array):Boolean{return (item.r==point.r && item.l==point.l)})){
					return true;
				}
			}
			return false;
		}
	}
}
