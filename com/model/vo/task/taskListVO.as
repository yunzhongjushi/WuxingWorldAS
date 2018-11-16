package com.model.vo.task {
	import com.model.vo.BaseObjectVO;
	import com.model.vo.config.mission.AchievementConfigVO;
	import com.model.vo.config.mission.AchievementTriggerConfigVO;
	import com.model.vo.config.mission.MissionConfig;

	/**
	 * 成就信息管理；
	 * 包含对应成就的用户总数据；
	 * @author hunterxie
	 */
	public class taskListVO extends BaseObjectVO{
		public static const NAME:String = "AchievementListVO";
		public static const SINGLETON_MSG:String = "single_AchievementListVO_only";
		protected static var instance:taskListVO;
		
		public static function getInstance():taskListVO{
			if ( instance == null ) instance = new taskListVO();
			return instance;
		}
		
		
		public static var allAchievement:Object = {0:[]}; 
		public static function setAchievement(vo:TaskRecordVO):void{
			allAchievement[vo.id] = vo;
			
			if(!allAchievement[vo.getData().getKind()]){
				allAchievement[vo.getData().getKind()] = [];
			}
			allAchievement[0].push(vo);
			allAchievement[vo.getData().getKind()].push(vo);
		}
		
		public static function getAchievementByID(id:int=0):TaskRecordVO{
			getInstance();
			return allAchievement[id];
		}
		
		/**
		 * 某个类别的可获得总成就点数
		 */
		public static var totalScoreInfo:Object = {};
		
		
		/**
		 * 获取正在进行中的成就列表
		 * @return 
		 */
		public static function getOpenedArr():Array{
			getInstance();
			var arr:Array = [];
			for(var i:int=0; i<instance.achievements.length; i++){
				var vo:TaskRecordVO = instance.achievements[i] as TaskRecordVO;
				if(vo.state==TaskRecordVO.STATE_OPEN ||
					vo.state==TaskRecordVO.STATE_FINISH_NO_REWARD) {
					arr.push(vo);
				}
			}
			return arr;
		}
		
		
		/**
		 * 保存的成就数据
		 */
		public var achievements:Array = BaseObjectVO.getClassArray(TaskRecordVO);
		
		
		public function taskListVO(info:Object=null) {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;

			this.updateObj(info);
		}
		
		override public function updateObj(info:Object):void{
			super.updateObj(info);
			
			if(achievements.length==0){
				init();
			}
			totalScoreInfo = {};
			for(var i:int=0; i<achievements.length; i++){
				var vo:TaskRecordVO = achievements[i] as TaskRecordVO;
				totalScoreInfo[vo.getData().getKind()] = Math.floor(totalScoreInfo[vo.getData().getKind()])+vo.getTotalScore();
				totalScoreInfo[0] = Math.floor(totalScoreInfo[0])+vo.getTotalScore();
			}
		}
		
		
		/**
		 * 某个类别的成就数组
		 * @param tag
		 */
		public static function getAchievementKindArr(kind:int):Array {
			return allAchievement[kind] as Array;
		}
		
		public function init():void{
			var list:Array = MissionConfig.getInstance().achievements;
			for(var i:int=0; i<list.length; i++){
				var info:AchievementConfigVO = list[i] as AchievementConfigVO;
				var vo:TaskRecordVO = new TaskRecordVO({id:info.id});
				achievements.push(vo);
				setAchievement(vo);
			}
		}
		
		/**
		 * 判断是否有可以领取奖励的成就
		 * @return
		 */
		public static function get canGetReward():Boolean {
			getInstance();
			for(var i:int=0; i<instance.achievements.length; i++) {
				var achiVO:TaskRecordVO = instance.achievements[i] as TaskRecordVO;
				if(achiVO.state==TaskRecordVO.STATE_FINISH_NO_REWARD) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 根据前提ID改变目标任务完成度
		 * @param triggerID
		 * @param addNum
		 */
		public static function updateTrigger(triggerID:int, totalNum:int):void{
			var arr:Array = MissionConfig.getAchievementKindArr(triggerID);
			for(var i:int=0; i<arr.length; i++){
				var vo:AchievementConfigVO = arr[i] as AchievementConfigVO;
				var info:TaskRecordVO = getAchievementByID(vo.id);
				for(var j:int=0; j<vo.triggers.length; j++){
					var trigger:AchievementTriggerConfigVO = vo.triggers[j] as AchievementTriggerConfigVO;
					if(trigger.tarID==triggerID){
						if(totalNum>trigger.tarNum){
							totalNum = trigger.tarNum;
							if(info.state==TaskRecordVO.STATE_OPEN){
								info.state = TaskRecordVO.STATE_FINISH_NO_REWARD;
							}
						}
						info.triggers[j] = totalNum;
					}
				}
			}
		}
		
		/**
		 * 设置任务为完结状态（领取过奖励）
		 * @param id
		 */
		public static function setRewarded(id:int):void{
			var info:TaskRecordVO = getAchievementByID(id);
			info.state = TaskRecordVO.STATE_FINISH_REWARDED;
		}
	}
}
