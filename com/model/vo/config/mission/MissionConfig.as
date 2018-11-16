package com.model.vo.config.mission {
	import com.model.vo.BaseObjectVO;
	
	
	/**
	 * 成就配置信息
	 * @author hunterxie
	 */
	public class MissionConfig extends BaseObjectVO {
		public static const NAME:String = "AchievementInfo";
		public static const SINGLETON_MSG:String = "single_AchievementInfo_only";
		protected static var instance:MissionConfig;
		
		public static function getInstance():MissionConfig{
			if ( instance == null ) instance = new MissionConfig();
			return instance;
		}
		
		public static function updateObj(info:Object):MissionConfig{
			getInstance().updateObj(info);
			return instance;
		}
		
		/**
		 * 成就内容分类汇总，包括
		 */
		public static var allAchievement:Object = {0:[]};
		public static function setAchievement(vo:AchievementConfigVO):void{
			allAchievement[vo.id] = vo;
			
			if(!allAchievement[vo.getKind()]){
				allAchievement[vo.getKind()] = [];
			}
			allAchievement[0].push(vo);
			allAchievement[vo.getKind()].push(vo);
		}
		/**
		 * 通过原始ID获取成就配置信息
		 * @param id
		 */
		public static function getAchievementConfigByID(id:int=0):AchievementConfigVO{
			getInstance();
			return allAchievement[id];
		}
		
		/**
		 * 某个类别的可获得总成就点数
		 */
		public static var totalScoreInfo:Object = {};
		
		/**
		 * 根据触发条件的成就分类
		 */
		public static var totalTriggerInfo:Object = {};
		
		
		
		/**
		 * 相关配置说明信息
		 */
		public var achievementConfig:Object;
		
		/**
		 * 
		 */
		public var achievements:Array = BaseObjectVO.getClassArray(AchievementConfigVO);
		
		
		/**
		 * 
		 * 
		 */
		public function MissionConfig(info:Object=null) {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			if(!info){
				info = BaseInfo.achievementConfigVO;//JSON.parse(String(LoadProxy.getLoadInfo("achievementInfo.json")));
//				updateByXML();
			}
			instance.updateObj(info);
			
			totalScoreInfo = {0:[]};
			totalTriggerInfo = {};
			for(var i:int=0; i<achievements.length; i++){
				var vo:AchievementConfigVO = achievements[i] as AchievementConfigVO;
				totalScoreInfo[vo.getKind()] = Math.floor(totalScoreInfo[vo.getKind()])+vo.score;
				totalScoreInfo[0] = Math.floor(totalScoreInfo[0])+vo.score;
				
				for(var j:int=0; j<vo.triggers.length; j++){
					var trigger:AchievementTriggerConfigVO = vo.triggers[j] as AchievementTriggerConfigVO;
					if(!totalTriggerInfo[trigger.tarID]){
						totalTriggerInfo[trigger.tarID] = [];
					}
					totalTriggerInfo[trigger.tarID].push(vo);
				}
			}
		}
		/**
		 * 某个类别的成就数组
		 * @param tag
		 */
		public static function getAchievementKindArr(kind:int):Array {
			return allAchievement[kind] as Array;
		}
		/**
		 * 包含某个触发条件的成就数组
		 * @param tag
		 */
		public static function getQuestConditionByType(trigger:int):Array {
			return totalTriggerInfo[trigger] as Array;
		}
		
	}
}
