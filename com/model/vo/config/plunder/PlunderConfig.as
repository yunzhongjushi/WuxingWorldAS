package com.model.vo.config.plunder {import com.model.vo.BaseObjectVO;
import com.model.vo.config.lvs.LVCheckVO;
import com.model.vo.config.lvs.LVsConfig;
	
	/**
	 * 掠夺相关配置信息
	 * @author hunterxie
	 */
	public class PlunderConfig extends BaseObjectVO {
		public static const NAME:String = "PlunderConfig";
		public static const SINGLETON_MSG:String = "single_PlunderConfig_only";
		protected static var instance:PlunderConfig;
		
		public static function getInstance():PlunderConfig{
			if ( instance == null ) instance = new PlunderConfig();
			return instance;
		}
		
		public static function updateObj(info:Object):PlunderConfig{
			getInstance().updateObj(info);
			return instance;
		}
		
		/**
		 * 
		 */
		public var plunders:Array = BaseObjectVO.getClassArray(PlunderConfigVO);
		
		
		/**
		 * 
		 * 
		 */
		public function PlunderConfig(info:Object=null) {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			if(!info){
				info = BaseInfo.plunderConfigInfo;//JSON.parse(String(LoadProxy.getLoadInfo("PlunderConfig.json")));
			}
			instance.updateObj(info);
			
			for(var i:int=1; i<plunders.length-1; i++){
				(plunders[i] as PlunderConfigVO).next = plunders[i+1] as PlunderConfigVO;
			}
		}
		
		public static function checkLvInfo(num:int):PlunderConfigVO{
			var vo:LVCheckVO = LVsConfig.checkLvInfo(num, "score", getInstance().plunders);
			var plunder:PlunderConfigVO = instance.plunders[vo.LV];
			return plunder
		}
	}
}
