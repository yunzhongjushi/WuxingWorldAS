package com.model.vo.config.wuxing {
	import com.model.vo.BaseObjectVO;
	
	/**
	 * 五行等级关卡五行相关配置信息
	 * @author hunterxie
	 */
	public class WuxingConfig extends BaseObjectVO {
		public static const NAME:String = "WuxingLevelLVInfo";
		public static const SINGLETON_MSG:String = "single_WuxingLevelLVInfo_only";
		protected static var instance:WuxingConfig;
		
		public static function getInstance():WuxingConfig{
			if ( instance == null ) instance = new WuxingConfig();
			return instance;
		}
		
		public static function updateObj(info:Object):WuxingConfig{
			getInstance().updateObj(info);
			return instance;
		}
		
		/**
		 * 五行等级对应配置信息
		 */
		public var wuxingLV:Array = BaseObjectVO.getClassArray(WuxingLVConfigVO);
		/**
		 * 关卡对应的五行产出配置信息
		 */
		public var levelLV:Array = BaseObjectVO.getClassArray(WuxingLevelConfigVO);
		
		
		/**
		 * 所有等级相关配置信息
		 */
		public function WuxingConfig(info:Object=null) {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			if(!info){
				info = BaseInfo.wuxingLvInfo;//JSON.parse(String(LoadProxy.getLoadInfo("wuxingLvInfo.json")));
			}
			instance.updateObj(info);
		}
		
		/**
		 * 五行等级对应相关信息: 
		 * @param lv	对应五行等级
		 * @return  
		 */
		public static function getWuxingInfo(lv:int):WuxingLVConfigVO{
			return getInstance().wuxingLV[lv];
		}
		
		/**
		 * 通过等级获取五行模块资源容量
		 * @param lv
		 */
		public static function getWuxingCapacity(lv:int):int{
			var vo:WuxingLVConfigVO = getWuxingInfo(lv);
			return vo.capacity;
		}
		
		/**
		 * 关卡等级对应相关信息: 
		 * @param lv	对应五行等级
		 */
		public static function getLevelInfo(lv:int):WuxingLevelConfigVO{
			return getInstance().levelLV[lv];
		}
		
		/**
		 * 通过等级获取关卡资源增长速度
		 * @param lv
		 */
		public static function getLevelIncreaseByLV(lv:int):int{
			var vo:WuxingLevelConfigVO = getLevelInfo(lv);
			return vo.increase;
		}
		
		/**
		 * 通过等级获取关卡资源容量
		 * @param lv
		 */
		public static function getLevelCapacity(lv:int):int{
			var vo:WuxingLevelConfigVO = getLevelInfo(lv);
			return vo.capacity;
		}
		
		
		/**
		 * 五行等级对应相关信息: 
		 * <wuxing lv="1" p_max="1000" p_inc="50" clear_3="30" f_max="180" f_base="27" f_inc="10"/>
		 * @param lv	对应五行等级
		 * @param name	对应字段名
		 * @return  
		 */
		//		public static function getWuxingLvInfo(lv:int, name:String):Number{
		//			wuxingLvInfo;
		//			return Number(_wuxingLvInfoArr[lv]["@"+name]);
		//		}
		
		/**
		 * 根据精灵等级计算精灵的五行值：五行等级=(精灵五行种族值*2+个体值+角色五行等级增量)*精灵等级/100+5；
		 * @param lv	
		 * @param value 
		 * @param lv	精灵等级
		 * @param v1	精灵的五行种族值
		 * @param v2	个体值
		 * @param v3	角色五行等级增量
		 * @return 
		 */
		//		public static function getFairyWuxing(lv:int, v1:int, v2:int=0, v3:int=0):int{
		//			if(lv==0){
		//				return 0;
		//			}
		//			return Math.ceil((v1*2+v2+v3)*lv/100+5);
		//		}
	}
}
