package com.model.vo.config.board {
	import com.model.vo.BaseObjectVO;
	import com.model.vo.chessBoard.QiuPoint;
	
	import flas.utils.utils;

	/**
	 * 棋盘配置
	 * @author hunterxie
	 */
	public class BoardConfigVO extends BaseObjectVO{
		/**
		 * 步数限制
		 */
		public static const LIMIT_SETP:String = "LIMIT_SETP";
		/**
		 * 回合限制
		 */
		public static const LIMIT_ROUND:String = "LIMIT_ROUND";
		
		public static var compare:BoardConfigVO = new BoardConfigVO();
		
		/**
		 * 横/行(棋盘大小)
		 */
		public var maxR:int = 8;
		/**
		 * 竖/列(棋盘大小)
		 */
		public var maxL:int = 8;
		/**
		 * 1、回合驱动：一次移动一颗；
		 * 2、全回合制驱动：一次移动多颗直到掉下终断消除；
		 * 3、时间驱动；
		 */
		public var activeMode:int = 1;
		/**
		 * 新生成整盘棋子时其中是否允许有可消除的（3颗相同）存在
		 */
		public var isInitCanClear:int = 0;
		/**
		 * 是否可以连续移动
		 */
		public var isDelayFall:int = 1;
		/**
		 * 是否有新棋子掉落(根据掉落表取随机)
		 */
		public var isCreateNew:int = 0;
		/**
		 * 交换(动画)用时
		 */
		public var exchangeTime:Number = 0.2;
		/**
		 * 掉落(动画)用时
		 */
		public var fallTime:Number = 0.2;
		/**
		 * 消除(动画)用时
		 */
		public var clearTime:Number = 0.5;
		/**
		 * 掉落后一定时间内再次消除算同回合内
		 */
		public var sequenceTime:Number = 0;
		
		public function set maxKinds(value:int):void{}
		public function get maxKinds():int{
			if(kindArr.length<3){
				return 6;
			}
			return kindArr.length;
		}
		/**
		 * 掉落的棋子种类
		 */
		public var kindArr:Array = [0,1,2,3,4];
		/**
		 * 对应种类的掉落概率
		 */
		public var chanceArr:Array = [1,1,1,1,1];
		
		
		/**
		 * 步数限制，0表示不限制
		 */
		public var stepLimit:int = 0;
		/**
		 * 回合限制，0表示不限制
		 */
		public var roundLimit:int = 0;
		
		
		
		private var _sumChance:Number = 0;
		public function get sumChance():Number{
			if(_sumChance==0){
				for(var i:int=0; i<chanceArr.length; i++){
					_sumChance += Math.floor(chanceArr[i]);
				}
			}
			return _sumChance;
		}
		public function getChanceBall():int{
			var sum:Number = sumChance;
			var temp:Number = sum*Math.random();
			for(var k:int=0; k<chanceArr.length; k++){
				sum -= chanceArr[k];
				if(temp>=sum){
					return kindArr[k];
				}
			}
			return QiuPoint.KIND_NULL;
		}
		
		
		public function BoardConfigVO(info:Object=null) {
			super(info);
		}
		
		public function reset():void{
			var s:XML = utils.describeType(compare);
			for (var i:int=0; i<s.variable.length(); i++) {
				var a:String=s.variable[i].attribute("name");
				if(compare[a] is Array){
					this[a] = [];
					for(var j:* in compare[a]){
						this[a][j] = compare[a][j];
					}
				}else {
					this[a] = compare[a];
				}
			}
		}
		
		public function getChangeVO():Object{
			return getChange(compare, this);
		}
	}
}
