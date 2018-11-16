package com.view.UI.chessboard {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.logic.BaseGameLogic;
	import com.model.logic.ChessBoardLogic;
	import com.model.logic.LevelGameLogic;
	import com.model.vo.animation.AnimationShowVO;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.config.level.LevelConfigVO;
	import com.model.vo.conn.ServerVO_91;
	import com.model.vo.level.LevelOverVO;
	import com.model.vo.level.SolvePuzzleVO;
	import com.model.vo.tip.TipVO;
	import com.model.vo.user.UserVO;
	import com.view.BasePanel;
	
	import flas.display.Sprite;
	import flas.display.StageAlign;
	import flas.events.MouseEvent;
	
	import ui.chessboard.PuzzlePanelUI;
	
	/**
	 * 特殊情况：不进行移动过程中控制操作会出现消除中移动额外棋子过来也可跟正在消除棋子匹配的情况（消除开始时就应该进行数组处理了）
	 * @author hunterxie
	 */
	public class PuzzlePanel extends PuzzlePanelUI {
		public static const NAME:String = "PuzzlePanel";
		private static const SINGLETON_MSG:String="single_"+NAME+"_only";
		private static var instance:PuzzlePanel;
		public static function getInstance():PuzzlePanel{
			if ( instance == null ) instance=new PuzzlePanel();
			return instance as PuzzlePanel;
		}
		
		
		public var boardPanel:ChessboardPanel;
		//=============================数据、战斗、技能逻辑==============================
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		public var skillUseArr:Array=[];
		public var isFightOver:Boolean = false;
		public var puzzleVO:LevelGameLogic;
		/**
		 * 游戏逻辑实例
		 * @return 
		 */
		private function get ddpLogic():ChessBoardLogic{
			return ChessBoardLogic.getInstance();
		}
		
		//=======================显示================================
		/**
		 * 
		 */
		public var fitContainer:Sprite = new Sprite;
		
		
		/**
		 * 主函数
		 *
		 */
		public function PuzzlePanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			this.closeName = NAME;
			this.alignInfo = StageAlign.BOTTOM;
			if(mc_targetYuansu) mc_targetYuansu.visible=false;
			
			btn_escape.setNameTxt("逃跑", true);
			btn_escape.on(MouseEvent.CLICK, this, onEscape);
			btn_solving.setNameTxt("解谜", true);
			btn_solving.on(MouseEvent.CLICK, this, onSolve);
			
			boardPanel = ChessboardPanel.getInstance();
			boardPanel.on(ChessboardPanel.BOARD_GAME_OVER, this, onGameOver);
			boardPanel.on(ChessboardPanel.TURN_OVER, this, onTurnOver);
//			boardPanel.on(ChessboardPanel.CANNOT_CHANGE_TO_FIT, this, onCannotMove);
			boardPanel.on(AnimationShowVO.EFFECT_TRIGGER, this, skillTrigger);
			
			addChild(fitContainer);
			
			
			puzzleVO = LevelGameLogic.getInstance();
			puzzleVO.on(LevelGameLogic.LEVEL_GAME_START, this, startNewGame);
			puzzleVO.on(BaseGameLogic.UPDATE_COLLECT_INFO, this, onScoreUpdate);
			
			EventCenter.on(BasePanel.CLOSE_PANEL, this, onPanelClose);
			EventCenter.on(TipVO.TIP_PANEL_CONFIRM, this, onTipConfirm);
			
			EventCenter.on(ApplicationFacade.SHOW_FIGHT_RESULT, this, onShowResult);
		}
		private function onShowResult(e:ObjectEvent):void{
			if(!puzzleVO || puzzleVO.gameID!=e.data.gameId) return;//如果不在解谜关卡当中那么就不展示内容
			
			if(e.data.gameType == ServerVO_91.FIGHT_TYPE_PUZZLE){
				puzzleVO.fightOver();
				EventCenter.event(ApplicationFacade.SHOW_PANEL, "LevelReportPanel");
			}
		}
		
		/**
		 * 用户关闭战报/失败/重放面板时关闭面板
		 * @param e
		 */
		private function onPanelClose(e:ObjectEvent):void  {
			if(e.data=="LevelReportPanel" ||
				e.data=="LevelFailurePanel" ||
				e.data=="LevelReviewOverPanel"){
					close();
			}
		}
		
		private function onTipConfirm(e:ObjectEvent):void{
			if(e.data is SolvePuzzleVO){
				var solve:SolvePuzzleVO = e.data as SolvePuzzleVO;
				if(BaseInfo.isTestLogin){//测试
					boardPanel.SolvePuzzle(solve.solveInfo);
				}else{//向服务器请求付费解谜
					
				}
			}
		}
		
		protected function onBallClear(event:ObjectEvent):void{
			var judge:Boolean = false;
			switch(puzzleVO.gameType){
				case LevelConfigVO.KIND_GAME_COLLECT_RESOURCE:
					judge = true;
					for(var kind:String in puzzleVO.levelVO.tarResource){
						if(puzzleVO.levelVO.tarResource[kind]>Math.floor(boardPanel.baseGameVO.boardUserInfo.resourceCollect[kind])){
							judge = false;
							break;
						}
					}
					break;
				case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_NUM:
//					judge = true;
//					for(var kind:String in puzzleVO.levelVO.targetClearNum){
//						if(!ddpLogic.fitBoardBallNum(kind, puzzleVO.levelVO.targetClearNum[kind])){
//							judge = false;
//							break;
//						}
//					}
					break;
			}
			
			if(judge && !puzzleVO.isPassed){
				puzzleVO.isPassed = true;
				boardPanel.isFightOver = true;
			}
		}
		
		protected function onScoreUpdate(event:*):void{
			tf_score.text = String(puzzleVO.boardUserInfo.totalScore);
			tf_steps.text = String(puzzleVO.totalMoveTime);
			tf_turns.text = String(puzzleVO.turnNum);
		}
		
		protected function onTurnOver(event:*):void{
			if(!this.contains(boardPanel)) return;
			puzzleVO.scoreCalculate()
			switch(puzzleVO.gameType){
				case LevelConfigVO.KIND_GAME_PUZZLE_FIT_ELEMENTS:
					if(puzzleVO.isPassed){
//						fightOver(true);
					}
					break;
				case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_POINT:
					if(puzzleVO.isPassed){
						onGameOver();
					}
					break;
				case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_NUM:
					var judge:Boolean = true;
					for(var kind:* in puzzleVO.levelVO.targetClearNum){
						if(!ddpLogic.fitBoardBallNum(parseInt(kind), puzzleVO.levelVO.targetClearNum[kind])){
							judge = false;
							break;
						}
					}
					
					if(judge && !puzzleVO.isPassed){
						puzzleVO.isPassed = true;
						boardPanel.isFightOver = true;
					}
					break;
			}
		}
		
		/**
		 * 指定球消除时
		 * @param e
		 */
		private function skillTrigger(e:ObjectEvent):void{
			if(!this.contains(boardPanel)) return;
			if(puzzleVO.gameType==LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_POINT && ddpLogic.getTarBuffBalls(puzzleVO.levelVO.targetClearBuff).length==0){
				puzzleVO.isPassed = true;
				boardPanel.isFightOver = true; 
			}
		}
		
//		private function onCannotMove(e:*):void{
//			if(!this.contains(boardPanel)) return;
//			switch(puzzleInfo.gameType){
//				case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_All:
//					this.isPassed = ddpLogic.checkHasClearAll();
//					panel.boardPanel.isFightOver = true;
////					fightOver();
//					break;
//				case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_POINT:
//					panel.boardPanel.isFightOver = true;
//					break;
//				case LevelConfigVO.KIND_GAME_COLLECT_RESOURCE:
//					isPassed = false;
//					panel.boardPanel.isFightOver = true;
//					break;
//				case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_NUM:
//					var judge:Boolean = true;
//					for(var kind:String in puzzleInfo.levelVO.targetClearNum){
//						if(!ddpLogic.fitBoardBallNum(kind, puzzleInfo.levelVO.targetClearNum[kind])){
//							judge = false;
//							break;
//						}
//					}
//					if(judge && !isPassed){
//						isPassed = true;
//						panel.boardPanel.isFightOver = true;
//					}
//					break;
//			}
//		}
		
//		override public function show(info:*):void{
//			this.x = (BaseInfo.fullScreenWidth-960)/2;
//			this.y = (BaseInfo.fullScreenHeight-640);
//		}
		
		/**
		 * 游戏结束
		 * @param e
		 */
		private function onGameOver(e:*=null):void{
			if(!this.contains(boardPanel)) return;
			if(boardPanel.isShowAction){
				EventCenter.event(ApplicationFacade.SHOW_PANEL, "LevelReviewOverPanel");
				return;
			}
			
			switch(puzzleVO.gameType){
				case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_All:
					puzzleVO.isPassed = ddpLogic.checkHasClearAll();
					break;
				case LevelConfigVO.KIND_GAME_PUZZLE_SCORE:
					puzzleVO.isPassed = puzzleVO.tarScore<=puzzleVO.scoreCalculate();
					break;
			}
			var action:String = boardPanel.getTotalAction();
			var fightOverVO:LevelOverVO = puzzleVO.fightOver();
			
			if(!puzzleVO.isPassed){
				EventCenter.event(ApplicationFacade.SHOW_PANEL, "LevelFailurePanel");
				
//				if(puzzleVO.levelVO.configVO.isGuide){//技巧，如果是引导那么隐藏掉失败面板，关闭引导对话面板后由失败面板发出通知
//					GuideTipVO.show(GuideTipVO.FIRST_PUZZLE_SOLVE_FAIL, new Point(560,440), GuideTipVO.GUIDE_KIND_CHANGE_H, "解谜失败了哦~~~请交换这个位置再试一次吧！", GuidePanel.NAME);
//				}
				return;
			}else if(puzzleVO.levelVO.configVO.isGuide && fightOverVO.levelID==LevelConfigVO.LEVEL_ID_20000){
				EventCenter.event(ApplicationFacade.GUIDE_MISSION_COMPLETE, GuideMissionContainer.CutsceneIntoMap);
				close();
			}else if(BaseInfo.isTestLogin){
				EventCenter.event(ApplicationFacade.SHOW_PANEL, "LevelReportPanel");
			}else{// if(isPassed){
				ServerVO_91.getPuzzleResult({
					code:ServerVO_91.FIGHT_MOVE,//isPassed ? ServerVO_91.FIGHT_MOVE : ServerVO_91.FIGHT_FAIL,
					gameType:ServerVO_91.FIGHT_TYPE_PUZZLE,
					levelID:puzzleVO.levelVO.id,
					gameId:puzzleVO.gameID,
					actions:String(action),
					timeUse:puzzleVO.timeUse,
					details:puzzleVO.getDetails(puzzleVO.isPassed)
				});
//				LoadingVO.showLoadingInfo("fight_over_send", true, "正在请求战斗结果......");
			}
		}
		
		public function startNewGame(e:ObjectEvent):void{
			this.isFightOver = false;
			
//			mc_targetYuansu.visible=false;
//			if(puzzleVO.gameType == LevelConfigVO.KIND_GAME_COLLECT_RESOURCE){ 
//				mc_targetYuansu.visible=true;
//				mc_targetYuansu.init(puzzleVO);
//			}

			tf_score.text = "0";
			tf_steps.text = "0";
			tf_turns.text = "0";
			tf_target.text = "目标：\n"+puzzleVO.levelVO.configVO.describe; 
			
			addChildAt(boardPanel, 0);
//			boardPanel.startNewGame();
			
//			ChessBoardLogic.isInitCanClear = vo.levelVO.boardInfo.isInitCanClear;
//			ChessBoardLogic.initInfo(vo.levelVO.boardInfo.maxR, vo.levelVO.boardInfo.maxL, vo.levelVO.boardInfo.maxKinds, vo.levelVO.boardInfo.isCreateNew);
//			boardPanel.startNewGame(vo.levelVO.boardInfo.qiuArr, vo.levelVO.boardInfo.skillArr);
			
			this.btn_escape.visible = this.btn_solving.visible = !puzzleVO.levelVO.configVO.isGuide;
			boardPanel.startNewGame(puzzleVO);
			
			showFitPanel();
		}
		
		public function showTotalAction(actionStr:String):void{
			boardPanel.showTotalAction(actionStr);
		}
		
		protected function onEscape(event:*):void {
			boardPanel.removeGame();
			close();
		}
			
		
		protected function onSolve(event:*):void {
			TipVO.showChoosePanel(new TipVO("解谜付费", "解谜付费需要10钻石", new SolvePuzzleVO(puzzleVO.levelVO)));
		}
		
		/**
		 * 
		 * 
		 */
		public function showFitPanel():void{
			fitContainer.x = boardPanel.qiuContainer.x;
			fitContainer.y = boardPanel.qiuContainer.y;
			while(fitContainer.numChildren){
				fitContainer.removeChildAt(0);
			}
			if(puzzleVO.gameType == LevelConfigVO.KIND_GAME_PUZZLE_FIT_ELEMENTS){
				var qiu:Qiu = Qiu.getNewQiu(new QiuPoint());
				var pointArr:Array = puzzleVO.levelVO.tarArea;
				for(var i:int=0; i<pointArr.length; i++){
					qiu.updateInfo(pointArr[i]);
					qiu.fall(true);
					
//					var shape:Shape = new Shape;
//					shape.graphics.lineStyle(1,0);
//					shape.graphics.drawRect(qiu.x-BaseInfo.boardWidth/2, qiu.y-BaseInfo.boardWidth/2, qiu.width, qiu.height);
//					fitContainer.addChild(shape);//TODO:这里需要改进，不画出来了，直接用图片然后设置shape的位置
				}
//				fitContainer.filters = [new GlowFilter(WuxingVO.getColor(qiu.kind), 1, 10, 10, 1.5), AnimationPanel.wuxingClearingMatrix[qiu.kind]];
				qiu.remove();
			}
		}
		
		private function onSkillUseClick(e:ObjectEvent):void{
			var skillID:int = e.data as int;
			switch(skillID){
				case 0://静空领域
					boardPanel.stopFall();
					break;
				case 1://重排
					boardPanel.boardRandomSet();
					break;
				case 2://点消
					boardPanel.startTouchPointSkill();
					break;
				case 5://如果技能中不括棋盘动作（消除、添加等等）
					break;
				default:// if(boardPanel.tarQiu){包含目标球的技能需要在棋盘上处理
					//				boardPanel.onSkillUse();
			}
		}
	}
}