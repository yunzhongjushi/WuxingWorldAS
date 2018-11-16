package com.model.vo.user {
	import com.model.event.ObjectEvent;
	import com.model.logic.BaseGameLogic;
	import com.model.vo.WuxingVO;
	import com.model.vo.chessBoard.ResourceVO;
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.fairy.FairyVO;
	import com.model.vo.skill.SkillTriggerVO;
	

	/**
	 * 战斗中用到的用户信息，固定实例化6份战斗用
	 * @author hunterxie
	 */	
	public class FightUserVO extends ChessboardUserVO{
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		/**
		 * 类型（1.玩家，2.电脑）
		 */
		public var roleKind:int = BaseFairyVO.FIGHT_ROLE_KIND_PERSON;
		public function get isAI():Boolean{
			return roleKind==BaseFairyVO.FIGHT_ROLE_KIND_AI;
		}
		
		/**
		 * 总精灵列表，根据玩家携带数量更新数据
		 */
		public var fairys:Array = [];
		
		/**
		 * 玩家能够携带的精灵数量
		 */
		public var fairyNum:int = 1;
		
		/**
		 * 对手角色
		 */
		public var tarUser:FightUserVO;
		/**
		 * 计算判断精灵此次是否连击
		 * @param sequenceClearNum
		 */		
		public function getAISequenceChance(sequenceClearNum:int):Boolean{
			if(sequenceClearNum>0){
				var randomNum:Number = BaseGameLogic.randomGeter.GetNext("skill_random______获取精灵连击概率随机：")%10000/10000;
				return randomNum<BaseInfo.AISequenceChance;
			}
			return true;
		}
		/**
		 * 精灵模拟能够消除的数量数组，根据AIClearNumChanceArr中的概率获取
		 */
		private var cleNumArr:Array = [3,4,5];
		/**
		 * 精灵对应多消总概率列表，每个占总数的比例为抽中的概率
		 */
		private var AIClearNumChanceArr:Array = [100, 20, 5];
		/**
		 * 
		 */
		private var AIClearNumSum:int;
		/**
		 * 获取AI消除数
		 * @return 
		 */
		public function getAIClearNum():int{
			return 3;
			
			if(!AIClearNumSum){
				AIClearNumChanceArr.forEach(function(item:int, index:int, arr:Array):void{AIClearNumSum+=item});
			}
			
			var sum:int = AIClearNumSum;
			var temp:Number = BaseGameLogic.randomGeter.GetNext("skill_random______获取AI精灵消除球数量随机：")%sum;
			for(var i:int=0; i<AIClearNumChanceArr.length; i++){
				sum-=AIClearNumChanceArr[i];
				if(temp>=sum){
					return cleNumArr[i];
				}
			}
			return 3;
		}
		
		/**
		 * 是否有存活，判断战斗是否胜利
		 */
		public function get isAlive():Boolean{
			for(var i:int=0; i<fairyNum; i++){
				if((fairys[i] as FairyVO).isAlive){
					return true;
				}
			};
			return false;
		}
		
		
		/**
		 * 
		 * 
		 * 
		 * 
		 * 
		 */
		public function FightUserVO() {
			for(var i:int=0; i<BaseInfo.maxFairyNum; i++){
				var fairy:FairyVO = new FairyVO(0,30001);
				fairy.myUser = this;
//				fairy.wuxingInfo.setFightRes(this.wuxingInfo); 
				fairys.push(fairy);
			}
			this.wuxingInfo.on(WuxingVO.WUXING_RESOURCE_UPDATE, this, updateResource);
		}
		protected function updateResource(e:ObjectEvent):void{
			for(var i:int=0; i<fairyNum; i++){
				(fairys[i] as FairyVO).skillTrigger(SkillTriggerVO.TRIGGER_KIND_16, fairys[i]);
			} 
		}
		
		/**
		 * 
		 * @param userID
		 * @param wuxing
		 * @param fairys
		 * @param boardSkill
		 */
		public function init(userID:int, lv:int, wuxing:Array,  fairysArr:Array, boardSkill:Array):void{
			super.initBase(userID, lv, wuxing, boardSkill);
			
			this.roleKind = userID==0 ? BaseFairyVO.FIGHT_ROLE_KIND_AI : BaseFairyVO.FIGHT_ROLE_KIND_PERSON;
			fairyNum = (fairysArr.length>userInfo.fairyOpenNum && userID!=0) ? userInfo.fairyOpenNum : fairysArr.length;
			for(var i:int=0; i<fairyNum; i++){
				var fairy:FairyVO = fairys[i] as FairyVO;
				fairy.updateByFairyVO(fairysArr[i]);
			}
			
//			for(i=0; i<5; i++){//精灵影响角色五行
//				this.wuxingInfo.setProperty(i, int(wuxing[i]));
//				for(var j:int=0; j<fairyNum; j++){
//					fairy = fairys[j] as FairyVO;
//					this.wuxingInfo.setProperty(i, this.wuxingInfo.getWuxingProperty(i)+Math.ceil(fairy.wuxingInfo.getWuxingProperty(i)/2));
////					fairy.wuxingInfo.updateProperty(i, fairy.wuxingInfo.getWuxingProperty(i)+Math.ceil(wuxing[i]/2));
//				}
//				this.wuxingInfo.setResource(i, BaseInfo.getWuxingLvInfo(this.wuxingInfo.getWuxingProperty(i), "f_base"));
//			}
		}
		
		/**
		 * 返回第一个活的精灵
		 * @return 
		 */
		public function getFirstFairy():FairyVO{
			var tar:FairyVO;
			for(var i:int=0; i<fairyNum; i++){
				tar = fairys[i];
				if(tar.isAlive){
					break;
				}
			}
			return tar;
		}
		
		/**
		 * 返回最后一个活的精灵
		 * @return 
		 */
		public function getLastFairy():FairyVO{
			var tar:FairyVO;
			for(var i:int=fairyNum-1; i>=0; i--){
				tar = fairys[i];
				if(tar.isAlive){
					break;
				}
			}
			return tar;
		}
		
		/**
		 * 获取生命最少的精灵，一样生命就选第一个
		 * @return 
		 */
		public function getLowHPFairy():FairyVO{
			var tar:FairyVO;
			for(var i:int=0; i<fairyNum; i++){
				var fairy:FairyVO = fairys[i] as FairyVO;
				if(tar){
					tar = tar.HP_cu>fairy.HP_cu ? tar : fairy;
				}
			}
			return tar;
		}
		
		/**
		 * 获取生命最多的精灵，一样生命就选第一个
		 * @return 
		 */
		public function getHighHPFairy():FairyVO{
			var tar:FairyVO;
			for(var i:int=0; i<fairyNum; i++){
				var fairy:FairyVO = fairys[i] as FairyVO;
				if(tar){
					tar = tar.HP_cu<fairy.HP_cu ? tar : fairy;
				}
			}
			return tar;
		}
		
		/**
		 * 回合结束进行普攻、buff/技能触发判断、buff回合结束处理
		 * @return 
		 */
		public function onTurnOver():FightUserVO{
			baseAttack();
			fairySkillTrigger(SkillTriggerVO.TRIGGER_KIND_4, this);
			
			for(var i:int=0; i<fairyNum; i++){
				(fairys[i] as FairyVO).onTurnOver();
			}
			return this;
		}
		
		/**
		 * 回合开始改变所有精灵状态
		 * @return 
		 */
		public function onTurnStart():FightUserVO{
			for(var i:int=0; i<fairyNum; i++){
				(fairys[i] as FairyVO).onTurnStart();
			}
			return this;
		}
		
		/**
		 * 处理精灵前提
		 * @param id
		 * @param target
		 */
		public function fairySkillTrigger(id:int, target:Object):void{
			for(var i:int=0; i<fairyNum; i++){
				var fairy:FairyVO = fairys[i] as FairyVO;
				if(fairy.isAlive){
					if(target is FairyVO){//如果是精灵发出的就触发精灵判断
						fairy.skillTrigger(id, target as FairyVO);
					}else{//否则就触发棋盘判断，自己发出
						fairy.skillTrigger(id, fairy);
					}
				}
			}
		}
		
		/**
		 * 判断触发基础攻击
		 */		
		public function baseAttack():void{
			for(var i:int=0; i<fairyNum; i++){
				var fairy:FairyVO = fairys[i] as FairyVO;
				if(fairy.isAlive){
					(fairys[i] as FairyVO).baseAttack();
				}
			}
		}
		
		/**
		 * 棋盘消除—增加资源，此过程只做增加资源时的触发
		 * @param kind		消除球类型
		 * @param num		得分
		 * @param clearNum	消除数量
		 */
		override public function addClearResource(vo:ResourceVO):void{
			super.addClearResource(vo);//处理自己的棋盘消除事件
			
			for(var i:int=0; i<fairyNum; i++){
				var fairy:FairyVO = fairys[i] as FairyVO;
				fairy.addClearResource(vo);
			}
			
			event(SkillTriggerVO.SKILL_TRIGGER_SEND, SkillTriggerVO.TRIGGER_KIND_14);//这里触发玩家技能前提——消除事件，资源增加前
			
			if(WuxingVO.judgeIsWuxing(vo.kind)){//如果属于五行范围
				wuxingInfo.addResource(vo.kind, vo.finalNum);//上面事件出去有可能导致获得资源变化，所以这里加上临时增量
			}
			for(i=0; i<fairyNum; i++){
				fairy = fairys[i] as FairyVO;
				fairy.skillTrigger(SkillTriggerVO.TRIGGER_KIND_15, fairys[i]);
				fairy.dispatchResourceUpdate();
			}
//			EventCenter.traceInfo(this.userID+"_消除......获得："+vo.finalNum+"点"+vo.kind+"资源");
		}
	}
}
