package com.view.UI.fight {
	import com.greensock.TweenLite;
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.logic.FightGameLogic;
	import com.model.vo.GameSO;
	import com.model.vo.WuxingVO;
	import com.model.vo.animation.AnimationShowVO;
	import com.model.vo.animation.InfoShowVO;
	import com.model.vo.animation.LightningShowVO;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.config.level.LevelConfigVO;
	import com.model.vo.conn.ServerVO_91;
	import com.model.vo.fairy.FairyVO;
	import com.model.vo.level.LevelOverVO;
	import com.model.vo.skill.fight.FairySkillEffectVO;
	import com.model.vo.skill.fight.FairySkillVO;
	import com.model.vo.skill.fight.event.SkillCureVO;
	import com.model.vo.skill.fight.event.SkillHurtVO;
	import com.model.vo.skill.fight.event.SkillResistVO;
	import com.model.vo.user.UserVO;
	import com.view.BasePanel;
	import com.view.UI.animation.AnimationPanel;
	import com.view.UI.animation.GuideMissionContainer;
	import com.view.UI.chessboard.ChessboardPanel;
	import com.view.UI.level.LevelFailurePanel;
	import com.view.UI.level.LevelReportPanel;
	import com.view.UI.level.LevelReviewOverPanel;
	import com.view.UI.tip.FightFairyInfoPanel;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	import flas.geom.Point;
	import flas.utils.utils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * 特殊情况：不进行移动过程中控制操作会出现消除中移动额外棋子过来也可跟正在消除棋子匹配的情况（消除开始时就应该进行数组处理了）
	 * @author hunterxie
	 */
	public class FightPanel extends BasePanel {
		public static const NAME:String = "FightPanel";
		private static const SINGLETON_MSG:String="single_"+NAME+"_only";
		private static var instance:FightPanel;
		public static function getInstance():FightPanel{
			if ( instance == null ) instance=new FightPanel();
			return instance;
		}
		
		public static const FIGHT_OVER:String = "FIGHT_OVER";
		public var container:MovieClip;
		public var tf_turnUser:TextField;
		public var mc_turnCover:MovieClip;
		public var mc_controlCover:Sprite;
		
		public var mc_myResourcePanel:FightResourcePanel;
		public var mc_enemyResourcePanel:FightResourcePanel;
		
		public var mc_myRolePanel0:FightFairyPanel;
		public var mc_myRolePanel1:FightFairyPanel;
		public var mc_myRolePanel2:FightFairyPanel;
		public var mc_enemyRolePanel0:FightFairyPanel;
		public var mc_enemyRolePanel1:FightFairyPanel;
		public var mc_enemyRolePanel2:FightFairyPanel;
		
		public var btn_escape:CommonBtn;
		public var btn_test:CommonBtn; 
		
		/**
		 * 精灵信息展示面板
		 */
		public var mc_fairyInfo:FightFairyInfoPanel;
		
		public var boardPanel:ChessboardPanel;
		//=============================数据、战斗、技能逻辑==============================
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		//=======================显示================================
		
		public var skillUseArr:Array=[];
		
		public var isFightOver:Boolean = false;
		
		public var fightInfo:FightGameLogic = FightGameLogic.getInstance();
		
		/**
		 * 主函数
		 *
		 */
		public function FightPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			this.closeName = NAME;
			mc_turnCover.visible = false; 
			mc_controlCover.visible = false;
			mc_fairyInfo.visible = false; 
			
			btn_escape.setNameTxt("逃跑", true);
			btn_escape.addEventListener(MouseEvent.CLICK, onEscape);
			btn_test.setNameTxt("测试", true);
			btn_test.addEventListener(MouseEvent.CLICK, onTest);
			
			if(mc_myResourcePanel) mc_myResourcePanel.mouseChildren = mc_myResourcePanel.mouseEnabled = false;
			if(mc_enemyResourcePanel) mc_enemyResourcePanel.mouseChildren = mc_enemyResourcePanel.mouseEnabled = false;
			
			boardPanel = ChessboardPanel.getInstance();
			boardPanel.on(ChessboardPanel.TURN_OVER, this, updateTurnInfo);
			boardPanel.on(ChessboardPanel.GAME_ACTION, this, onGameAction);
			boardPanel.on(ChessboardPanel.BOARD_GAME_OVER, this, onFightOver);
			
			fightInfo = FightGameLogic.getInstance();
			fightInfo.on(FightGameLogic.FIGHT_LOGIC_OVER, this, onFightLogicOver);
			fightInfo.on(FightGameLogic.FIGHT_LOGIC_START, this, startNewGame);
			fightInfo.on(FightGameLogic.UPDATE_FIGHT_CLEAR_INFO, this, fightClear);
			fightInfo.on(FightGameLogic.SKILL_EFFECTIVE, this, skillEffectShow);
			
			for(var i:int=0; i<BaseInfo.maxFairyNum; i++){
				var myRole:FightFairyPanel = (this["mc_myRolePanel"+i] as FightFairyPanel);
				var enemyRole:FightFairyPanel = (this["mc_enemyRolePanel"+i] as FightFairyPanel);
				myRole.on(MouseEvent.CLICK, this, roleSkillUse);
				myRole.init(fightInfo.attackUser.fairys[i] as FairyVO, fightInfo.defendUser.fairys);
				enemyRole.init(fightInfo.defendUser.fairys[i] as FairyVO, fightInfo.attackUser.fairys);
				
				myRole.on(MouseEvent.MOUSE_DOWN, this, fairyInfoShow);
				myRole.on(MouseEvent.MOUSE_UP, this, fairyInfoShow);
				myRole.on(MouseEvent.MOUSE_OUT, this, fairyInfoShow);
				
				enemyRole.on(MouseEvent.MOUSE_DOWN, this, fairyInfoShow);
				enemyRole.on(MouseEvent.MOUSE_UP, this, fairyInfoShow);
				enemyRole.on(MouseEvent.MOUSE_OUT, this, fairyInfoShow);
			}
			
			EventCenter.on(BasePanel.CLOSE_PANEL, this, onPanelClose);
			EventCenter.on(ApplicationFacade.SHOW_FIGHT_RESULT, this, onShowResult);
		}
		
		private function onShowResult(e:ObjectEvent):void{
			if(!fightInfo || fightInfo.gameID!=e.data.gameId) return;//如果不在战斗关卡当中那么就不展示内容
			//			if(e.data.gameType == ServerVO_91.FIGHT_TYPE_PVE){
			fightInfo.fightOverByServerInfo(e.data);
			EventCenter.event(ApplicationFacade.SHOW_PANEL, LevelReportPanel.NAME);
			GameSO.save();
			//			}
		}
		
		
		
		private function onFightOver(e:ObjectEvent):void{
			if(!this.contains(boardPanel)) return;
			
			if(boardPanel.isShowAction){
				EventCenter.event(ApplicationFacade.SHOW_PANEL, LevelReviewOverPanel.NAME);
				return;
			}
			//			trace("showFightOver",e.target, e.currentTarget);
			//			onFightReportClose();
			var fightOverVO:LevelOverVO = fightInfo.fightOver();
			var action:String = boardPanel.getTotalAction();
			if(!fightOverVO.isWin){//输了就展示失败面板
				EventCenter.event(ApplicationFacade.SHOW_PANEL, LevelFailurePanel.NAME);
//				if(fightInfo.levelVO.configVO.isGuide){//小技巧，如果是引导那么隐藏掉失败面板，关闭引导对话面板后由失败面板发出通知
//					GuideTipVO.show(GuideTipVO.FIRST_PUZZLE_SOLVE_FAIL,  new Point(560,465), GuideTipVO.GUIDE_KIND_CHANGE_H, "解谜失败了哦~~~请交换最下面那排~~再试一次吧！", GuidePanel.NAME);
//				}
			}else if(fightInfo.levelVO.configVO.isGuide && fightOverVO.levelID==LevelConfigVO.LEVEL_ID_20000){
				EventCenter.event(ApplicationFacade.GUIDE_MISSION_COMPLETE, GuideMissionContainer.CutsceneIntoMap);
				close();
			}else if(BaseInfo.isTestLogin){
				EventCenter.event(ApplicationFacade.SHOW_PANEL, LevelReportPanel.NAME);
			}else if(fightInfo.fightKind == ServerVO_91.FIGHT_TYPE_PVE){
				ServerVO_91.getFightResult({
					code:ServerVO_91.FIGHT_MOVE, 
					gameType:ServerVO_91.FIGHT_TYPE_PVE,
					atId:fightInfo.attackUser.userID,
					deId:fightInfo.defendUser.userID,
					actions:String(e.data), 
					gameId:fightInfo.gameID,
					timeUse:fightInfo.timeUse,
					details:fightInfo.getDetails(fightOverVO.isWin)
				});
			}
		}
		
		
		/**
		 * 技能生效时展示技能名字动画
		 * @param skill
		 */
		private function showSkillName(skill:FairySkillVO):void{
			AnimationShowVO.showAnimation(AnimationShowVO.TEXT_INFO_SHOW, 
				new InfoShowVO(String(skill.name), 
					fightInfo.nowTarFairy.globalPoint,  
					WuxingVO.getColor(skill.useFairy.wuxing), 4));
		}
		
		/**
		 * 用户关闭战报/失败/重放面板时关闭面板
		 * @param e
		 */
		private function onPanelClose(e:ObjectEvent):void  {
			if(e.data==LevelReportPanel.NAME ||
				e.data==LevelFailurePanel.NAME ||
				e.data==LevelReviewOverPanel.NAME){
				close();
			}
		}
		
		
		/**
		 * 战斗关卡消除时 展示相关动画（闪电）
		 * @param e
		 */
		private function fightClear(e:ObjectEvent):void{
			var point:QiuPoint = e.data as QiuPoint;
			AnimationShowVO.showAnimation(AnimationShowVO.FIGHT_LIGHTNING_SHOW, new LightningShowVO(ChessboardPanel.getQiuGlobalPoint(point), fightInfo.nowTarFairy.globalPoint, AnimationPanel.wuxingLightningGlow[point.showKind]));
		}
		
		/**
		 * 战斗关卡展示技能相关动画
		 * 技能动画分为3种：1.技能效果展示(名字、动画)；2.数值展示(伤害、治疗、抵抗);3.界面刷新(buff列表);
		 * @param e
		 */
		private function skillEffectShow(e:ObjectEvent):void{
			var str:String=utils.getQualifiedClassName(e.data);
			switch(utils.getQualifiedClassName(e.data)){
				case utils.getQualifiedClassName(FairySkillEffectVO):
					var effect:FairySkillEffectVO = e.data as FairySkillEffectVO; 
					//					if(effect.ID!=0 || effect.useFairy.isAI){// && effect.isBeneficial通过棋盘消除施放的攻击已经在其他地方展示动画了
					for(var i:int=0; i<effect.targetFairys.length; i++){
						if(effect.skill.ID==0){//普通攻击
							AnimationShowVO.showAnimation(AnimationShowVO.WUXING_FIRE_BALL, new LightningShowVO(effect.useFairy.globalPoint, effect.targetFairys[i].globalPoint, 0.5, effect.useFairy.wuxing));
						}else{
							AnimationShowVO.showAnimation(AnimationShowVO.FIGHT_LIGHTNING_SHOW, new LightningShowVO(effect.useFairy.globalPoint, effect.targetFairys[i].globalPoint));
						}
					}
					//						AnimationShowVO.showAnimation(AnimationShowVO.TEXT_INFO_SHOW, new InfoShowVO(effect.skillName, effect.useFairy.globalPoint,  WuxingVO.getColor(effect.wuxing), 2));
					//					}
					break;
				case utils.getQualifiedClassName(SkillHurtVO):
					var hurtVO:SkillHurtVO = e.data as SkillHurtVO;
					AnimationShowVO.showAnimation(AnimationShowVO.TEXT_INFO_SHOW, 
						new InfoShowVO("-"+String(hurtVO.hurt), 
							hurtVO.tarFairy.globalPoint,  
							WuxingVO.getColor(hurtVO.effect.useFairy.wuxing), 
							1.5,2.5,
							hurtVO.effect.skill.ID==0?0.5:0));//普通攻击
					break;
				case utils.getQualifiedClassName(SkillCureVO):
					var cureVO:SkillCureVO = e.data as SkillCureVO;
					AnimationShowVO.showAnimation(AnimationShowVO.TEXT_INFO_SHOW, new InfoShowVO("+"+String(cureVO.cure), cureVO.tarFairy.globalPoint,  0xffffff, 2));
					break;
				case utils.getQualifiedClassName(SkillResistVO):
					var resistVO:SkillResistVO = e.data as SkillResistVO;
					//					AnimationShowVO.showAnimation(AnimationShowVO.TEXT_INFO_SHOW, new InfoShowVO(String(-effect.finalValue), fightInfo.nowTarUser.globalPoint,  WuxingVO.wuxingColor[effect.wuxing], 4));
					break;
			}
			
			//			switch(effect.ID){
			//				case SkillEffectVO.EFFECT_KIND_100://攻击
			//					AnimationShowVO.showAnimation(AnimationShowVO.TEXT_INFO_SHOW, new InfoShowVO(String(-effect.finalValue), fightInfo.nowTarUser.globalPoint,  WuxingVO.wuxingColor[effect.wuxing], 4));
			////					AnimationShowVO.showAnimation(AnimationShowVO.TEXT_INFO_SHOW, new InfoShowVO("伤害"+effect.finalValue, new Point(point.globalPoint.x, point.globalPoint.y-30),  WuxingVO.wuxingColor[point.showKind], 2));
			//					break;
			//				case SkillEffectVO.EFFECT_KIND_1:
			//					if(effect.finalValue>0){//技能治疗
			//						AnimationShowVO.showAnimation(AnimationShowVO.TEXT_INFO_SHOW, new InfoShowVO("治疗"+String(effect.finalValue), fightInfo.nowTarUser.globalPoint,  0xffffff, 4));
			//					}else{//技能伤害
			//						AnimationShowVO.showAnimation(AnimationShowVO.TEXT_INFO_SHOW, new InfoShowVO(String(-effect.finalValue), fightInfo.nowTarUser.globalPoint,  WuxingVO.wuxingColor[effect.wuxing], 4));
			//						AnimationShowVO.showAnimation(AnimationShowVO.FIGHT_LIGHTNING_SHOW, new LightningShowVO(fightInfo.nowTurnUser.globalPoint, fightInfo.nowTarUser.globalPoint));
			//					}
			//					break;
			//			}
		}
		
		/**
		 * 收到玩家操作信息，如果是联网战斗就向后台发送消息
		 * @param e
		 */
		private function onGameAction(e:ObjectEvent):void{
			if(!this.contains(boardPanel)) return;
			if(this.contains(boardPanel) && !BaseInfo.isTestLogin && fightInfo.fightKind==ServerVO_91.FIGHT_TYPE_PVP){
				ServerVO_91.fightMove({
					code:ServerVO_91.FIGHT_MOVE, 
					fairyID:fightInfo.nowTurnUser.userID, 
					tarFairyID:fightInfo.nowTarUser.userID, 
					actions:e.data
				});
			}
		}
		
		protected function fairyInfoShow(event:*):void{
			var role:FightFairyPanel = event.target as FightFairyPanel;
			switch(event.type){
				case MouseEvent.MOUSE_DOWN:
					TweenLite.to(this, 1, {onComplete:showFairyInfo, onCompleteParams:[role]});
//					mc_fairyInfo.visible = true;
//					mc_fairyInfo.updateInfo(role.fairyInfo);
//					if(role.name.indexOf("enemy")!=-1){
//						mc_fairyInfo.x = 460;
//					}else{
//						mc_fairyInfo.x = 170;
//					}
//					if(mc_fairyInfo.mc_bg.height<640-role.y){
//						mc_fairyInfo.y = role.y;
//					}else{
//						role.y = 4;
//					}
					break;
				case MouseEvent.MOUSE_UP:
					TweenLite.killTweensOf(this);
					if(mc_fairyInfo.visible){
						mc_fairyInfo.visible = false;
					}else{
						role.fairyInfo.useBigSkill();
					}
					break;
				case MouseEvent.MOUSE_OUT:
					TweenLite.killTweensOf(this);
					mc_fairyInfo.visible = false;
					break;
			}
		}
		
		protected function showFairyInfo(fairy:FightFairyPanel):void{
			mc_fairyInfo.visible = true;
			mc_fairyInfo.updateInfo(fairy.fairyInfo);
			if(fairy.name.indexOf("enemy")!=-1){
				mc_fairyInfo.x = 460;
			}else{
				mc_fairyInfo.x = 170;
			}
			if(mc_fairyInfo.mc_bg.height<640-fairy.y){
				mc_fairyInfo.y = fairy.y;
			}else{
				fairy.y = 4;
			}
		}
		
		/**
		 * 玩家点精灵击使用主动技能
		 * @param e
		 */
		private function roleSkillUse(e:Event):void{
//			var role:FightFairyPanel = e.target as FightFairyPanel;
//			if(role.skillPrepare || fightInfo.isSelfAction){
//				var vo:FairySkillVO = role.fairyInfo.aiSkillUse();
//				if(fightInfo.aiSkillUse(vo, role.fairyInfo)){
//					boardPanel.recordUserAction(GameActionVO.SKILL_USE, role.fairyInfo.ID+":"+vo.ID);
//				}
//			}
		}
		
//		override public function show(info:*):void{
//			this.x = (BaseInfo.fullScreenWidth-960)/2;
//			this.y = (BaseInfo.fullScreenHeight-640);
//		}
		
		protected function onFightLogicOver(event:Event):void{
			boardPanel.isFightOver = true;
			mc_controlCover.visible = true;
		}
		
		private function updateTurnInfo(event:Event=null):void{
			if(!this.contains(boardPanel)) return;
			mc_turnCover.visible = !fightInfo.isSelfAction;
			mc_turnCover.tf_info.text = "正在等待 "+fightInfo.nowTurnUser.userID+" 行动......";
		}
		
		public function startNewGame(e:ObjectEvent=null):void{
			EventCenter.traceInfo("defend.userID:"+fightInfo.defendUser.userID+"__userInfo.userID:"+userInfo.userID);
			for(var i:int=0; i<BaseInfo.maxFairyNum; i++){
				var myRole:FightFairyPanel = (this["mc_myRolePanel"+i] as FightFairyPanel);
				var enemyRole:FightFairyPanel = (this["mc_enemyRolePanel"+i] as FightFairyPanel);
				myRole.visible = i<fightInfo.attackUser.fairyNum;
				myRole.updateInfo();
				enemyRole.visible = i<fightInfo.defendUser.fairyNum;
				enemyRole.updateInfo();
//				if(fightInfo.isSelfAttack){
//					if(i<fightInfo.attackUser.fairyNum){
//						myRole.visible = true;
//						myRole.init(fightInfo.attackUser.fairys[i] as FairyVO, fightInfo.defendUser.fairys);
//					}else{
//						myRole.visible = false;
//					}
//					if(i<fightInfo.defendUser.fairyNum){
//						enemyRole.visible = true;
//						enemyRole.init(fightInfo.defendUser.fairys[i] as FairyVO, fightInfo.attackUser.fairys);
//					}else{
//						enemyRole.visible = false;
//					}
//				}else{
//					if(i<fightInfo.attackUser.fairyNum){
//						enemyRole.visible = true;
//						enemyRole.init(fightInfo.defendUser.fairys[i] as FairyVO, fightInfo.attackUser.fairys);
//					}else{
//						enemyRole.visible = false; 
//					}
//					if(i<fightInfo.defendUser.fairyNum){
//						myRole.visible = true;
//						enemyRole.init(fightInfo.attackUser.fairys[i] as FairyVO, fightInfo.defendUser.fairys);
//					}else{
//						myRole.visible = false;
//					}
//				}
			}
			if(mc_myResourcePanel) mc_myResourcePanel.init(fightInfo.attackUser.wuxingInfo);
			if(mc_enemyResourcePanel) mc_enemyResourcePanel.changeSite();
			if(mc_enemyResourcePanel) mc_enemyResourcePanel.init(fightInfo.defendUser.wuxingInfo);
			this.isFightOver = false;
			mc_controlCover.visible = false;
			
			updateTurnInfo(); 
			
			addChildAt(boardPanel, 0);
			this.btn_escape.visible = this.btn_test.visible = !fightInfo.levelVO.configVO.isGuide;
			boardPanel.startNewGame(fightInfo);
		}
		
		private function onSkillUseClick(e:ObjectEvent):void{
			var skillID:int = e.data as int;
//			onSkillUse(skillID);
			
			if(skillID==6){//如果技能中不括棋盘动作（消除、添加等等）
				
			}else{// if(boardPanel.tarQiu){包含目标球的技能需要在棋盘上处理
//				boardPanel.onSkillUse();
			}
		}
		
		
		public function onTest(event:*=null):void {
			
		}
		
		public function showTotalAction(actionStr:String):void{
			boardPanel.showTotalAction(actionStr);
		}
		
		public function getFairyPanelPoint(fairyID:int):Point{
			for(var i:int=0; i<BaseInfo.maxFairyNum; i++){
				var myRole:FightFairyPanel = this["mc_myRolePanel"+i];
				var enemyRole:FightFairyPanel = this["mc_enemyRolePanel"+i];
				if(myRole.fairyInfo && fairyID==myRole.fairyInfo.ID){
					return myRole.fairyInfo.globalPoint;
				}
				if(enemyRole.fairyInfo && fairyID==enemyRole.fairyInfo.ID){
					return enemyRole.fairyInfo.globalPoint;
				}
			}
//			if(fairyID == this["mc_myRolePanel"+].fairyInfo.ID){
//				return this.mc_myRolePanel.fairyInfo.globalPoint;
//			}else if(fairyID == this.mc_enemyRolePanel.fairyInfo.ID){
//				return this.mc_enemyRolePanel.fairyInfo.globalPoint;
//			}else if(fairyID == this.mc_enemyRolePanel2.fairyInfo.ID){
//				return this.mc_enemyRolePanel2.fairyInfo.globalPoint;
//			}
			return new Point;
		}
		
		public function onEscape(e:Event=null):void{
//			this.fightInfo.reset();
			close();
		}
	}
}