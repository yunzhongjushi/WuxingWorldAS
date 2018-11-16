package com.model.vo.level {
	import com.model.event.ObjectEvent;
	import com.model.logic.BaseGameLogic;
	import com.model.vo.WuxingVO;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.config.board.BoardBaseVO;
	import com.model.vo.config.board.BoardConfig;
	import com.model.vo.config.board.BoardConfigVO;
	import com.model.vo.config.fairy.FairyConfig;
	import com.model.vo.config.level.LevelConfig;
	import com.model.vo.config.level.LevelConfigVO;
	import com.model.vo.fairy.FairyVO;
	import com.model.vo.skill.SkillListVO;
	import com.utils.PoolFactory;
	
	import flas.events.EventDispatcher;
	
	/**
	 * 关卡信息
	 * @author hunterxie
	 */
	public class LevelVO extends EventDispatcher{
		public static const LEVEL_INFO_UPDATE:String = "LEVEL_INFO_UPDATE";

		public function get id():int{
			return baseInfo.ID;
		}
		
		/**
		 * 关卡配置(读取)信息
		 */
		public var configVO:LevelConfigVO;
		
		/**
		 * 关卡对应的高级关卡
		 */
		public function get highLevel():LevelVO{
			return LevelVO.getLevelVO(id+10000);
		}

		/**
		 * 对应的高级关卡是否开启
		 * @return 
		 */
		public function get isHighLevelOpen():Boolean{
			if(!highLevel){
				return false; 
			}
			return (this.highLevel.isOpen && this.maxStarNum>=3);
		}
		public function get isHighLevelPass():Boolean{
			if(!highLevel){
				return false;
			}
			return highLevel.maxStarNum>=3;
		}
		
		/**
		 * 棋盘布局配置信息
		 */
		public var boardBallConfig:BoardBaseVO;
		/**
		 * 棋盘配置信息
		 */
		public var boardConfig:BoardConfigVO;
		
		/**
		 * 星星1，默认过关条件，过关后获得此星星
		 */
		public var star_1:LevelStarVO = new LevelStarVO;
		/**
		 * 星星2
		 */
		public var star_2:LevelStarVO = new LevelStarVO;
		/**
		 * 星星2
		 */
		public var star_3:LevelStarVO = new LevelStarVO;
		
		
		/**
		 * 本地保存玩家选择的技能、精灵列表信息
		 */
		public var levelChoiceVO:LevelChooseEnterVO = new LevelChooseEnterVO;
		/**
		 * 本地保存玩家选择的技能、精灵列表信息，用来快捷展示
		 * @param id
		 * @param skills
		 * @param fairys
		 */
		public function updateChoice(id:int, skills:Array, fairys:Array):void{
			this.levelChoiceVO.updateInfo(id, skills, fairys);
		}
		
		/**
		 * 本关记录中的最高得分
		 * @return 
		 */
		public function get myScore():int{
			return baseInfo.maxScore;
		}
		public function set myScore(value:int):void{
			baseInfo.maxScore = Math.max(baseInfo.maxScore, value);
		}
		
		/**
		 * 此关用户获得星星数量
		 */
		public function get maxStarNum():int{
			var num:int = 0;
			if(this.baseInfo.star1) num++;
			if(this.baseInfo.star1) num++;
			if(this.baseInfo.star1) num++;
			return num;
		}
		public function get isPassed():Boolean{
			return maxStarNum>0;
		}
		
		/**
		 * 此关是否开启
		 */
		public function get isOpen():Boolean{
			return BaseInfo.isOpenAllLevel ? true : _isOpen;
		}
		public function set isOpen(value:Boolean):void{
			_isOpen = value;
		}
		private var _isOpen:Boolean;
		
		/**
		 * 游戏的gameID（server传）
		 */
		public var gameID:String = "0";
		/**
		 * 棋盘随机数种子
		 */
		public var seed:Number = 0;
		/**
		 * 棋盘随机数开始位置
		 */
		public var initNum:Number = 0;
		/**
		 * 技能随机数开始位置
		 */
		public var skillInitNum:Number = 0;
		/**
		 * 技能随机数种子
		 */
		public var skillSeed:Number = 0;
		
		
		/**
		 * 闯关所需精力，过关转为经验
		 */
//		public var liveCose:int = 5;
		
		/**
		 * 此关能否携带技能
		 */
		public function get skillCarry():Boolean{
			return _skillCarry && SkillListVO.skillLength>0;
		}
		public function set skillCarry(value:Boolean):void{
			_skillCarry = value;
		}
		private var _skillCarry:Boolean = false;
		
		/**
		 * 此关是否需要精灵出战
		 */
		public function get fairyCarry():Boolean{
			return configVO.isFight;
		}
		
		/**
		 * 关卡开启前提(关卡)
		 */
		public var triggerLevelVO:LevelVO;

		/**
		 * 设置关卡开启前提(通过某关)，只需侦听前提关卡过关事件
		 * @param vo
		 */
		public function setTriggerLevel(vo:LevelVO):void{
		if(triggerLevelVO) triggerLevelVO.off(LEVEL_INFO_UPDATE, this, onTriggerLevelInfoChange);
		triggerLevelVO = vo;
		if(triggerLevelVO) triggerLevelVO.on(LEVEL_INFO_UPDATE, this, onTriggerLevelInfoChange);
		}
		/**
		 * 前提关卡信息改变，判断自己是否开启
		 * @param e
		 */
		private function onTriggerLevelInfoChange(e:ObjectEvent):void{
//			if(this.id==11 || this.id==6){
//				trace("levelVO.ID:",this.id);
//			}
			if(!this.isOpen && triggerLevelVO.isPassed){
				this.isOpen = true;
				dispatchUpdate();
			}
		}
		
		/**
		 * 此关中精灵 3:3,3:3
		 * @com.model.vo.fairy.FairyVO
		 */
		public var fairyInfos:Array = [];
		
		/**
		 * 闯此关必须携带的精灵模版ID
		 */
		public var userNeedFairyID:int;
		/**
		 * 闯关需要得到的资源；
		 * 火:30,土:15,秘籍:3
		 * @see com.model.vo.QiuPoint
		 */
		public var tarResource:Object = {};
		
		/**
		 * 闯关需要得到的得分
		 */
		public var tarScore:int = 0;
		/**
		 * 闯关需要得到的棋盘上的形状
		 * 如图数组内将为4个目标匹配球，完全匹配就达成任务
		 * 火:3:2,火:3:3,火:3:4
		 * [*,*,*,*,*,*,*,*]
		 * [*,*,*,*,*,*,*,*]
		 * [*,*,*,*,*,*,*,*]
		 * [*,*,*,*,*,*,*,*]
		 * [*,*,*,1,1,1,*,*]
		 * [*,*,*,*,1,*,*,*]
		 * [*,*,*,*,*,*,*,*]
		 * [*,*,*,*,*,*,*,*]
		 * @see com.model.vo.QiuPoint
		 */		
		public var tarArea:Array = [];
		
		/**
		 * 消除初始棋盘上包含目标buff的棋子；
		 * 4:2,3:5
		 * @see com.model.vo.QiuPoint
		 */
		public var targetClearBuff:int = 44;
		/**
		 * 消除棋盘上某个类型的所有棋子；
		 * 火,土
		 */
		public var targetClearKind:Array = [];
		/**
		 * 指定球达到指定数量范围；
		 * 平均值为8，小于8就是要小于目标数，反则要大于目标数；
		 * 火:4,木:14
		 */
		public var targetClearNum:Object = {};
		
		/**
		 * 关卡默认携带的技能数组，如果不用这几个技能就不能完成关卡
		 * 一般都是1级的角色技能
		 * @return 
		 */
		public var defaultBoardSkills:Array=[];
		
		
		public function get chooseSkills():Array{
			return levelChoiceVO.skills;
		}
		public function set chooseSkills(arr:Array):void{
			levelChoiceVO.skills = arr;
		}
		public function get chooseFairys():Array{
			return levelChoiceVO.fairys;
		}
		public function get hasFairys():Boolean{
			return levelChoiceVO.fairys[0]>-1;
		}
//		public function updateBoardSkills(arr:*):void{
//			
//		}
		/**
		 * 用于存储关卡数据
		 */
		public function get baseInfo():LevelSaveVO{
			return _baseInfo;
		}
		public function set baseInfo(value:LevelSaveVO):void{
			_baseInfo = value;
		}
		private var _baseInfo:LevelSaveVO = new LevelSaveVO({ID:LevelConfigVO.LEVEL_SECTION_UNIVERSAL})
		
		/**
		 * 能否再次闯关（次数限制和每日次数限制）
		 * @return 
		 */
		public function get canPassAgain():Boolean{
			var judge:Boolean = true;
			switch(this.configVO.crossTime){
				case -1:
					judge = true;
					break;
				case 0:
					judge = !(this.baseInfo.totalCross>0);
					break;
				default:
					judge = this.baseInfo.todayCross<this.configVO.crossTime;
			}
			return judge;
		}
		
		
		/**
		 * 通过对象池获取对应的LevelVO
		 * @param kind
		 * @param id
		 * @param isOpen
		 * @param base
		 * @return 
		 */
		public static function getLevelVO(id:int):LevelVO{
			var vo:LevelVO = PoolFactory.getPoolInfo(LevelVO, id) as LevelVO;
			vo.initInfo(id);
			return vo;
		}
//		private static var pool:Object = {};
		
		
		/**
		 * @param levelID	
		 * @param score		玩家本关积分
		 * @param isOpen	本关是否已经激活
		 */
		public function LevelVO(id:int) {
			initInfo(id);
		}
		
		private function initInfo(id:int):void{
//			if(this.id==10357){
//				trace("??"); 
//			}
			this.configVO = LevelConfig.getLevelByID(id);
			if(!configVO){
				return;
			}
			this.baseInfo = new LevelSaveVO({ID:id});
			this.star_1.init(configVO.star1);
			this.star_2.init(configVO.star2);
			this.star_3.init(configVO.star3);
			
			this.boardConfig = new BoardConfigVO();
			this.boardBallConfig = BoardConfig.getBoardInfo(configVO.boardID);
			if(configVO.boardConfig){
				boardConfig.updateObj(configVO.boardConfig);
			}else if(boardBallConfig && boardBallConfig.boardConfig){
				boardConfig.updateObj(boardBallConfig.boardConfig);
			}else{
				this.boardConfig = new BoardConfigVO();
			}

			this.isOpen = configVO.trigger==-1;
			this.skillCarry = Boolean(configVO.skillCarry);
//			this.energyCost = parseInt(data.@energyCost);
			var target:Array = resolveLevelTarget(configVO.target);
			for(var i:int=0; i<target.length; i++){ 
				switch(this.configVO.kind){
					case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_All:
						star_1.tarInfo = "消除所有棋子！";
						break;
					case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_POINT:
						targetClearBuff = parseInt(configVO.target); 
						star_1.tarInfo = "消除所有目标棋子！";
//						boardInfo.skillArr[target[i][0]][target[i][1]].push(QiuEffect.LEVEL_TARGET_POINT);
						break;
					case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_KIND:
						targetClearKind.push(target[i][0]);
						star_1.tarInfo = "消除棋盘上所有的"+String(configVO.target)+"棋子！";
						break;
					case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_NUM:
						targetClearNum[target[i][0]] = target[i][1];
						star_1.tarInfo = "使棋盘上"+WuxingVO.getHtmlWuxing(target[i][0])+"棋子"+(parseInt(target[i][1])>8?"大于":"小于")+target[i][1]+"颗!";
						break;
					case LevelConfigVO.KIND_GAME_FIGHT_PVE:
						var starlv:int = target[i][2] ? parseInt(target[i][2]) : 1;//星级
						var hpper:Number = target[i][3]?Number(target[i][3]) : 1;//生命值初始百分比
						fairyInfos.push(new FairyVO(0, target[i][0], target[i][1], 0, starlv, 1, hpper)); 
						star_1.tarInfo = "使用精灵赢得战斗!"; 
						break;
					case LevelConfigVO.KIND_GAME_COLLECT_RESOURCE:
						tarResource[target[i][0]] = parseInt(target[i][1]);
						star_1.tarInfo = "收集指定量的资源!";
						break;
					case LevelConfigVO.KIND_GAME_PUZZLE_FIT_ELEMENTS:
						tarArea.push(new QiuPoint(target[i][1], target[i][2], target[i][0]));
						star_1.tarInfo = "通过移动使得棋盘上某个区域填充某种颜色的棋子!";
						break;
					case LevelConfigVO.KIND_GAME_FIGHT_PVE_GIVEN:
						userNeedFairyID = target[i][0];
						star_1.tarInfo = "使用精灵:"+FairyConfig.getFairyName(userNeedFairyID)+"赢得战斗!";
						break;
					case LevelConfigVO.KIND_GAME_PUZZLE_SCORE:
						tarScore = target[i][0];
						star_1.tarInfo = "目标得分: "+tarScore+" 分!";
						break;
				}
			}
//			pool[kind+save.ID] = this;
			
			dispatchUpdate();
		}

		/**
		 * 返回一个二维数组，数组内容
		 * @param str
		 * @return 
		 */
		private function resolveLevelTarget(str:String):Array{
			var tarArr:Array = [];
			var arr:Array = str.split(",");
			for(var i:int=0; i<arr.length; i++){
				var arr1:Array = String(arr[i]).split(":");
				if(this.configVO.kind==LevelConfigVO.KIND_GAME_FIGHT_PVE){//配置变更，精灵ID+30000起
					arr1[0] = parseInt(arr1[0])+30000;
				}
				tarArr.push(arr1);
			}
			
			return tarArr;
		}
		
		public function updateReport(vo:BaseGameLogic):void{
			var tempIsPass:Boolean = this.isPassed;
			this.myScore = vo.totalExp; 
			if(vo.isPassed){
				this.star_1.hasOwn = true;
				this.baseInfo.star1 = true;
				this.star_2.updateInfo(vo);// = true;
				this.star_3.updateInfo(vo);//.isOpen = true;
				this.baseInfo.star1 = this.star_1.hasOwn;
				this.baseInfo.star2 = this.star_2.hasOwn;
				this.baseInfo.star3 = this.star_3.hasOwn;
			}
			
			if(!tempIsPass && this.isPassed){
				dispatchUpdate();
			}
		}
		
		public function dispatchUpdate():void{
			event(LevelVO.LEVEL_INFO_UPDATE);
		}
		
//		override public function on(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
//			super.on(type, listener, useCapture, priority, useWeakReference);
//		}
		
		public function updateInfo(info:LevelSaveVO=null):void{
			if(info) baseInfo = info;
			
			star_1.hasOwn = baseInfo.star1;
			star_2.hasOwn = baseInfo.star2;
			star_3.hasOwn = baseInfo.star3;
			
			dispatchUpdate();
		}
	}
}