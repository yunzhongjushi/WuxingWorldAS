package com.view.UI.chessboard {
//	import com.control.TimeCounter;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.logic.BaseGameLogic;
	import com.model.logic.ChessBoardLogic;
	import com.model.logic.LevelGameLogic;
	import com.model.vo.WuxingVO;
	import com.model.vo.animation.AnimationShowVO;
	import com.model.vo.animation.InfoShowVO;
	import com.model.vo.chessBoard.BoardSkillActiveVO;
	import com.model.vo.chessBoard.ExchangeJudgeVO;
	import com.model.vo.chessBoard.GameActionVO;
	import com.model.vo.chessBoard.GridPoint;
	import com.model.vo.chessBoard.QiuClearVO;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.chessBoard.SingleClearVO;
	import com.model.vo.config.board.BoardBaseVO;
	import com.model.vo.config.level.LevelConfigVO;
	import com.model.vo.conn.FightActionVO;
	import com.model.vo.skill.BaseSkillVO;
	import com.model.vo.skill.BoardBuffVO;
	import com.model.vo.skill.BoardSkillEffectVO;
	import com.model.vo.skill.BoardSkillVO;
	import com.utils.TimerFactory;
//	import com.view.UI.tip.ExchangeTip;
//	import com.view.UI.tip.TipLightPanel;
	
	import flas.display.Bitmap;
	import flas.events.MouseEvent;
	import flas.geom.Point;
	import flas.utils.MultTween;
	import flas.utils.Tween;
	
	import ui.chessboard.ChessBoardPanelUI;
	
	/**
	 * 特殊情况：不进行移动过程中控制操作会出现消除中移动额外棋子过来也可跟正在消除棋子匹配的情况（消除开始时就应该进行数组处理了）
	 * @author hunterxie
	 */
	public class ChessboardPanel extends ChessBoardPanelUI {
		public static const NAME:String="ChessboardPanel";
		private static const SINGLETON_MSG:String="single_ChessboardPanel_only";
		private static var instance:ChessboardPanel;
		public static function getInstance():ChessboardPanel{
			if ( instance == null ) instance=new ChessboardPanel();
			return instance;
		}
		
		public static const BOARD_GAME_OVER:String = "BOARD_GAME_OVER";
		public static const TURN_OVER:String = "TURN_OVER";
//		/**
//		 * 没有可消除棋子
//		 */
//		public static const CANNOT_CHANGE_TO_FIT:String = "cannotChangeToFit";
		public static const GAME_ACTION:String = "game_action";
		
		/**
		 * 延迟执行复盘展示，为了能让玩家看得更清楚
		 */
		public static const delayShowActionTime:Number = 0.5;
		
		/**
		 * 棋盘棋子容器
		 */
//		public var qiuContainer:Sprite;
		/**
		 * 棋盘格子buff容器
		 */
//		public var gridContainer:Sprite;
		public static var containerPositions:Object = {"x5":new Point(285,516), "x6":new Point(246,554), "x8":new Point(168,632)};
		/**
		 * 不能点击覆盖
		 */
//		public var mc_cover:Sprite;
		public function get canClick():Boolean{
			return mc_cover.visible;
		}
		public function set canClick(value:Boolean):void{
			mc_cover.visible = value;
		}
		/** 步数是否用完 */
		public function get isStepLimit():Boolean{
			return (baseGameVO.levelVO.boardConfig.stepLimit>0 && baseGameVO.levelVO.boardConfig.stepLimit<=baseGameVO.totalMoveTime)
		}
		/** 回合是否用完 */
		public function get isRoundLimit():Boolean{
			return (baseGameVO.levelVO.boardConfig.roundLimit>0 && baseGameVO.levelVO.boardConfig.roundLimit<=baseGameVO.turnNum)
		}
		/**
		 * 复盘展示覆盖
		 */
//		public var mc_actionCover:Sprite;
		
		/**
		 * 棋盘付费技能列表
		 */
//		public var mc_boardSkillPanel:BoardSkillPanel;
		/**
		 * 消除提示
		 */ 
//		public var exchangeTip:ExchangeTip;
		
		/**
		 * 静空领域技能
		 */
//		public var mc_stopFall:MovieClip;
		public function get isStopFall():Boolean{
			return mc_stopFall.visible;
		}
		public function set isStopFall(value:Boolean):void{
			mc_stopFall.visible = value;
			if(value){
				mc_stopFall.gotoAndPlay(2);
			}else{
				mc_stopFall.gotoAndStop(1);
			}
		}
		
		/**
		 * 战斗回放
		 */
//		public var tf_gameReview:TextField;
		 
		/**
		 * 倒计时/倒计步数
		 */
//		public var tf_countdown:TextField;
//		private var countDown:TimeCounter = new TimeCounter;
		
		/**
		 * 游戏积分
		 */
//		public var tf_score:TextField;
		
		
		/**
		 * 上次移动且消除的球
		 */
//		public var mc_active:ActiveElemental;
//		public var mc_boardBG:MovieClip;
		public var mc_board:Bitmap = new Bitmap;
//		public var mc_mask:MovieClip;
		
		//=============================数据、战斗、技能逻辑==============================
//		public var btn_help:CommonBtn;
//		public var tf_turnNum:TextField;

		private var firstFall:Boolean = true; 
		
		//=======================显示================================
		/**
		 * 显示的球数组
		 */
		public var qiuArr:Array=[];
		/**
		 * 显示的格子buff数组
		 */
		public var gridArr:Array=[];
		
		/** 获取qiupoint对应qiu的全局坐标，用于定位动画展示位置 */
		public static function getQiuGlobalPoint(qiuPoint:QiuPoint):Point{
			var qiu:Qiu = getInstance().qiuArr[qiuPoint.r][qiuPoint.l];
			if(qiu) return qiu.globalPoint;
			return new Point;
		}
		
		/**
		 * 获取两个棋子的中点坐标(全局)
		 * @param p1
		 * @param p2
		 */
		public static function getMiddlePoint(p1:Point, p2:Point):Point{
			var point1:Point = (getInstance().qiuArr[p1.x][p1.y] as Qiu).globalPoint;
			var point2:Point = (getInstance().qiuArr[p2.x][p2.y] as Qiu).globalPoint;
			return new Point((point1.x+point2.x)/2, (point1.y+point2.y)/2);
		}
		/**
		 * 选中的目标球
		 */
		private var _nowQiu:Qiu;
		private function set nowQiu(qiu:Qiu):void{
			_nowQiu=qiu;
			event(AnimationShowVO.SOUND_PLAY, AnimationShowVO.FIGHT_QIU_CHOOSE_SOUND);
		}
		private function get nowQiu():Qiu{
			return _nowQiu
		}
		
		//行动记录+行动展示=====================================================================================
		/**
		 * 玩家一个回合内的行动列表（一回合只能移动一次数组长度就是1，可不间断消除就是多个）
		 * @return 
		 */
		private var actionArr:Array=[];
		/**
		 * 整盘行动记录，二维数组
		 * @see actionArr
		 */
		private var totalActionArr:Array=[];
		public function getTotalAction():String{
			if(tempTotalActionStr) tempTotalActionStr;
			return String(totalActionArr);
		}
		/**
		 * 展示中的当前回合行动
		 */
		private var showActionArr:Array;
		/**
		 * 展示中的整盘行动（二维）
		 */
		private var showTotalActionArr:Array;
		private var totalActionStr:String;
		/**
		 * 下一个展示的类型（如果是交换就需要展示得更快）
		 */
		private var nextShowActionKind:String;
		/**
		 * 是否正在展示中（展示中不能操作棋盘)
		 */
		public function set isShowAction(value:Boolean):void{
			_isShowAction = value;
			mc_actionCover.visible = value;
			tf_gameReview.visible = value;
		}
		public function get isShowAction():Boolean{
			return _isShowAction;
		}
		private var _isShowAction:Boolean=false;
		
		
		/**
		 * 游戏逻辑实例
		 * @return 
		 */
		private function get ddpLogic():ChessBoardLogic{
			return ChessBoardLogic.getInstance();
		}
		
		//===================================================================================================
		/**
		 * 行动中（交换、消除、下落），设置这个值必须配对，设true就一定要设false
		 * 通过控制cover的visible来屏蔽用户操作，而当可不间断消除时就单独屏蔽消除、移动中的球的操作
		 * 等于false时，可不间断消除状态下等所有消除都结束后在统一生成和掉落
		 */
		public function get isMoving():int{
			return _isMoving;
		}
		public function set isMoving(value:int):void{
			_isMoving = value;
			if(!value){
				for (var i:int=0; i<ddpLogic.maxR; i++) {
					for (var j:int=0; j<ddpLogic.maxL; j++) {
						(qiuArr[i][j] as Qiu).moveKind = Qiu.MOVE_KIND_STATIC;
					}
				}
			}
			
			if(!ddpLogic.isDelayFall){ 
				canClick = Boolean(_isMoving) || this.isFightOver;
			}
			
		}
		private var _isMoving:int=0;
		
		/**
		 * 主动技能使用数组
		 */
		public var skillUseArr:Array=[];
		
		private var _isFightOver:Boolean = false;
		/**
		 * 是否结束游戏（设置结束就禁止玩家操作，等掉落等展示完毕后再进行相应的如结算面板的弹出处理）
		 * @return 
		 */
		public function get isFightOver():Boolean{
			return _isFightOver;
		}
		public function set isFightOver(value:Boolean):void{
			this._isFightOver = value;
			this.canClick = value;
			
			if(value && isMoving==Qiu.MOVE_KIND_STATIC && !isRecoardGameOver){
				isRecoardGameOver = true;
				recordUserAction(GameActionVO.GAME_OVER, "");
				if(tempTotalActionStr!=""){//如果模拟/复盘用户操作
					event(BOARD_GAME_OVER, tempTotalActionStr, true);
				}else{
					event(BOARD_GAME_OVER, totalActionArr, true);
				}
			}
		}
		/**
		 * 是否记录游戏中用户行动
		 */
		public var isRecoardGameOver:Boolean = false;
		/**
		 * 是否继续创造、下落、消除
		 */
		public function get isContinueGame():Boolean{
			return isFitGameOver;
			
			var judge:Boolean = (baseGameVO.gameType==LevelConfigVO.KIND_GAME_PUZZLE_FIT_ELEMENTS && baseGameVO.levelVO.tarArea.length>0);
			judge = !(isFightOver && judge);//游戏结束了而且为匹配关卡就返回false
			return judge;
		}
		private var isFitGameOver:Boolean = false;
		
		public function get baseGameVO():BaseGameLogic{
			return _baseGameVO;
		}
		public function set baseGameVO(vo:BaseGameLogic):void{
//			if(_baseGameVO){
//				bakeGameVO.off(BaseGameLogic.BOARD_EFFECT_CLEAR, this, skillClear);
//			}
			
			_baseGameVO = vo ? vo : bakeGameVO; 
//			bakeGameVO.on(BaseGameLogic.BOARD_EFFECT_CLEAR, this, skillClear);
		}
		private var _baseGameVO:BaseGameLogic;
		
		/**
		 * 另一份GameVO
		 */
		public var bakeGameVO:BaseGameLogic = new BaseGameLogic;
		
		private var fightActionVO:FightActionVO;
		
		
		/**
		 * =====================================================================
		 * 主函数
		 * =====================================================================
		 */
		public function ChessboardPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this; 
			
			qiuContainer.mouseEnabled = true;
			if(BaseInfo.isLayaProject) qiuContainer.width = qiuContainer.height = 640;
			this.removeChild(mc_mask);
//			qiuContainer.mask = mc_mask;
//			gridContainer.mask = mc_mask;
			
			mc_stopFall.visible = mc_stopFall.mouseEnabled = mc_stopFall.mouseChildren =false;
			
			tf_gameReview.visible = false;
			tf_countdown.visible = false;
			
//			this.mouseEnabled = false;
//			this.mouseChildren = true;
			this.on(MouseEvent.MOUSE_DOWN, this, mouseFunc);
			this.on(MouseEvent.MOUSE_UP, this, mouseFunc);
			if(BaseInfo.isLayaProject){
				this.on(Qiu.EXCHANGE_OVER, this, function(e:*){
//					trace("qiu EXCHANGE_OVER");
					if (nowQiu && nowQiu != e) {
						mouseChangeJudge(e);
					}
				});
			}else{
				this.on(MouseEvent.MOUSE_OVER, this, mouseFunc);
			}
			this.on(Qiu.MOVE_STATE_CHANGE, this, qiuMoveStateChange);
			
			btn_help.setNameTxt("帮助",true); 
			btn_help.on(MouseEvent.CLICK, this, onHelp);
			
			mc_board.x = 130;
			this.addChildAt(mc_board, 1);
			
			fightActionVO = FightActionVO.getInstance();
			fightActionVO.on(FightActionVO.SHOW_FIGHT_ACTION, this, addUserAction);
		}
		
		/**
		 * 倒计时
		 * @param e
		 */
//		private function onTimeCounter(e:Event):void{
//			switch(e.type){
//				case TimeCounter.TIME_COUNT_UPDATE:
//					tf_countdown.text = int(countDown.num/60)+":"+countDown.num%60
//					break;
//				case TimeCounter.TIME_COUNT_OVER:
//					isFightOver = true;
//					break;
//			}
//		}
		
		/**
		 * 连击结束判断
		 * @param e
		 */
		private function sequenceTimerOver(e:*=null):void{
			this.canClick = false;
			if(firstFall){
				firstFall = false; 
				return;
			}
			if(isMoving==Qiu.MOVE_KIND_GOING_STATIC){
				isMoving = Qiu.MOVE_KIND_STATIC; 
				recordUserAction(GameActionVO.TURN_OVER, "");
//				if(isResetBoard){
//					isResetBoard = false;
//					return;
//				}
				if(baseGameVO.levelVO.boardConfig.roundLimit>0){
					tf_countdown.text = "剩余回合:"+(baseGameVO.levelVO.boardConfig.roundLimit-baseGameVO.turnNum);
				}
				if(isStepLimit || isRoundLimit){
					isFightOver = true;
					return;
				}
				baseGameVO.onTurnOver();
				this.tf_turnNum.text = "回合:"+baseGameVO.turnNum;
				event(TURN_OVER, true);
				
				if(this.isFightOver){//等待静态以后的重复设置，以触发事件
					isFightOver = true;
				}
			}
		}
		
		/**
		 * 设置棋盘背景
		 * @param r_l 棋盘宽高
		 */
		public function setBoardBG(r_l:int=5):void{
			mc_board.setBitmapDataClass("Chessboard"+r_l, "imgs/chessboard/", ".png");
		}
		
		/**
		 * 开始一盘新游戏
		 * @param arr
		 */
		public function startNewGame(vo:BaseGameLogic=null, boardInfo:BoardBaseVO=null, isTest:Boolean=false):void{
			this.baseGameVO = vo;
			if(vo==null){
				this.bakeGameVO.initNew();
			}
		
			if(boardInfo!=null){
				baseGameVO.updateBoardInfo(boardInfo, isTest);
			}
			btn_help.visible = !baseGameVO.levelVO.configVO.isGuide;
			
			setBoardBG(baseGameVO.levelVO.boardConfig.maxR);
//			mc_board.bitmapData = utils.getDefinitionByName("Chessboard"+baseGameVO.levelVO.boardConfig.maxR);
//			mc_board.smoothing = true;
//			if(mc_board) mc_board.gotoAndStop("x"+baseGameVO.levelVO.boardConfig.maxR);
			var point:Point = containerPositions["x"+baseGameVO.levelVO.boardConfig.maxR];
			qiuContainer.x = gridContainer.x = point.x;
			qiuContainer.y = gridContainer.y = point.y;
//			mc_mask.height = BaseInfo.boardWidth*boardVO.maxR;
			mc_mask.y = point.y-mc_mask.height;
//			trace(BaseInfo.boardWidth,"????????????????",boardVO.maxR, point.y, mc_mask.height, mc_mask.y)
			
			ddpLogic.updateBoardParam(baseGameVO.levelVO.boardConfig);
			if(baseGameVO.levelVO && baseGameVO.levelVO.boardBallConfig){
				ddpLogic.updateSeed(baseGameVO.levelVO.initNum, baseGameVO.levelVO.seed);
				if(boardInfo){
					ddpLogic.updateContent(boardInfo);
				}else if(baseGameVO.levelVO.boardBallConfig.balls){
					ddpLogic.updateContent(baseGameVO.levelVO.boardBallConfig, baseGameVO.levelVO.isPassed);
				}
			}else if(boardInfo){
				ddpLogic.updateContent(boardInfo);
			}else{
				ddpLogic.initInfo();
			}
			
			if(mc_active) mc_active.updateClears(baseGameVO.exchangeActive, baseGameVO.getExchangeActiveNum(baseGameVO.exchangeActive));
			resetInfo();
			if(baseGameVO.levelVO.boardConfig.stepLimit>0){
				tf_countdown.visible = true;
				tf_countdown.text = "剩余步数:"+baseGameVO.levelVO.boardConfig.stepLimit;
			}else if(baseGameVO.levelVO.boardConfig.roundLimit>0){
				tf_countdown.visible = true;
				tf_countdown.text = "剩余回合:"+baseGameVO.levelVO.boardConfig.roundLimit;
			}else{//时间限制
//				tf_countdown.visible = true;
//				countDown.on(TimeCounter.TIME_COUNT_UPDATE, this, onTimeCounter);
//				countDown.on(TimeCounter.TIME_COUNT_OVER, this, onTimeCounter);
//				countDown.updateInfo(baseGameVO.levelVO.timeLimit);
			}
		}
		
		public function fightOver(e:*=null):void{
			this.isFightOver = true;
		}
		
		public function removeGame():void{
			isRecoardGameOver = true;
			resetInfo();
			close();
		}
		
		private function mouseFunc(event:*):void {
//			trace(event.type, event.currentTarget, event.target, nowQiu);
			if(event.type==MouseEvent.MOUSE_UP){
				nowQiu = null;
			}else if (event.target is Qiu) {
				var mc:Qiu=event.target as Qiu;
				switch (event.type) {
					case MouseEvent.MOUSE_DOWN:
						if(isTouchPointSkillOpen){//使用道具点击消除某颗球，规则之外的技能，需要记录玩家使用技能操作，不能在解谜关中使用
							var vo:BoardSkillActiveVO = ddpLogic.skillUse_ouchClear(mc.point);
							fitChange(vo); 
							clearStart(vo);
							isTouchPointSkillOpen = false;
							recordUserAction(GameActionVO.SKILL_USE, "0:2");
						}else if (nowQiu) {
							if (nowQiu != mc) {
								mouseChangeJudge(mc, true);
							} else {
								nowQiu = null;
							}
						} else {
							nowQiu = mc;
						}
						break;
					case MouseEvent.MOUSE_OVER:
						if (nowQiu && nowQiu != mc && (BaseInfo.isLayaProject || event.buttonDown)) {//
							mouseChangeJudge(mc);
						}
						break;
				}
			}
		}
		
		/**
		 * 测试使用技能
		 * @param skillID
		 */
		private function onTestSkillUse(vo:BoardSkillVO):void{
			for(var i:int=0; i<vo.effectArr.length; i++){
				var effect:BoardSkillEffectVO = vo.effectArr[i] as BoardSkillEffectVO;
				if(BaseSkillVO.judgeBoardEffectKind(effect.data.effectKind)){
					effect.triggerPoint = (nowQiu ? nowQiu.point : null);
					baseGameVO.onBoardSkillEffect(new ObjectEvent("", effect));
				}
			}
//			fitChange();
			if(!isMoving){
				skillUse();
			}
			
//			effect.triggerPoint = tarQiu ? tarQiu.point : null;
//			var skillVO:BoardSkillActiveVO = baseGameVO.onBoardSkillEffect(effect);//SkillLogic["skillUse_"+skillID](tarQiu ? tarQiu.point : null);
//			if(vo && skillVO.clearArr.length>0){
//				skillUseArr.push(skillVO);
//				fitChange(skillVO.clearArr);
//				if(!isMoving){
//					skillUse();
//				}
//			}
		}
		
		
		private function onSkillUse(skill:BoardSkillActiveVO):void{
			if(skill.interval>0){
				AnimationShowVO.showAnimation(AnimationShowVO.FIGHT_SKILL_LIGHTNING_SHOW, skill);
			}else if(skill.id==BoardSkillVO.CHESS_SKILL_KIND_2){
				AnimationShowVO.showAnimation(AnimationShowVO.FIGHT_SKILL_BOOM_SHOW, skill);
			}
		}
		
		
		/**
		 * 有球消除，处理消除数组
		 * @param e
		 */
		private function onBallClear(vo:QiuClearVO):void{
			var clearSoundNum:int = baseGameVO.sequenceClearNum>5 ? 5 : baseGameVO.sequenceClearNum;
			AnimationShowVO.showAnimation(AnimationShowVO.SOUND_PLAY, AnimationShowVO["FIGHT_QIU_CLEAR_SOUND"+clearSoundNum]);
			
			for (var i:int=0; i<vo.clearArr.length; i++) {
				var single:SingleClearVO = vo.clearArr[i] as SingleClearVO;
				var point:QiuPoint = single.tarPoint;//vo.clearArr[i][l];
				AnimationShowVO.showAnimation(
					AnimationShowVO.TEXT_INFO_SHOW, 
					new InfoShowVO(String(single.clearResource.finalNum),
						ChessboardPanel.getQiuGlobalPoint(point),  
						WuxingVO.getColor(point.showKind), 
						2)
				);
			}
			
			AnimationShowVO.showAnimation(AnimationShowVO.TEXT_INFO_SHOW,  new InfoShowVO(baseGameVO.sequenceClearNum+"连", new Point(80, 520), 0xFFFFFF, 2));
			
			if((baseGameVO is LevelGameLogic) && (baseGameVO as LevelGameLogic).isPuzzleGameOver()){
				baseGameVO.isPassed = true;
				isFightOver = true;
			}
		}
		
		/**
		 * 实现技能消除效果，也会触发棋子技能
		 * @return 
		 */
		private function skillUse(skill:BoardSkillActiveVO=null):Boolean{
			if(skill){
				isMoving = Qiu.MOVE_KIND_CLEAR;
				onSkillUse(skill);
				clearSkill(skill);
				return true;
			}
//			trace("skillArrUse:",skillUseArr.length, !skillUseArr.length);
			if(!skillUseArr.length) return false;
			while(skill=skillUseArr.pop()){
				isMoving = Qiu.MOVE_KIND_CLEAR;
				fitChange(skill);
				onSkillUse(skill);
//				ddpLogic.clearSkill(vo);
				clearSkill(skill);
			}
			return true;
		}
		
		private function clearSkill(skill:BoardSkillActiveVO):void{
			for(var i:int=0; i<skill.clearArr.length; i++){
				var vo:SingleClearVO = skill.clearArr[i] as SingleClearVO;
				var delay:Number = 0;
				for(var j:int=0; j<vo.clearArr.length; j++){
					var point:QiuPoint = vo.clearArr[j] as QiuPoint;
					var qiu:Qiu = qiuArr[point.r][point.l];
					switch(skill.id){
						case BoardSkillVO.CHESS_SKILL_KIND_0:
						case BoardSkillVO.CHESS_SKILL_KIND_1:
						case BoardSkillVO.CHESS_SKILL_KIND_2:
						case BoardSkillVO.CHESS_SKILL_KIND_3://技能消除
							qiuClear(point, delay);
							break;
						case BoardSkillVO.CHESS_SKILL_KIND_4://消除技能时，根据多消事件生成新棋子,并且在棋子上添加技能
							qiu.createClearSkill(point);
							break;
						case BoardSkillVO.CHESS_SKILL_KIND_5:
						case BoardSkillVO.CHESS_SKILL_KIND_6:
						case BoardSkillVO.CHESS_SKILL_KIND_7:
							qiu.updateInfo(point);
							break;
						case BoardSkillVO.CHESS_SKILL_KIND_8:
							qiu.updateInfo(point);
							break;
					}
					delay += skill.interval;
				}
			}
		}
		
		/**
		 * 判断能否交换，不能交换即改变目标球
		 * @param mc
		 */
		private function mouseChangeJudge(mc:Qiu, isDown:Boolean=false):void {
			if((Math.abs(mc.r - nowQiu.r) == 1 && mc.l == nowQiu.l) || //横排相邻且竖排相同
				(Math.abs(mc.l - nowQiu.l) == 1 && mc.r == nowQiu.r)) { //竖排相邻且横排相同
				exchange(mc);
			}else if(isDown){
				nowQiu = mc;
			}else{
				nowQiu = null;
			}
		}
		
		/**
		 * 有球的状态改变，如果所有球都符合静止状态才设置为静止
		 * @param event
		 */
		protected function qiuMoveStateChange(event:ObjectEvent):void{
//			trace((event.target as Qiu).r, (event.target as Qiu).l, (event.target as Qiu).kind, "球状态改变：", boardMaxKind);
			if(isRecoardGameOver) return;
			switch(boardMaxKind){
				case Qiu.MOVE_KIND_EXCHANGE_BACK_OVER:
					this.isMoving = Qiu.MOVE_KIND_STATIC;
					break;
				case Qiu.MOVE_KIND_FALL_OVER:
					if(!skillUse() && !isContinueGame){
						fallOverClearJudge();
					}
					break;
				case Qiu.MOVE_KIND_CLEAR_OVER:
	//				trace("clearOverUseSkill:");
					if(!skillUse() && !isContinueGame){
						if(isShowAction){
							showUserAction();
						}else if(isStopFall){
							if(!ddpLogic.isCanChangeFit){
								this.isStopFall = false;
								clearOverAddStart();
							}
						}else{
							clearOverAddStart();
						}
					}
					break;
				case Qiu.MOVE_KIND_EXCHANGE_OVER:
					if(isShowAction && (nextShowActionKind==GameActionVO.EXCHANGE_BALL || nextShowActionKind==GameActionVO.SKILL_USE)){
						showUserAction();
					}
					break;
			}
		}
		
		/**
		 * 获取当前所有棋子的最高级状态
		 */
		private function get boardMaxKind():int{
			var maxkind:int = 0;
			for (var i:int=0; i<ddpLogic.maxR; i++) {
//				var arr:Array=[];
				for (var j:int=0; j<ddpLogic.maxL; j++) {
					var qiu:Qiu = qiuArr[i][j];
					maxkind=Math.max(maxkind, qiu.moveKind);
//					arr.push(qiu.moveKind);
				}
//				trace(arr);
			}
//			trace("moveKind,maxkind:", maxkind);
			return maxkind;
		}
		
		/**
		 * 整盘下落，告一个段落，清除当前所有
		 * @param immediately	是否立刻执行到位
		 */
		private function fallMovePosition(immediately:Boolean=false):void {
			isMoving = Qiu.MOVE_KIND_FALL;
			
			for (var i:int=0; i<ddpLogic.maxR; i++) {
				for (var j:int=0; j<ddpLogic.maxL; j++) {
					var qiu:Qiu = qiuArr[i][j] as Qiu;
					qiu.updateInfo();//ddpLogic.getPoint(i, j));
					qiu.fall(immediately);
				}
			}
			
			//消除开始后,数据部分后清除可消数组
			ddpLogic.resetClearArr();
		}
		
		/**
		 * 设置可消除队列中的球不可点(匹配+技能);<br>
		 * 否则玩家点到移动了会看到展示出错（坏体验）;<br>
		 * 并且设置全局坐标，用于展示动画
		 * @param arr 数组内容
		 * @see com.model.vo.chessBoard.SingleClearVO
		 */
		private function fitChange(clearVO:QiuClearVO):void{
			for (var i:int=0; i<clearVO.clearArr.length; i++){
//				trace("此处baseGameVO放出单次消除事件！记录此时的消除数据/棋子数组");
				baseGameVO.updateCollect(clearVO.clearArr[i]);
//				trace("此处单次记录完毕一系列角色技能+精灵技能触发效果后回来了！");
			}
			tf_score.text = String(baseGameVO.boardUserInfo.totalScore);
			var point:QiuPoint;
			var k:int = 0;
			while(point=ddpLogic.getClearPoint(k)){//锁定所有将被消除的棋子
				var qiu:Qiu=qiuArr[point.r][point.l] as Qiu;
				qiu.fitChange();
				k++;
			}
		}
		
		/**
		 * 执行交换
		 * @param mc 被交换的球
		 */
		private function exchange(tarQiu:Qiu):void {
			if(isStepLimit) return;
			if(!tarQiu.point.canMove || !nowQiu.point.canMove){
				if(isShowAction){
					EventCenter.traceInfo("棋盘记录还原失败__交换空棋子!!!!!!!");
				}
				return;
			}
			if(fitMovePosition(nowQiu, tarQiu)){//棋子布局符合范围即结束游戏
				this.canClick = true;
				return;
			}
			var canClearVO:ExchangeJudgeVO = ddpLogic.exchangeJudge(nowQiu.point,tarQiu.point);
//			var canChangeJudge:Boolean = canClearNum!=0;
//			trace("能否消除：", canChangeJudge);
			qiuContainer.addChild(nowQiu);//把交换点击的那个球提到最上层
			if (canClearVO.hasClear) {
				exchangeArrQiu(nowQiu, tarQiu);
				baseGameVO.totalMoveTime++;
				
				var clearVO:QiuClearVO = ddpLogic.getExchangeClear();
				EventCenter.traceInfo("连续消除：", baseGameVO.addSequence());
				baseGameVO.setExchangeActive(canClearVO.getCanClear(nowQiu.point) ? nowQiu.kind : tarQiu.kind);
				fitChange(clearVO);
				
				if(mc_active) mc_active.updateClears(baseGameVO.exchangeActive, baseGameVO.getExchangeActiveNum(baseGameVO.exchangeActive));

				MultTween.add([tarQiu.exchange(nowQiu, canClearVO.hasClear, canClearVO.getCanClear(tarQiu.point)),
				 			   nowQiu.exchange(tarQiu, canClearVO.hasClear, canClearVO.getCanClear(nowQiu.point), true)],
							this,
							clearStart,
							[clearVO]);
				
				if(baseGameVO.levelVO.boardConfig.stepLimit>0){
					tf_countdown.text = "剩余步数:"+(baseGameVO.levelVO.boardConfig.stepLimit-baseGameVO.totalMoveTime);
				}
			} else {
				tarQiu.exchange(nowQiu, canClearVO.hasClear, canClearVO.getCanClear(tarQiu.point));
				nowQiu.exchange(tarQiu, canClearVO.hasClear, canClearVO.getCanClear(nowQiu.point), true);
				if(isShowAction){
					EventCenter.traceInfo("棋盘记录还原失败__交换错误棋子!!!!!!!");
				}
			}
			
			nowQiu = null;
			isMoving = Qiu.MOVE_KIND_EXCHANGE;
		}
		
		private function exchangeArrQiu(nowQiu:Qiu, tarQiu:Qiu):void{
			qiuArr[nowQiu.r][nowQiu.l] = nowQiu;//tarQiu;//
			qiuArr[tarQiu.r][tarQiu.l] = tarQiu;//qiu;//
//			var tempr:int = qiu.r;
//			var templ:int = qiu.l;
//			qiu.point.resetRL(tarQiu.r, tarQiu.l);
//			tarQiu.point.resetRL(tempr, templ);
			recordUserAction(GameActionVO.EXCHANGE_BALL, tarQiu.r+":"+tarQiu.l+":"+nowQiu.r+":"+nowQiu.l);
		}
		
//		/**
//		 * 当前消除的棋子数组
//		 */
//		private var clearVO:QiuClearVO;
		/**
		 * 执行消除展示，其中消除到有技能的球激活技能同时消除技能队列;
		 * 下落过程中将锁定下落后会消除的棋子(包括一连串技能消除的球);
		 * 每次行动对应一次clearStart
		 * @param
		 */
		private function clearStart(clearVO:QiuClearVO):void{
//			if(isMoving) EventCenter.traceInfo("连续消除：", baseGameVO.sequenceClearNum++);
			isMoving = Qiu.MOVE_KIND_CLEAR; 
			
			for(var i:int=0; i<clearVO.clearArr.length; i++){
				var singlevo:SingleClearVO = clearVO.clearArr[i] as SingleClearVO;
				for(var j:int=0; j<singlevo.clearNum; j++){
					qiuClear(singlevo.clearArr[j] as QiuPoint);
				}
//				onBallClear(singlevo.clearResource);
			}
//			if(exchangeTip && exchangeTip.parent) exchangeTip.parent.removeChild(exchangeTip);
			onBallClear(clearVO);
						
			var skill:BoardSkillActiveVO;
			while(skill=ddpLogic.getSkillEffect()){
				if(skill && skill.clearArr.length>0){//技能触发时就算没有消除队列（旁边的已经被其他技能消除掉了）也需要展示动画，这里clearArr处理后都会有内容（即便是空数组），仅作出错判断
					skillUse(skill);
				}
			}
			
			if(isShowAction && ddpLogic.isDelayFall){//复盘展示如果是连续移动就不需要等待“上一步消除结束”，清除开始就可以继续
				var action:Array = (showActionArr[0] as String).split(":");//下一步当前行动记录
				if(action[0]!="fall") Tween.to({}, ddpLogic.clearTime*BaseInfo.showActionBoardRunTimes/2, {onComplete:showUserAction}, this);
			}
		}
		
		/** 
		 * 单个球的消除，包含技能触发
		 * @param qiu
		 */
		private function qiuClear(point:QiuPoint, delay:Number=0):void {
			var qiu:Qiu = qiuArr[point.r][point.l];
//			point.showKind = qiu.point.kind;
//			if(point.r==0 && point.l==2){
//				trace("?????");
//			}
			for(var i:int=0; i<qiu.point.extraBuffs.length; i++){
				var buff:BoardBuffVO = qiu.point.extraBuffs.pop();
				for(var j:int=0; j<buff.effectArr.length; j++){
					effect = buff.effectArr[j];
					if(effect.boardResultVO)
						Tween.to({}, delay, {onComplete:skillUse, onCompleteParams:[effect.boardResultVO]}, this);
				}
			}
			while(point.showBuffEffect.length>0){
				var effect:BoardSkillEffectVO = point.showBuffEffect.pop(); 
				if(effect.boardResultVO){
					Tween.to({}, delay, {onComplete:skillUse, onCompleteParams:[effect.boardResultVO]}, this);
				}
			}
//			if(point.kind!=QiuPoint.KIND_NULL){//只有2号技能位上没有（限定消除的）技能，球才进行消除
//				qiu.point.buff2.removeEffectTime();
				qiu.setBuffs();
//				return;
//			}
			
//			&& qiu.moveKind<=Qiu.MOVE_KIND_EXCHANGE_OVER){//那么之前消除中状态的球不再执行消除（消除队列有重复）
			if(point.kind==QiuPoint.KIND_NULL){//如果棋子是空就执行消除展示
				qiu.clearMC(false, delay);
			}
//			}
//			if(qiu.buff1){
////				point.buff1 = new BuffVO(qiu.point.buff1.ID, qiu.point.buff1.LV);//MyClass.cloneOBJ(qiu.point.buff1) as BuffVO;
//				if(qiu.buff1.isSkillModeActive){//激活宝盒元素
////					Tween.to({}, delay, {onComplete:function():void{
//						event(AnimationShowVO.ELEMENT_ACTIVATING, point, true);
////					}});
//				}
//
//				event(AnimationShowVO.EFFECT_TRIGGER, qiu.buff1.ID, true);
//				for(var i:int=0; i<qiu.buff1.buffVO.effectArr.length; i++){
//					var effect:BoardSkillEffectVO = qiu.buff1.buffVO.effectArr[i]; 
//					if(effect.boardResultVO){
//						Tween.to({}, delay, {onComplete:skillUse, onCompleteParams:[effect.boardResultVO]});
//					}
//				}
//			}
		}
		
		/**
		 * 消除完毕以后开始生成新的球并向下移动
		 * @param e
		 */
		private function clearOverAddStart():void {
			//			trace("clearOverAddStart");
			//			if (ddpLogic.isDelayFall && isMoving) {
			//				return ;
			//			}
			
			var point:QiuPoint;
			var i:int=0;
			while(point=ddpLogic.getClearPoint(i)){
				var qiuList:Array = qiuArr[point.r];
				var qiu:Qiu = qiuList[point.l] as Qiu;
				if(point.kind==QiuPoint.KIND_NULL){
					qiu.y = qiuArr[point.r][ddpLogic.maxL-1].y - BaseInfo.boardWidth;
					qiuList.splice(point.l, 1);
					qiuList.push(qiu);
				}
				i++;
			}
			ddpLogic.addStart();
			if(i==0 && isShowAction){//这个地方应该是gameover了，如果不是就有问题
				showUserAction();
			}
			
			fallMovePosition();
			if(fitMovePosition()){
				this.canClick = true;
				return;
			}
			
			if(fallFitClear=ddpLogic.allClearJudge()){//落下后如果有可消除的棋子，在下落动画开始时就执行锁定
				var clearVO:QiuClearVO = ddpLogic.getExchangeClear();
				EventCenter.traceInfo("连续消除：", baseGameVO.addSequence());
				fitChange(clearVO);
				Tween.to({}, ddpLogic.fallTime*BaseInfo.showActionBoardRunTimes, {onComplete:clearStart, onCompleteParams:[clearVO]}, this);
			}
			//下落结束后再进行其他展示，保持节奏
			if(!firstFall) recordUserAction(GameActionVO.FALL_JUDGE);
		}
		
		/**
		 * 下落是否有可消，如果有可消即开始消除
		 */
		private var fallFitClear:Boolean = false;
		
		/**
		 * 新生成球向下移动结束后判断是否有可消除的球
		 * @param e
		 * @return 
		 */
		private function fallOverClearJudge():void {
			if(firstFall){
				firstFall = false;
				this.canClick = false;
				isMoving = Qiu.MOVE_KIND_STATIC;
				return;
			}
			
			if (fallFitClear) {
				fallFitClear = false;
			}else if(!ddpLogic.isCanChangeFit) { 
				if(ddpLogic.isCreateNew){
//					TipLightPanel.showTip("已经没有可消除棋子，重新排列");
					ddpLogic.setContentRandom();
					contactInfoRandom();
//					recordUserAction(GameActionVO.RESET_BOARD);
				}else{
					isMoving = Qiu.MOVE_KIND_STATIC;
					recordUserAction(GameActionVO.TURN_OVER, ""); 
//					EventCenter.traceInfo(CANNOT_CHANGE_TO_FIT);
//					event(CANNOT_CHANGE_TO_FIT, true);
					
//					if(!this.isFightOver){
						this.isFightOver = true;
//					}
				}
			}else{
				isMoving = Qiu.MOVE_KIND_GOING_STATIC;
				if(isShowAction){
					showUserAction();
				}else if(ddpLogic.sequenceTime==0){
					sequenceTimerOver();
				}else{
					TimerFactory.once(ddpLogic.sequenceTime*1000, this, sequenceTimerOver);
				}
			}
		}
		
		/**
		 * 球显示数组连接数据,从棋盘顶上掉落
		 */
		private function contactInfo():void {
			for (var i:int=0; i<ddpLogic.maxR; i++) {
				for (var j:int=ddpLogic.maxL-1; j>=0; j--) {
					var qiu:Qiu = qiuArr[i][j] as Qiu;
					qiu.updateInfo(ddpLogic.getPoint(i, j));
					qiu.y = qiu.tarY - BaseInfo.boardWidth * ddpLogic.maxR;
					qiu.x = qiu.tarX;
					qiuContainer.addChild(qiu);
					
					var grid:BoardGrid = gridArr[i][j] as BoardGrid;
					var gridPoint:GridPoint = ddpLogic.getGrid(i, j);
					if(gridPoint){
						if(!grid){//已经有了就不管，buff的状态改变会触发展示
							gridArr[i][j] = BoardGrid.getGrid(gridPoint);
							gridContainer.addChild(gridArr[i][j]);
						}
					}else if(grid){
						grid.clear();
					}
				}
			}
			fallMovePosition();
		}
		/**
		 * 展示打乱数组数据
		 * @param delay	延迟执行
		 */
		private function contactInfoRandom(delay:Number=0):void {
			var arr:Array = [];
			for (var i:int=0; i<ddpLogic.maxR; i++) {
				for (var j:int=0; j<ddpLogic.maxL; j++) {
					arr.push(qiuArr[i][j]);
				}
			}
			while(arr.length){
				var qiu:Qiu = arr.pop() as Qiu;
				qiuArr[qiu.r][qiu.l] = qiu;
				qiu.updateInfo();
			}
			Tween.to({}, delay, {onComplete:fallMovePosition}, this);
		}
		
		/**
		 * 展示帮助信息，如果没有鼠标事件就隐藏帮助信息
		 * @param e
		 */
		public function onHelp(e:*=null):void {
//			if(!exchangeTip){
//				exchangeTip = new ExchangeTip;
//				exchangeTip.mouseEnabled = exchangeTip.mouseChildren = false;
//			}
//			var arr:Array = ddpLogic.getCanChangePoints();
//			var qiu1:QiuPoint = arr[0];
//			var point1:Point = getQiuGlobalPoint(qiu1);
//			var qiu2:QiuPoint = arr[1];
//			var point2:Point = getQiuGlobalPoint(qiu2);
//			exchangeTip.x = (point1.x+point2.x)/2;
//			exchangeTip.y = (point1.y+point2.y)/2;
//			exchangeTip.rotation = point1.x==point2.x ? 90 : 0;
//			this.addChild(exchangeTip);
		}
		
		/**
		 * 解谜展示，初始化棋盘信息，获取解谜过程
		 * @param e
		 */
		public function SolvePuzzle(action:String):void {
			showTotalAction(action);
		}
		
		public function clearBoard():void{
//			trace(qiuPool.length+"++++++++++++++++++++++++++++++++++++");
			for(var i:int=0; i<qiuArr.length; i++){
				for(var j:int=0; j<qiuArr[i].length; j++){
					(qiuArr[i][j] as Qiu).remove();
					if(gridArr[i][j]) (gridArr[i][j] as BoardGrid).clear();
				}
			}
//			trace(Qiu.qiuPool.length+"++++++++++++++++++++++++++++++++++++"+ddpLogic.maxR+":"+ddpLogic.maxL);
			qiuArr = [];
			gridArr = [];
		}
		
		private function resetInfo():void{
			this.isFightOver = false;
			this.isFitGameOver = false;
			this.isRecoardGameOver = false;
			this.canClick = true;
			this.isShowAction = false;
			this.firstFall = true;
			
			actionArr = [];
			totalActionArr = [];
			showActionArr = [];
			showTotalActionArr = [];
			isShowAction = false;
			nextShowActionKind = "";
			tf_turnNum.text = "1";
			tempTotalActionStr = "";
			tf_score.text = "0";
			tf_countdown.visible = false;
//			countDown.clear();
//			countDown.off(TimeCounter.TIME_COUNT_UPDATE, this, onTimeCounter);
//			countDown.off(TimeCounter.TIME_COUNT_OVER, this, onTimeCounter);
			
			clearBoard();
			for (var i:int=0; i<ddpLogic.maxR; i++) {
				qiuArr[i] = [];
				gridArr[i] = [];
				for (var j:int=0; j<ddpLogic.maxL; j++) {
					var mc:Qiu=Qiu.getNewQiu(ddpLogic.getPoint(i, j));
					qiuArr[i].push(mc);
				}
			}
//			trace(Qiu.qiuPool.length+"++++++++++++++++++++++++++++++++++++"+ddpLogic.maxR+":"+ddpLogic.maxL);
			contactInfo();
		}
		
		
		/**
		 * 编辑器添加用户行动；
		 * 或者相同棋盘对战中展示对手的行动；
		 * @param arr
		 */
		public function addUserAction(e:ObjectEvent):void{
			EventCenter.traceInfo("addShow——"+fightActionVO.actions.toString());
			showTotalActionArr.push(fightActionVO.actions.concat());
			if(!isShowAction && fightActionVO.actions.length>0){
				showUserAction(showTotalActionArr.shift());
				return;
			}
		}
		/**
		 * 模拟用户操作（战斗演示）
		 */
		private function showUserAction(arr:Array=null):void{
			if(arr){
				showActionArr = arr;
			}else if(showActionArr.length<=0){
				return;
			}
			isShowAction = true;
//			if(showActionArr[0]=="exc:3:5:3:4"){
//				trace("??");
//			}
			var action:Array = (showActionArr.shift() as String).split(":");//取出当前行动记录
			switch(action[0]){
				case GameActionVO.EXCHANGE_BALL:
					nowQiu = qiuArr[action[1]][action[2]];
					exchange(qiuArr[action[3]][action[4]]);
					break;
				case GameActionVO.FALL_JUDGE:
					clearOverAddStart();
					break;
				case GameActionVO.SKILL_USE:
					
					break;
				case GameActionVO.RESET_BOARD:
					isResetBoard = true;
					ddpLogic.setContentRandom();
					contactInfoRandom(delayShowActionTime);
					break;
				case GameActionVO.TURN_OVER:
					sequenceTimerOver();//trace("模拟用户操作没有下落结束时间");
//					EventCenter.traceInfo("showTotalActionArr.length:"+showTotalActionArr.length);
					if(showTotalActionArr.length>0){
						Tween.to({}, delayShowActionTime, {onComplete:showUserAction, onCompleteParams:[showTotalActionArr.shift()]}, this);
					}else{
						//fightOver();
						isShowAction = false;
					}
					break;
				case GameActionVO.GAME_OVER:
					trace("复盘结束");
					event(BOARD_GAME_OVER, tempTotalActionStr, true);
					break;
			}
			if(showActionArr.length>0){
				nextShowActionKind = (showActionArr[0] as String).split(":")[0];
			}else{//数组取空，回合展示结束
				nextShowActionKind = "";
			}
		}
		
		/**
		 * 用于展示复盘的复盘信息
		 */
		public var tempTotalActionStr:String = "";
		/**
		 * 整盘复盘展示
		 * @param arr
		 * @return 
		 */
		public function showTotalAction(action:String):void{
			tempTotalActionStr = totalActionStr = action;
			showTotalActionArr = action.split("turnover,");
			for(var i:int=0; i<showTotalActionArr.length; i++){
				if(String(showTotalActionArr[i]).indexOf("turnover")==-1 && showTotalActionArr[i]!="gameover"){
					showTotalActionArr[i]+="turnover";
				}
				showTotalActionArr[i] = String(showTotalActionArr[i]).split(",");
			}
			
			if(!isShowAction){
				Tween.to({}, delayShowActionTime, {onComplete:showUserAction, onCompleteParams:[showTotalActionArr.shift()]}, this);
			}
		}
		
		public function recordUserAction(kind:String, info:String=""):void{
			if(isShowAction) return;
			switch(kind){
				case GameActionVO.EXCHANGE_BALL:
					actionArr.push(GameActionVO.EXCHANGE_BALL+":"+info);
					break;
				case GameActionVO.SKILL_USE:
					actionArr.push(GameActionVO.SKILL_USE+":"+info);
					break;
				case GameActionVO.FALL_JUDGE:
					actionArr.push(GameActionVO.FALL_JUDGE);
					break;
				case GameActionVO.RESET_BOARD:
					actionArr.push(GameActionVO.RESET_BOARD);
					break;
				case GameActionVO.TURN_OVER:
					if(actionArr.length>0){
						actionArr.push(GameActionVO.TURN_OVER);
						event(GAME_ACTION, actionArr.toString(), true);
	//					EventCenter.traceInfo("record——"+actionArr.toString());
						totalActionArr.push(actionArr);
						actionArr = [];
					}
					break;
				case GameActionVO.GAME_OVER:
					actionArr.push(GameActionVO.GAME_OVER);
					totalActionArr.push(actionArr);
					EventCenter.traceInfo(tempTotalActionStr?tempTotalActionStr:totalActionArr);
//					Glog.gameaction(String(tempTotalActionStr?tempTotalActionStr:totalActionArr));
					break;
			}
		}
		
		/**
		 * 首先判断是否满足区域匹配；如果满足就终止后续判断，并且禁止用户操作；
		 * 然后判断是否满足交换匹配；
		 * @param qiu
		 * @param tarQiu
		 * @return 
		 */
		private function fitMovePosition(nowQiu:Qiu=null, tarQiu:Qiu=null):Boolean{
			var judge:Boolean = true;
			if(baseGameVO.gameType==LevelConfigVO.KIND_GAME_PUZZLE_FIT_ELEMENTS && baseGameVO.levelVO.tarArea.length>0){
				for (var i:int=0; i<baseGameVO.levelVO.tarArea.length; i++) {
					var point:QiuPoint = (baseGameVO.levelVO.tarArea[i] as QiuPoint);
					var judgePoint:QiuPoint = ddpLogic.getPoint(point.r, point.l);
					if(nowQiu && tarQiu){
						if(nowQiu.r==point.r && nowQiu.l==point.l){
							judgePoint = ddpLogic.getPoint(tarQiu.r, tarQiu.l);
						}else if(tarQiu.r==point.r && tarQiu.l==point.l){
							judgePoint = ddpLogic.getPoint(nowQiu.r, nowQiu.l);
						}
					}
					if(judgePoint.showKind != point.showKind){
						judge = false;
						break;
					}
				}
			}else{
				judge = false;
			}
			
			if(judge){
				isFitGameOver = true;
				baseGameVO.isPassed = true;//TODO 延迟到棋子移动到位后增加匹配动画展示
				if(nowQiu && tarQiu){//满足条件如果是交换触发的就移动交换后的球
					exchangeArrQiu(nowQiu, tarQiu);
					nowQiu.exchange(tarQiu, true);
					tarQiu.exchange(nowQiu, true);//满足交换就移动
					Tween.to({}, ddpLogic.exchangeTime*BaseInfo.showActionBoardRunTimes, {onComplete:showFitMovie}, this);
				}else{
					Tween.to({}, ddpLogic.fallTime*BaseInfo.showActionBoardRunTimes, {onComplete:showFitMovie}, this);
				}
			}
			
			return judge;
		}
		
		/**
		 * 展示成功匹配区域达到解谜条件后的动画
		 */
		private function showFitMovie():void{
			for (var i:int=0; i<ddpLogic.maxR; i++) {
				for(var j:int=0; j<ddpLogic.maxL; j++){
					var qiu:Qiu = qiuArr[i][j];
					qiu.fitChange();
					var judge:Boolean = true;
					for (var k:int=0; k<baseGameVO.levelVO.tarArea.length; k++) {
						var point:QiuPoint = (baseGameVO.levelVO.tarArea[k] as QiuPoint);
						if(point.r==qiu.r && point.l==qiu.l){
							judge = false;
							break;
						}
					}
					if(judge){
						qiu.fitChange();
						qiu.clearMC();
					}
				}
			}
			
			Tween.to({}, BaseInfo.showFitMovieTime, {onComplete:fightOver}, this);
		}
		
		/**
		 * 静空领域
		 * 停止掉落，知道没有可消棋子才开始往下掉落
		 */
		public function stopFall():void{
			this.isStopFall = true;
		}
		
		/**
		 * 是否执行了重排棋盘，如果是重排那么到位结束后不增加回合数
		 */
		private var isResetBoard:Boolean = false;
		public function boardRandomSet():void{
			if(boardMaxKind==Qiu.MOVE_KIND_STATIC){
				isResetBoard = true;
				ddpLogic.setContentRandom();
				contactInfoRandom();
				recordUserAction(GameActionVO.RESET_BOARD);
			}
		}
		
		public var isTouchPointSkillOpen:Boolean = false;
		public function startTouchPointSkill():void{
			isTouchPointSkillOpen = true;
		}
	}
}