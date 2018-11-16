package com.model.vo.task {

	public class TaskEndVO {

		/**
		 * 是否胜利 0胜 1败 2平局
		 */
		public var isWin:int;

		/**
		 * 战斗时长 秒
		 */
		public var fightTime:int;

		/**
		 * 连击数
		 */
		public var comboMax:int;

		/**
		 * 当前hp
		 */
		public var hp:int;

		/**
		 * 最大hp
		 */
		public var maxHp:int;

		/**
		 * 各属性魔法值 各属性:魔法值
		 */
		public var mp:Array;

		/**
		 * 
		 */
		public var maxMp:Array;

		/**
		 * 战利品 ID:数量
		 */
		public var rewardArr:Object;

		/**
		 * 使用技能  技能ID:次数
		 */
		public var skillTimes:int;

		/**
		 * N次M连击  M连击:N次数 
		 */
		public var comboObj:Object;

		/**
		 * 关卡ID
		 */
		public var MissionId:int;

		/**
		 * 关卡类型
		 */
		public var MissionType:int;

		/**
		 * 是否为新关卡
		 */
		public var isNewMission:Boolean;

		
		/**
		 *
		 * 
		 * 
		 * 
		 * 
		 * 
		 * 
		 *  
		 * 
		 */
		public function TaskEndVO() {
			
		}
		
		/**
		 * 《AchMissionEndVO.as》
		 *
		 * @param isWin
		 * 是否胜利 0胜 1败 2平局
		 *
		 * @param fightTime
		 * 战斗时长 秒
		 *
		 * @param comboMax
		 * 最大连击数
		 *
		 * @param hp
		 * @param maxHp
		 * @param mp
		 * 数组arr:arr[0]-金元素，arr[1]-木元素，arr[2]-土元素，arr[3]-水元素，arr[4]-火元素
		 *
		 * @param maxMp
		 * 数组arr:arr[0]-金元素，arr[1]-木元素，arr[2]-土元素，arr[3]-水元素，arr[4]-火元素
		 *
		 * @param skillTimes
		 * 使用技能的次数
		 *
		 * @param comboObj
		 * 连击obj:obj[String(连击数)] = 连击次数
		 *
		 * @param MissionId
		 * 关卡ID
		 *
		 * @param MissionType
		 * 关卡类型
		 *
		 * @param isNewMission
		 * 是否是新关卡
		 *
		 */
		public function setup(isWin:int, fightTime:int, comboMax:int, hp:int, maxHp:int, mp:Array, maxMp:Array, skillTimes:int, comboObj:Object, MissionId:int, MissionType:int, isNewMission:Boolean):void {
			this.isWin=isWin;
			this.fightTime=fightTime;
			this.comboMax=comboMax;
			this.hp=hp;
			this.maxHp=maxHp;
			this.mp=mp;
			this.maxMp=maxMp;
			this.skillTimes=skillTimes;
			this.comboObj=comboObj;
			this.MissionId=MissionId;
			this.MissionType=MissionType;
			this.isNewMission=isNewMission;
		}
	}
}
