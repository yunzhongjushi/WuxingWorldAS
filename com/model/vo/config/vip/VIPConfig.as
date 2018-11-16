package com.model.vo.config.vip {
	import com.model.vo.BaseObjectVO;
	
	public class VIPConfig extends BaseObjectVO{
		public static const NAME:String = "VIPConfig";
		public static const SINGLETON_MSG:String = "single_VIPConfig_only";
		protected static var instance:VIPConfig;
		
		public static function getInstance():VIPConfig{
			if ( instance == null ) instance = new VIPConfig();
			return instance;
		}
		
		public static function updateObj(info:Object):VIPConfig{
			getInstance().updateObj(info);
			return instance;
		}
		
		
		
		/**
		 * VIP等级列表
		 */
		public var vips:Array = BaseObjectVO.getClassArray(VIPConfigVO);
		
		
		
		
		public static var maxVIPLVNum:int;

		/**
		 * 通过充值金额获取VIP等级
		 * @return 
		 */
		public static function getGameVIPLVByGold(gold:int):VIPConfigVO{
			getInstance();
			for(var i:int=instance.vips.length-1; i>0; i--){
				var vo:VIPConfigVO = instance.vips[i] as VIPConfigVO;
				if(vo.chager<gold){
					return vo;
				}
			}
			return instance.vips[0];
//			var xmllist:XMLList = gameVIPInfo.vipinfo.(int(@chager)<=gold);
//			return xmllist[xmllist.length()-1];
		}
		/**
		 * 获取对应等级的VIP信息
		 * @param lv
		 * @return 
		 */
		public static function getGameVIPByLV(lv:int):VIPConfigVO{
			if(getInstance().vips.length>lv){
				return instance.vips[lv] as VIPConfigVO;
			}
			return null;
		}
		
		
		
		public function VIPConfig(info:Object=null) {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			if(!info){
				info = BaseInfo.VIPInfo;//JSON.parse(String(LoadProxy.getLoadInfo("vipInfo.json")));
			}
			instance.updateObj(info);
		}
		
		public static function getTotalInfo():void{
			
		}
	}
}
