package com.model.logic{
	import com.greensock.TweenLite;
	import com.model.event.ObjectEvent;
	import com.model.vo.chessBoard.QiuClearVO;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.chessBoard.SingleClearVO;
	import com.model.vo.conn.ServerGameStartVO;
	import com.model.vo.conn.ServerVO_91;
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.fairy.FairyListVO;
	import com.model.vo.fairy.FairyVO;
	import com.model.vo.level.LevelOverVO;
	import com.model.vo.level.LevelVO;
	import com.model.vo.skill.BaseSkillVO;
	import com.model.vo.skill.SkillTriggerVO;
	import com.model.vo.skill.fight.FairySkillEffectVO;
	import com.model.vo.skill.fight.FairySkillVO;
	import com.model.vo.user.ChessboardUserVO;
	import com.model.vo.user.FightUserVO;
	import com.model.vo.user.UserVO;
	
	/**
	 * 战斗数据，所有战斗数据相关（包括技能）通过此结构分发
	 * 包含战斗数据处理逻辑
	 * @author hunterxie
	 */
	public class FightGameLogic extends BaseGameLogic{
		public static const SINGLETON_MSG:String="single_FightVO_only";
		protected static var instance:FightGameLogic;
		public static function getInstance():FightGameLogic{
			if ( instance == null ) instance = new FightGameLogic();
			return instance;
		}
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		
		/**
		 * 技能效果生效事件，作用：
		 * 1.展示动画效果；
		 * 2.传给外部作为触发计算；
		 */
		public static const SKILL_EFFECTIVE:String="SKILL_EFFECTIVE";
		/**
		 * 技能效果生效展示名字
		 */
		public static const SKILL_SHOW_NAME:String="SKILL_SHOW_NAME";
		
		/**
		 * 由战斗逻辑判断出游戏结束（一方团灭）
		 */
		public static const FIGHT_LOGIC_OVER:String="FIGHT_LOGIC_OVER";
		
		/**
		 * 战斗开始
		 */
		public static const FIGHT_LOGIC_START:String="FIGHT_LOGIC_START";
		
		/**
		 * 展示战斗中跟清除棋子相关的伤害/技能
		 */
		public static const UPDATE_FIGHT_CLEAR_INFO:String="UPDATE_FIGHT_CLEAR_INFO";
		
		/**
		 * 基础伤害系数，用于消除时根据消除元素数量进行计算
		 */
		public static const baseWuxingHurt:int = 1;
		
		
		/**
		 * 当前行动用户ID
		 */
		public function get nowTurnUser():FightUserVO{
//			if(!_nowTurnUser){
//				_nowTurnUser = 
//			}
			return _nowTurnUser;
		}
		public function set nowTurnUser(value:FightUserVO):void{
			_nowTurnUser = value;
		}
		private var _nowTurnUser:FightUserVO;
		public var nowTurnFairy:FairyVO;
		
		public var nowTarUser:FightUserVO;
		public var nowTarFairy:FairyVO
		
		/**
		 * 攻击方（左边）
		 */
		public var attackUser:FightUserVO = new FightUserVO;
		/**
		 * 防御方（右边）
		 */
		public var defendUser:FightUserVO = new FightUserVO;
		
		/**
		 * 是否是自己行动，只针对当前客户端使用者
		 */
		public function get isSelfAction():Boolean{
			return nowTurnUser.userID==nowTurnUser.userID;
		}
		/**
		 * 自己是否是攻击方
		 * @return 
		 */
		public function get isSelfAttack():Boolean{
			return nowTurnUser.userID==attackUser.userID;
		}
		
		/**
		 * 一场战斗中所有精灵列表
		 */
		public var totalRoleArr:Array;
		
		public var isGameOver:Boolean = false;
		
		/**
		 * 战斗初始化时后台传过来的战场信息
		 */
		public var serverInfo:ServerGameStartVO;
		
		/**
		 * 战斗类型（PVP/PVE)
		 */
		public var fightKind:int;
		
		/**
		 * 是否战斗展示
		 */
		public var fightShow:Boolean = false;
		
		
		public static function newVO(lvInfo:LevelVO=null, serverInfo:ServerGameStartVO=null):FightGameLogic{
			getInstance().startNewGame(lvInfo, serverInfo);
			return instance;
		}
		
		
		/**
		 * 
		 * @param lvInfo
		 * @param fairyInfo
		 */
		public function FightGameLogic(){
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			attackUser.tarUser = defendUser;
			defendUser
			defendUser.tarUser = attackUser;
			
			for(var i:int=0; i<BaseInfo.maxFairyNum; i++){
				attackUser.fairys[i].on(FairyVO.SKILL_USE_SUCCESS, this, onSkillEffect);
				attackUser.fairys[i].on(SkillTriggerVO.SKILL_TRIGGER_SEND, this, onTriggerDispatch);
				
				attackUser.fairys[i].on(FairyVO.BE_ATTACK, this, onFairyEffect);
				attackUser.fairys[i].on(FairyVO.BE_CURE, this, onFairyEffect);
				attackUser.fairys[i].on(FairyVO.BE_RESIST, this, onFairyEffect);
				
				//========================================================================================
				defendUser.fairys[i].on(FairyVO.SKILL_USE_SUCCESS, this, onSkillEffect);
				defendUser.fairys[i].on(SkillTriggerVO.SKILL_TRIGGER_SEND, this, onTriggerDispatch);
				
				defendUser.fairys[i].on(FairyVO.BE_ATTACK, this, onFairyEffect);
				defendUser.fairys[i].on(FairyVO.BE_CURE, this, onFairyEffect);
				defendUser.fairys[i].on(FairyVO.BE_RESIST, this, onFairyEffect);
			}
		}
		
		/**
		 * 开始一场新的战斗
		 * @param lvInfo
		 * @param serverVO
		 */
		public function startNewGame(lvInfo:LevelVO, serverVO:ServerGameStartVO=null):void{
			isGameOver = false;
			
			if(serverVO){
				serverInfo = serverVO;
				fightKind = serverVO.fightKind;
//				updateSeed(serverVO.skillInitNum, serverVO.skillSeed);
				attackUser.init(serverVO.attackUserID, serverVO.attackuserLV, serverVO.attackWuxing, serverVO.attackFairys, serverVO.attackSkills);
				defendUser.init(serverVO.defendUserID, serverVO.defendUserLV, serverVO.defendWuxing, serverVO.defendFairys, serverVO.defendSkills);
			}else {
//				var fairyListVO:FairyListVO = FairyListVO.getInstance();
//				var arr:Array = fairyListVO.fairyList;//[FairyListVO.getInstance().fairyList[0]];//
//				if(fairyListVO.fairyList.length==0){
//					FairyListVO.testAddFairy(1);
//				}
				var arr:Array = [];
				for(var j:int=0; j<lvInfo.chooseFairys.length; j++){
					var fairy:BaseFairyVO = FairyListVO.getFairy(lvInfo.chooseFairys[j]);
					if(fairy) arr.push(fairy);
				}
				if(arr.length==0) arr.push(new BaseFairyVO(Math.floor(Math.random()*99999), 30001, 1, userInfo.userID));//没有出战精灵就模拟一个
				
				fightKind = ServerVO_91.FIGHT_TYPE_PVE;
//				updateSeed();
				attackUser.init(userInfo.userID, userInfo.LV, userInfo.wuxingInfo.getWuxingPropertyArr(), arr, lvInfo.chooseSkills);
				defendUser.init(0, 0, [0,0,0,0,0], lvInfo.fairyInfos, []);
			}
			
			nowTurnUser = attackUser;
			nowTurnUser.resourceCollect = {};
			nowTurnUser.totalScore = 0;
			nowTurnUser.exchangeActives = [];
			
			nowTarUser = defendUser;
			nowTarUser.resourceCollect = {};
			nowTarUser.totalScore = 0;
			nowTarUser.exchangeActives = [];
			
			this.totalRoleArr = [];
			for(var i:int=0; i<attackUser.fairyNum; i++){
				totalRoleArr.push(attackUser.fairys[i]);
			}
			for(i=0; i<defendUser.fairyNum; i++){
				totalRoleArr.push(defendUser.fairys[i]);
			}
			maxSequence = 0;
			turnNum=0;
			
			super.initNew(lvInfo, nowTurnUser);
			
			event(FightGameLogic.FIGHT_LOGIC_START);
//			nextTurn(nowTurnUser);
		}
		

		/**
		 * 回合开始后初始化下个回合信息
		 */
		override public function nextTurn(user:ChessboardUserVO=null):void{
			super.nextTurn(user); 
			
			if(user){
				nowTurnUser = user as FightUserVO;
			}else{
				nowTurnUser = nowTarUser.tarUser;
			}
			nowTarUser = nowTurnUser.tarUser;
			
			if(turnNum==1){
				nowTarUser.boardSkillTrigger(SkillTriggerVO.TRIGGER_KIND_2);//双方都需要生效角色对局开始技能，补上另一方的角色技能触发
				onTriggerDispatch(new ObjectEvent(SkillTriggerVO.SKILL_TRIGGER_SEND, SkillTriggerVO.TRIGGER_KIND_2));
			}

			nowTurnUser.onTurnStart();
			nowTurnUser.fairySkillTrigger(SkillTriggerVO.TRIGGER_KIND_3, nowTurnUser);
			if(gameOverJudge()) return;
			if(nowTurnUser.isAI){
				increaseAiResource(); 
			}
		}
		
		/**
		 * 
		 * @return 
		 */
		override public function fightOver():LevelOverVO{
			this.isPassed = attackUser.isAlive;
			super.fightOver();
			
			var fairy:FairyVO
			var fairyExp:int = 0;
			for(var i:int=0; i<defendUser.fairyNum; i++){
				fairy = defendUser.fairys[i];
				fairyExp += Math.pow(fairy.LV,1.1)*50/7;
			}
			for(i=0; i<attackUser.fairyNum; i++){
				if(i<nowTurnUser.fairys.length){
					fairy = nowTurnUser.fairys[i];
//					FairyListVO.testAddExp(fairy.ID, fairyExp);
				}else{
					break;
				}
			}
			
//			fightOverVO.resource = attackUser.wuxingInfo.resourceArr;
			if(userInfo.userID==attackUser.userID){
				fightOverVO.isWin = attackUser.isAlive;
			}else if(userInfo.userID==defendUser.userID){
				fightOverVO.isWin = defendUser.isAlive;
			}else{
				fightOverVO.isWin = attackUser.isAlive;
			}
			fightOverVO.dispatchUpdate();
			return fightOverVO;
		}
		
		/**
		 * 回合结束函数，战斗面板中回合结束会有AI参与
		 */
		override public function onTurnOver(user:ChessboardUserVO=null):void{
			nowTurnUser.onTurnOver();
			
			if(gameOverJudge()) return;
			
//			nextTurn();
			super.onTurnOver(nowTarUser); 
		}
		
		
		/**
		 * 回合结束时AI资源增长；
		 * 模拟消除（分精灵聪明程度）
		 * 相关技能触发（主动+buff）；
		 */
		public function increaseAiResource():void{
			
//			onTurnOver();
//			return;//TODO:AI精灵暂时不通过模拟棋盘消除进行技能触发,待AI控制玩家精灵时再处理棋盘
			
//			var incObj:Object = {};
//			while(nowTurnUser.getAISequenceChance(sequenceClearNum)){
//				sequenceClearNum++;
			for(var k:int=0; k<3; k++){
				var kind:int = QiuPoint.KIND_JING;//WuxingVO.getWuxing(randomGeter.GetNext("skill_random______获取精灵获得五行随机：")%5, "", false);
				var num:int = nowTurnUser.getAIClearNum();
				var point1:QiuPoint = new QiuPoint(0,0,kind);
				var point2:QiuPoint = new QiuPoint(0,1,kind);
				var point3:QiuPoint = new QiuPoint(0,2,kind);
				var vo:SingleClearVO = new SingleClearVO(QiuClearVO.QIU_CLEAR_EXCHANGE, [point1,point2,point3], point1);
				updateCollect(vo);
			}
				
				for(var i:int=0; i<nowTurnUser.fairyNum; i++){
					var role:FairyVO = nowTurnUser.fairys[i] as FairyVO;
					aiSkillUse(role.aiSkillCountDown(), role);
				}
//				incObj[kind] = parseInt(incObj[kind])+num;
//			}
//			for(var k:* in incObj){
//				if(incObj[k]>0) updateCollect(k, incObj[k]);
//			}
//			if(nowTurnUser.getAISequenceChance(sequenceClearNum)){//模拟消除（分精灵聪明程度）
//				trace("精灵__模拟消除......")
//				sequenceClearNum++;
//				updateCollect(ChessBoardLogic.getRandomKind(), nowTurnUser.getAIClearNum());
//				increaseAiResource();
////				TweenLite.to({},0.5,{onComplete:increaseAiResource});
//			}//else{
				onTurnOver();
//			}
		}
		
		/**
		 * 棋盘消除，得到是根据基础计算得出的数据；
		 * 战斗中再根据精灵信息计算积分、伤害（根据具体数值计算）
		 * @param clearVO
		 */
		override public function updateCollect(clearVO:SingleClearVO):void {
			super.updateCollect(clearVO);
			
//			for(var i:int=0; i<nowTurnUser.fairyNum; i++){
//				nowTurnFairy = nowTurnUser.fairys[i];
//				nowTarFairy = nowTurnFairy.targetFairy;
//				if(nowTurnFairy.wuxing==kind){//需要从棋盘上展示棋子位置的技能
//					event(UPDATE_FIGHT_CLEAR_INFO, nowTurnFairy.globalPoint);//point);
//				}
//			}
			gameOverJudge();
		}
		
		/**
		 * 判断是否达到结束游戏的条件
		 * @param delay 延迟执行
		 */
		private function gameOverJudge(delay:Number=1):Boolean{
			if(!attackUser.isAlive || !defendUser.isAlive){
				isGameOver = true;
				TweenLite.to({}, delay, {onComplete:sendOver});
				return isGameOver;
			}
			function sendOver():void{
				event(FIGHT_LOGIC_OVER);
			}
			return false;
		}
		
		/**
		 * 精灵技能的使用
		 * @param skill
		 * @param role
		 */
		public function aiSkillUse(skill:FairySkillVO, role:FairyVO):Boolean{
			if(!skill) return false;
			
			nowTurnUser.wuxingInfo.useRes(skill.data.cost);//扣除对应资源
			skill.useSkill(skill.targetFairy, true);
			role.dispatchUpdate();
			role.targetFairy.dispatchUpdate();
			gameOverJudge();
			return true;
		}
		
		/**
		 * 技能的使用
		 * @param e		SkillEffectVO
		 */
		public function onSkillEffect(e:ObjectEvent):void{ 
			var effect:FairySkillEffectVO = e.data as FairySkillEffectVO;
			if(BaseSkillVO.judgeBoardEffectKind(effect.data.effectKind)){
				super.onBoardSkillEffect(e);
				return;
			}
			for(var i:int=0; i<effect.targetFairys.length; i++){
				(effect.targetFairys[i] as FairyVO).beSkillEffect(effect);
			}
//			var showTime:int = 
			TweenLite.to({}, nowTurnUser.isAI?0.5:0, {onComplete:function():void{event(SKILL_EFFECTIVE, effect)}});
//			event(SKILL_EFFECTIVE, effect);
		}

		/**
		 * 此处处理精灵技能前提；
		 * 双方角色技能只影响到自己的棋盘，不能影响到对方棋盘，所以不做角色技能处理
		 * @param e
		 */
		private function onTriggerDispatch(e:ObjectEvent):void{
			var triggerID:int = e.data as int;
			nowTurnUser.fairySkillTrigger(triggerID, e.target);
			nowTarUser.fairySkillTrigger(triggerID, e.target);
//			for(var i:int=0; i<this.totalRoleArr.length; i++){//按照精灵速度的先后顺序进行前提判断
//				var fairy:FairyVO = totalRoleArr[i] as FairyVO;
//				if(fairy.isAlive){
//					if(e.target is FairyVO){
//						fairy.skillTrigger(triggerID, e.target as FairyVO);
//					}else{
//						fairy.skillTrigger(triggerID, fairy);
//					}
//				}
//			}
		}
		private function onFairyEffect(e:ObjectEvent):void{
			TweenLite.to({}, nowTurnUser.isAI?0.5:0, {onComplete:function():void{event(SKILL_EFFECTIVE, e.data)}});
//			onTriggerDispatch(new ObjectEvent(SkillTriggerVO.SKILL_TRIGGER_SEND, SkillTriggerVO.TRIGGER_KIND_36));
//			event(SKILL_EFFECTIVE, e.data);
		}
	}
}