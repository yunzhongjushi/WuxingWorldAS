package com.model.vo.config.skill{
	import com.model.vo.BaseObjectVO;
	
	
	/**
	 * 技能效果前提配置信息
	 * @author hunterxie
	 */
	public class SkillEffectTriggerConfigVO extends BaseObjectVO{
		/**
		 * 0	使用生效，只有主动技能<br>
			1	持续生效：增加属性点的buff就是持续生效的，被动技能将持续到战斗结束<br>
			2	对局开始,先发效果<br>
			3	回合开始,棋盘类型<br>
			4	回合结束:一方的回合开始等于另一方的回合结束<br>
			5	被普通攻击命中后<br>
			6	受到伤害前：一般是对伤害量改变<br>
			7	受到伤害前伤害计算结束后伤害吸收阶段<br>
			8	受到伤害后：一般是生成/触发buff<br>
			9	受到治疗前：一般是对治疗量量改变<br>
			10	受到治疗后：一般是生成/触发buff<br>
			11	主动技能使用生效之后<br>
			12	技能抵抗之后(不包括攻击)<br>
			13	攻击/技能暴击之后<br>
			14	通过消除获得元素前<br>
			15	通过消除获得元素后<br>
			16	某元素变化时(触发达到某个值——效果如金元素增加时金最大值加1),包括非消除获得的变动——比如debuff这段收集满之前你都得不到此元素<br>
			17	棋盘棋子变动时，如：X元素棋子数量达到x值时<br>
			18	棋子buff生效时：如每触发一个棋盘技能加100HP<br>
			19	棋子移动时：自己/敌人每次移动并消除棋子<br>
			20	到期生效：buff持续回合数降到0或者技能被移除时即触发生效<br>
			21	收集值为0时：buff收集值降到0即触发生效<br>
			22	参照值为0时：buff参照值降到0即触发生效<br>
			23	当前棋子有技能，在消除棋子时，棋子上触发新技能<br>
			24	当前技能中的第一个effect前提满足时<br>
			25	当前buff所在格子上的棋子消除时<br>
			26	当前buff所在棋子旁边有匹配(非技能)消除时<br>
		 */
		public var id:int = 14;
		
		/**
		 * 触发目标，谁发出的事件;<br>
		 * 等于0就相当于任何角色/精灵，比如对方4消时给对方生成一个技能！<br>
			0	无/棋盘<br>
			1	自己<br>
			2	第一个敌人<br>
			3	全体<br>
			4	全体除了自己<br>
			5	任一敌人<br>
			6	全体己方<br>
			7	全体敌方<br>
			8	生命最少敌人<br>
			9	生命最少队友<br>
			10	最后一个敌人<br>
			11	最后一个队友<br>
			12	buff使用者<br>
			13	效果触发者*/
		public var who:int = 0;
		
		/**针对目标类型生效，对应ID效果中的类型<br>
		 * 100	任意类型<br>
		 0	金<br>
		 1	木<br>
		 2	土<br>
		 3	水<br>
		 4	火<br>
		 5	空<br>
		 6	灰<br>
		 7	钻<br>
		 8	经<br>
		 9	五<br>
		 10	宝<br>
		 11	秘<br>
		 101	随精：当前使用精灵的五行<br>
		 102	随技：当前技能的五行<br>
		 103	随球：当前棋子的五行<br>
		 104	随消：当前消除的五行<br>
		 105	五行：任意五行*/
		public var kind:int = 100;
		
		/**
		 * 技能生效概率
		 */
		public var chance:Number = 1;
		
		/**
		 * 100级时技能生效概率
		 */
		public var chance2:Number = 1;

		/**
		 * 参照目标<br>
			0	无/棋盘<br>
			1	自己<br>
			2	第一个敌人<br>
			3	全体<br>
			4	全体除了自己<br>
			5	任一敌人<br>
			6	全体己方<br>
			7	全体敌方<br>
			8	生命最少敌人<br>
			9	生命最少队友<br>
			10	最后一个敌人<br>
			11	最后一个队友<br>
			12	buff使用者<br>
			13	效果触发者*/
		public var target:int = 0;
		
		/**
		 * 参照目标2,如果有这个那么就是目标1跟目标2对比<br>
			0	无/棋盘<br>
			1	自己<br>
			2	第一个敌人<br>
			3	全体<br>
			4	全体除了自己<br>
			5	任一敌人<br>
			6	全体己方<br>
			7	全体敌方<br>
			8	生命最少敌人<br>
			9	生命最少队友<br>
			10	最后一个敌人<br>
			11	最后一个队友<br>
			12	buff使用者<br>
			13	效果触发者*/
		public var target2:int = 0;
		
		/**
		 * 参照类型<br>
			0	棋盘某棋子数<br>
			1	棋子种类<br>
			2	某攻击力<br>
			3	某防御力<br>
			4	暴击率<br>
			5	受到的伤害量<br>
			6	受到的治疗量<br>
			7	当前生命值<br>
			8	生命上限<br>
			9	当前某MP<br>
			10	某MP上限<br>
			11	最大MP<br>
			12	MP总和<br>
			13	资源上限和<br>
			14	目标五行<br>
			15	得到的某元素量<br>
			16	得到的元素五行<br>
			17	消耗的某元素量<br>
			18	消耗的元素五行<br>
			19	消除某棋子数<br>
			20	某连消数<br>
			21	某连色消数<br>
			22	精灵某五行等级<br>
			23	最大五行等级<br>
			24	五行等级和<br>
			25	buff收集值<br>
			26	棋盘buff数<br>
			27	拥有某类buff<br>
			28	没有某buff<br>
			29	角色某五行等级<br>
			30	回合某五行得分<br>
			31	回合综合得分*/
		public var refer:int = 0;
		
		/**针对目标类型生效，对应ID效果中的类型<br>
		 * 100	任意类型<br>
		 0	金<br>
		 1	木<br>
		 2	土<br>
		 3	水<br>
		 4	火<br>
		 5	空<br>
		 6	灰<br>
		 7	钻<br>
		 8	经<br>
		 9	五<br>
		 10	宝<br>
		 11	秘<br>
		 101	随精：当前使用精灵的五行<br>
		 102	随技：当前技能的五行<br>
		 103	随球：当前棋子的五行<br>
		 104	随消：当前消除的五行<br>
		 105	五行：任意五行*/
		public var referKind:int = 100;
		
		/**参照类型2<br>
			0	棋盘某棋子数<br>
			1	棋子种类<br>
			2	某攻击力<br>
			3	某防御力<br>
			4	暴击率<br>
			5	受到的伤害量<br>
			6	受到的治疗量<br>
			7	当前生命值<br>
			8	生命上限<br>
			9	当前某MP<br>
			10	某MP上限<br>
			11	最大MP<br>
			12	MP总和<br>
			13	资源上限和<br>
			14	目标五行<br>
			15	得到的某元素量<br>
			16	得到的元素五行<br>
			17	消耗的某元素量<br>
			18	消耗的元素五行<br>
			19	消除某棋子数<br>
			20	某连消数<br>
			21	某连色消数<br>
			22	精灵某五行等级<br>
			23	最大五行等级<br>
			24	五行等级和<br>
			25	buff收集值<br>
			26	棋盘buff数<br>
			27	拥有某类buff<br>
			28	没有某buff<br>
			29	角色某五行等级<br>
			30	回合某五行得分<br>
			31	回合综合得分*/
		public var refer2:int = 0;
		
		/**针对目标类型生效，对应ID效果中的类型<br>
		 * 100	任意类型<br>
		 0	金<br>
		 1	木<br>
		 2	土<br>
		 3	水<br>
		 4	火<br>
		 5	空<br>
		 6	灰<br>
		 7	钻<br>
		 8	经<br>
		 9	五<br>
		 10	宝<br>
		 11	秘<br>
		 101	随精：当前使用精灵的五行<br>
		 102	随技：当前技能的五行<br>
		 103	随球：当前棋子的五行<br>
		 104	随消：当前消除的五行<br>
		 105	五行：任意五行*/
		public var referKind2:int = 100;
		
		/**效果值*/
		public var value:Number = 0;
		
		/**如果有参照值那么就是参照百分比*/
		public var percent:Number = 0;
		
		/**判定条件<br>
			0	无<br>
			1	等于<br>
			2	大于<br>
			3	小于<br>
			4	大于等于<br>
			5	小于等于*/
		public var judge:int = 0;
		
		
		/**
		 * 
		 * @param info
		 */
		public function SkillEffectTriggerConfigVO(info:Object=null):void{
			super(info);
			
		}


//		public function updateByXML(skill:XML):void{
//			this.id = int(skill.@id);
//			this.who = int(skill.@who);
//			this.kind = int(skill.@kind);
//			this.chance = Number(skill.@chance);
//			this.chance2 = Number(skill.@chance2);
//			this.target = int(skill.@target);
//			this.target2 = int(skill.@target2);
//			this.refer = int(skill.@refer);
//			this.referKind = int(skill.@referKind);
//			this.refer2 = int(skill.@refer2);
//			this.referKind2 = int(skill.@referKind2);
//			this.value = Number(skill.@value);
//			this.percent = Number(skill.@percent);
//			this.judge = int(skill.@judge);
//		}
	}
}