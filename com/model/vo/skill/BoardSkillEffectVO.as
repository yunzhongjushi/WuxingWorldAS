package com.model.vo.skill {
	import com.model.logic.BaseGameLogic;
	import com.model.vo.chessBoard.BoardSkillActiveVO;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.config.skill.SkillEffectConfigVO;
	import com.model.vo.user.ChessboardUserVO;
	
	import listLibs.Glog;
	
	
	
	/**
	 * 棋盘技能效果，其中包含了效果前提；
	 * 一个效果只有一个数值改变（calculateValue）
	 * @author hunterxie
	 */
	public class BoardSkillEffectVO{
		public static const NAME:String = "BoardSkillEffectVO";
		
		/**
		 * 所属技能：循环引用
		 */
		public var skill:BoardSkillVO;

		public function get myUser():ChessboardUserVO{
			return skill.myUser;
		}
		
		/**
		 * 技能效果模版数据
		 */
		public var data:SkillEffectConfigVO;
		
		
		/**
		 * 对应ID效果中的五行/棋子类型
		 */
//		public var kind:int;
		
		
		/**
		 * 根据技能生效概率，判断技能能否触发
		 */
		protected function getChanceToEffect():Boolean{
			if(this.trigger.effectChanceByLV==1){
				return true; 
			}
			if(BaseGameLogic.randomGeter.GetNext("skill_random____获取__"+this.skill.name+"__技能命中率随机：")%10000/10000<this.trigger.effectChanceByLV){
				this.isEffected = true;
				Glog.chance2(this.skill.name,this.trigger.effectChanceByLV);
				return true;
			}
			Glog.chance2(this.skill.name,this.trigger.effectChanceByLV);
			this.isEffected = false;
			return false;
		}
		
		/**
		 * 生效前提
		 */
		public var trigger:SkillTriggerVO;
		
		/** 
		 * 棋盘效果的触发点
		 */
		public var triggerPoint:QiuPoint;
		
		/**
		 * 设置效果触发点
		 * @param point
		 */
		public function setQiuPoint(point:QiuPoint):void{
			this.triggerPoint = point;
		}
		
		/**
		 * 附属的棋子的kind/五行
		 */
		public function get qiuKind():int{
			return triggerPoint ? triggerPoint.showKind : QiuPoint.KIND_NULL;
		}
		
		public function get originFairyKind():int{
			return QiuPoint.KIND_100;
		}
		
		
		/**
		 * 最终计算出来的数值
		 */
		public var calculateValue:int = 0;
		/**
		 * 最终计算出来的系数(百分比)，生效时此系再进行计算和实现(参照生效参数，如：全体生命增加50%)
		 */
		public var calculatePer:Number = 1;
		
		/**
		 * 效果是否触发(自身命中概率），用于展示动画,计算实际效果
		 */
		public var isEffected:Boolean = true;
		/**
		 * 技能是否有益（造成伤害、debuff）
		 * @return 
		 */
		public var isBeneficial:Boolean = false;
		
		/**
		 * 效果对棋盘影响后得到的point数组，用于动画/棋盘展示
		 */
		public var boardResultVO:BoardSkillActiveVO;
		
		
		
		/**
		 * 技能效果，其中包含了效果前提
		 * @param info		技能效果配置信息
		 * @param skill		所属技能，五行也是所属技能的五行
		 * @param user		使用者/触发者
		 */
		public function BoardSkillEffectVO(info:SkillEffectConfigVO, skill:BoardSkillVO):void{
			this.data = info;
			this.skill = skill;
			
//			this.kind = data.kind;
			
//			this.effectKind = int(info.@effectKind);
//			this.ID = int(info.@id);
//			this.target = int(info.@target);
//			this.targetKind = int(info.@targetKind);
//			this.referTarget = int(info.@referTarget);
//			this.refer = int(info.@refer);
//			this.referKind = int(info.@referKind);
//			this.value = Number(info.@value);
//			this.value2 = Number(info.@value2);
//			this.percent = Number(info.@percent);
//			this.percent2 = Number(info.@percent2);
			
			this.trigger = new SkillTriggerVO(info.trigger, skill);
		}
		
		/**
		 * 获取value2的系数，如果是棋盘技能就是不计算等级的，就不用计算这个系数；
		 * 有一些棋盘效果中value2是生成的棋子buff
		 * @return
		 */
		private function get coefficient():int{
			var value:int=1;
			if(BaseSkillVO.judgeBoardEffectKind(this.data.effectKind)){
				value=0; 
			}
			return value;
		}
		/**
		 * 根据参照的计算得出最后数值
		 * @param tar	作用目标
		 * @return 
		 */
		public function calculateUser(tar:ChessboardUserVO=null):void{
			var referUser:ChessboardUserVO = getTriggerUser(data.referTarget);
			var value_f:int = Math.ceil(this.data.value+(this.data.value2-this.data.value)/100*(skill.LV-1)*coefficient);
			var percent_f:Number = this.data.percent+(this.data.percent2-this.data.percent)/100*(skill.LV-1)*coefficient;
			
			if(!referUser || (judgeSameEffect() && percent_f<=0)){//小于0需要单独计算到百分比数值变量中
				this.calculateValue = value_f;
				this.calculatePer = 1+percent_f;
			}else if(this.data.refer == BaseSkillVO.REFER_KIND_25){//棋盘效果也可能是精灵buff上，棋子buff上的，需要参照对应收集值
				if(skill is BoardBuffVO){
					calculateValue = Math.ceil((skill as BoardBuffVO).collect*percent_f);
				}else{
					throw Error("此技能不是buff，没有收集值!!");
				}
			}else{
				calculateValue = Math.ceil(value_f+referUser.getRefer(this.data.refer, BaseGameLogic.getKindString(data.referKind,qiuKind, this.myUser.wuxing))*percent_f);
			}
		}
		
		/**
		 * 前提判断,是否满足触发条件
		 * @param user	触发角色(发出者)
		 * @param kind	当前消除棋子的五行
		 * @return 
		 */
		public function getBoardTrigger(user:ChessboardUserVO):Boolean{
			var judgeUser:ChessboardUserVO = getTriggerUser(trigger.data.who);
			if((!judgeUser || user==judgeUser) && getChanceToEffect()){
				if(trigger.data.refer==SkillTriggerVO.TRIGGER_KIND_0) return true;
				if(trigger.data.target==TARGET_KIND_0 || trigger.data.judge==SkillTriggerVO.JUDGE_KIND_0) return true;
					
				var taruser:ChessboardUserVO = getTriggerUser(trigger.data.target2);
				var compare1:Number = user.getRefer(trigger.data.refer, BaseGameLogic.getKindString(data.referKind, qiuKind, this.myUser.wuxing))
				var compare2:Number = trigger.data.value;
				if(taruser) compare2 = taruser.getRefer(trigger.data.refer2, BaseGameLogic.getKindString(trigger.data.referKind2,qiuKind, this.myUser.wuxing));
				return trigger.judgeUserTrigger(compare1, compare2);
			}
			return false;
		}
		
		/**
		 * 获取参照user
		 * @param kind
		 * @return 
		 */
		public function getTriggerUser(kind:int):ChessboardUserVO{
			switch(kind){ 
				case TARGET_KIND_0://如果是0，则满足任意User行动条件
					break;
				default:
					return myUser;
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
			}
			return false;
		}
		
		
		//===targetKind=============================================
		/**
		 * 目标类型：无
		 */
		public static const TARGET_KIND_0:int = 0;
		/**
		 * 目标类型：自己
		 */
		public static const TARGET_KIND_1:int = 1;
		/**
		 * 目标类型：第一个敌人
		 */
		public static const TARGET_KIND_2:int = 2;
		/**
		 * 目标类型：全体
		 */
		public static const TARGET_KIND_3:int = 3;
		/**
		 * 目标类型：全体(不包括自己)
		 */
		public static const TARGET_KIND_4:int = 4;
		/**
		 * 目标类型：所选目标，仅仅在参照目标时有效。
		 * 当参照目标为所选目标时，生效时才对不同目标进行不同计算。体现在effect中的效果百分比上
		 */
		public static const TARGET_KIND_5:int = 5;
		/**
		 * 目标类型：全体己方
		 */
		public static const TARGET_KIND_6:int = 6;
		/**
		 * 目标类型：全体敌方
		 */
		public static const TARGET_KIND_7:int = 7;
		/**
		 * 目标类型：生命最少的敌人
		 */
		public static const TARGET_KIND_8:int = 8;
		/**
		 * 目标类型：生命最少的队友
		 */
		public static const TARGET_KIND_9:int = 9;
		/**
		 * 目标类型：最后一个敌人
		 */
		public static const TARGET_KIND_10:int = 10;
		/**
		 * 目标类型：最后一个队友
		 */
		public static const TARGET_KIND_11:int = 11;
		/**
		 * 目标类型：buff使用者
		 */
		public static const TARGET_KIND_12:int = 12;
		/**
		 * 目标类型：效果触发者，当前效果由另一个效果触发，另一个效果的使用者（如：攻击者、技能使用者）
		 */
		public static const TARGET_KIND_13:int = 13;
		
		
		//=====effects:效果===============================================
//		private static var boardEffectIncrease:int = 0;
//		
//		/**
//		 棋盘效果：消除获得量改变，棋子类型分类
//		 */
//		public static const EFFECT_KIND_0:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：随机消除，随机value颗kind类棋子上增加id为value2的buff并消除
//		 */
//		public static const EFFECT_KIND_1:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：随机变色，随机把value颗kind类棋子变色为value2类型
//		 */
//		public static const EFFECT_KIND_2:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：添加buff，随机value颗kind类棋子上增加id为value2的buff
//		 */
//		public static const EFFECT_KIND_3:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：生成新棋子，在消除的中心位置生成一颗kind类带value2 buff的新棋子（某个任务收集棋子）
//		 */
//		public static const EFFECT_KIND_4:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：禁止掉落，下次消除结束后掉下来的棋子中不会有value2类棋子
//		 */
//		public static const EFFECT_KIND_5:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：静空领域，消除后球不会下落，直到棋盘上所有可消棋子都消除后再生成新棋子下落
//		 */
//		public static const EFFECT_KIND_6:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：棋子生成率，kind类五行棋子生成率改变，必须是棋盘配置中有的棋子
//		 */
//		public static const EFFECT_KIND_7:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：棋子锁，有此buff的棋子不能移动（能消除、技能消除），消除一次一层
//		 */
//		public static const EFFECT_KIND_8:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：冻格子，棋子不能交换，也不能掉落，每次交换消除/技能消除只能消除一层
//		 */
//		public static const EFFECT_KIND_9:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：棋子buff扩散，复制buff到其他棋子
//		 */
//		public static const EFFECT_KIND_10:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：炸弹1级
//		 */
//		public static const EFFECT_KIND_11:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：炸弹2级
//		 */
//		public static const EFFECT_KIND_12:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：炸弹3级
//		 */
//		public static const EFFECT_KIND_13:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：炸弹4级
//		 */
//		public static const EFFECT_KIND_14:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：横排1级
//		 */
//		public static const EFFECT_KIND_15:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：横排2级
//		 */
//		public static const EFFECT_KIND_16:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：横排3级
//		 */
//		public static const EFFECT_KIND_17:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：竖排1级
//		 */
//		public static const EFFECT_KIND_18:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：竖排2级
//		 */
//		public static const EFFECT_KIND_19:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：竖排3级
//		 */
//		public static const EFFECT_KIND_20:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：十字1级
//		 */
//		public static const EFFECT_KIND_21:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：十字2级
//		 */
//		public static const EFFECT_KIND_22:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：十字3级
//		 */
//		public static const EFFECT_KIND_23:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：十字4级
//		 */
//		public static const EFFECT_KIND_24:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：上消1级
//		 */
//		public static const EFFECT_KIND_25:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：上消2级
//		 */
//		public static const EFFECT_KIND_26:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：右消1级
//		 */
//		public static const EFFECT_KIND_27:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：右消2级
//		 */
//		public static const EFFECT_KIND_28:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：下消1级
//		 */
//		public static const EFFECT_KIND_29:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：下消2级
//		 */
//		public static const EFFECT_KIND_30:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：左消1级
//		 */
//		public static const EFFECT_KIND_31:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：左消2级
//		 */
//		public static const EFFECT_KIND_32:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：模块激活
//		 */
//		public static const EFFECT_KIND_33:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：叉消1级
//		 */
//		public static const EFFECT_KIND_34:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：叉消2级
//		 */
//		public static const EFFECT_KIND_35:int = boardEffectIncrease++;
//		/**
//		 棋盘效果：叉消3级
//		 */
//		public static const EFFECT_KIND_36:int = boardEffectIncrease++;
	}
}