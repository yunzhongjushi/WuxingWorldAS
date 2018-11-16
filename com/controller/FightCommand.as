package com.controller{
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.logic.BaseGameLogic;
	import com.model.logic.FightGameLogic;
	import com.model.logic.LevelGameLogic;
	import com.model.vo.config.level.LevelConfigVO;
	import com.model.vo.conn.ServerVO_91;
	import com.model.vo.level.LevelCollectVO;
	import com.model.vo.level.LevelVO;
	import com.model.vo.user.UserVO;
	import com.view.UI.fight.FightPanel;
	import com.view.UI.chessboard.PuzzlePanel;
	import com.view.UI.level.ResourceCollectPanel;
	
	
	/**
	 * 战斗开始
	 * @author hunterxie
	 */
	public class FightCommand{
		public static const SINGLETON_MSG:String="single_FightCommand_only";
		protected static var instance:FightCommand;
		public static function getInstance():FightCommand{
			if ( instance == null ) instance = new FightCommand();
			return instance;
		}
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		public function FightCommand(){
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			EventCenter.on(ApplicationFacade.LEVEL_GAME_START, this, execute);
		};
		
		private function execute(e:ObjectEvent):void{
			var levelVO:LevelVO = e.data as LevelVO;
			if(BaseInfo.isTestLogin || levelVO.configVO.isGuide){//note.getType()=="serverInfo" || 
				if(levelVO.configVO.isGuide || userInfo.testReleaseEnergy(levelVO.configVO.energyCost, true)){
					fightStart(levelVO);
				}else{
					fightStartByLevel(levelVO);//测试精力不足时后台返回错误信息
				}
			}else { 
				fightStartByLevel(levelVO);
			}
		}
		
		
		private function fightStart(vo:LevelVO):void {
			if(vo.configVO.kind == LevelConfigVO.KIND_GAME_COLLECT_RESOURCE){
				LevelCollectVO.newVO(vo);
				EventCenter.event(ApplicationFacade.SHOW_PANEL, ResourceCollectPanel.NAME);
			}else if(vo.configVO.isPuzzle){
				LevelGameLogic.newVO(vo)
				EventCenter.event(ApplicationFacade.SHOW_PANEL, PuzzlePanel.NAME);
			}else if(vo.configVO.isFight){
				FightGameLogic.newVO(vo)
				EventCenter.event(ApplicationFacade.SHOW_PANEL, FightPanel.NAME);
			}else{
				trace("未发现关卡类型！！");
			}
		}
		
		private function fightStartByLevel(levelVO:LevelVO):void{
			var type:int=1;
			switch(levelVO.configVO.kind){
				case LevelConfigVO.KIND_GAME_FIGHT_PVE:
					type = ServerVO_91.FIGHT_TYPE_PVE;
					break;
				case LevelConfigVO.KIND_GAME_FIGHT_PVP_REAL_TIME:
				case LevelConfigVO.KIND_GAME_FIGHT_PVP_ROUND:
					type = ServerVO_91.FIGHT_TYPE_PVP;
					break;
				case LevelConfigVO.KIND_GAME_COLLECT_RESOURCE:
				case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_All:
				case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_KIND:
				case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_NUM:
				case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_POINT:
				case LevelConfigVO.KIND_GAME_PUZZLE_FIT_ELEMENTS:
					type = ServerVO_91.FIGHT_TYPE_PUZZLE;
					break;
			}
			ServerVO_91.fightStart({
				code:ServerVO_91.FIGHT_CREATE,
				gameType:type,
				boardInitNum:BaseInfo.isTestRandom ? 945797944 : 0,
				boardSeed:BaseInfo.isTestRandom ? 9999 : 0,
				skillInitNum:BaseInfo.isTestRandom ? 945798182 : 0,
				skillSeed:BaseInfo.isTestRandom ? 9999 : 0,
				skills:levelVO.chooseSkills,
				fairys:levelVO.chooseFairys,
				levelID:levelVO.id
			});
		}
	}
}