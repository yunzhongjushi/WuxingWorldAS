package com.model.vo.config.mission{
	import com.model.vo.BaseObjectVO;
	
	
	/**
	 * 成就配置信息
	 * @author hunterxie
	 */
	public class AchievementConfigVO extends BaseObjectVO{
		/**成就所有类别*/
		public static const TYPE_ACHIEVEMENT:int = 0;
		/**成就通用类型*/
		public static const TYPE_COMMON:int = 1;
		/**成就解谜类型*/
		public static const TYPE_PUZZLE:int = 2;
		/**成就战斗类型*/
		public static const TYPE_FIGHT:int = 3;
		/**日常任务类型*/
		public static const TYPE_DAILY:int = 6;
		/**通用任务类型*/
		public static const TYPE_STORY:int = 5;
		/**精灵任务类型*/
		public static const TYPE_FAIRY:int = 7;
		
		
		public function get id():int{
			return _id;
		}
		public function set id(value:int):void{
			_id = value;
			this._kind = Math.floor(id/1000);
			MissionConfig.setAchievement(this);
		}
		private var _id:int = 0;
		/**成就名字*/
		public var label:String = "成就";
		/**成就详细描述*/
		public var describe:String = "成就描述";
		/**成就(获得前提)类型*/
		private var _kind:int = 0;
		public function getKind():int{
			return _kind;
		}
		/**成就等级*/
		public var LV:int = -1;
		/**成就点数(获得)*/
		public var score:int = -1;
		/**成就已完成数量*/
		public var progress:int = 0;
		/**成就前提数组*/
		public var triggers:Array = BaseObjectVO.getClassArray(AchievementTriggerConfigVO);
		/**奖励信息数组*/
		public var rewards:Array = BaseObjectVO.getClassArray(AchievementRewardConfigVO);
		
		
		
		/**
		 * 
		 * @param info
		 */
		public function AchievementConfigVO(info:Object=null):void{
			super(info);
			MissionConfig.setAchievement(this);
		}
		
		/**
		 * 奖励文字描述信息
		 * @return 
		 */
		public function getRewardDescription():String {
			var str:String = "奖励:";
			for(var i:int=0; i<this.rewards.length; i++){
				var reward:AchievementRewardConfigVO = this.rewards[0] as AchievementRewardConfigVO;
				str += reward.label +":"+reward.num+"；";
			}
			return str;
		}
		
		public function updateByXML(info:XML, trigger:XML, reward:XML):void{
			this.id = info.@QuestID;
			this.label = info.@Title;
			this.describe = info.@Detail;
//			this.kind = parseInt(info.@Type);
			this.LV = parseInt(info.@Level);
			this.score = parseInt(info.@Score);
			this.progress = parseInt(info.@ProgressNum);
			
			var vo:AchievementTriggerConfigVO = new AchievementTriggerConfigVO();
			vo.updateByXML(trigger);
			triggers.push(vo);
			
			if(parseInt(reward.@RewardItemID_1)>0) {
				rewards.push(AchievementRewardConfigVO.getTestVO(parseInt(reward.@RewardItemID_1), parseInt(reward.@RewardItemNum_1)));
			}
			if(parseInt(reward.@RewardItemID_2)>0) {
				rewards.push(AchievementRewardConfigVO.getTestVO(parseInt(reward.@RewardItemID_2), parseInt(reward.@RewardItemNum_2)));
			}
			if(parseInt(reward.@RewardItemID_3)>0) {
				rewards.push(AchievementRewardConfigVO.getTestVO(parseInt(reward.@RewardItemID_3), parseInt(reward.@RewardItemNum_3)));
			}
			if(parseInt(reward.@RewardGP)>0) {
				rewards.push(AchievementRewardConfigVO.getTestVO(1, parseInt(reward.@RewardGP)));
			}
			if(parseInt(reward.@RewardGold)>0) {
				rewards.push(AchievementRewardConfigVO.getTestVO(4, parseInt(reward.@RewardGold)));
			}
			if(parseInt(reward.@RewardEnergy)>0) {
				rewards.push(AchievementRewardConfigVO.getTestVO(3, parseInt(reward.@RewardEnergy)));
			}
			if(parseInt(reward.@RewardJIN)>0) {
				rewards.push(AchievementRewardConfigVO.getTestVO(10, parseInt(reward.@RewardJIN)));
			}
			if(parseInt(reward.@RewardMU)>0) {
				rewards.push(AchievementRewardConfigVO.getTestVO(11, parseInt(reward.@RewardMU)));
			}
			if(parseInt(reward.@RewardTU)>0) {
				rewards.push(AchievementRewardConfigVO.getTestVO(12, parseInt(reward.@RewardTU)));
			}
			if(parseInt(reward.@RewardSHUI)>0) {
				rewards.push(AchievementRewardConfigVO.getTestVO(13, parseInt(reward.@RewardSHUI)));
			}
			if(parseInt(reward.@RewardHUO)>0) {
				rewards.push(AchievementRewardConfigVO.getTestVO(14, parseInt(reward.@RewardHUO)));
			}
		}
	}
}