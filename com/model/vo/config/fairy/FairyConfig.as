package com.model.vo.config.fairy{
	import com.model.vo.BaseObjectVO;

	/**
	 * 关卡配置信息
	 * @author hunterxie
	 */
	public class FairyConfig extends BaseObjectVO {
		public static const NAME:String = "FairyInfo";
		public static const SINGLETON_MSG:String = "single_FairyInfo_only";
		protected static var instance:FairyConfig;

		public static function getInstance():FairyConfig{
			if ( instance == null ) instance = new FairyConfig();
			return instance;
		}
		
		public static function updateObj(info:Object):FairyConfig{
			getInstance().updateObj(info);
			return instance;
		}
		
		/**
		 * 初始化精灵时根据精灵模版ID作为下标存放至数组
		 * @param vo
		 */
		public static var allFairy:Object = {}; 
		public static function setFairy(vo:FairyConfigVO):void{
			allFairy[vo.id] = vo;
		}
		/**
		 * 通过原始ID获取精灵配置信息
		 * @param id
		 * @return 
		 * 
		 */
		public static function getFairyConfigByID(id:int=0):FairyConfigVO{
			getInstance();
			return allFairy[id];
		}
		/**
		 * 通过原始ID获取精灵名字
		 * @param id
		 * @return 
		 */
		public static function getFairyName(id:int):String{
			var fairy:FairyConfigVO = getFairyConfigByID(id);
			if(fairy){
				return fairy.label;
			}
			return "null";
		}
		/**
		 * 获取精灵强化等级
		 * @param lv
		 */
		public static function getFairyIntensLV(lv:int):Number{
			return getInstance().infos.fairyIntens[lv].value;
		}
		
		/**
		 * 
		 */
		public var fairys:Array = BaseObjectVO.getClassArray(FairyConfigVO);
		
		
		/**
		 * 
		 * 
		 */
		public function FairyConfig(info:Object=null) {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			if(!info){
				info = BaseInfo.fairyInfo;//JSON.parse(String(LoadProxy.getLoadInfo("fairyInfo.json")));
			}
			instance.updateObj(info);
		}
		
		/**
		 * 新增一个配置精灵
		 * @return 
		 */
		public function addFairy(id:int):FairyConfigVO{
			var vo:FairyConfigVO = new FairyConfigVO({id:id});
			fairys.push(vo);
			return vo;
		}
	}
}
