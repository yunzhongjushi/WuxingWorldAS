package com.model.vo.config.guide{
	import com.model.vo.BaseObjectVO;
	
	/**
	 * 引导任务配置信息
	 * @author hunterxie
	 */
	public class GuideConfig extends BaseObjectVO {
		public static const NAME:String = "GuideInfo";
		public static const SINGLETON_MSG:String = "single_GuideInfo_only";
		protected static var instance:GuideConfig;
		
		public static function getInstance():GuideConfig{
			if ( instance == null ) instance = new GuideConfig();
			return instance;
		}
		
		public static function updateObj(info:Object):GuideConfig{
			getInstance().updateObj(info);
			return instance;
		}
		
		/**
		 * 
		 */
		public var guides:Array = BaseObjectVO.getClassArray(GuideConfigVO);
		
		/**
		 * 
		 */
		public var asks:Array = BaseObjectVO.getClassArray(GuideAskConfigVO);
		
		
		/**
		 * 
		 * 
		 */
		public function GuideConfig(info:Object=null) {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			if(!info){
				info = BaseInfo.guideInfo;//JSON.parse(String(LoadProxy.getLoadInfo("guideInfo.json")));
			}
			instance.updateObj(info); 
		}
		
		/**
		 * 获取引导对话config
		 * 每次询问都重复利用同一个VO
		 * @param info	传入的引导配置VO
		 */
		public static function getGuideAsk(info:GuideConfigVO):GuideAskConfigVO{
			var vo:GuideAskConfigVO = getInstance().asks[info.kindID];
			vo.guideID = info.id;
			vo.kind = info.kind;
			return vo;
		}
		
		/**
		 * 判断满足条件的首个guide
		 * @param premise	前提ID
		 * @param id		对应的ID（如levelID）
		 * @choice			选择ID(引导触发对应的)
		 */
		public static function judgeGuidePremise(premise:int, id:int=0, choice:int=0):GuideConfigVO{
			for(var i:int=0; i<getInstance().guides.length; i++){
				var vo:GuideConfigVO = getInstance().guides[i];
				if(vo.premise==premise && vo.premiseID==id && vo.premiseChoice==choice){
					return vo; 
				}
			}
			return null;
		}
	}
}
