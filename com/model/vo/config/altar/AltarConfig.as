package com.model.vo.config.altar {
	import com.model.vo.BaseObjectVO;

	/**
	 * 祭坛/抽奖配置
	 * @author hunterxie
	 * 
	 */
	public class AltarConfig extends BaseObjectVO{
		public static const NAME:String = "AltarConfig";
		public static const SINGLETON_MSG:String = "single_AltarConfig_only";
		protected static var instance:AltarConfig;
		
		public static function getInstance():AltarConfig{
			if ( instance == null ) instance = new AltarConfig();
			return instance;
		}
		
		public static function updateObj(info:Object):AltarConfig{
			getInstance().updateObj(info);
			return instance;
		}
		
		/**物品数量范围*/
		public var rangeItem:int;
		/**精灵数量范围*/
		public var rangeFairy:int;
		/**碎片数量范围*/
		public var rangePiece:int;
		/**精灵转碎片数量*/
		public var fairyToPiece:int;
		/**五行抽奖配置*/
		public var wuxing:AltarKindConfigVO;
		/**钻石抽奖配置*/
		public var gold:AltarKindConfigVO;
		

		
		/**
		 * 祭坛/抽奖配置
		 * @param info
		 */
		public function AltarConfig(info:Object=null) {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			if(!info){
				info = BaseInfo.altarInfo;//JSON.parse(String(LoadProxy.getLoadInfo("itemInfo.json")));
			}
			instance.updateObj(info);
		}
		
		public static function getTotalInfo():void{
			
		}
	}
}
