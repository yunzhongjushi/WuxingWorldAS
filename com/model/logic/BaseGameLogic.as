package com.model.logic {
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.WuxingVO;
	import com.model.vo.chessBoard.BoardSkillActiveVO;
	import com.model.vo.chessBoard.QiuClearVO;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.chessBoard.ResourceVO;
	import com.model.vo.chessBoard.SingleClearVO;
	import com.model.vo.chessBoard.TurnActionVO;
	import com.model.vo.config.board.BoardBaseVO;
	import com.model.vo.config.skill.SkillEffectConfigVO;
	import com.model.vo.fairy.FairyListVO;
	import com.model.vo.item.ItemListVO;
	import com.model.vo.level.LevelOverVO;
	import com.model.vo.level.LevelVO;
	import com.model.vo.skill.BaseSkillVO;
	import com.model.vo.skill.BoardBuffVO;
	import com.model.vo.skill.BoardSkillEffectVO;
	import com.model.vo.skill.BoardSkillVO;
	import com.model.vo.skill.SkillListVO;
	import com.model.vo.skill.SkillTriggerVO;
	import com.model.vo.skill.fight.FairyBuffVO;
	import com.model.vo.skill.fight.FairySkillEffectVO;
	import com.model.vo.user.ChessboardUserVO;
	import com.model.vo.user.UserVO;
	import com.utils.Rander;
	
	import flas.events.EventDispatcher;
	import flas.utils.utils;

	/**
	 * 前端模拟数据结构，计算记录游戏中的数据变化，如：积分、各种资源获得
	 * 所有棋盘数据相关（包括技能）通过此结构分发
	 * @author hunterxie
	 */
	public class BaseGameLogic extends EventDispatcher {
		public static const SINGLETON_MSG:String="single_BaseGameLogic_only";
		protected static var instance:BaseGameLogic;
		public static function getInstance():BaseGameLogic{
			if ( instance == null ) instance = new BaseGameLogic();
			return instance;
		}
	

		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		public static const GAME_OVER:String="GAME_OVER";
		
		public static const UPDATE_GAME_INFO:String="UPDATE_GAME_INFO";
		/**
		 * 收集到资源时发出事件，如果有资源展示面板收听即做出相应的展示
		 */
		public static const UPDATE_COLLECT_INFO:String="UPDATE_COLLECT_INFO";
		
		/**
		 * 静空领域
		 */
		public static const BOARD_EFFECT_STOP_FALL:String = "BOARD_EFFECT_STOP_FALL";
		/**
		 * 禁止掉落，下次消除结束后掉下来的棋子中不会有某类棋子
		 */
		public static const BOARD_EFFECT_STOP_CREATE:String = "BOARD_EFFECT_STOP_CREATE";
		
		/**
		 * 元素得分系数，用于消除时计算
		 */
		public static const baseWuxingScore:int = 1;
		
		/**
		 * 对局游戏ID，跟后台匹配
		 */
		public function get gameID():String{
			return levelVO.gameID;
		}
		/**
		 * 对局类型(如上)
		 */
		public function get gameType():String{
			return levelVO.configVO.kind;
		}
		
		/**
		 * 关卡信息(对战依然会有此关卡的基础信息),默认一个通用关卡
		 */
		public function get levelVO():LevelVO{
			if(_levelVO){
				return _levelVO;
			}
			return bakeLevelVO;
		}
		public function set levelVO(value:LevelVO):void{
			_levelVO = value;
		}
		private var _levelVO:LevelVO;
		public var bakeLevelVO:LevelVO = LevelVO.getLevelVO(30000);
		
		public function updateBoardInfo(info:BoardBaseVO, isTest:Boolean=false):void{
			levelVO.boardConfig.reset();
			levelVO.boardConfig.updateObj(info.boardConfig);
			boardUserInfo.updateSkills(info.boardSkills, isTest);
		}
		
		/**
		 * 当前游戏积累的总经验
		 */
		public var totalExp:int;
		/**
		 * 是否通过当前关卡
		 */
		public var isPassed:Boolean;
		
		/**
		 * 一场战斗花费的时间,秒
		 */
		public var timeUse:int=0;
		
		/**
		 * 游戏逻辑实例
		 * @return 
		 */
		private function get ddpLogic():ChessBoardLogic{
			return ChessBoardLogic.getInstance();
		}
		


		/**
		 * 关卡统计信息
		 * @return 
		 */
		public function getDetails(win:Boolean):Object{
			showAllclearCountMap();
			
			var obj:Object = {};
			obj.mp = boardUserInfo.wuxingInfo.resourceArr;
			obj.maxMp = boardUserInfo.wuxingInfo.getMaxResourceArr();
			obj.playerSkill = totalSkillTime;
			obj.combo = maxSequence;
			obj.boardKind = {"金":Math.floor(clearCountMap["金"]),
				"木":Math.floor(clearCountMap["木"]),
				"土":Math.floor(clearCountMap["土"]),
				"水":Math.floor(clearCountMap["水"]),
				"火":Math.floor(clearCountMap["火"]),
				"经":Math.floor(clearCountMap["经"]),
				"钻":Math.floor(clearCountMap["钻"])};//消除棋子个数，数组[金，木，土]消除的球种类数组
			obj.boardSkill = {};//棋盘技能触发次数
			obj.isWin = win;
			obj.clearNum = {"3":Math.floor(clearCountMap["3消"]),"4":Math.floor(clearCountMap["4消"]),"5":Math.floor(clearCountMap["5消"]),"8":Math.floor(clearCountMap["8消"])};//多消次数
			obj.score = boardUserInfo.totalScore;
			
			return obj;
		}
		private var startTime:Number = 0;
		
		
		/**
		 * 回合数
		 */
		public function get turnNum():int	{
			return _turnNum;
		}
		public function set turnNum(value:int):void{
			_turnNum = value;
			turnNums = value;
		}
		private var _turnNum:int=0;
		
		public static var turnNums:int = 0;
		/**
		 * 总移动次数
		 */
		public var totalMoveTime:int = 0;
		/**
		 * 总技能使用次数
		 */
		public var totalSkillTime:int = 0;
		
		private var _sequenceClearNum:int=0;
		/**
		 * 连续消除数目
		 */
		public function get sequenceClearNum():int {
			return _sequenceClearNum;
		}
		public function set sequenceClearNum(value:int):void {
			_sequenceClearNum=value;
			maxSequence = Math.max(value, maxSequence);
		}
		public function addSequence():int{
			sequenceClearNum++;
			return sequenceClearNum;
		}
		
		
		/**
		 * 记录游戏中所有消除VO
		 */
		public var totalClearArr:Array = [];
		/**
		 * 消除数据统计
		 * 可以通过统计数据获取x消、五行X消、五行X连消的数量
		 */
		private var clearCountMap:Object = {};
		/**
		 * 获取当场游戏的多消数量
		 * @param num	多少消
		 * @param wuxing 空代表任意五行
		 * @return 		wuxing棋子的num消的个数
		 */
		public function getGameMultipleClear(num:int, wuxing:int=100):int{
			if(wuxing==QiuPoint.KIND_100){
				return clearCountMap[num+"消"];
			}
			return clearCountMap[WuxingVO.getWuxing(wuxing)+num+"消"];
		}
		/**
		 * 获取当场游戏的连消数量
		 * @param num	多少连色
		 * @return 		num消的个数
		 */
		public function getGameContinuousClear(num:int):int{
			return clearCountMap[num+"连"];
		}
		/**
		 * 获取当场游戏的连色消数量
		 * @param num	多少消
		 * @param wuxing 空代表任意五行
		 * @return 		wuxing棋子的num连色消的个数
		 */
		public function getGameSameContinuousClear(num:int, wuxing:int):int{
			if(wuxing==QiuPoint.KIND_100){
				return clearCountMap[num+"连色"];
			}
			return clearCountMap[WuxingVO.getWuxing(wuxing)+num+"连色"];
		}
		/**
		 * 获得当场游戏的某个技能触发次数
		 * @param skillID
		 * @return 
		 */
		public function getSkillEffectedNum(skillID:int):int{
			return clearCountMap["skill"+skillID];
		}
		
		/**
		 * 最高连击数
		 */
		public var maxSequence:int=0;

		/**
		 * 游戏过程记录
		 */
		public var gameProcess:Array=[];
		
		/**
		 * 记录的初始棋盘信息（种子）
		 */
		public var originalQiu:Array=[];
		
		/**
		 * 当前通过棋盘消除得到的资源量;
		 * 临时记录，用于获得资源时技能的触发
		 */
		public static var nowClearResource:ResourceVO;
		

		public function get missionKind():int{
			if(!this.levelVO){
				return 0;
			}
			return this.levelVO.configVO.missionKind;
		}
		
		/**
		 * 每场战斗中单独的随机数获取器，用于计算技能中的概率;
		 */
		public static var randomGeter:Rander = new Rander();
		public static function updateSeed(initNum:int=945797944, seed:int=9999):void{
			if(initNum==0) initNum=945798182;
			if(seed==0) seed=9999;
			randomGeter.Initialize(initNum);
			randomGeter.SetSeed(seed);
			EventCenter.traceInfo("skill_seedInit:"+initNum+":"+seed);
		}
		
		
		/**
		 * 游戏结束信息
		 */
		public var fightOverVO:LevelOverVO = LevelOverVO.getInstance();
		
		/**
		 * 当前记录的VO，可能是bake可是跟fight继承的
		 */
		public function get boardUserInfo():ChessboardUserVO{
			return _boardUserInfo;
		}
		public function set boardUserInfo(value:ChessboardUserVO):void{
			if(_boardUserInfo){
				_boardUserInfo.off(ChessboardUserVO.BOARD_SKILL_USE_SUCCESS, this, onBoardSkillEffect);
			}
			if(value){
				_boardUserInfo = value;
			}else{
				_boardUserInfo = bakeUserInfo;
				_boardUserInfo.initBase(userInfo.userID, userInfo.LV, userInfo.wuxingInfo.getWuxingPropertyArr(), levelVO.chooseSkills);
			}
			_boardUserInfo.on(ChessboardUserVO.BOARD_SKILL_USE_SUCCESS, this, onBoardSkillEffect);
		}
		private var _boardUserInfo:ChessboardUserVO = new ChessboardUserVO;
		
		/**
		 * 单独一份基础VO，作为默认用户用于解谜、非战斗关卡；跟fight继承的分开为不同VO
		 */
		public static var bakeUserInfo:ChessboardUserVO = new ChessboardUserVO;
		/**
		 * 当前回合行动数据，用于触发普攻
		 */
		public static var nowTurnAction:TurnActionVO = new TurnActionVO(bakeUserInfo);
		
		/**
		 * 设置连色消
		 * @param kind
		 */
		public function setExchangeActive(kind:int):int{
			return boardUserInfo.setExchangeActive(kind);
		}
		/**
		 * 当前记录交换的消除kind
		 * @return 
		 */
		public function get exchangeActive():int{
			return boardUserInfo.exchangeActive;
		}
		
		/**
		 * 获取当前移动数(开局到现在的移动次数)
		 * @return 
		 */
		public function getExchangeNum():uint{
			return boardUserInfo.getExchangeNum();
		}
		public function getExchangeActiveNum(kind:int):int{
			return boardUserInfo.getExchangeActiveNum(kind);
		}
		
		
		
		
		
		/**
		 * =============================main===================================
		 * @param vo
		 * 
		 * 
		 * 
		 * 
		 * 
		 * 
		 * 
		 * 
		 * ====================================================================
		 */
		public function BaseGameLogic(vo:LevelVO=null) {
//			if (instance != null) throw Error(SINGLETON_MSG);
//			instance = this;
			
			if (vo) {
				initNew(vo);
			}
//			bakeUserInfo.on(ChessboardUserVO.BOARD_SKILL_USE_SUCCESS, onBoardSkillEffect);
		}
		
		/**
		 * 开启一场新的游戏
		 * @param vo
		 * @param user	新的user
		 * @return 
		 */
		public function initNew(vo:LevelVO=null, user:ChessboardUserVO=null):BaseGameLogic {
			this.levelVO = vo;
			this.boardUserInfo = user;
			this.isPassed = false;
			nowTurnAction = new TurnActionVO(user);
			
			updateSeed(levelVO.skillInitNum, levelVO.skillSeed);
			
//			Glog.start(levelVO);
			
//			userInfo.updateSkills(levelVO.chooseSkills);
			boardUserInfo.resourceCollect = {};
			boardUserInfo.totalScore = 0;
			boardUserInfo.exchangeActives = [];
			
			this.gameProcess = [];
			this.originalQiu = [];
			
			this.timeUse = 0;
			this.startTime = utils.getTimer();
			this.totalExp = 0;
			this.turnNum = 0;
			this.totalMoveTime = 0;
			this.totalSkillTime = 0;
			this._sequenceClearNum = 0;
			this.clearCountMap = {};
			this.totalClearArr = [];
			this.maxSequence = 0;
			
			nextTurn(user);
			
			return this;
		}
		
		/**
		 * 根据配置中的kind获取对应五行/棋子类型
		 * @param kind				配置类型
		 * @param tarQiuKind		跟随棋子类型
		 * @param tarFairyKind		跟随精灵五行
		 */
		public static function getKindString(kind:int, tarQiuKind:int=100, tarFairyKind:int=100):int{
			switch(kind){
				case QiuPoint.KIND_104:
					if(nowClearResource){//有棋盘消除行动(说明不是电脑)，如果是buff生成就随机一个地方？
						return nowClearResource.kind;
					}
				case QiuPoint.KIND_103:
					return tarQiuKind;
				case QiuPoint.KIND_102:
				case QiuPoint.KIND_101:
					return tarFairyKind;
				default:
					return kind;
					break;
			}
			return kind;
		}
		
		/**
		 * 此处处理棋子技能前提；
		 * @param triggerID		触发ID
		 * @param vo			触发的消除事件
		 */
		private function onChessBuffTrigger(triggerID:int):void{
			var arr:Array = ddpLogic.getFitPoints(QiuPoint.KIND_100, null, QiuPoint.HAS_BUFF);//所有1号位上的技能都进行前提判断
			for(var i:int=0; i<arr.length; i++){
				var point:QiuPoint = arr[i];
				if(point.buff1) point.buff1.onBoardTrigger(boardUserInfo, triggerID);//棋子技能触发，由施放该BUFF的user发出事件
				if(point.buff2) point.buff2.onBoardTrigger(boardUserInfo, triggerID);//棋子技能触发，由施放该BUFF的user发出事件
			}
		}
		
		/**
		 * 技能的生效，暂时把棋盘效果收集起来，包括：
		 * 1.当前行动角色技能效果；
		 * 2.双方所有精灵的棋盘效果；
		 * 3.棋子消除时的触发效果(包括棋盘和角色)；
		 * @param e		BoardSkillEffectVO
		 */
		public function onBoardSkillEffect(e:ObjectEvent):void{
			var effect:BoardSkillEffectVO = e.data as BoardSkillEffectVO; 
			effect.calculateUser();
			var kind:int = getKindString(effect.data.kind, effect.qiuKind, effect["originFairyKind"]);
			
			if(!nowClearResource && effect.data.id==SkillEffectConfigVO.board_effect_0){//不是消除触发，初始化时设定消除得分加成
//				if(WuxingVO.judgeIsWuxing(kind)){
					boardUserInfo.setKindScoreAdd(kind, effect.calculateValue);
					boardUserInfo.setKindScoreAddPer(kind, effect.calculatePer);
//				}
				var len:int = (kind==QiuPoint.KIND_100 ? QiuPoint.kindStringArr.length : (kind==QiuPoint.KIND_105 ? 5 : 0));
				for(var i:int=0; i<len; i++){
					boardUserInfo.setKindScoreAdd(i, effect.calculateValue);
					boardUserInfo.setKindScoreAddPer(i, effect.calculatePer);
				}
				return;
			}
			
			var createBuff:BoardBuffVO;//需要生成的棋子BUFF
			var action:BoardSkillActiveVO;
			var point:QiuPoint = effect.triggerPoint ? effect.triggerPoint : ddpLogic.getRandomPoint();
//			var effectPoint:QiuPoint;//生效的某个需要动画展示的棋子，随事件发送出去
			 
			if(effect.data.id==SkillEffectConfigVO.board_effect_1 || effect.data.id==SkillEffectConfigVO.board_effect_3 || effect.data.id==SkillEffectConfigVO.board_effect_4 || effect.data.id==SkillEffectConfigVO.board_effect_38){
				if(effect.data.value2>0){
					if(effect is FairySkillEffectVO && !BaseSkillVO.judgeBoardEffectKind((effect as FairySkillEffectVO).data.effectKind)){
						createBuff = new FairyBuffVO(effect as FairySkillEffectVO);
					}else{
						createBuff = new BoardBuffVO(effect.data.value2, effect.skill.LV, effect);
					}
				}
			}
			switch(effect.data.id){
				case SkillEffectConfigVO.board_effect_0:
					if(kind==QiuPoint.KIND_100 || effect.qiuKind==nowClearResource.kind || (WuxingVO.judgeIsWuxing(kind) && kind==QiuPoint.KIND_105)){
						nowClearResource.num_add += effect.calculateValue;
						nowClearResource.num_per *= effect.calculatePer; 
					}
					break;
				case SkillEffectConfigVO.board_effect_1:
					action = ddpLogic.skillUse_4(BoardSkillVO.CHESS_SKILL_KIND_1, point, effect.calculateValue, kind, QiuPoint.KIND_NULL, createBuff, createBuff!=null);
					break;
				case SkillEffectConfigVO.board_effect_2:
					action = ddpLogic.skillUse_4(BoardSkillVO.CHESS_SKILL_KIND_8, point, effect.calculateValue, kind, getKindString(effect.data.value2));
					break;
				case SkillEffectConfigVO.board_effect_3:
					action = ddpLogic.skillUse_4(BoardSkillVO.CHESS_SKILL_KIND_5, point, effect.calculateValue, kind, QiuPoint.KIND_NULL, createBuff);
					break;
				case SkillEffectConfigVO.board_effect_4:
					action = ddpLogic.createSkillBall(point.r, point.l, kind, createBuff);
					break;
				case SkillEffectConfigVO.board_effect_5:
					ddpLogic.stopFallKind = getKindString(effect.data.value2);
					break;
				case SkillEffectConfigVO.board_effect_6:
					event(BOARD_EFFECT_STOP_FALL);
					break;
				case SkillEffectConfigVO.board_effect_7:
					ddpLogic.setKindRat(kind, effect.calculateValue);
					break;
				case SkillEffectConfigVO.board_effect_10:
					action = ddpLogic.skillUse_5(point, effect.skill.clone() as BoardBuffVO);
					break;
				case SkillEffectConfigVO.board_effect_11:
					action = ddpLogic.skillUse_0(point, 1);
					break;
				case SkillEffectConfigVO.board_effect_12:
					action = ddpLogic.skillUse_0(point, 2);
					break;
				case SkillEffectConfigVO.board_effect_13:
					action = ddpLogic.skillUse_0(point, 3);
					break;
				case SkillEffectConfigVO.board_effect_14:
					action = ddpLogic.skillUse_0(point, 4);
					break;
				case SkillEffectConfigVO.board_effect_15:
					action = ddpLogic.skillUse_2(point, 1);
					break;
				case SkillEffectConfigVO.board_effect_16:
					action = ddpLogic.skillUse_2(point, 2);
					break;
				case SkillEffectConfigVO.board_effect_17:
					action = ddpLogic.skillUse_2(point, 3);
					break;
				case SkillEffectConfigVO.board_effect_18:
					action = ddpLogic.skillUse_3(point, 1);
					break;
				case SkillEffectConfigVO.board_effect_19:
					action = ddpLogic.skillUse_3(point, 2);
					break;
				case SkillEffectConfigVO.board_effect_20:
					action = ddpLogic.skillUse_3(point, 3);
					break;
				case SkillEffectConfigVO.board_effect_21:
					action = ddpLogic.skillUse_1(point, 0);
					break;
				case SkillEffectConfigVO.board_effect_22:
					action = ddpLogic.skillUse_1(point, 1);
					break;
				case SkillEffectConfigVO.board_effect_23:
					action = ddpLogic.skillUse_1(point, 2);
					break;
				case SkillEffectConfigVO.board_effect_24:
					action = ddpLogic.skillUse_1(point, 3);
					break;
				case SkillEffectConfigVO.board_effect_25:
					action = ddpLogic.skillUse_6("上", point, 1);
					break;
				case SkillEffectConfigVO.board_effect_26:
					action = ddpLogic.skillUse_6("上", point, 3);
					break;
				case SkillEffectConfigVO.board_effect_27:
					action = ddpLogic.skillUse_6("右", point, 1);
					break;
				case SkillEffectConfigVO.board_effect_28:
					action = ddpLogic.skillUse_6("右", point, 3);
					break;
				case SkillEffectConfigVO.board_effect_29:
					action = ddpLogic.skillUse_6("下", point, 1);
					break;
				case SkillEffectConfigVO.board_effect_30:
					action = ddpLogic.skillUse_6("下", point, 3);
					break;
				case SkillEffectConfigVO.board_effect_31:
					action = ddpLogic.skillUse_6("左", point, 1);
					break;
				case SkillEffectConfigVO.board_effect_32:
					action = ddpLogic.skillUse_6("左", point, 3);
					break;
				case SkillEffectConfigVO.board_effect_33:
					
					break;
				case SkillEffectConfigVO.board_effect_34:
					action = ddpLogic.skillUse_7(point, 0);
					break;
				case SkillEffectConfigVO.board_effect_35:
					action = ddpLogic.skillUse_7(point, 1);
					break;
				case SkillEffectConfigVO.board_effect_36:
					action = ddpLogic.skillUse_7(point, 2);
					break;
				case SkillEffectConfigVO.board_effect_38:
					createBuff.effectTime = nowClearResource.getMergeNum();
					action = ddpLogic.createSkillBall(point.r, point.l, kind, createBuff);
					break;
			}
			
			if(action){
				if(effect.skill.equipKind==BaseSkillVO.EQUIP_KIND_2){//如果是棋子上的技能触发的效果就放入效果中，延后展示
					effect.boardResultVO = action;
				}else{
					ddpLogic.setSkillEffect(action);//如果是精灵/角色技能触发的效果就放入数组，延后展示
				}
			}
		}
		
		/**
		 * 记录用户操作
		 */
		public function onTurnOver(user:ChessboardUserVO=null):void{
//			if(this.turnNum==17){
//				trace("numnum");
//			}
			EventCenter.traceInfo(this.turnNum+"_________回合结束，消除得分们："+nowTurnAction.getAllScoreStr());
//			EventCenter.traceInfo(this.turnNum+"_________回合结束，消除得分们：", "金_"+nowTurnAction.getKindScore(0)+" 木_"+nowTurnAction.getKindScore(1)+" 土_"+nowTurnAction.getKindScore(2)+" 水_"+nowTurnAction.getKindScore(3)+" 火_"+nowTurnAction.getKindScore(4));
			sequenceClearNum = 0;
			onChessBuffTrigger(SkillTriggerVO.TRIGGER_KIND_4);
			
			nextTurn(user);
		}
		
		/**
		 * 回合开始后初始化下个回合信息
		 */
		public function nextTurn(user:ChessboardUserVO=null):void{
//			Glog.turnOver();
			
			turnNum++;
			nowTurnAction = new TurnActionVO(user);
			if(user){
				this.boardUserInfo = user;
			}
			
			if(turnNum==1){
				boardUserInfo.boardSkillTrigger(SkillTriggerVO.TRIGGER_KIND_2);
			}else{
				onChessBuffTrigger(SkillTriggerVO.TRIGGER_KIND_3);
				boardUserInfo.boardSkillTrigger(SkillTriggerVO.TRIGGER_KIND_3);
			}
		}
			


		/**
		 * 球消除时按照基础规则（角色等级、技能）收集当前元素/积分；
		 * 用于解谜关卡
		 * @param clearVO		消除球信息
		 * @return 
		 */
		public function updateCollect(clearVO:SingleClearVO):void {
//			trace(clearVO.clearNum, clearVO.kind, "_________");
			var baseScore:Number = BaseInfo.SINGLE_CLEAR_SCORE*Math.pow(BaseInfo.CLEAR_MULTIPE_SCORE, (clearVO.clearNum-1));
			if(WuxingVO.judgeIsWuxing(clearVO.kind)){//如果属于五行范围
//				baseScore = BaseInfo.getWuxingLvInfo(boardUserInfo.wuxingInfo.getWuxingProperty(clearVO.kind), "clear_3");//基础3消得分
				baseScore *= Math.pow(1.02, boardUserInfo.wuxingInfo.getWuxingProperty(clearVO.kind));//根据玩家五行等级计算
			}
			
//			Math.ceil(单消得分*(Math.pow(2,消除数)*Math.pow(1.02, 五行等级-1)*(1+(连击数-1)*0.3));
//			trace(Math.pow(2, (clearVO.clearNum-1)),Math.pow(1.02, boardUserInfo.wuxingInfo.getWuxingProperty(clearVO.kind)),(1+(sequenceClearNum-1)*0.3))
			var score:int = Math.ceil((baseScore*(1+(sequenceClearNum-1)*0.3)+boardUserInfo.getKindScoreAdd(clearVO.kind))*boardUserInfo.getKindScoreAddPer(clearVO.kind));
			
			var sameNum:int = clearVO.clearKind==QiuClearVO.QIU_CLEAR_EXCHANGE?boardUserInfo.getExchangeActiveNum(clearVO.kind):0;
			EventCenter.traceInfo("消除得分："+clearVO.kind+"_"+score+"__"+sequenceClearNum+"连击__"+sameNum+"连色");
			nowClearResource = clearVO.clearResource = new ResourceVO(clearVO, score, sequenceClearNum, sameNum);
//			Glog.matchScore(clearVO.kind, score);
			totalClearArr.push(nowClearResource);
			nowTurnAction.addClear(nowClearResource);
			
			onChessBuffTrigger(SkillTriggerVO.TRIGGER_KIND_14);
			boardUserInfo.addClearResource(nowClearResource);
			onChessBuffTrigger(SkillTriggerVO.TRIGGER_KIND_15);

			event(UPDATE_COLLECT_INFO);
			nowClearResource = null;
		}
		
		public function updateSkillClear(obj:Object):void{
			
			for(var str:String in obj){
				
			}
		}
		
		/**
		 * 过关得分
		 */
		public var passScore:int;
		/**
		 * 过关得分计算
		 * @return 
		 */
		public function scoreCalculate():int{
			passScore = 10*(10-turnNum)+maxSequence*100+boardUserInfo.totalScore;//panel.boardPanel.baseGameVO.maxSequence*10 + panel.boardPanel.baseGameVO.totalScore;
			if(passScore<=0){
				passScore = 100;
			}
			return passScore;
		}
		
		
		/**
		 * 计算游戏结束信息
		 * @return 
		 */
		public function fightOver():LevelOverVO{
			if(!levelVO){
				throw Error("游戏结束时遇到错误：找不到关卡信息，所以没有对应的fightOverVO");
				return null;
			}
			showAllclearCountMap();
			if(!isPassed || !userInfo.testReleaseEnergy(levelVO.configVO.energyCost, false)){//没有过关或者过关扣除精力点失败
				totalExp = 0;// + Math.floor(boardUserInfo.resourceCollect["经"]*0.1);//没有过关精力值为关卡获得的1/10
//				return;
			}
			totalExp = levelVO.configVO.energyCost;// + Math.floor(boardUserInfo.resourceCollect["经"]);
			fightOverVO.updateInfo(this, totalExp, turnNum, maxSequence);
			fightOverVO.timeUse = Math.floor((utils.getTimer()-startTime)/1000);
			fightOverVO.oldLV = userInfo.LV;
			if(BaseInfo.isTestLogin){
				UserVO.testAddExp(totalExp);
				UserVO.testAddGold(getGold());
				if(levelVO.hasFairys){
					for(var i:int=0; i<levelVO.chooseFairys.length; i++){
						FairyListVO.testAddExp(levelVO.chooseFairys[i], totalExp);
					}
				}
			}
			fightOverVO.newLV = userInfo.LV; 
			fightOverVO.score =  scoreCalculate(); 
			levelVO.updateReport(this); 
			
			FairyListVO.testAddReward(fightOverVO.reward);
			ItemListVO.testAddReward(fightOverVO.reward);
			SkillListVO.testAddReward(fightOverVO.reward.skills);
			UserVO.saveToSO();
			this.event(GAME_OVER);
			return fightOverVO;
		}
		
		/**
		 * 接收到后台游戏结束信息
		 * @param info
		 * @return 
		 */
		public function fightOverByServerInfo(info:Object):LevelOverVO{
			fightOverVO.updateInfo(this, Math.floor(info.roleExp), turnNum, maxSequence);
			fightOverVO.reward.updateInfoByServer(info);
//			fightOverVO.reward.resource = info.res;//myInfo.wuxingInfo.resourceArr;
			fightOverVO.oldLV = userInfo.LV;
			userInfo.EXP_cu += fightOverVO.reward.exp;
			fightOverVO.newLV = userInfo.LV;
			fightOverVO.score = levelVO.myScore =  scoreCalculate();
			fightOverVO.dispatchUpdate();
			return fightOverVO;
		}
		
		public function getGold():int{
			var num:int = 0;
			
			for(var i:int=0; i<totalClearArr.length; i++){
				var vo:ResourceVO = totalClearArr[i] as ResourceVO;
				if(vo.kind==QiuPoint.KIND_ZUAN){
					num += vo.clearNum;
				}
			}
			EventCenter.traceInfo("闯关获得钻石："+num);
			return num;
		}
		
		public function getExp():int{
			var num:int = 0;
			
			for(var i:int=0; i<totalClearArr.length; i++){
				var vo:ResourceVO = totalClearArr[i] as ResourceVO;
				if(vo.kind==QiuPoint.KIND_JING){
					num += vo.clearNum;
				}
			}
			EventCenter.traceInfo("闯关获得经验："+num);
			return num;
		}
		
		/**
		 * 展示本次游戏统计消除数据
		 */
		private function showAllclearCountMap():void{
			var t:Number = utils.getTimer();
			trace("展示本次游戏统计消除数据：")
			var obj:Object = {};
			for(var i:int=0; i<totalClearArr.length; i++){
				var vo:ResourceVO = totalClearArr[i];
				
				if(clearCountMap[vo.kind]==null){
					clearCountMap[vo.kind] = 0;
				}
				clearCountMap[vo.kind]+=vo.clearNum;//球消除个数
				
				if(clearCountMap[vo.clearNum+"消"]==null){
					clearCountMap[vo.clearNum+"消"] = 0;
				}
				if(clearCountMap[vo.kind+vo.clearNum+"消"]==null){
					clearCountMap[vo.kind+vo.clearNum+"消"] = 0;
				}
				clearCountMap[vo.kind+vo.clearNum+"消"]+=1;//对应五行的多消数
				clearCountMap[vo.clearNum+"消"]+=1;//总多消数
				
				for(var j:int=1; j<=vo.sequenceNum; j++){
					if(clearCountMap[j+"连"]==null){
						clearCountMap[j+"连"] = 0;
					}
					clearCountMap[j+"连"]+=1;//如3连数量（包括了大于3的数量）
				}
				
				for(j=2; j<=vo.exchangeSameNum; j++){
					if(clearCountMap[j+"连色"]==null){
						clearCountMap[j+"连色"] = 0;
					}
					clearCountMap[vo.kind+j+"连色"]+=1;//对应五行的连色消数
					clearCountMap[j+"连色"]+=1;//总连色消数
				}
			}
			
			for(var k:* in clearCountMap){
				trace(k+":"+clearCountMap[k]);
			}
			trace("__time"+(utils.getTimer()-t));
			trace("注：1连代表消除总数，如果造成了5连那么之前的1、2、3、4连数都会增加");
		}
	}
}
