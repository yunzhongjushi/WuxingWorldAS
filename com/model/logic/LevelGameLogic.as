package com.model.logic{
	import com.model.vo.config.level.LevelConfigVO;
	import com.model.vo.level.LevelVO;
	
	/**
	 * 解谜关卡数据结构
	 * @author hunterxie
	 */
	public class LevelGameLogic extends BaseGameLogic{
		public static const SINGLETON_MSG:String="single_LevelGameLogic_only";
		protected static var instance:LevelGameLogic;
		public static function getInstance():LevelGameLogic{
			if ( instance == null ) instance = new LevelGameLogic();
			return instance;
		}
		
		public static const LEVEL_GAME_START:String = "LEVEL_GAME_START";
		/**
		 * 闯关需要得到的棋盘上的形状
		 * 如图数组内将为4个目标匹配球，完全匹配就达成任务
		 * [*,*,*,*,*,*,*,*]
		 * [*,*,*,*,*,*,*,*]
		 * [*,*,*,*,*,*,*,*]
		 * [*,*,*,*,1,*,*,*]
		 * [*,*,*,1,1,1,*,*]
		 * [*,*,*,*,1,*,*,*]
		 * [*,*,*,*,*,*,*,*]
		 * [*,*,*,*,*,*,*,*]
		 * @see com.model.vo.QiuPoint
		 */
		public var tarArea:Array = [];
		
		/**
		 * 闯关需要得到的资源
		 * @see com.model.vo.QiuPoint
		 */
		public var tarResource:Object;
		
		/**
		 * 闯关需要得到的得分
		 */
		public var tarScore:int;
		
		public function LevelGameLogic():void{
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
		}
		
		public static function newVO(lvInfo:LevelVO):LevelGameLogic{
			getInstance().initNew(lvInfo);
			
			instance.tarArea = lvInfo.tarArea;
			instance.tarResource = lvInfo.tarResource;
			instance.tarScore = lvInfo.tarScore;
			instance.event(LevelGameLogic.LEVEL_GAME_START);
			return instance;
		}
		
		
		public function isPuzzleGameOver():Boolean{
			var judge:Boolean = false;
			switch(this.gameType){
				case LevelConfigVO.KIND_GAME_COLLECT_RESOURCE:
					judge = true;
					for(var kind:String in this.levelVO.tarResource){
						if(this.levelVO.tarResource[kind]>Math.floor(boardUserInfo.resourceCollect[kind])){
							judge = false;
							break;
						}
					}
					break;
				case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_NUM:
//					judge = true;
//					for(var kind:String in this.levelVO.targetClearNum){
//						if(!ddpLogic.fitBoardBallNum(kind, this.levelVO.targetClearNum[kind])){
//							judge = false;
//							break;
//						}
//					}
					break;
			}
			return judge && !isPassed;
		}
	}
}