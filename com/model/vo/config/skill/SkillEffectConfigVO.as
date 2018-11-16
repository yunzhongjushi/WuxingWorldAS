package com.model.vo.config.skill{
	import com.model.vo.BaseObjectVO;
	
	
	/**
	 * 技能效果配置信息
	 * @author hunterxie
	 */
	public class SkillEffectConfigVO extends BaseObjectVO{
		public var id:int = 0;
		
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
		
		/**生效类型，棋盘类型<br>
			0	战斗效果<br>
			1	战斗buff<br>
			2	棋盘效果<br>
			3	棋盘buff*/
		public var effectKind:int = 2;
		
		/**生效目标<br>
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
		public var targetKind:int = 100;
		
		/**参照目标<br>
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
		public var referTarget:int = 0;
		
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
		
		/**参照类型<br>
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
		
		/**效果值*/
		public var value:Number = 0;
		
		/**效果值(100级)*/
		public var value2:Number = 0;
		
		/**如果有参照值那么就是参照百分比增量*/
		public var percent:Number = 0;
		
		/**如果有参照值那么就是参照百分比增量(100级)*/
		public var percent2:Number = 0;
		
		/**生效前提*/
		public var trigger:SkillEffectTriggerConfigVO = new SkillEffectTriggerConfigVO;
		
		
		/**
		 * 
		 * @param info
		 */
		public function SkillEffectConfigVO(info:Object=null):void{
			super(info);
			
		}


//		public function updateByXML(skill:XML):void{
//			this.id = int(skill.@id);
//			this.kind = int(skill.@kind);
//			this.effectKind = int(skill.@effectKind);
//			this.target = int(skill.@target);
//			this.targetKind = int(skill.@targetKind);
//			this.referTarget = int(skill.@referTarget);
//			this.refer = int(skill.@refer);
//			this.referKind = int(skill.@referKind);
//			this.value = Number(skill.@value);
//			this.value2 = Number(skill.@value2);
//			this.percent = Number(skill.@percent);
//			this.percent2 = Number(skill.@percent2);
//			
//			this.trigger = new SkillEffectTriggerConfigVO();
//			this.trigger.updateByXML(skill.trigger[0]);
//		}
		
		/**
		 * kind:1<br>
		 * 某消除获得改变<br>
		 * exp、五行等棋盘消除获得的量(得分)改变，如果是角色技能的效果则直接改变得分，如果是精灵技能效果则计算完伤害后再改变	
		 */
		public static const board_effect_0:int = 0;
		/**
		 * kind:1<br>
		 * 随机消除某类<br>
		 * 随机value颗kind类棋子上增加id为value2的buff并消除	
		 */
		public static const board_effect_1:int = 1;
		/**
		 * kind:1<br>
		 * 随机变色某类<br>
		 * 随机把value颗kind类棋子变色为value2类型	
		 */
		public static const board_effect_2:int = 2;
		/**
		 * kind:1<br>
		 * 生成棋子buff<br>
		 * 随机value颗kind类棋子上增加id为value2的buff	
		 */
		public static const board_effect_3:int = 3;
		/**
		 * kind:1<br>
		 * 生成某棋子<br>
		 * 在消除的中心位置生成一颗kind类带value2技能的新棋子(某个任务收集棋子)
		 */
		public static const board_effect_4:int = 4;
		/**
		 * kind:0<br>
		 * 禁止生成<br>
		 * 下次消除结束后掉下来的棋子中不会新生成value2类棋子
		 */
		public static const board_effect_5:int = 5;
		/**
		 * kind:0<br>
		 * 静空领域<br>
		 * 消除后球不会下落，直到棋盘上所有可消棋子都消除后再生成新棋子下落
		 */
		public static const board_effect_6:int = 6;
		/**
		 * kind:0<br>
		 * 某棋子生成率改变<br>
		 * kind类五行棋子生成率改变，必须是棋盘配置中有的棋子
		 */
		public static const board_effect_7:int = 7;
		/**
		 * kind:0<br>
		 * 锁棋子<br>
		 * 阻止棋子被消除，且棋子不能交换，消除一次一层
		 */
		public static const board_effect_8:int = 8;
		/**
		 * kind:0<br>
		 * 阻止消除<br>
		 * 阻止棋子被消除
		 */
		public static const board_effect_9:int = 9;
		/**
		 * kind:0<br>
		 * 棋盘buff扩散<br>
		 * 棋盘buff扩散：复制当前buff到随机相邻棋子
		 */
		public static const board_effect_10:int = 10;
		/**
		 * kind:0<br>
		 * 炸弹1级<br>
		 *  [.,.,.,.,.,.,.]<br>[.,.,.,1,.,.,.]<br>[.,.,1,0,1,.,.]<br>[.,.,.,1,.,.,.]<br>[.,.,.,.,.,.,.]
		 */
		public static const board_effect_11:int = 11;
		/**
		 * kind:0<br>
		 * 炸弹2级<br>
		 *  [.,.,.,.,.,.,.]<br>[.,.,1,1,1,.,.]<br>[.,.,1,0,1,.,.]<br>[.,.,1,1,1,.,.]<br>[.,.,.,.,.,.,.]
		 */
		public static const board_effect_12:int = 12;
		/**
		 * kind:0<br>
		 * 炸弹3级<br>
		 *  [.,.,.,1,.,.,.]<br>[.,.,1,1,1,.,.]<br>[.,1,1,0,1,1,.]<br>[.,.,1,1,1,.,.]<br>[.,.,.,1,.,.,.]
		 */
		public static const board_effect_13:int = 13;
		/**
		 * kind:0<br>
		 * 炸弹4级<br>
		 *  [.,.,1,1,1,.,.]<br>[.,1,1,1,1,1,.]<br>[.,1,1,0,1,1,.]<br>[.,1,1,1,1,1,.]<br>[.,.,1,1,1,.,.]
		 */
		public static const board_effect_14:int = 14;
		/**
		 * kind:0<br>
		 * 横排1级<br>
		 *  [.,.,.,.,.,.,.,.]<br>[.,.,.,.,.,.,.,.]<br>[1,1,1,1,0,1,1,1]<br>[.,.,.,.,.,.,.,.]<br>[.,.,.,.,.,.,.,.]
		 */
		public static const board_effect_15:int = 15;
		/**
		 * kind:0<br>
		 * 横排2级<br>
		 *  [.,.,.,.,.,.,.,.]<br>[1,1,1,1,1,1,1,1]<br>[1,1,1,1,0,1,1,1]<br>[.,.,.,.,.,.,.,.]
		 */
		public static const board_effect_16:int = 16;
		/**
		 * kind:0<br>
		 * 横排3级<br>
		 *  [.,.,.,.,.,.,.,.]<br>[1,1,1,1,1,1,1,1]<br>[1,1,1,1,0,1,1,1]<br>[1,1,1,1,1,1,1,1]<br>[.,.,.,.,.,.,.,.]
		 */
		public static const board_effect_17:int = 17;
		/**
		 * kind:0<br>
		 * 竖排1级<br>
		 *  [.,.,.,.,1,.,.,.]<br>[.,.,.,.,1,.,.,.]<br>[.,.,.,.,1,.,.,.]<br>[.,.,.,.,1,.,.,.]<br>[.,.,.,.,0,.,.,.]<br>[.,.,.,.,1,.,.,.]<br>[.,.,.,.,1,.,.,.]<br>[.,.,.,.,1,.,.,.]
		 */
		public static const board_effect_18:int = 18;
		/**
		 * kind:0<br>
		 * 竖排2级<br>
		 *  [.,.,.,1,1,.,.,.]<br>[.,.,.,1,1,.,.,.]<br>[.,.,.,1,1,.,.,.]<br>[.,.,.,1,1,.,.,.]<br>[.,.,.,0,1,.,.,.]<br>[.,.,.,1,1,.,.,.]<br>[.,.,.,1,1,.,.,.]<br>[.,.,.,1,1,.,.,.]
		 */
		public static const board_effect_19:int = 19;
		/**
		 * kind:0<br>
		 * 竖排3级<br>
		 *  [.,.,.,1,1,1,.,.]<br>[.,.,.,1,1,1,.,.]<br>[.,.,.,1,1,1,.,.]<br>[.,.,.,1,1,1,.,.]<br>[.,.,.,1,0,1,.,.]<br>[.,.,.,1,1,1,.,.]<br>[.,.,.,1,1,1,.,.]<br>[.,.,.,1,1,1,.,.]
		 */
		public static const board_effect_20:int = 20;
		/**
		 * kind:0<br>
		 * 十字1级<br>
		 *  [.,.,.,.,.,.,.]<br>[.,.,.,1,.,.,.]<br>[.,.,.,1,.,.,.]<br>[.,1,1,0,1,1,.]<br>[.,.,.,1,.,.,.]<br>[.,.,.,1,.,.,.]<br>[.,.,.,.,.,.,.]
		 */
		public static const board_effect_21:int = 21;
		/**
		 * kind:0<br>
		 * 十字2级<br>
		 * [.,.,.,1,.,.,.]<br>[.,.,.,1,.,.,.]<br>[.,.,.,1,.,.,.]<br>[1,1,1,0,1,1,1]<br>[.,.,.,1,.,.,.]<br>[.,.,.,1,.,.,.]<br>[.,.,.,1,.,.,.]
		 */
		public static const board_effect_22:int = 22;
		/**
		 * kind:0<br>
		 * 十字3级<br>
		 * [.,.,.,.,1,.,.,.]<br>[.,.,.,.,1,.,.,.]<br>[.,.,.,.,1,.,.,.]<br>[.,.,.,.,1,.,.,.]<br>[1,1,1,1,0,1,1,1]<br>[.,.,.,.,1,.,.,.]<br>[.,.,.,.,1,.,.,.]<br>[.,.,.,.,1,.,.,.]
		 */
		public static const board_effect_23:int = 23;
		/**
		 * kind:0<br>
		 * 十字4级<br>
		 * [.,.,.,1,1,.,.,.]<br>[.,.,.,1,1,.,.,.]<br>[.,.,.,1,1,.,.,.]<br>[1,1,1,1,1,1,1,1]<br>[1,1,1,1,0,1,1,1]<br>[.,.,.,1,1,.,.,.]<br>[.,.,.,1,1,.,.,.]<br>[.,.,.,1,1,.,.,.]
		 */
		public static const board_effect_24:int = 24;
		/**
		 * kind:0<br>
		 * 上消1级<br>
		 * [.,.,.,1,.,.,.]<br>[.,.,.,1,.,.,.]<br>[.,.,.,1,.,.,.]<br>[.,.,.,1,.,.,.]<br>[.,.,.,0,.,.,.]
		 */
		public static const board_effect_25:int = 25;
		/**
		 * kind:0<br>
		 * 上消2级<br>
		 * [.,.,1,1,1,.,.]<br>[.,.,1,1,1,.,.]<br>[.,.,1,1,1,.,.]<br>[.,.,1,1,1,.,.]<br>[.,.,1,0,1,.,.]
		 */
		public static const board_effect_26:int = 26;
		/**
		 * kind:0<br>
		 * 右消1级<br>
		 * [.,.,.,.,.,.,.]<br>[.,.,.,.,.,.,.]<br>[0,1,1,1,1,1,1]<br>[.,.,.,0,.,.,.]<br>[.,.,.,.,.,.,.]
		 */
		public static const board_effect_27:int = 27;
		/**
		 * kind:0<br>
		 * 右消2级<br>
		 * [.,.,.,.,.,.,.]<br>[1,1,1,1,1,1,1]<br>[0,1,1,1,1,1,1]<br>[1,1,1,1,1,1,1]<br>[.,.,.,.,.,.,.]
		 */
		public static const board_effect_28:int = 28;
		/**
		 * kind:0<br>
		 * 下消1级<br>
		 * [.,.,.,0,.,.,.]<br>[.,.,.,1,.,.,.]<br>[.,.,.,1,.,.,.]<br>[.,.,.,1,.,.,.]<br>[.,.,.,1,.,.,.]
		 */
		public static const board_effect_29:int = 29;
		/**
		 * kind:0<br>
		 * 下消2级<br>
		 * [.,.,1,0,1,.,.]<br>[.,.,1,1,1,.,.]<br>[.,.,1,1,1,.,.]<br>[.,.,1,1,1,.,.]<br>[.,.,1,1,1,.,.]
		 */
		public static const board_effect_30:int = 30;
		/**
		 * kind:0<br>
		 * 左消1级<br>
		 * [.,.,.,.,.,.,.]<br>[.,.,.,.,.,.,.]<br>[1,1,1,1,1,1,0]<br>[.,.,.,.,.,.,.]<br>[.,.,.,.,.,.,.]
		 */
		public static const board_effect_31:int = 31;
		/**
		 * kind:0<br>
		 * 左消2级<br>
		 * [.,.,.,.,.,.,.]<br>[1,1,1,1,1,1,1]<br>[1,1,1,1,1,1,0]<br>[1,1,1,1,1,1,1]<br>[.,.,.,.,.,.,.]
		 */
		public static const board_effect_32:int = 32;
		/**
		 * kind:1<br>
		 * 模块激活<br>
		 */
		public static const board_effect_33:int = 33;
		/**
		 * kind:0<br>
		 * 叉消1级<br>
		 * [.,.,1,.,1,.,.]<br>.,.,.,0,.,.,.]<br>[.,.,1,.,1,.,.]
		 */
		public static const board_effect_34:int = 34;
		/**
		 * kind:0<br>
		 * 叉消2级<br>
		 * [.,2,.,.,.,2,.]<br>[.,.,1,.,1,.,.]<br>[.,.,.,0,.,.,.]<br>[.,.,1,.,1,.,.]<br>[.,2,.,.,.,2,.]
		 */
		public static const board_effect_35:int = 35;
		/**
		 * kind:0<br>
		 * 叉消3级<br>
		 * [3,.,.,.,.,.,3]<br>[.,2,.,.,.,2,.]<br>[.,.,1,.,1,.,.]<br>[.,.,.,0,.,.,.]<br>[.,.,1,.,1,.,.]<br>[.,2,.,.,.,2,.]<br>[3,.,.,.,.,.,3]
		 */
		public static const board_effect_36:int = 36;
		/**
		 * kind:1<br>
		 * 生成格子buff<br>
		 * 随机value颗kind类格子上增加id为value2的buff，buff固定由格子上的棋子消除而减少层数
		 */
		public static const board_effect_37:int = 37;
		/**
		 * kind:1<br>
		 * 合成棋子<br>
		 * 在消除的中心位置生成一颗kind类带value2技能的新棋子，相同ID的buff会叠加
		 */
		public static const board_effect_38:int = 38;
		/**
		 * kind:0；不判断棋子kind<br>
		 * buff加层<br>
		 * buff层数增加value层;消除时增加层棋子不消失，相当于合成;也可减少层(value为负)
		 */
		public static const board_effect_39:int = 39;
		
		/**
		 * kind:0；不判断棋子kind<br>
		 * 挖矿<br>
		 * buff层数减为0时如果棋子没有buff1则消除棋子
		 */
		public static const board_effect_40:int = 40;
		
		/**
		 * kind:0；不判断棋子kind<br>
		 * 阻止匹配<br>
		 * 不参与三消判断，如同灰色棋子
		 */
		public static const board_effect_41:int = 41;


		/**
		 * kind:1<br>
		 * 攻击<br>
		 * 攻击-得出数值为威力值
		 */
		public static const fairy_effect_100:int = 100;
		/**
		 * kind:1<br>
		 * 真实伤害<br>
		 * 不计攻击威力值防御的伤害
		 */
		public static const fairy_effect_101:int = 101;
		/**
		 * kind:1<br>
		 * 治疗<br>
		 * 治疗效果，增加HP
		 */
		public static const fairy_effect_102:int = 102;
		/**
		 * kind:0<br>
		 * AP改变<br>
		 * 攻击力计算基础值(AP)改变
		 */
		public static const fairy_effect_103:int = 103;
		/**
		 * kind:0<br>
		 * 某五行等级改变<br>
		 * 改变精灵五行等级值
		 */
		public static const fairy_effect_104:int = 104;
		/**
		 * kind:1<br>
		 * 造成伤害改变<br>
		 * 精灵造成的伤害量改变
		 */
		public static const fairy_effect_105:int = 105;
		/**
		 * kind:1<br>
		 * 受到伤害改变<br>
		 * 精灵受到的伤害量改变
		 */
		public static const fairy_effect_106:int = 106;
		/**
		 * kind:1<br>
		 * 受到治疗量改变<br>
		 * 受到的治疗效果改变
		 */
		public static const fairy_effect_107:int = 107;
		/**
		 * kind:1<br>
		 * 最大HP变化<br>
		 * 最大HP变化：上限(当前值根据上限变化的百分比改变)
		 */
		public static const fairy_effect_108:int = 108;
		/**
		 * kind:0<br>
		 * 设定HP值<br>
		 * 设定HP值：当前HP改变为指定值
		 */
		public static const fairy_effect_109:int = 109;
		/**
		 * kind:1<br>
		 * 当前某MP改变<br>
		 * 当前资源的改变
		 */
		public static const fairy_effect_110:int = 110;
		/**
		 * kind:1<br>
		 * 最大某MP改变<br>
		 * 最大金改变：上限(当前值根据上限变化的百分比改变)
		 */
		public static const fairy_effect_111:int = 111;
		/**
		 * kind:1<br>
		 * 某MP增长增速<br>
		 * 资源增长增速：AI的五行资源增长速度
		 */
		public static const fairy_effect_112:int = 112;
		/**
		 * kind:0<br>
		 * MP平均分配<br>
		 * MP总量平均分配
		 */
		public static const fairy_effect_113:int = 113;
		/**
		 * kind:1<br>
		 * 吸收某伤害护盾<br>
		 * 吸收伤害：永久护盾，MP/收集值降到0消失
		 */
		public static const fairy_effect_114:int = 114;
		/**
		 * kind:1<br>
		 * 禁魔某系<br>
		 * 禁魔：禁止使用X系/所有魔法
		 */
		public static const fairy_effect_115:int = 115;
		/**
		 * kind:1<br>
		 * 某技能免疫<br>
		 * 技能免疫：特定/所有技能抵抗护盾(有数量限制)	
		 */
		public static const fairy_effect_116:int = 116;
		/**
		 * kind:1<br>
		 * 改变某技能消耗<br>
		 * 改变技能消耗：增加敌人/降低自己的技能百分比消耗(敌人掐点配备的技能就使用不出了)
		 */
		public static const fairy_effect_117:int = 117;
		/**
		 * kind:1<br>
		 * 改变某技能CD<br>
		 * 改变技能CD：减少自己/增加敌人技能X秒/百分比回复时间
		 */
		public static const fairy_effect_118:int = 118;
		/**
		 * kind:0<br>
		 * 生成精灵buff<br>
		 * 为目标精灵生成1个ID为value2的buff，value为计算percent替换对应buff配置(回合数、生效数、收集值)
		 */
		public static const fairy_effect_119:int = 119;
		/**
		 * kind:1<br>
		 * 减少某buff<br>
		 * 减少buff一个：随机一个
		 */
		public static const fairy_effect_120:int = 120;
		/**
		 * kind:0<br>
		 * 昏迷<br>
		 * 对方不能行动，普攻+技能，不包括buff
		 */
		public static const fairy_effect_121:int = 121;
		/**
		 * kind:0<br>
		 * DP改变<br>
		 * 改变精灵的DP防御
		 */
		public static const fairy_effect_122:int = 122;

		

	}
}