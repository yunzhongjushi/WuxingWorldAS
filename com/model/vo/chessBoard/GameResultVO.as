package com.model.vo.chessBoard{
	import com.model.vo.fairy.FairyListVO;
	import com.model.vo.level.LevelVO;
	import com.model.vo.user.UserVO;
	
	import flas.events.EventDispatcher;
	
	/**
	 * 前端模拟数据结构，计算记录游戏中的数据变化，如：积分、各种资源获得
	 * @author hunterxie
	 */
	public class GameResultVO extends EventDispatcher{
		public static const UPDATE_GAME_INFO:String = "UPDATE_GAME_INFO";
		
		/**
		 * 解谜类型，消除所有可消元素即过关
		 */
		public static var GAME_KIND_PUZZLE:String = "GAME_KIND_PUZZLE";
		/**
		 * 收集资源，收集到目标资源即过关
		 */
		public static var GAME_KIND_RESOURCE:String = "GAME_KIND_RESOURCE";
		/**
		 * 跟电脑对战，打败对方即过关
		 */
		public static var GAME_KIND_FIGHT:String = "2";
		/**
		 * 跟其他玩家对战(可能多人)
		 */
		public static var GAME_KIND_PK:String = "1";
		
		/**
		 * 对局类型
		 */
		public var gameType:String;
		
		/**
		 * 关卡信息(对战依然会有此关卡的基础信息)
		 */
		public var levelVO:LevelVO;
		
		/**
		 * 游戏积分
		 */
		public var score:int;
		
		/**
		 * 回合数
		 */
		public var turnNum:int = 0;
		/**
		 * 最高连击数
		 */
		public var maxSequence:int = 1;
		
		/**
		 * 游戏过程记录
		 */
		public var gameProcess:Array = [];
		/**
		 * 记录的初始棋盘信息（种子）
		 */
		public var originalQiu:Array = [];
		
		public var resourceCollect:Object = {};
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		
		
		
		public function GameResultVO(vo:LevelVO){
			if(vo){
				this.levelVO = vo;
				this.gameType = vo.configVO.kind;
			}
		}
	}
}