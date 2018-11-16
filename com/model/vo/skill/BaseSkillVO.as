package com.model.vo.skill {
	import com.model.vo.config.skill.SkillConfig;
	import com.model.vo.config.skill.SkillConfigVO;
	
	import flas.events.EventDispatcher;
	
	
	/**
	 * 基础技能数据结构，棋盘技能
	 * @author hunterxie
	 */
	public class BaseSkillVO extends EventDispatcher{
		/**
		 * 技能使用/触发成功
		 */
		public static const SKILL_USE_SUCCESS:String = "SKILL_USE_SUCCESS";
		/**
		 * 技能升级成功
		 */
		public static const SKILL_INFO_UPDATE:String = "SKILL_UPDATE_SUCCESS";
		
		/**
		 * 通用公共CD
		 */
		public static const PUBLIC_CD:int = 1;
		
		/**
		 * 刷新CD时间
		 */
		public static const CD_INFO_UPDATE:String = "CD_INFO_UPDATE";
		
		/**
		 * 默认技能图标(一个问号)
		 */
		public static const DEFAULT_SKILL_ICON:String = "默认";
		
		
		/**
		 * 技能模版数据
		 */
		public var data:SkillConfigVO;
		
		/**
		 * 包含能够决定一个技能的最基础信息
		 * @return 
		 */
		public function get baseInfo():SkillInfoBaseVO{
			return _baseInfo;
		}
		public function set baseInfo(value:SkillInfoBaseVO):void{
			_baseInfo = value;
			updateInfo(_baseInfo.ID, _baseInfo.LV);
		}
		protected var _baseInfo:SkillInfoBaseVO = new SkillInfoBaseVO;
		

		/**
		 * 用户技能ID，根据LV不同对应不同技能ID
		 */
		public function get ID():int{
			return baseInfo.ID;
		}
		public function set ID(value:int):void{
			this.baseInfo.ID = value;
		}
		

		public function get LV():int{
			return baseInfo.LV;
		}
		public function set LV(value:int):void{
//			if(this.ID==139){
//				trace("???");
//			}
			if(value>maxUpLV) value = maxUpLV;
			baseInfo.LV = value;
//			this.describe = String(data.describe);
			event(SKILL_INFO_UPDATE);
		}
		
		/**
		 * 最大可升级等级
		 */
		public function get maxUpLV():int{
			return _maxUpLV;
		}
		public function set maxUpLV(value:int):void{
			_maxUpLV = value;
		}
		private var _maxUpLV:int = 1;
		
		/**
		 * 技能图标
		 */
		public function get icon():String{
			if(!data) return DEFAULT_SKILL_ICON;
//			if(data.icon==BoardSkillVO.BOARD_ICON_KIND_LIGHT || data.icon==BoardSkillVO.BOARD_ICON_KIND_VORTEX){
//				return data.icon+"_"+data.wuxing;
//			}
			return data.icon;
		}
		/**
		 * 技能名称
		 */
		public var name:String="";
		
		/**
		 * 技能五行类型(会发生改变)
		 */
//		public var wuxing:String;
		/**
		 * 技能威力
		 */
//		public var power:int = 1;
		/**
		 * 技能装备位置（0:角色，1:精灵，2:棋子）
		 */
		public var equipKind:int = BaseSkillVO.EQUIP_KIND_2;
		/**
		 * 技能描述
		 */
		protected var _describe:String = "棋盘/角色技能";
		public function get describe():String{
			return _describe;
		}
		/**
		 * 技能类型（0:主动， 1:被动）
		 */
		public var useKind:int = 1;
		/**
		 * 效果类型（0:战斗效果，1:战斗buff，2:棋盘效果，3:棋盘buff）
		 */
//		public var effectKind:int = 2;
		
		
		/**
		 * 基础技能
		 * @param id
		 * @param lv
		 */
		public function BaseSkillVO(id:int, lv:int=1):void {
			updateInfo(id, lv);
		}
		
		public function updateInfo(id:int=0, lv:int=1):void {
			this.ID = id;
			this.LV = lv;
			this.data = SkillConfig.getSkillInfo(id);
//			this.wuxing = WuxingVO.getWuxing(data.wuxing, "", false);
			this._describe = data.describe;
			this.name = data.label;
			this.useKind = data.useKind;
			
			init();
		}
		
		protected function init():void{

		}
		
		public function clone():BaseSkillVO{
			return new BaseSkillVO(this.ID, this.LV);
		}
		
		
		//===useKind=============================================
		/**
		 * 使用：主动类型（玩家通过点击使用）
		 */
		public static const USE_KIND_ACTIVE:int=1;
		/**
		 * 使用：被动类型（主要为触发、或者持续整场战斗的buff）
		 */
		public static const USE_KIND_PASSIVE:int=0;
		
		//===equipKind=============================================
		/**
		 * 装备位置：玩家技能
		 */
		public static const EQUIP_KIND_0:int=0;
		/**
		 * 装备位置：精灵技能
		 */
		public static const EQUIP_KIND_1:int=1;
		/**
		 * 装备位置：棋子
		 */
		public static const EQUIP_KIND_2:int=2;
		
		//===buffPosition=============================================
		/**
		 * buff出现位置：精灵身上
		 */
		public static const BUFF_POSITION_0:int=0;
		/**
		 * buff出现位置：棋子位置1
		 */
		public static const BUFF_POSITION_1:int=1;
		/**
		 * buff出现位置：棋子位置2
		 */
		public static const BUFF_POSITION_2:int=2;
		/**
		 * buff出现位置：棋盘格子
		 */
		public static const BUFF_POSITION_3:int=3;
		
		
		//=====effectKind===============================================
		/**
		 * 效果类型：战斗效果
		 */
		public static const EFFECT_KIND_FIGHT_EFFECT:int=0;
		/**
		 * 效果类型：战斗buff
		 */
		public static const EFFECT_KIND_FIGHT_BUFF:int=1;
		/**
		 * 效果类型：棋盘效果
		 */
		public static const EFFECT_KIND_BOARD_EFFECT:int=2;
		/**
		 * 效果类型：棋盘buff
		 */
		public static const EFFECT_KIND_BOARD_BUFF:int=3;
		
		/**
		 * 判断类型是否是棋盘类型
		 * @param kind
		 * @return 
		 */
		public static function judgeBoardEffectKind(kind:int):Boolean{
			return (kind==BaseSkillVO.EFFECT_KIND_BOARD_EFFECT || kind==BaseSkillVO.EFFECT_KIND_BOARD_BUFF);
		}

		
		
		//===效果参照前提，用于触发判断、确定效果值=============================================
//		private static var skillReferNum:int = 0;
		/**
		 * 判断类型：某棋子数
		 */
		public static const REFER_KIND_0:int = 0;//skillReferNum++;
		/**
		 * 棋盘上棋子种类的数量
		 */
		public static const REFER_KIND_1:int = 1;//skillReferNum++;
		/**
		 * 精灵攻击力
		 */
		public static const REFER_KIND_2:int = 2;//skillReferNum++;
		/**
		 * 精灵(某五行)防御力
		 */
		public static const REFER_KIND_3:int = 3;//skillReferNum++;
		/**
		 * 精灵暴击率
		 */
		public static const REFER_KIND_4:int = 4;//skillReferNum++;
		/**
		 * 受到的伤害量
		 */
		public static const REFER_KIND_5:int = 5;//skillReferNum++;
		/**
		 * 受到的治疗量
		 */
		public static const REFER_KIND_6:int = 6;//skillReferNum++;
		/**
		 * 当前生命值
		 */
		public static const REFER_KIND_7:int = 7;//skillReferNum++;
		/**
		 * 最大生命值
		 */
		public static const REFER_KIND_8:int = 8;//skillReferNum++;
		/**
		 * 当前某MP,当前某元素数量
		 */
		public static const REFER_KIND_9:int = 9;//skillReferNum++;
		/**
		 * 某MP上限,某元素上限
		 */
		public static const REFER_KIND_10:int = 10;//skillReferNum++;
		/**
		 * 当前MP中最多的那个
		 */
		public static const REFER_KIND_11:int = 11;//skillReferNum++;
		/**
		 * 所有MP资源的和
		 */
		public static const REFER_KIND_12:int = 12;//skillReferNum++;
		/**
		 * 目标精灵的资源上限的总和
		 */
		public static const REFER_KIND_13:int = 13;//skillReferNum++;
		/**
		 * 目标精灵的五行属性
		 */
		public static const REFER_KIND_14:int = 14;//skillReferNum++;
		/**
		 * 当前得到的元素的数量
		 */
		public static const REFER_KIND_15:int = 15;//skillReferNum++;
		/**
		 * 当前得到的元素的五行
		 */
		public static const REFER_KIND_16:int = 16;//skillReferNum++;
		/**
		 * 当前消耗的元素的数量
		 */
		public static const REFER_KIND_17:int = 17;//skillReferNum++;
		/**
		 * 当前消耗的元素的五行
		 */
		public static const REFER_KIND_18:int = 18;//skillReferNum++;
		/**
		 * 消除棋子数：当前消除的棋子数量
		 */
		public static const REFER_KIND_19:int = 19;//skillReferNum++;
		/**
		 * 连消数：当前消除的连消数量
		 */
		public static const REFER_KIND_20:int = 20;//skillReferNum++;
		/**
		 * 连色消数：当前连续相同棋子消除的数量，通过移动棋子达到消除效果时
		 */
		public static const REFER_KIND_21:int = 21;//skillReferNum++;
		/**
		 * 目标精灵的某五行等级值
		 */
		public static const REFER_KIND_22:int = 22;//skillReferNum++;
		/**
		 * 目标精灵五行等级最大的那个
		 */
		public static const REFER_KIND_23:int = 23;//skillReferNum++;
		/**
		 * 目标精灵的五行等级的总和
		 */
		public static const REFER_KIND_24:int = 24;//skillReferNum++;
		/**
		 * 当前触发的的buff中的已收集值
		 */
		public static const REFER_KIND_25:int = 25;//skillReferNum++;
		/**
		 * 棋盘上buff总数
		 */
		public static const REFER_KIND_26:int = 26;//skillReferNum++;
		/**
		 * 判断精灵身上是否拥有buff类型为value的buff，返回0/1
		 */
		public static const REFER_KIND_27:int = 27;//skillReferNum++;
		/**
		 * 判断精灵身上是否没有buff类型为value的buff，返回0/1
		 */
		public static const REFER_KIND_28:int = 28;//skillReferNum++;
		/**
		 * 目标角色的某五行等级值
		 */
		public static const REFER_KIND_29:int = 29;//skillReferNum++;
		/**
		 * 回合某五行得分,回合结束时某五行总消除得分
		 */
		public static const REFER_KIND_30:int = 30;//skillReferNum++;
		/**
		 * 回合总得分,回合结束时根据精灵五行计算出的总消除得分
		 */
		public static const REFER_KIND_31:int = 31;//skillReferNum++;
		
	}
}