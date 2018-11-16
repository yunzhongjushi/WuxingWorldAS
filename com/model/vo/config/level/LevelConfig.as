package com.model.vo.config.level {
	import com.model.vo.BaseObjectVO;

	/**
	 * 关卡配置信息
	 * @author hunterxie
	 */
	public class LevelConfig extends BaseObjectVO {
		public static const NAME:String = "LevelConfig";
		public static const SINGLETON_MSG:String = "single_LevelConfig_only";
		protected static var instance:LevelConfig;

		public static function getInstance():LevelConfig{
			if ( instance == null ) instance = new LevelConfig();
			return instance;
		}
		
		public static function updateObj(info:Object):LevelConfig{
			getInstance().updateObj(info);
			return instance;
		}
		
		public static var allLevel:Object = {}; 
		public static function setLevel(vo:LevelConfigVO):void{
			allLevel[vo.ID] = vo;
		}
		public static function getLevelByID(id:int=0):LevelConfigVO{
			getInstance();
			return allLevel[id];
		}
		
		
		/**
		 * 
		 */
		public var baseLevels:Array = BaseObjectVO.getClassArray(LevelConfigVO);
		/**
		 * 
		 */
		public var highLevels:Array = BaseObjectVO.getClassArray(LevelConfigVO);
		/**
		 * 
		 */
		public var guides:Array = BaseObjectVO.getClassArray(LevelConfigVO);
		/**
		 * 基础动态关卡配置
		 */
		public var universals:Array = BaseObjectVO.getClassArray(LevelConfigVO);
		/**
		 * 闯关建筑
		 */
		public var builds:Array = BaseObjectVO.getClassArray(LevelConfigVO);
		
		
		/**
		 * 
		 * 
		 */
		public function LevelConfig(info:Object=null) {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			if(!info){
				info = BaseInfo.levelInfo;//JSON.parse(String(LoadProxy.getLoadInfo("levelInfo.json")));
			}
			instance.updateObj(info);
			LevelRewardConfigVO.setGeneralReward(infos.generalReward);
		}
		
//		public function updateByXML(info:XML):void{
//			var vo:LevelConfigVO;
//			baseLevels=[];
//			for (var i:int=0; i<info.level.length(); i++) {
//				vo = new LevelConfigVO();
//				vo.updateByXML(info.level[i]);
//				baseLevels.push(vo);
//			}
//			highLevels=[];
//			for (i=0; i<info.levels.length(); i++) {
//				vo = new LevelConfigVO();
//				vo.updateByXML(info.levels[i]);
//				highLevels.push(vo);
//			}
//			guides=[];
//			for (i=0; i<info.guide.length(); i++) {
//				vo = new LevelConfigVO();
//				vo.updateByXML(info.guide[i]);
//				guides.push(vo);
//			}
//			universals=[];
//			for (i=0; i<info.universal.length(); i++) {
//				vo = new LevelConfigVO();
//				vo.updateByXML(info.universal[i]);
//				universals.push(vo);
//			}
//			builds=[];
//			for (i=0; i<info.build.length(); i++) {
//				vo = new LevelConfigVO();
//				vo.updateByXML(info.build[i]);
//				builds.push(vo);
//			}
//		}
		/**
		 * 获取关卡列表，用于展示下拉条
		 * @param id
		 * @return 
		 */
//		public function getChooseNameData():Array{
//			var arr:Array = [];
//			for(var i:int=0; i<baseLevels.length; i++){
//				var vo:LevelConfigVO = baseLevels[i]
//				arr.push({label:vo.name+"("+vo.ID+")"});
//			}
//			return arr;
//		}
		
		/**
		 * 地图上展示多少个关卡
		 * @return 
		 */
		public static function get levelLength():int{
			return 34;//
			return getInstance().baseLevels.length;
		}
		
		public function addLevel(kind:String="baseLevels"):LevelConfigVO{
			var vo:LevelConfigVO = new LevelConfigVO({id:baseLevels.length});
//			vo.ID = baseLevels.length;
			baseLevels.push(vo);
//			switch(kind){
//				case "baseLevels":
//					return baseLevels[id];
//				default:
//			}
			return vo;
		}
	}
}
