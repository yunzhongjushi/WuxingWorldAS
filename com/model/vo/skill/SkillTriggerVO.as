package com.model.vo.skill {
	import com.model.vo.config.skill.SkillEffectTriggerConfigVO;
	
	
	/**
	 * 效果触发前提
	 * @author hunterxie
	 */
	public class SkillTriggerVO {		
		/**
		 * 技能模版数据
			<trigger id="0" target="1" refer="1" target2="1" refer2="1" value="0" percent="0" judge="0"/>
		 */
		public var data:SkillEffectTriggerConfigVO;
		
//		public var ID:int;
		
		/**
		 * 对应ID效果中的五行/棋子类型
		 */
//		public var kind:int;
		
		/**
		 * 触发目标，谁发出的事件;
		 * 等于0就相当于任何角色/精灵，比如对方4消时给对方生成一个技能！
		 */
//		public var who:int;
		/**
		 * 技能触发概率
		 */
//		private var effectChance:Number = 1;
//		private var effectChance2:Number = 1;
		public function get effectChanceByLV():Number{
			return data.chance+(data.chance2-data.chance)/100*(skill.LV-1);
		}
		/**
		 * 参照目标（0:无，1:自己，2:敌人，3:全体，4:全体(不包括自己)，5:所选目标）
		 */
//		public var target:int;
		/**
		 * 参照目标2（0:无，1:自己，2:敌人，3:全体，4:全体(不包括自己)，5:所选目标）；
		 * 如果有这个那么就是目标1跟目标2对比
		 */
//		public var target2:int;
		
		/**
		 * 参照类型
		 */
//		public var refer:int;
		/**
		 * 对应refer效果中的五行/棋子类型
		 */
//		public var referKind:int;
		/**
		 * 参照类型2
		 */
//		public var refer2:int;
		/**
		 * 对应refer2效果中的五行/棋子类型
		 */
//		public var referKind2:int;
		
		/**
		 * 效果值
		 */
//		public var value:Number;
		
		/**
		 * 如果有参照值那么就是参照百分比
		 */
//		public var percent:Number;
		
		/**
		 * 判定条件
		 */
//		public var judge:int;
		
		
		public var skill:BoardSkillVO;
		
		
		/**
		 * 技能生效前提
		 * “参照1”相对“参照2”是否满足“判定条件”
		 * @param info	<trigger who="0" id="13" kind="-2" chance="1" judge="0" value="0" percent="0" target="0" refer="0" referKind="-1" target2="0" refer2="0" referKind2="-1"/>
		 */
		public function SkillTriggerVO(info:SkillEffectTriggerConfigVO, skill:BoardSkillVO):void {
			this.data = info;
			if(!data) return;
			
//			this.who = int(info.@who);
//			this.ID = int(info.@id);
//			this.kind = int(info.@kind);
//			this.effectChance = Number(info.@chance);
//			this.effectChance2 = Number(info.@chance2);
//			this.target = int(info.@target);
//			this.target2 = int(info.@target2);
//			this.refer = int(info.@refer);
//			this.referKind = int(info.@referKind);
//			this.refer2 = int(info.@refer2);
//			this.referKind2 = int(info.@referKind2);
//			this.value = Number(info.@value);
//			this.percent = Number(info.@percent);
//			this.judge = int(info.@judge);
			this.skill = skill;
		}
		
		
		
		/**
		 * 前提判断，角色的技能前提是否满足
		 * @param user
		 * @return 
		 */
		public function judgeUserTrigger(compare1:Number, compare2:Number):Boolean{//user:ChessboardUserVO, user2:ChessboardUserVO=null):Boolean{
			return judgeT(compare1, compare2);
			
//			var compare1:Number = user.getRefer(this.refer, this.referKind);
//			var compare2:Number = this.value;
//			if(user2){
//				compare2 += user2.getRefer(this.refer2, this.referKind2)*this.percent;
//			}
//			return judgeT(compare1, compare2);
		}
		
		/**
		 * 两个角色参数比较
		 * @param c1	
		 * @param c2	
		 * @return 
		 */
		public function judgeT(c1:Number, c2:Number):Boolean{
			var triggerJudge:Boolean = false;
			switch(this.data.judge){
				case JUDGE_KIND_0:
					triggerJudge = true;
					break;
				case JUDGE_KIND_1:
					triggerJudge = c1==c2; 
					break;
				case JUDGE_KIND_2:
					triggerJudge = c1>c2;
					break;
				case JUDGE_KIND_3:
					triggerJudge = c1<c2;
					break;
				case JUDGE_KIND_4:
					triggerJudge = c1>=c2;
					break;
				case JUDGE_KIND_5:
					triggerJudge = c1<=c2;
					break;
			}
			
			return triggerJudge;
		}
		
		
		
		//=====judgeKind===============================================
		/**
		 * 判断类型：无
		 */
		public static const JUDGE_KIND_0:int=0;
		/**
		 * 判断类型：等于
		 */
		public static const JUDGE_KIND_1:int=1;
		/**
		 * 判断类型：大于
		 */
		public static const JUDGE_KIND_2:int=2;
		/**
		 * 判断类型：小于
		 */
		public static const JUDGE_KIND_3:int=3;
		/**
		 * 判断类型：大于等于
		 */
		public static const JUDGE_KIND_4:int=4;
		/**
		 * 判断类型：小于等于
		 */
		public static const JUDGE_KIND_5:int=5;
		
		//=====trigger:前提===============================================
		/**
		 * 技能触发前提事件trigger
		 * @triggerID
		 */
		public static const SKILL_TRIGGER_SEND:String = "SKILL_TRIGGER_SEND";
		
		
//		private static var triggerKindIncrease:int = 0;
		/**
		 * 使用/棋子消除/被动触发时默认生效（无其他前提）
		 */
		public static const TRIGGER_KIND_0:int = 0;//triggerKindIncrease++;
		/**
		 * 持续生效：新增时生效一次，消失时失效。增加属性点的buff就是持续生效的，被动技能将持续到战斗结束
		 */
		public static const TRIGGER_KIND_1:int = 1;//triggerKindIncrease++;
		/**
		 * 对局开始时,先发效果
		 */
		public static const TRIGGER_KIND_2:int = 2;//triggerKindIncrease++;
		/**
		 * 回合开始时,棋盘类型
		 */
		public static const TRIGGER_KIND_3:int = 3;//triggerKindIncrease++;
		/**
		 * 回合结束时
		 */
		public static const TRIGGER_KIND_4:int = 4;//triggerKindIncrease++;
		/**
		 * 被普攻命中后
		 */
		public static const TRIGGER_KIND_5:int = 5;//triggerKindIncrease++;
		/**
		 * 受到伤害前：触发效果一般是对伤害量改变
		 */
		public static const TRIGGER_KIND_6:int = 6;//triggerKindIncrease++;
		/**
		 * 吸收伤害阶段：受到伤害时计算伤害吸收量
		 */
		public static const TRIGGER_KIND_7:int = 7;//triggerKindIncrease++;
		/**
		 * 受到伤害后：触发效果一般是生成/触发buff
		 */
		public static const TRIGGER_KIND_8:int = 8;//triggerKindIncrease++;
		/**
		 * 受到治疗前：触发效果一般是对治疗量量改变
		 */
		public static const TRIGGER_KIND_9:int = 9;//triggerKindIncrease++;
		/**
		 * 受到治疗后：触发效果一般是生成/触发buff
		 */
		public static const TRIGGER_KIND_10:int = 10;//triggerKindIncrease++;
		/**
		 * 使用/触发某技能后触发
		 */
		public static const TRIGGER_KIND_11:int = 11;//triggerKindIncrease++;
		/**
		 * 技能抵抗时（不包括攻击）
		 */
		public static const TRIGGER_KIND_12:int = 12;//triggerKindIncrease++;
		/**
		 * 暴击时
		 */
		public static const TRIGGER_KIND_13:int = 13;//triggerKindIncrease++;
		/**
		 * 消除时，获得资源生效前（普攻阶段）
		 */
		public static const TRIGGER_KIND_14:int = 14;//triggerKindIncrease++;	
		/**
		 * 消除时，获得资源后
		 */
		public static const TRIGGER_KIND_15:int = 15;//triggerKindIncrease++;
		/**
		 * 某资源变化后，包括消除变化使用变化等等
		 */
		public static const TRIGGER_KIND_16:int = 16;//triggerKindIncrease++;
		/**
		 * 棋子数量变化时
		 */
		public static const TRIGGER_KIND_17:int = 17;//triggerKindIncrease++;
		/**
		 * 棋子buff生效时：棋盘类型
		 */
		public static const TRIGGER_KIND_18:int = 18;//triggerKindIncrease++;
		/**
		 * 棋子移动时：自己/敌人/任何人每次移动棋子
		 */
		public static const TRIGGER_KIND_19:int = 19;//triggerKindIncrease++;
		/**
		 * buff到期生效：buff持续回合数降到0即触发生效
		 */
		public static const TRIGGER_KIND_20:int = 20;//triggerKindIncrease++;
		/**
		 * buff收集值为0时：buff收集值降到0即触发生效
		 */
		public static const TRIGGER_KIND_21:int = 21;//triggerKindIncrease++;
		/**
		 * buff参照值为0时：buff参照值降到0即触发生效
		 */
		public static const TRIGGER_KIND_22:int = 22;//triggerKindIncrease++;
		/**
		 * 移除buff时，所在棋子消除时
		 */
		public static const TRIGGER_KIND_23:int = 23;//triggerKindIncrease++;
		/**
		 * 当前技能中的第一个effect前提满足时;
		 * 后续效果如果跟第一个效果前提一样就可以省去很多配置，也可以减少很多运算量，还可以多出一个对比条件
		 */
		public static const TRIGGER_KIND_24:int = 24;//triggerKindIncrease++;
	}
}