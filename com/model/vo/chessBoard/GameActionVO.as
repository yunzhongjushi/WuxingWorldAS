package com.model.vo.chessBoard{

	/**
	 * 一个回合内记录的数据
	 * @author hunterxie
	 */
	public class GameActionVO {
		/**
		 * 交换两个球
		 */
		public static const EXCHANGE_BALL:String = "exc";
		/**
		 * 使用技能
		 */
		public static const SKILL_USE:String = "skill";
		/**
		 * 下落后进行全盘判断
		 */
		public static const FALL_JUDGE:String = "fall";
		/**
		 * 一个回合结束
		 */
		public static const TURN_OVER	:String = "turnover";
		/**
		 * 游戏结束
		 */
		public static const GAME_OVER	:String = "gameover";
		/**
		 * 重置棋盘
		 */
		public static const RESET_BOARD:String = "reset";
		
		/**
		 * 游戏中玩家行动行动类型
		 */
		public var kind:String;
		
		
		/**
		 * 游戏中用户的一次操作/事件
		 */
		public function GameActionVO(kind:String) {
			
		}
	}
}
