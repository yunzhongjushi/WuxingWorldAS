package com.model.vo.level {
	import com.model.ApplicationFacade;
	import com.model.logic.BaseGameLogic;
	import com.model.vo.BaseObjectVO;

	/**
	 * 游戏结束信息
	 * @author hunterxie
	 */
	public class LevelOverVO extends BaseObjectVO{
		public static const INFO_UPDATED:String="INFO_UPDATED";
		
		public static const SINGLETON_MSG:String="single_FightOverVO_only";
		protected static var instance:LevelOverVO;
		public static function getInstance():LevelOverVO{
			if ( instance == null ) instance = new LevelOverVO();
			return instance;
		}
		
		public function get levelID():int{
			return gameVO.levelVO.id;
		}
		public var gameVO:BaseGameLogic;
		
		public var oldLV:int;
		public var newLV:int;
		
		/**
		 * 回合数
		 */
		public var turnNum:int = 0;
		/**
		 * 最高连击数
		 */
		public var maxSequence:int = 1;
		public var score:int = 0;
		
		public var reward:LevelRewardVO = new LevelRewardVO;
		
		/**
		 *  是否通过 
		 */
		public var isWin:Boolean = false;
		public var userID:String;
		public var roleEXP:int; 
		public var fairyEXP:int;
		
		/**
		 * 上一局输了的记录，用于触发失败后再次闯关事件
		 */
		public static var nowFailueID:int;
		/**
		 * 本关用时
		 */
		public var timeUse:int;
		
		
		public function LevelOverVO(){ 
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
		}
		
		public function updateInfo(vo:BaseGameLogic, exp:int, turnNum:int, maxSequence:int):void {
			this.gameVO = vo;
			this.turnNum = turnNum;
			this.maxSequence = maxSequence;
			
			if(vo.isPassed && BaseInfo.isTestLogin && !vo.levelVO.configVO.isGuide){
				reward.testGetReward(vo.levelVO.configVO.rewards.getTestRewards(), 0, 0);
			}
		}
		
		public function updateByServer(info:Object):LevelOverVO{
			this.isWin = info.winner=="1";
			nowFailueID = this.isWin ? 0 : gameVO.levelVO.id;
			this.reward.updateInfoByServer(info);
			this.userID = info.userId;
			this.roleEXP = info.roleExp;
			this.fairyEXP = info.fairyExp;
			 
			return this;
		}
		
		public function dispatchUpdate():void{
			this.event(INFO_UPDATED);//ApplicationFacade.ONE_LEVEL_RESULT;
		}
	}
}