package com.model.vo.chessBoard {
	import com.model.vo.user.ChessboardUserVO;

	/**
	 * 棋盘上单次行动数据，包括移动消除和下落匹配消除；
	 * 以及行动带来的角色技能消除+精灵技能消除；
	 * @author hunterxie
	 */
	public class TurnActionVO {
		public var user:ChessboardUserVO;
		
		/**
		 * 记录每次行动数据
		 */
		public var actionArr:Array = [];
		
		/**
		 * 记录每次消除（匹配+技能）数据
		 */
		public var clearArr:Array = [];
		
		private var totalScores:Array = [0,0,0,0,0];
		
		public var userSkillEffects:Array = [];
		
		public var fairySkillEffects:Array = [];
		
		public function TurnActionVO(user:ChessboardUserVO) {
			this.user = user;
		}
		
		public function addClear(vo:ResourceVO):void{
			clearArr.push(vo);
			if(totalScores[vo.kind]==null){
				totalScores[vo.kind] = 0;
			}
			totalScores[vo.kind]+=vo.finalNum;
		}
		
		/**
		 * 获取某个类型得分
		 * @param kind
		 * @return 
		 */
		public function getKindScore(kind:int):int{
			return Math.floor(totalScores[kind]);
		}
		
		public function getAllScoreStr():String{
			var str:String = "";
			for(var i:* in totalScores){
				str += QiuPoint.getKindStrig(i)+"_"+getKindScore(i);
			}
			return str;
		}
		
		/**
		 * 获取当前回合获得的总分
		 * @return 
		 */
		public function getTotalScore():int{
			var score:int = 0;
			for(var i:* in totalScores){
				score += Math.floor(totalScores[i]);
			}
			return score;
		}
	}
}
