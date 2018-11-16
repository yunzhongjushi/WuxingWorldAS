package com.model.logic {
	import com.model.event.ObjectEvent;
	import com.model.vo.BaseObjectVO;
	import com.model.vo.config.mission.AchievementConfigVO;
	import com.model.vo.config.mission.MissionConfig;
	import com.model.vo.level.LevelOverVO;
	import com.model.vo.level.LevelVO;
	import com.model.vo.task.TaskStoreVO;
	import com.model.vo.task.taskListVO;
	import com.model.vo.user.UserVO;

	/**
	 * 暂停开发于：2015-7-9
	 * 存储基本搞定，设置成就条件值的框架基本可用
	 * 具体的条件实现逻辑没写
	 */
	public class TaskLogic extends BaseObjectVO{
		private static var instance:TaskLogic;


		public static function getInstance():TaskLogic {
			if(instance==null)
				instance=new TaskLogic();
			return instance
		}

		private function get userInfo():UserVO {
			return UserVO.getInstance()
		}
		;

//		public function getStoreVOByID(id:int):AchStoreVO {
//			var vo:AchStoreVO = storeVOlist[id];
//			if(vo==null) {
//				vo = storeVOlist[id] = AchStoreVO.genEmpty(id);
//			}
//			return vo;
//		}

		/**
		 * 任务数组
		 */
		public var storeVOlist:Array = BaseObjectVO.getClassArray(TaskStoreVO);;
		
		/**
		 * 记录上次金币更新时的数据，用于判断任务完成情况
		 */
		public function get record_gold():int	{
			return _record_gold;
		}
		public function set record_gold(value:int):void{
			_record_gold = value;
		}
		private var _record_gold:int=-1;

		
		
		
		
		/**
		 * 
		 * 
		 */		
		public function TaskLogic(info:Object=null):void {
			super(info);
		}
		override public function updateObj(info:Object):void{
			super.updateObj(info);
			userInfo.on(UserVO.UPDATE_USER_INFO, this, refreshCoin);
		}

		/**
		 * 
		 * @param e
		 * 
		 */
		private function refreshCoin(e:ObjectEvent):void {//TODO:初始化(登录)时更新金币不应该触发,因为还没有数据
			if(record_gold!=-1) {
				var change:int=userInfo.gold-record_gold;
				if(change>0)
					updateFromCoinAdd(change);
			}
			record_gold = userInfo.gold;
		}

		/**
		 * 获取所有的成就与任务信息，并转化为数据包，用于本地模式下发送数据
		 * @return
		 */
		public function getTotalAchInfo():Object {
			var obj:Object={};
			var localNum:int=0;
			for each(var storeVO:TaskStoreVO in storeVOlist) {
				obj["LocalData"+localNum]=storeVO.getServerPack();
				localNum++;
			}
			return obj;
		}

//		public function setAchRewarded(id:int):void {
//			getStoreVOByID(id).isComplete=true;
//		}

		/**
		 * 调用：钻石增加时
		 * 对应成就条件：
		 * [1:1] 获得钻石的数量大于等于N
		 */
		public function updateFromCoinAdd(addNum:int):void {
			taskListVO.updateTrigger(1,addNum);
			
			
//			var xmllist:XMLList;
//			var conditionXML:XML
//
//			// [1:1] 解谜关卡、PVE结束，通过关卡ID为X的关卡次数大于等于N
//			if(true) {
//				xmllist=BaseInfo.getQuestConditionByType(1, 1);
//				for each(conditionXML in xmllist) {
//					updateCondition(conditionXML, addNum);
//				}
//			}
		}

		/**
		 * 调用：关卡或战斗完成后
		 *
		 * 对应成就条件：
		 *
		 * 完成任务，【日常类任务】完成次数大于等于N
		 *
		 */
		public function updateFromAchAndTaskComplete():void {
		}

		/**
		 * 调用：获得新的精灵时
		 *
		 * 对应成就条件：
		 *
		 * 	获得精灵的数量大于等于N
		 *	金属性精灵的数量大于等于N
		 *	木属性精灵的数量大于等于N
		 *	土属性精灵的数量大于等于N
		 *	水属性精灵的数量大于等于N
		 *	火属性精灵的数量大于等于N
		 *	获得ID为X的精灵大于等于N
		 */
		public function updateFromFairyAdd():void {

		}

		/**
		 * 调用：成就或任务完成与领取奖励后
		 *
		 * 对应成就条件：
		 *
		* [5:1] 解谜关卡、PVE结束，通过关卡ID为X的关卡次数大于等于N
		* [6:1] PVE、PVP结束，累计赢了次数大于等于N
		* [7:1] PVE、PVP结束，累计输了次数大于等于N
		* [10:1] PVE、PVP结束，累计使用技能数量大于等于N
		* [11:1] PVE、PVP结束，当场使用技能数超过X的场数大于等于N
		* [14:1] PVE、PVP结束，五项魔法值全满的情况下赢了场数大于等于N
		* [18:1] 解谜关卡结束，累计输了场数大于等于N
		* [19:1] 解谜关卡结束，累计X秒通过场数大于等于N
		* [25:1] 解谜关卡、PVE、PVP结束，累计完成X消的次数大于等于N
		* [26:1] PVE、PVP结束，最高连击数超过X的次数大于等于N
		* [28:0] PVE、PVP结束，消除金棋子的数量大于等于N
		* [28:1] PVE、PVP结束，消除木棋子的数量大于等于N
		* [28:2] PVE、PVP结束，消除土棋子的数量大于等于N
		* [28:3] PVE、PVP结束，消除水棋子的数量大于等于N
		* [28:4] PVE、PVP结束，消除火棋子的数量大于等于N
		* [28:5] PVE、PVP结束，消除经验棋子的数量大于等于N
		* [28:6] PVE、PVP结束，消除钻石棋子的数量大于等于N
		* [28:7] PVE、PVP结束，消除灰色棋子的数量大于等于N
		* [29:1] 解谜关卡、PVE结束,通过解谜和PVE类关卡次数(重复也算)大于等于N
		* [29:2] 解谜关卡、PVE结束,通过解谜类关卡次数(重复也算)大于等于N
		* [29:3] 解谜关卡、PVE结束,通过PVE类关卡次数(重复也算)大于等于N
		* [30:1] 已通过关卡的数量(包括PVE和解谜，重复闯关不计)大于等于N
		 *
		 */
		public function updateFromLevelComplete(overVO:LevelOverVO):void {
			var levelVO:LevelVO;
			var gameVO:BaseGameLogic=overVO.gameVO;
//			var xmllist:XMLList;
//			var conditionXML:XML

			// [5:1] 解谜关卡、PVE结束，通过关卡ID为X的关卡次数大于等于N
			if(levelVO.configVO.isPuzzle) {
//				xmllist=BaseInfo.getQuestConditionByType(5, 1);
//				for each(conditionXML in xmllist) {
//					if(conditionXML.@Para1==String(overVO.levelID))
//						updateCondition(conditionXML, 1);
//				}
			}

			// [6:1] PVE、PVP结束，累计赢了次数大于等于N
			if(overVO.isWin) {
//				xmllist=BaseInfo.getQuestConditionByType(6, 1);
//				for each(conditionXML in xmllist) {
//					updateCondition(conditionXML, 1);
//				}
			} else {
				// [7:1] PVE、PVP结束，累计输了次数大于等于N
//				xmllist=BaseInfo.getQuestConditionByType(7, 1);
//				for each(conditionXML in xmllist) {
//					updateCondition(conditionXML, 1);
//				}
			}

			// [10:1] PVE、PVP结束，累计使用技能数量大于等于N
			if(true) {
//				xmllist=BaseInfo.getQuestConditionByType(10, 1);
//
//				// 总技能使用次数
//				var useSkillTimes:int=gameVO.totalSkillTime;
//
//				for each(conditionXML in xmllist) {
//					updateCondition(conditionXML, useSkillTimes);
//				}
			}

			// [11:1] PVE、PVP结束，当场使用技能数超过X的场数大于等于N
			if(true) {
//				xmllist=BaseInfo.getQuestConditionByType(11, 1);
//
//				// 总技能使用次数
//				var useSkillTimes:int=gameVO.totalSkillTime;
//
//				for each(conditionXML in xmllist) {
//					if(useSkillTimes>=conditionXML.@Para1)
//						updateCondition(conditionXML, 1);
//				}
			}

			// [14:1] PVE、PVP结束，五项魔法值全满的情况下赢了场数大于等于N
			// 该条不存在

			// [18:1] 解谜关卡结束，累计输了场数大于等于N
			if(levelVO.configVO.isPuzzle) {
//				xmllist=BaseInfo.getQuestConditionByType(11, 1);
//
//				// 总技能使用次数
//				var useSkillTimes:int=gameVO.totalSkillTime;
//
//				for each(conditionXML in xmllist) {
//					if(useSkillTimes>=conditionXML.@Para1)
//						updateCondition(conditionXML, 1);
//				}
			}

		}

		/**
		 * 某个成就积累增加
		 * @param conditionXML
		 * @param change
		 */
//		private function updateCondition(conditionXML:XML, change:int):void {
//			getStoreVOByID(int(conditionXML.@QuestID)).setCondition(int(conditionXML.@ConditionIndex), change)
//		}
	}
}