package com.model.vo.task {
	import com.model.vo.BaseObjectVO;
	import com.model.vo.config.mission.AchievementConfigVO;
	import com.model.vo.config.mission.MissionConfig;
	import com.model.vo.config.mission.AchievementTriggerConfigVO;

	/**
	 * 记录单个成就数据
	 * @author hunterxie
	 */
	public class TaskRecordVO extends BaseObjectVO{
		/**
		 * 成就状态——未初始化
		 */
		public static const STATE_NO_INIT:int = 0;
		/**
		 * 成就状态——进行中
		 */
		public static const STATE_OPEN:int = 1;
		/**
		 * 成就状态——完成未领奖
		 */
		public static const STATE_FINISH_NO_REWARD:int = 2;
		/**
		 * 成就状态——完成已领奖
		 */
		public static const STATE_FINISH_REWARDED:int = 3;
		
		
		
		public function get id():int{
			return _id;
		}
		public function set id(value:int):void{
			_id = value;
			this.setConfig(MissionConfig.getAchievementConfigByID(value));
		}
		private var _id:int = 0;
		
		/**
		 * 成就状态
		 */
		public var state:int = 0;
		
		/**
		 * 对应前提完成数据
		 */
		public var triggers:Array = [];
		
		private var data:AchievementConfigVO;
		
		public function TaskRecordVO(info:Object=null) {
			super(info);
		}
		
		/**
		 * 获得原始数据
		 */
		public function getData():AchievementConfigVO{
			return data;
		}
		
		/**
		 * 获得完成总数
		 */
		public function getTotalScore():int{
			var num:int=0;
			for(var i:int=0; i<triggers.length; i++){
				num+=triggers[i];
			}
			return num;
		}
		
		/**
		 * 获得标数总目
		 */
		public function getTarTotalScore():int{
			var num:int=0;
			for(var i:int=0; i<data.triggers.length; i++){
				num += (data.triggers[i] as AchievementTriggerConfigVO).tarNum;
			}
			return num;
		}
		
		/**
		 * 
		 * @param info
		 */
		public function setConfig(info:AchievementConfigVO):void{
			this.data = info;
			for(var i:int=0; i<info.triggers.length; i++){
				triggers.push(0);
			}
		}
		
		
	}
}
