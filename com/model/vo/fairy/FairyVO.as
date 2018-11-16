package com.model.vo.fairy{
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.logic.BaseGameLogic;
	import com.model.logic.ChessBoardLogic;
	import com.model.vo.WuxingVO;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.chessBoard.ResourceVO;
	import com.model.vo.chessBoard.TurnActionVO;
	import com.model.vo.config.skill.SkillEffectConfigVO;
	import com.model.vo.skill.BaseSkillVO;
	import com.model.vo.skill.BoardBuffVO;
	import com.model.vo.skill.SkillTriggerVO;
	import com.model.vo.skill.fight.FairyBuffVO;
	import com.model.vo.skill.fight.FairySkillEffectVO;
	import com.model.vo.skill.fight.FairySkillVO;
	import com.model.vo.skill.fight.event.SkillCureVO;
	import com.model.vo.skill.fight.event.SkillHurtVO;
	import com.model.vo.user.FightUserVO;
	import com.model.vo.user.UserVO;
	
//	import listLibs.Glog;
	
	/**
	 * 战斗中精灵数据
	 * @author hunterxie
	 */
	public class FairyVO extends BaseFairyVO{
		/**
		 * 大技能准备好
		 */
		public static var BIG_SKILL_ENERGY_CHANGE:String = "BIG_SKILL_ENERGY_CHANGE";
		/**
		 * 回合获得资源增加
		 */
		public static var TURN_CLEAR_RESOURCE_ADD:String = "TURN_CLEAR_RESOURCE_ADD";
		/**
		 * 回合结束
		 */
		public static var ON_TURN_OVER:String = "ON_TURN_OVER";
		/**
		 * 技能使用成功
		 */
		public static var SKILL_USE_SUCCESS:String = "SKILL_USE_SUCCESS";
		/**
		 * 技能使用失败——未命中
		 */
		public static var SKILL_USE_MISS:String = "SKILL_USE_MISS";
		/**
		 * 受到伤害后事件
		 * @see com.model.vo.skill.SkillHurtVO
		 */
		public static var BE_ATTACK:String = "BE_ATTACK";
		/** 
		 * 受到治疗 
		 * @see com.model.vo.skill.SkillCureVO
		 */
		public static var BE_CURE:String = "BE_CURE";
		/**
		 * 得到一个buff
		 */
		public static var BE_BUFFED:String = "BE_BUFFED";
		/**
		 * 抵抗一个负面技能
		 */
		public static var BE_RESIST:String = "BE_RESIST";
		

		/**
		 * 根据当前减少的伤害计算得出的附带伤害；
		 * 增加百分比通过加法合在此参数中
		 */
		public function get nowHurt_add():int{
			return _nowHurt_add;
		}
		public function set nowHurt_add(value:int):void{
			_nowHurt_add = value;
		}

		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		
		private var _myUser:FightUserVO;
		public function get myUser():FightUserVO{
			return _myUser;
		}
		public function set myUser(tar:FightUserVO):void{
			this._myUser = tar;
		}
		
		public function get userWuxingLV():int{
			return this.myUser.getWuxingLV(wuxing);
		}
		
		public function get tarUser():FightUserVO{
			return myUser.tarUser;
		}
		
		/**
		 * 闯关得到的经验增加百分比
		 */
		public var EXP_per:Number = 1;
		
		
		
		/**
		 * 最大可升级等级
		 */
		public function get maxUpLV():int{
			if(myUser){
				return myUser.LV+9;
			}
			return 99; 
		}
		
		
		/**
		 * 战斗中附加加的精灵等级
		 */
		public var LV_add:int;
		
		/**
		 * 战斗中是否昏迷状态
		 */
		public var cannotAction:int = 0;
		
		/**
		 * 战斗中的流血效果
		 */
		public var bloodStyle:int = 0;
		

		/**
		 * 是否还活着
		 * @return
		 */
		public function get isAlive():Boolean{
			return this.HP_cu>0;
		} 
		
		
		
//		/**
//		 * 总技能列表
//		 */
//		public function get totalSkillArr():Array{
//			var arr:Array = [baseAttackSkill];
//			return arr.concat(this.skillArr);
//		}
		/**
		 * 基础攻击
		 */
		public var baseAttackSkill:FairySkillVO;
		/**
		 * 战斗中使用的技能数组，前端模拟的精灵技能vo列表
		 * @see com.model.vo.skill.FairySkillVO
		 */
		public var skillArr:Array = [];
		
		/**
		 * 大技能是否准备好(收集五行)
		 */
		public function isBigSkillPrepared():Boolean{
			return bigSkillEnergy>=bigSkillEnergyMax;
		}
		
		/** 战斗能量（消除对应五行棋子）收集 */
		public var bigSkillEnergy:int = 0;
		/** 满能量值 */
		public var bigSkillEnergyMax:int = 10;
		
		/**
		 * 游戏中buff列表，被动技能是一个永久生效的buff，不能使用
		 * @see 
		 */
		public var buffArr:Array = [];
		/**
		 * 每个精灵默认拥有的攻击技能，通过棋盘消除进行攻击
		 */
		
		
		
		/**
		 * 当前受到的伤害
		 */
		public function get nowHurt():int{
			var num:int = Math.ceil((_nowHurt+nowHurt_add)*nowHurt_per);
			if(num<0) num=0;
			if(num-nowHurt_Absorb<0) throw Error("伤害计算错误，伤害吸收量大于伤害量!");
			return num-nowHurt_Absorb;
		}
		public function set nowHurt(value:int):void{
			_nowHurt = value;
		}
		private var _nowHurt:int;
		
		private var _nowHurt_add:int;
		/**
		 * 伤害改变百分比，减少百分比通过乘法合在此参数中；
		 * 最后计算
		 */
		public var nowHurt_per:Number = 1;
		/**
		 * 伤害吸收量
		 */
		public var nowHurt_Absorb:uint = 0;
		/**
		 * 当前通过棋盘消除得到的资源量;
		 * 临时记录，用于获得资源时技能的触发
		 */
		private function get nowClearResource():ResourceVO{
			return BaseGameLogic.nowClearResource;
		}
		private function get nowActionInfo():TurnActionVO{
			return BaseGameLogic.nowTurnAction;
		}
		/**
		 * 当前受到的治疗
		 */
		public var nowCure:int;
		public var nowCure_add:int = 0;
		public var nowCure_per:Number = 1;
		/**
		 * 当前消耗的资源五行
		 */
		public var nowCostWuxing:int;
		/**
		 * 当前消耗的五行资源量
		 */
		public var nowCostWuxingNum:int;
		
		
		/**
		 * 当前受到的攻击效果
		 */
		public var nowAttackEffect:FairySkillEffectVO=null;
		
		/**
		 * 本回合获取的相同五行的资源得分
		 */
		private var myTurnClearResource:int;
		
		/**
		 * 目标精灵
		 * @return 
		 */
		public function get targetFairy():FairyVO{
			return tarUser.getFirstFairy();
		}
		
		
		
		
		
		/**
		 * 精灵数据
		 * @param id
		 * @param originID
		 * @param lv
		 * @param userID
		 * @param starLV
		 * @param intensLV
		 */
		public function FairyVO(id:int, originID:int, lv:int=1, userID:int=0, starLV:int=0, intensLV:int=0, hpPer:Number=1):void{
			super(id, originID, lv, userID, starLV, intensLV, hpPer);
			this.roleKind = userID==0 ? FIGHT_ROLE_KIND_AI : FIGHT_ROLE_KIND_PERSON;
			
//			this.wuxingInfo.on(WuxingVO.WUXING_RESOURCE_UPDATE, updateResource);
			this.baseAttackSkill = new FairySkillVO(0, this.LV, this);
		}
		
//		/**
//		 * 资源改变时的技能判定;
//		 * 如火资源满的时候
//		 * @param e
//		 */
//		protected function updateResource(e:*):void{
////			skillTrigger(SkillTriggerVO.TRIGGER_KIND_16, this);
//		}
		
		/**
		 * 战斗精灵根据外部传入的精灵信息初始化
		 * @param vo
		 * @return 
		 */
		public function updateByFairyVO(vo:BaseFairyVO):FairyVO{
			resetAddInfo();
			this.roleKind = vo.roleKind;
			this.ID = vo.ID;
			this.userID = vo.userID;
			
			this.data = vo.data;
			this.LV = vo.LV;
			this.starLV = vo.starLV;
			this.intensLV = vo.intensLV;
			this.HP_max_per = this.HP_max_first = vo.HP_max_first;
			this.HP_cu = this.HP_max;
//			this.wuxingInfo.updateByVO(vo.wuxingInfo);
			for(var i:int=0; i<5; i++){
				this.reduceArr[i] = vo.reduceArr[i];
				this.reducePerArr[i] = vo.reducePerArr[i];
			}
			this.skillArr = [];
			baseAttackSkill = new FairySkillVO(0, this.LV, this);
			this.aiSkillCountList = [baseAttackSkill];
			for(i=0; i<vo.baseSkillArr.length; i++){
				var tarSkill:BaseSkillVO = vo.baseSkillArr[i];
				var skill:FairySkillVO = new FairySkillVO(tarSkill.ID, tarSkill.LV, this);
				if(skill.ID!=0){
					skillArr.push(skill);
					if(skill.cd>0) aiSkillCountList.push(skill);
				}
			}
			event(FAIRY_INFO_UPDATE);
			return this;
		}
		
		/**
		 * 回合结束所有技能cd计算
		 * @return 
		 */
		public function onTurnOver():FairyVO{
			var num:int = buffArr.length; 
			var i:int=0;
			while(i<num){
				var buff:FairyBuffVO = buffArr[i] as FairyBuffVO;
				buff.onTurnOver();
				
				if(buffArr.length<num){
					num = buffArr.length;
				}else{ 
					i++;
				}
			}
			for(i=0; i<skillArr.length; i++){
				(skillArr[i] as FairySkillVO).onTurnOver();
			}
			myTurnClearResource = 0;
			event(ON_TURN_OVER, myTurnClearResource);
			return this;
		}
		
		/**
		 * 回合开始所有buff触发
		 * @return 
		 */
		public function onTurnStart():FairyVO{
			var num:int = buffArr.length; 
			var i:int=0;
			while(i<num){
				var buff:FairyBuffVO = buffArr[i] as FairyBuffVO;
				buff.onTurnStart();
				if(buffArr.length<num){
					num = buffArr.length;
				}else{ 
					i++;
				}
			}
			return this;
		}
		 
		
		//=====以下为数据处理逻辑================================================================
		//================================================================
		//================================================================
		//================================================================
		//================================================================
		//=====以下为数据处理逻辑================================================================
		/**
		 * 技能触发点，前提是否触发某个技能
		 * @param triggerID
		 * @param tar		触发精灵(事件发出者)
		 * @param kind		前提携带的五行
		 */
		public function skillTrigger(triggerID:int, tar:FairyVO, kind:String=null):void{
			buffTrigger(triggerID, tar);
			
			if(!cannotAction){
				for(var i:int=0; i<skillArr.length; i++){
					var vo:FairySkillVO = skillArr[i] as FairySkillVO;
					if(vo.useKind==BaseSkillVO.USE_KIND_PASSIVE){//被动技能触发
						vo.onFairyTrigger(tar, triggerID);
					}
				}
			}
		}
		
		/**
		 * 回合结束时的触发
		 */
		public function baseAttack():void{
			if(!cannotAction && this.roleKind==FIGHT_ROLE_KIND_PERSON){
				baseAttackSkill.onFairyTrigger(this, SkillTriggerVO.TRIGGER_KIND_4);
			}
		}
		
		/**
		 * buff触发
		 * @param triggerID
		 * @param tar
		 */
		public function buffTrigger(triggerID:int, tar:FairyVO):void{
			var num:int = buffArr.length; 
			var i:int=0;
			while(i<num){
				var buff:FairyBuffVO = buffArr[i] as FairyBuffVO;
				buff.onFairyTrigger(tar, triggerID);
				
				if(buffArr.length<num){
					num = buffArr.length;
				}else{ 
					i++;
				}
			}
		} 
		
		/**
		 * 棋盘消除—增加资源
		 * @param kind		消除球类型
		 * @param num		得分
		 * @param clearNum	消除数量
		 */
		public function addClearResource(vo:ResourceVO):void{
			if(isAlive){
				skillTrigger(SkillTriggerVO.TRIGGER_KIND_14, this);
				if(vo.clearKind==this.wuxing){
					this.bigSkillEnergy += vo.clearNum;
					if(bigSkillEnergy>bigSkillEnergyMax){
						bigSkillEnergy = bigSkillEnergyMax;
					}
					event(BIG_SKILL_ENERGY_CHANGE);
				}
//				this.wuxingInfo.addResource(nowAddClearResource.kind, nowAddClearResource.calculateValue);//上面事件出去有可能导致获得资源变化，所以这里加上临时增量（暂不变化，角色技才改变）
			}
		}
		
		/**
		 * 技能使用—减少资源
		 * @param kind
		 * @param num
//		 */
//		public function reduceSkillResource(kind:String, num:int):void{
//			this.wuxingInfo.addResource(kind, num);
//		}
		
		/**
		 * buff改变最大mp值
		 */
		private function changeMaxResourceByBuff():void{
			
		}
		
		public function get isAI():Boolean{
			return roleKind==BaseFairyVO.FIGHT_ROLE_KIND_AI;
		}
		
		/**
		 * 控制AI施放技能的数组，循环施放，第一个使用后开始第二个的倒计时
		 */
		public var  aiSkillCountList:Array;
		/**
		 * 当前倒计时的技能(用于技能触发、改变CD等操作)
		 */
		public function get nowCountSkill():FairySkillVO{
			return aiSkillCountList[0];
		}
		/**
		 * AI技能倒计时
		 * @return 返回倒计时结束的技能
		 */
		public function aiSkillCountDown():FairySkillVO{
			if(!this.isAlive) return null;//死亡以后技能也不倒计时了
			var skill:FairySkillVO = nowCountSkill;
			skill.nowCD--;
			if(this.isAlive && skill.nowCD==0){
				aiSkillCountList.push(aiSkillCountList.shift());
				return skill;
			}
			return null;
		}
		
		public function useBigSkill():void{
			if(isBigSkillPrepared()){
				event(SkillTriggerVO.SKILL_TRIGGER_SEND, SkillTriggerVO.TRIGGER_KIND_0);
				this.bigSkillEnergy = 0;
				event(BIG_SKILL_ENERGY_CHANGE);
			}
		}
		
		/**
		 * 电脑技能选择使用 
		 */
		public function aiSkillUse():FairySkillVO{
			if(!isAlive)return null;
			for(var i:int=0; i<skillArr.length; i++){
				var vo:FairySkillVO = skillArr[i] as FairySkillVO;
				if(vo.data.useKind==BaseSkillVO.USE_KIND_ACTIVE && vo.isActivating && this.tarUser.wuxingInfo.useRes(vo.data.cost, false)){
					return vo;
				}
			}
			return null;
		}
		
		
		/**
		 * 受到一个攻击效果，减血
		 * @param hurt		负数，受到的伤害
		 * @param wuxing	伤害类型
		 * @return 			返回最终受到的伤害
		 */
		private function beAttack(effect:FairySkillEffectVO):void{ 
			if(effect.calculateValue<0){ 
				throw Error("伤害值不能为负数!!");
			} 
			nowAttackEffect = effect;
//			if(effect.skillName=="流血"){
//				trace("asdfasdfasdfasdf");
//			}
//			G：攻击方攻击力，
//			F：被攻击方防御力， 
//			M：精灵对应玩家的五行等级
//			L：五行伤害加成系数，  
//			K：威力值(消除时获得的得分)
//			伤害计算公式：伤害=2*[G*G/（F+G）]*(1+L)*(1+M*0.2%)*（K*0.1）+M（最后结果向上取整）
			var G:Number = effect.originFairy.finalAP;
			var F:Number = this.finalDP; 
			var M:Number = effect.myUser.getWuxingLV(effect.originFairy.wuxing);
			var L:Number = WuxingVO.getHurt_ke(effect.originFairy.wuxing, this.wuxing); 
			var K:Number = effect.calculateValue;
			var hurt:int = effect.data.id==SkillEffectConfigVO.fairy_effect_101 ? effect.calculateValue : Math.ceil(2*(G*G/(F+G))*L*(1+M*0.002)*(K*0.1)+M);
//			var hurt:int = Math.ceil((effect.originFairy.LV*2+10)/250*effect.originFairy.getFinalAP(effect.wuxing)/this.finalDP*effect.calculateValue+2);
//			hurt = Math.ceil(hurt * WuxingVO.getHurt_ke(effect.wuxing, this.wuxing));
			this.nowHurt = hurt;
			event(SkillTriggerVO.SKILL_TRIGGER_SEND, SkillTriggerVO.TRIGGER_KIND_6);
			//event(SkillTriggerVO.SKILL_TRIGGER_SEND, SkillTriggerVO.TRIGGER_KIND_7); 
			skillTrigger(SkillTriggerVO.TRIGGER_KIND_7, this);
			this.HP_cu -= nowHurt;
			EventCenter.traceInfo("userID:"+this.userID+"_"+this.nickName+"受到"+effect.useFairy.nickName+"的"+effect.skill.name+"伤害："+nowHurt+" 当前生命："+this.HP_cu);
			
//			Glog.beatk(this.nickName,nowHurt,this.HP_cu, this.finalDP);
			
			event(SkillTriggerVO.SKILL_TRIGGER_SEND, SkillTriggerVO.TRIGGER_KIND_8);
			if(effect.skill.ID==0){//普通攻击命中后
				event(SkillTriggerVO.SKILL_TRIGGER_SEND, SkillTriggerVO.TRIGGER_KIND_5);
			}
			event(BE_ATTACK, new SkillHurtVO(nowHurt, effect, this)); //会触发技能的事件——伤害，可能改变受到的伤害值
			
			nowAttackEffect = null;
			this.nowHurt=0;
			this.nowHurt_add=0;
			this.nowHurt_Absorb=0; 
			this.nowHurt_per=1;  
			this.dispatchUpdate();
		}
		
		/**
		 * 受到一个治疗效果，加血   
		 * @return  
		 */
		private function beCure(effect:FairySkillEffectVO):void{
			var cure:int = effect.calculateValue;
			this.nowCure = cure;
			event(SkillTriggerVO.SKILL_TRIGGER_SEND, SkillTriggerVO.TRIGGER_KIND_9);
			nowCure+=nowCure_add;
			if(nowCure<0) nowCure=0;
			this.HP_cu += nowCure;
			this.dispatchUpdate();
			event(SkillTriggerVO.SKILL_TRIGGER_SEND, SkillTriggerVO.TRIGGER_KIND_10);
			event(BE_CURE, new SkillCureVO(nowCure, effect, this)); 
			
			this.nowCure_add = 0;
			this.nowCure_per = 1;
		}
		
		/**
		 * 受到一个buff，添加buff列表
		 * @return 
		 */
		private function beBuff(effect:FairySkillEffectVO):void{
			if(buffArr.length>=4){//已经有4个buff就不再生成新buff
				return;
			}
			var buff:FairyBuffVO; 
			var newBuff:FairyBuffVO = new FairyBuffVO(effect);
			for(var i:int=0; i<buffArr.length; i++){
				buff = buffArr[i]; 
				if(buff.ID==newBuff.ID){
					if(buff.canAddLayer){
						buff.addLayers();
						
						event(BE_BUFFED);
						this.dispatchUpdate();
						return;
					}else{
						buff.clear(); 
					}
					break;
				}else if(buff.buffData.replaceKind>0 && buff.buffData.replaceKind==newBuff.buffData.replaceKind){
					if(buff.buffData.priority>0 && buff.buffData.priority<=newBuff.buffData.priority){
						buff.clear();
					}else{ 
						return;
					}
				}
			}
			EventCenter.traceInfo(this.nickName+"生成buff____："+newBuff.name); 
			newBuff.on(BoardBuffVO.CLEAR_BUFF, this, onClearBuff);
			this.buffArr.push(newBuff);
			newBuff.onFairyTrigger(this, SkillTriggerVO.TRIGGER_KIND_1);
			event(BE_BUFFED);
			this.dispatchUpdate();
			
//			Glog.buff(this.userID+"-"+this.nickName,newBuff.name,newBuff.continuedTime);
		}
		
		/**
		 * buff被清除时进行清除buff相关的逻辑
		 * @param e
		 */
		private function onClearBuff(e:ObjectEvent):void{
			var buff:FairyBuffVO = e.target as FairyBuffVO;
			for(var i:int=0; i<buffArr.length; i++){
				if(buff == buffArr[i]){
					buff.off(BoardBuffVO.CLEAR_BUFF, this, onClearBuff);
					buffArr.splice(i,1);
					disperseBuff(buff);
					event(BE_BUFFED); 
					break;
				}
			}
		}
		
		/**
		 * buff失效，进行数据结算
		 * @param id
		 */
		private function disperseBuff(buff:FairyBuffVO):void{
			for(var i:int=0; i<buff.effectArr.length; i++){ 
				var effect:FairySkillEffectVO = buff.effectArr[i];
				if(effect.trigger.data.id == SkillTriggerVO.TRIGGER_KIND_1){
					beSkillEffect(effect, true)
				}
			}
		}
		
		/**
		 * 判断精灵的buff/技能中是否有某效果 
		 * @param effectID		效果ID
		 */
		private function hasSkillEffect(effectID:int):Boolean{
			for(var i:int=0; i<buffArr.length; i++){
				var buff:FairyBuffVO = this.buffArr[i] as FairyBuffVO;
				for(var j:int=0; j<buff.effectArr.length; j++){
					var eff:FairySkillEffectVO = buff.effectArr[j] as FairySkillEffectVO;
					if(eff.data.id == SkillEffectConfigVO.fairy_effect_115){
						return true;
					}
				}
			}
			for(i=0; i<skillArr.length; i++){
				var skill:FairySkillVO = this.skillArr[i] as FairySkillVO;
				for(j=0; j<skill.effectArr.length; j++){
					eff = buff.effectArr[j] as FairySkillEffectVO;
					if(eff.data.id == SkillEffectConfigVO.fairy_effect_115){
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * 受到一个技能效果,总入口
		 * @param effect
		 * @param isRemove	是否是移除效果
		 */
		public function beSkillEffect(effect:FairySkillEffectVO, isRemove:Boolean=false):void{
			var buff:FairyBuffVO;
			if(isRemove){
				effect.calculateValue = -effect.calculateValue;
				effect.calculatePer = 1/effect.calculatePer;
			}else{
				effect.calculateFairy(this);
			}
			if(effect.skill.name=="点燃"){
				trace("点燃点燃点燃点燃");
			}
			EventCenter.traceInfo(effect.useFairy.userID+"-"+effect.useFairy.nickName+"施放技能："+effect.data.id+"-"+effect.skill.name+"-威力："+effect.calculateValue);
			
//			Glog.effect(effect.useFairy.userID+"-"+effect.useFairy.nickName,effect.skill.name,effect.data.id,effect.calculateValue,effect.useFairy.finalAP,this.nickName);
			
//			if(!effect.isBeneficial && hasSkillEffect(SkillEffectVO.EFFECT_KIND_115)){//首先受到一个技能效果，分辨出是有害技能就判定buff列表中是否有魔抗buff
//				event(BE_RESIST, new SkillResistVO(effect, this));
//				return;
//			}
			
			switch(effect.data.id){
				case SkillEffectConfigVO.board_effect_0:
					if(effect.qiuKind==nowClearResource.kind){
						this.nowClearResource.num_add += effect.calculateValue;
						this.nowClearResource.num_per *= effect.calculatePer;
					}
					break;
				case SkillEffectConfigVO.fairy_effect_100:
					beAttack(effect);
					break; 
				case SkillEffectConfigVO.fairy_effect_101:
					beAttack(effect);
					break;
				case SkillEffectConfigVO.fairy_effect_102: 
					beCure(effect);
					break;
				case SkillEffectConfigVO.fairy_effect_103://AP改变：攻击力计算基础值(AP)改变
					this.AP_add += effect.calculateValue;
					this.AP_per *= effect.calculatePer;
					break;
//				case SkillEffectConfigVO.fairy_effect_104://精灵五行等级改变
//					if(effect.kind==-1){
//						this.wuxingInfo.setWuxingProperty_add("金", effect.calculateValue, effect.data.percent);
//						this.wuxingInfo.setWuxingProperty_add("木", effect.calculateValue, effect.data.percent);
//						this.wuxingInfo.setWuxingProperty_add("土", effect.calculateValue, effect.data.percent);
//						this.wuxingInfo.setWuxingProperty_add("水", effect.calculateValue, effect.data.percent);
//						this.wuxingInfo.setWuxingProperty_add("火", effect.calculateValue, effect.data.percent);
//					}else if(effect.kind==-2){
//						this.wuxingInfo.setWuxingProperty_add(effect.skill.wuxing, effect.calculateValue, effect.calculatePer);
//					}else if(effect.kind<5){
//						this.wuxingInfo.setWuxingProperty_add(effect.kind, effect.calculateValue, effect.calculatePer);
//					}
//					break;
				case SkillEffectConfigVO.fairy_effect_105://造成伤害改变
					this.nowHurt_add += effect.calculateValue;
					this.nowHurt_per *= effect.calculatePer; 
					break;
				case SkillEffectConfigVO.fairy_effect_106://受到伤害量改变：当前受到的伤害量改变
					this.nowHurt_add += effect.calculateValue;
					this.nowHurt_per *= effect.calculatePer;
					break;
				case SkillEffectConfigVO.fairy_effect_107://治疗量量改变：当前受到的治疗量量改变
					this.nowCure_add += effect.calculateValue;
					break;
				case SkillEffectConfigVO.fairy_effect_108://战斗效果：最大HP变化
					this.HP_max_add += effect.calculateValue;
					this.HP_max_per *= effect.calculatePer;
					break;
				case SkillEffectConfigVO.fairy_effect_109://设定HP值：当前HP改变为指定值(死亡后设置生命)
					this.HP_cu = effect.calculateValue;
					break;
//				case SkillEffectConfigVO.fairy_effect_110:
//					if(effect.kind==-1){
//						this.wuxingInfo.addResource("金", effect.calculateValue, effect.data.percent);
//						this.wuxingInfo.addResource("木", effect.calculateValue, effect.data.percent);
//						this.wuxingInfo.addResource("土", effect.calculateValue, effect.data.percent);
//						this.wuxingInfo.addResource("水", effect.calculateValue, effect.data.percent);
//						this.wuxingInfo.addResource("火", effect.calculateValue, effect.data.percent);
//					}else if(effect.kind==-2){
//						this.wuxingInfo.addResource(effect.skill.wuxing, effect.calculateValue, effect.calculatePer);
//					}else if(effect.kind<5){
//						this.wuxingInfo.addResource(effect.kind, effect.calculateValue, effect.calculatePer);
//					}
//					break;
//				case SkillEffectConfigVO.fairy_effect_111:
//					if(effect.kind==-1){
//						this.wuxingInfo.changeMaxResAdd("金", effect.calculateValue, effect.data.percent);
//						this.wuxingInfo.changeMaxResAdd("木", effect.calculateValue, effect.data.percent);
//						this.wuxingInfo.changeMaxResAdd("土", effect.calculateValue, effect.data.percent);
//						this.wuxingInfo.changeMaxResAdd("水", effect.calculateValue, effect.data.percent);
//						this.wuxingInfo.changeMaxResAdd("火", effect.calculateValue, effect.data.percent);
//					}else if(effect.kind==-2){
//						this.wuxingInfo.changeMaxResAdd(effect.skill.wuxing, effect.calculateValue, effect.calculatePer);
//					}else if(effect.kind<5){
//						this.wuxingInfo.changeMaxResAdd(effect.kind, effect.calculateValue, effect.calculatePer);
//					}
//					break;
//				case SkillEffectConfigVO.fairy_effect_112:
//					this.wuxingInfo.changeIncreaseAdd(effect.calculateValue, effect.calculatePer);
//					break;
//				case SkillEffectConfigVO.fairy_effect_113:
//					this.wuxingInfo.setAverageResourceNum();
//					break;
				case SkillEffectConfigVO.fairy_effect_115://技能使用时判定前提，不能当效果传递
					break;
				case SkillEffectConfigVO.fairy_effect_116://不能当效果传递
					break;
				case SkillEffectConfigVO.fairy_effect_117://不能当效果传递
					break;
				case SkillEffectConfigVO.fairy_effect_118:
					for(var i:int=0; i<this.skillArr.length; i++){
						(this.skillArr[i] as FairySkillVO).changeCDAdd(effect.calculateValue, effect.calculatePer);
					}
					break;
				case SkillEffectConfigVO.fairy_effect_119:
					beBuff(effect);
					break;
				case SkillEffectConfigVO.fairy_effect_120://驱散，减少一个buff
//					disperseBuff(this.buffArr[BaseGameLogic.randomGeter.GetNext()%this.buffArr.length]);
					break;
				case SkillEffectConfigVO.fairy_effect_121://昏迷，对方不能行动
					this.cannotAction += isRemove ? 1 : -1;
					break;
				case SkillEffectConfigVO.fairy_effect_122://DP改变，改变精灵的DP防御
					this.DP_add += effect.calculateValue; 
					this.DP_per *= effect.calculatePer;
					break;
			}
			event(FAIRY_INFO_UPDATE);  
		}
		
		
		/**
		 * 获得参照信息
		 * @param refer		数据ID
		 * @param kind		数据五行
		 * @return 
		 */
		public function getRefer(refer:int, kind:int):int{
			var num:int = 0;
			var tarKind:int = BaseGameLogic.getKindString(kind, QiuPoint.KIND_100, this.wuxing);
			switch(refer){
				case BaseSkillVO.REFER_KIND_0://只有一份棋盘，所以获取的棋子数都是自己的。对方棋盘情况未做
					num = ChessBoardLogic.getInstance().getTarBallNum(tarKind);
					break;
				case BaseSkillVO.REFER_KIND_1:
					num = ChessBoardLogic.getInstance().maxKinds;
					break;
				case BaseSkillVO.REFER_KIND_2://用于参照计算的原始AP
					num = this.AP;
					break;
				case BaseSkillVO.REFER_KIND_3://用于参照计算的原始DP
//					if(!wuxing){
						num = this.DP;
//					}else{
//						num = this.getWuxingDP(wuxing);
//					}
					break;
				case BaseSkillVO.REFER_KIND_4://用于参照计算的原始暴击率
					num = this.CRI;
					break;
				case BaseSkillVO.REFER_KIND_5://受到的原始伤害
					num = this.nowHurt;
					break;
				case BaseSkillVO.REFER_KIND_6://受到的原始治疗量
					num = this.nowCure;
					break;
				case BaseSkillVO.REFER_KIND_7:
					num = this.HP_cu;
					break;
				case BaseSkillVO.REFER_KIND_8:
					num = this.HP_max;
					break;
//				case BaseSkillVO.REFER_KIND_9:
//					num = wuxingInfo.getResource(wuxing);
//					break;
//				case BaseSkillVO.REFER_KIND_10:
//					num = wuxingInfo.getMaxResource(wuxing);
//					break;
//				case BaseSkillVO.REFER_KIND_11:
//					num = wuxingInfo.getResource(WuxingVO.VALUE_KIND_MAX);
//					break;
//				case BaseSkillVO.REFER_KIND_12:
//					num = wuxingInfo.getResource(WuxingVO.VALUE_KIND_ANY);
//					break;
				case BaseSkillVO.REFER_KIND_13:
//					num = wuxingInfo.getMaxResource(WuxingVO.VALUE_KIND_ANY);
					break;
				case BaseSkillVO.REFER_KIND_14:
					num = this.wuxing;
					break;
				case BaseSkillVO.REFER_KIND_15:
					num = this.nowClearResource.num;
					break;
				case BaseSkillVO.REFER_KIND_16:
					num = this.nowClearResource.kind;
					break;
				case BaseSkillVO.REFER_KIND_17://暂不处理
					num = nowCostWuxingNum;
					break;
				case BaseSkillVO.REFER_KIND_18://暂不处理
					num = nowCostWuxing;
					break;
				case BaseSkillVO.REFER_KIND_19:
					num = this.nowClearResource.clearNum;
					break;
				case BaseSkillVO.REFER_KIND_20:
					num = this.nowClearResource.sequenceNum;
					break;
				case BaseSkillVO.REFER_KIND_21:
					num = this.nowClearResource.exchangeSameNum;
//					if(num==2){//调试用
//						trace("!");
//					}
					break;
//				case BaseSkillVO.REFER_KIND_22:
//					num = wuxingInfo.getWuxingProperty(wuxing);
//					break;
//				case BaseSkillVO.REFER_KIND_23:
//					num = wuxingInfo.getWuxingProperty(WuxingVO.VALUE_KIND_MAX);
//					break;
//				case BaseSkillVO.REFER_KIND_24: 
//					num = wuxingInfo.getWuxingProperty(WuxingVO.VALUE_KIND_ANY);
//					break;
				case BaseSkillVO.REFER_KIND_25:
					throw Error("此技能不是buff，没有收集值!!"); 
					break;
				case BaseSkillVO.REFER_KIND_26:
					num = ChessBoardLogic.getInstance().getBoardBuffNum(tarKind);
					break;
				case BaseSkillVO.REFER_KIND_27:
					if(buffArr.some(function(item:FairyBuffVO, index:int, arr:Array):Boolean{return kind==item.buffData.replaceKind;})){
						num = 1;
					}
					break;
				case BaseSkillVO.REFER_KIND_28: 
					if(!buffArr.some(function(item:FairyBuffVO, index:int, arr:Array):Boolean{return kind==item.buffData.replaceKind;})){
						num = 1;
					}
					break;
//				case BaseSkillVO.REFER_KIND_29:
//					num = wuxingInfo.getWuxingProperty(wuxing);
//					break;
				case BaseSkillVO.REFER_KIND_30:
					num = nowActionInfo.getKindScore(tarKind);
					break;
				case BaseSkillVO.REFER_KIND_31:
					num = (nowActionInfo.getTotalScore()+nowActionInfo.getKindScore(this.wuxing)*BaseInfo.baseAttackTimes)/3;
					break;
			}
			
			return num;
		}
		
		public function resetAddInfo():void{
			this.buffArr = [];
			this.HP_max_add = 0; 
			this.HP_max_per = this.HP_max_first;
			this.AP_add = 0;
			this.AP_per = 1;
			this.EXP_per = 1;
			this.DP_add = 0;
			this.DP_per = 1;
//			this.DP_wuxing_add = [0,0,0,0,0];
//			this.DP_wuxing_per = [1,1,1,1,1];
			this.reduceArr_add = [0,0,0,0,0];
			this.reduceArr_per = [1,1,1,1,1];
			this.reducePerArr_add = [0,0,0,0,0];
			this.reducePerArr_per = [1,1,1,1,1];
			this.skillArr = [];
			this.cannotAction = 0;
			this.bloodStyle = 0;
		}
		
		
		override protected function initSkill():void{
			super.initSkill();
			skillArr = [];
			aiSkillCountList = [baseAttackSkill];
//			this.baseSkillArr = [];
			for(var i:int=0; i<data.skills.length; i++){
				var skill:FairySkillVO = new FairySkillVO(data.skills[i], 1, this);
				skillArr.push(skill);
//				baseSkillArr.push(skill);
//				baseInfo.skills[i] = 0;
				if(skill.cd>0) aiSkillCountList.push(skill);
			}
			this.bigSkillEnergy = 0;
		}
		
		public function dispatchResourceUpdate():void{
			var score:int = (BaseGameLogic.nowTurnAction.getTotalScore()+BaseGameLogic.nowTurnAction.getKindScore(this.wuxing)*BaseInfo.baseAttackTimes)/3;
//			if(myTurnClearResource<score){
				myTurnClearResource = score;
				event(TURN_CLEAR_RESOURCE_ADD, myTurnClearResource);
//			}
		}
	}
}