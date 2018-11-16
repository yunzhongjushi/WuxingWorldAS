package com.model.vo.skill.fight {
	import com.model.vo.WuxingVO;
	import com.model.logic.BaseGameLogic;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.config.skill.SkillEffectConfigVO;
	import com.model.vo.fairy.FairyVO;
	import com.model.vo.skill.BaseSkillVO;
	import com.model.vo.skill.BoardSkillEffectVO;
	import com.model.vo.skill.SkillTriggerVO;
	import com.model.vo.user.FightUserVO;
	
	
	
	/**
	 * 精灵技能效果，其中包含了效果前提；
	 * 一个效果只有一个数值改变（calculateValue）
	 * @author hunterxie
	 */
	public class FairySkillEffectVO extends BoardSkillEffectVO{
		public static const NAME:String = "SkillEffectVO";
		
		
		public function get myTrigger():FairySkillTriggerVO{
			return trigger as FairySkillTriggerVO;
		}
		public function get mySkill():FairySkillVO{
			return skill as FairySkillVO;
		}
		/**
		 * 使用者/触发者
		 */
		public function get useFairy():FairyVO{
			return mySkill.useFairy;
		}
		/**
		 * 最初使用者
		 */
		public function get originFairy():FairyVO{
			if(skill is FairyBuffVO){
				return (skill as FairyBuffVO).originFairy;
			}
			return useFairy;
		}
		override public function get originFairyKind():int{
			if(originFairy){
				return originFairy.wuxing;
			}
			return QiuPoint.KIND_100;
		}
		/**
		 * 当前生效目标(用于参照)
		 */
		public var tarFairy:FairyVO;
		
		private function get myUser1():FightUserVO{
			return myUser as FightUserVO;
		}
		public function get tarUser():FightUserVO{
			return mySkill.tarUser;
		}
		
		
		/**
		 * 目标数组
		 */
		public var targetFairys:Array = [];
		/**
		 * 生效目标精灵数组,计算时获取一次(传出去后再次获取会改变目标)
		 * @param tar	触发效果的精灵
		 * @return @see com.model.vo.fairy.FairyVO
		 */
		public function getTargetFairys(tar:FairyVO):Array{
			var arr:Array = [];
			switch(data.target){
				case TARGET_KIND_0: 
					break; 
				case TARGET_KIND_1:
					arr.push(useFairy);
					break;
				case TARGET_KIND_2:
					arr.push(tarUser.getFirstFairy());
					break;
				case TARGET_KIND_3: 
					for(var i:int=0; i<myUser1.fairyNum; i++){
						if((myUser1.fairys[i] as FairyVO).HP_cu>0){
							arr.push(myUser1.fairys[i]);
						}
					}
					for(i=0; i<tarUser.fairyNum; i++){
						if((tarUser.fairys[i] as FairyVO).HP_cu>0){
							arr.push(tarUser.fairys[i]);
						}
					}
//					arr = [].concat(myUser1.fairys, tarUser.fairys);
					break;
				case TARGET_KIND_4:
					for(i=0; i<myUser1.fairyNum; i++){
						if((myUser1.fairys[i] as FairyVO).HP_cu>0 && myUser1.fairys[i]!=useFairy){
							arr.push(myUser1.fairys[i]);
						}
					}
					for(i=0; i<tarUser.fairyNum; i++){
						if((tarUser.fairys[i] as FairyVO).HP_cu>0 && tarUser.fairys[i]!=useFairy){
							arr.push(tarUser.fairys[i]);
						}
					}
					//arr = [].concat(myUser1.fairys, tarUser.fairys);
					//arr.splice(arr.indexOf(useFairy),1);
					break;
				case TARGET_KIND_5:
					
					break;
				case TARGET_KIND_6:
					for(i=0; i<myUser1.fairyNum; i++){
						if((myUser1.fairys[i] as FairyVO).HP_cu>0){
							arr.push(myUser1.fairys[i]);
						}
					}
//					arr = [].concat(myUser1.fairys);
					break;
				case TARGET_KIND_7:
					for(i=0; i<tarUser.fairyNum; i++){
						if((tarUser.fairys[i] as FairyVO).HP_cu>0){
							arr.push(tarUser.fairys[i]);
						}
					}
//					arr = [].concat(tarUser.fairys);
					break;
				case TARGET_KIND_8:
					arr.push(tarUser.getLowHPFairy());
					break;
				case TARGET_KIND_9:
					arr.push((myUser as FightUserVO).getLowHPFairy());
					break;
				case TARGET_KIND_10:
					arr.push(tarUser.getLastFairy());
					break;
				case TARGET_KIND_11:
					arr.push((myUser as FightUserVO).getLastFairy());
					break;
				case TARGET_KIND_12:
					if(this.skill is FairyBuffVO){
						arr.push((this.skill as FairyBuffVO).originFairy);
					}else{
						throw Error("配置错误：获取的目标不是精灵buff不能获取“buff使用者目标");
					}
					break;
				case TARGET_KIND_13:
					arr.push(tar.nowAttackEffect.originFairy);
					break;
			}
			
			if(WuxingVO.judgeIsWuxing(data.targetKind)){//五行之中
				for(i=0; i<arr.length; i++){
					var fairy:FairyVO = arr[i] as FairyVO;
					if(fairy.wuxing!=data.targetKind){
						arr.splice(i,1); 
						i--;
					}
				}
			} 
			targetFairys = arr;
			return arr;
		}
		
		
		/***********************************
		 * 技能效果，其中包含了效果前提
		 * @info <effect id="18" target="1" referTarget="1" refer="23" value="0" percent="1" chance="1">
				<trigger id="5" target="1" refer="1" target2="1" refer2="1" value="0" percent="0" judge="0"/>
			</effect>
		 * @param skill		所属技能，五行也是
		 * @param useFairy	使用者/触发者
		 ***********************************/
		public function FairySkillEffectVO(info:SkillEffectConfigVO, skill:FairySkillVO):void {
			super(info, skill);
			
			this.trigger = new FairySkillTriggerVO(info.trigger, skill);
		}
		
		/**
		 * 根据参照的计算得出最后数值
		 * @param tar	作用目标
		 * @return 
		 */
		public function calculateFairy(tar:FairyVO=null):Boolean{
			tarFairy = tar;
			var referFairy:FairyVO = getTriggerFairy(data.referTarget);
			var value_f:int = Math.ceil(this.data.value+(this.data.value2-this.data.value)/100*skill.LV);
			var percent_f:Number = this.data.percent+(this.data.percent2-this.data.percent)/100*skill.LV;
			
			if(!referFairy || (judgeSameEffect() && percent_f<=0)){//小于0需要单独计算到百分比数值变量中
				this.calculateValue = value_f;
				this.calculatePer = 1+percent_f;
			}else if(this.data.refer == BaseSkillVO.REFER_KIND_25){//棋盘效果也可能是精灵buff上，棋子buff上的，需要参照对应收集值
				if(skill is FairyBuffVO){
					calculateValue = Math.ceil((skill as FairyBuffVO).collect*percent_f);
				}else{
					throw Error("此技能不是buff，没有收集值!!");
				}
			}else{
				calculateValue = Math.ceil(value_f+referFairy.getRefer(this.data.refer, data.referKind)*percent_f);
			}
			
//			if(!referFairy){
//				if(this.percent<=0){//如果小于0那么就是加法
//					this.calculateValue = this.value;
//					this.calculatePer = 1+this.percent;
//				}else{//大于0就是乘法；如果没有参照的精灵，那么当比率的时候计算user中的信息
//					calculateValue = this.value+this.tarUser.getRefer(this.data.refer, getKindString(referKind))*this.percent;
//				}
//				return true;
//			}
//			if(judgeSameEffect() && this.percent<=0){//如果是百分比减少就用除法
//				calculateValue = this.value;
//				this.calculatePer = 1+this.percent;
//			}else if(this.data.refer == FairySkillVO.REFER_KIND_25){
//				if(skill is FairyBuffVO){
//					calculateValue = (skill as FairyBuffVO).collect;
//				}else{
//					throw Error("此技能不是buff，没有收集值!!");
//				}
//			}else{
//				calculateValue = this.value+referFairy.getRefer(this.data.refer, this.referKind)*this.percent;
//			}
			return true;
		}
		
		/**
		 * 精灵技能前提判断,是否满足触发条件
		 * @param 	tar触发精灵(发出者)
		 * @return	是否成功 
		 */
		public function judgeFairyTrigger(tar:FairyVO):Boolean{
//			if(this.skillID==128 && BaseGameLogic.turnNums==3){
//				trace("judgeFairyTrigger————");
//			}
			if((trigger.data.who==0 || tar==getTriggerFairy(trigger.data.who)) && getChanceToEffect()){
				if(trigger.data.refer==SkillTriggerVO.TRIGGER_KIND_0) return true;
				if(trigger.data.target==0 || trigger.data.judge==0) return true; 
				return myTrigger.judgeFairyTrigger(getTriggerFairy(trigger.data.target), getTriggerFairy(trigger.data.target2));
			}
			return false;
		}
		
		/**
		 * 通过相对类型获取进行对比的FairyVO
		 * @param kind
		 * @return 
		 */
		private function getTriggerFairy(kind:int):FairyVO{
			switch(kind){
				case TARGET_KIND_0:
					return null;
					break;
				case TARGET_KIND_1:
					return useFairy;
					break;
				case TARGET_KIND_2:
					return tarUser.getFirstFairy();
					break;
				case TARGET_KIND_5:
					return tarFairy;
					break;
				default:
					throw Error("此技能效果前提对比类型有误，应该是单一精灵的数据才能对比。");
					break;
			}
			return null;
		}
		
		/**
		 * 判断效果参考的和改变的是否是同一个值
		 * @return 
		 */
		private function judgeSameEffect():Boolean{
			switch(this.data.id){
				case SkillEffectConfigVO.board_effect_0:
					return (this.data.refer==BaseSkillVO.REFER_KIND_15);
					break;
				case SkillEffectConfigVO.fairy_effect_108:
					return (this.data.refer==BaseSkillVO.REFER_KIND_8);
					break;
				case SkillEffectConfigVO.fairy_effect_111:
					return (this.data.refer==BaseSkillVO.REFER_KIND_10);
					break;
				case SkillEffectConfigVO.fairy_effect_106:
					return (this.data.refer==BaseSkillVO.REFER_KIND_5);
					break;
				case SkillEffectConfigVO.fairy_effect_107:
					return (this.data.refer==BaseSkillVO.REFER_KIND_6);
					break;
				case SkillEffectConfigVO.fairy_effect_103:
					return (this.data.refer==BaseSkillVO.REFER_KIND_2);
					break;
				case SkillEffectConfigVO.fairy_effect_104:
					return (this.data.refer==BaseSkillVO.REFER_KIND_22);
					break;
			}
			return false;
		}
		
		public function cloneEffect():FairySkillEffectVO{
			var effect:FairySkillEffectVO = new FairySkillEffectVO(this.data, this.mySkill);
			return effect;
		}
		
		
		
		
		
		
		//=====effects:效果===============================================
//		private static var fairyEffectIncrease:int = 100;
//		
//		/**
//		 战斗效果：攻击-造成伤害
//		 */
//		public static const EFFECT_KIND_100:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：真实伤害，不计算威力和防御
//		 */
//		public static const EFFECT_KIND_101:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：治疗效果，当前HP增加
//		 */
//		public static const EFFECT_KIND_102:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：攻击力计算基础值(AP)改变
//		 */
//		public static const EFFECT_KIND_103:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：改变精灵某五行等级值
//		 */
//		public static const EFFECT_KIND_104:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：精灵造成的某伤害量改变
//		 */
//		public static const EFFECT_KIND_105:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：受到伤害改变
//		 */
//		public static const EFFECT_KIND_106:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：当前受到的治疗量改变
//		 */
//		public static const EFFECT_KIND_107:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：最大HP变化（当前值根据上限变化的百分比改变）
//		 */
//		public static const EFFECT_KIND_108:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：当前HP改变为指定值
//		 */
//		public static const EFFECT_KIND_109:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：当前某MP改变
//		 */
//		public static const EFFECT_KIND_110:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：最大某MP改变
//		 */
//		public static const EFFECT_KIND_111:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：AI的某MP增长速度
//		 */
//		public static const EFFECT_KIND_112:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：MP总量平均分配，如果有元素的最大值小于平均值那么得到的依然是最大值
//		 */
//		public static const EFFECT_KIND_113:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：吸收伤害护盾：永久护盾，MP/收集值降到0消失
//		 */
//		public static const EFFECT_KIND_114:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：禁止使用X系/所有魔法
//		 */
//		public static const EFFECT_KIND_115:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：非普通攻击（id=0）技能免疫
//		 */
//		public static const EFFECT_KIND_116:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：改变技能消耗，增加敌人/降低自己的技能百分比消耗
//		 */
//		public static const EFFECT_KIND_117:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：改变某技能CD，减少自己/增加敌人技能X秒/百分比回复时间
//		 */
//		public static const EFFECT_KIND_118:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：生成一个buff，附带buff的ID
//		 */
//		public static const EFFECT_KIND_119:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：减少buff一个，随机（某系）一个
//		 */
//		public static const EFFECT_KIND_120:int = fairyEffectIncrease++;
//		/**
//		 战斗效果：昏迷，对方不能行动（普攻+技能）
//		 */
//		public static const EFFECT_KIND_121:int = fairyEffectIncrease++; 
//		/**
//		 战斗效果：DP改变，改变精灵的DP防御
//		 */
//		public static const EFFECT_KIND_122:int = fairyEffectIncrease++;
	}
}