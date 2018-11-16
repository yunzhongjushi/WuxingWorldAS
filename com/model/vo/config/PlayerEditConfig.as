package com.model.vo.config {
	import com.model.vo.BaseObjectVO;

	/**
	 * 玩家自创谜题配置信息
	 * @author hunterxie
	 */
	public class PlayerEditConfig extends BaseObjectVO {
		public static const NAME:String = "PlayerEditConfig";
		public static const SINGLETON_MSG:String = "single_PlayerEditConfig_only";
		protected static var instance:PlayerEditConfig;
		
		public static function getInstance():PlayerEditConfig{
			if ( instance == null ) instance = new PlayerEditConfig();
			return instance;
		}
		
		
		
		/** 默认已经解锁可配置数 */
		public var unlockedBoardNum:int = 5;
		
		/** 最大可以解锁配置数，通过购买扩充 */
		public var totalBoardNum:int = 20;
		
		/** 可以编辑的技能数据，需要通过解锁 */
		public var buffSetArr:Array = [1,4,9,10,13,41,0];
		
		/** 解锁新棋盘需要的钻石数 */
		public var unlockBoardCost:int = 10;
		
		/**
		 * 
		 * 
		 */
		public function PlayerEditConfig(info:Object=null) {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			if(!info){
				info = BaseInfo.playerEditConfigInfo;//JSON.parse(String(LoadProxy.getLoadInfo("playerEditConfig.json")));
			}
			instance.updateObj(info);
		}
		
		
	}
}
