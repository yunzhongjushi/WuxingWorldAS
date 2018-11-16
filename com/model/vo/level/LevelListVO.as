package com.model.vo.level {
	import com.model.vo.BaseObjectVO;
	import com.model.vo.config.level.LevelConfig;
	import com.model.vo.config.wuxing.WuxingConfig;
	import com.model.vo.conn.level.LevelListReturnVO;
	import com.model.vo.user.UserVO;
	
	import flas.utils.utils;
	
	
	
	/**
	 * 静态变量关卡记录列表
	 * @author hunterxie
	 */
	public class LevelListVO extends BaseObjectVO{
		public static const NAME:String = "LevelListVO";
		public static const SINGLETON_MSG:String="single_LevelListVO_only";
		protected static var instance:LevelListVO;
		public static function getInstance():LevelListVO{
			if ( instance == null ) instance=new LevelListVO();
			return instance as LevelListVO;
		}
		
		public static function getLevelVO(id:int):LevelVO{
			var vo:LevelVO = getInstance().levelList[id];
			if(!vo) vo = LevelVO.getLevelVO(id);
			return vo;
		}
		
		/**
		 * 获得用户当前资源增长速度
		 * @return 
		 */
		public static function getIncreaseRes(wuxing:int):int{
			getInstance();
			var num:int = 0;
			for(var i:* in instance.levelList){
				var vo:LevelVO = instance.levelList[i] as LevelVO;
				if(vo.configVO.wuxing==wuxing){
					if(vo.baseInfo.wuxingLV>0){
						num+=WuxingConfig.getLevelIncreaseByLV(vo.baseInfo.wuxingLV);
					}
				}
			}
			return num;
		}
		
		/**
		 * 玩家获得的星星总数
		 * @return 
		 */
		public function get totalStarNum():int{
			var starnum:int = 0;
			
			for(var i:* in getInstance().levelList){
				var level:LevelVO = instance.levelList[i] as LevelVO;
				starnum += level.maxStarNum;
			}
			return starnum;
		}
		
		public static function updateServerGame(obj:Object):LevelVO{
			var vo:LevelVO = getLevelVO(obj.levelID);
			vo.gameID = obj.gameId;
			vo.initNum = parseInt(obj.initNum);
			vo.seed = parseInt(obj.seed);
			vo.skillInitNum = parseInt(obj.skillInit);
			vo.skillSeed = parseInt(obj.skillSeed);
			vo.levelChoiceVO.updateInfo(obj.levelID, obj.skills, obj.fairys);
			
			return vo;
		}
		
		/**
		 * 更新从server收到的列表信息
		 * @param obj
		 */
		public static function updateServerList(vo:LevelListReturnVO):void{
			getInstance().updateObj(vo.jsonInfo);
		}
		
		public static const UPDATE_LEVELS_INFO:String = "UPDATE_LEVELS_INFO";
		
		/**
		 * @see LevelVO
		 */
		private var levelList:Object = {};  
		
		/**
		 * 基础闯关信息,用于缓存/初始化
		 * @see com.model.vo.LevelBaseVO
		 */
//		public var levels:Array = BaseObjectVO.getClassArray(LevelSaveVO);
		public var levels:Object = {cls:LevelSaveVO};
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		
		/**
		 * @param levelID	
		 */
		public function LevelListVO() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			trace("开始初始化所有levels——"+utils.getTimer()+"ms");
			for(var i:int=0; i<LevelConfig.levelLength; i++){
				var level:LevelVO = levelList[i] = LevelVO.getLevelVO(i);
				levels[i] = level.baseInfo;
				var id1:int = i+10000;//高级关ID
				if(LevelConfig.getLevelByID(id1)){//存在config
					var level1:LevelVO = levelList[id1] = LevelVO.getLevelVO(id1);
					levels[id1] = level1.baseInfo;
				}
			}
			
			for(var k:String in levelList){//初始化完毕后整体判断一次开启前提
				var judgeLevel:LevelVO = levelList[k] as LevelVO;
				if(judgeLevel.configVO.trigger!=-1){
					judgeLevel.setTriggerLevel(levelList[judgeLevel.configVO.trigger]); 
				}
			}
			trace("结束处理levels——"+utils.getTimer()+"ms");
		}
		
		override public function updateObj(info:Object):void{
			super.updateObj(info);
			for(var i:* in levelList){
				var level:LevelVO = levelList[i] as LevelVO;
				if(level){
					level.updateInfo();
				}
			}
			event(UPDATE_LEVELS_INFO);
		}

		/**
		 * 返回一个二维数组，数组内容参考levelInfo.xml里的说明
		 * @param str
		 * @return 
		 */
		private function resolveLevelTarget(str:String):Array{
			var tarArr:Array = [];
			var arr:Array = str.split(",");
			for(var i:int=0; i<arr.length; i++){
				tarArr.push(String(arr[i]).split(":"));
			}
			
			return tarArr;
		}
		
		/**
		 * 通过关卡ID获取关卡VO
		 * @param levelID
		 * @return 
		 */
		public function getLevel(levelID:int):LevelVO{
			for(var i:* in levelList){
				var levelVo:LevelVO = levelList[i];
				if(levelVo.id == levelID){
					return levelVo;
				}
			}
			return null;
		}
		
		/**
		 * 根据装备ID返回能够掉落装备的所有关卡列表，如果返回列表长度为0即不会掉落
		 * @param equipID
		 * @return 
		 */
		public static function getItemDropLevels(equipID:int):Array{
			var arr:Array = [];
			for(var i:* in instance.levelList){
				var vo:LevelVO = instance.levelList[i] as LevelVO;
				if(vo.configVO.rewards.judgeHaveReward(equipID)){
					arr.push(vo);
				}
			}
			return arr;
		}
	}
}