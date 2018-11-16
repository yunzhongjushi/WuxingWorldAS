package com.model.vo.config.lvs{
	import com.model.vo.BaseObjectVO;
	
	/**
	 * 所有等级相关配置信息
	 * @author hunterxie
	 */
	public class LVsConfig extends BaseObjectVO {
		public static const NAME:String = "LVsInfo";
		public static const SINGLETON_MSG:String = "single_LVsInfo_only";
		protected static var instance:LVsConfig;
		
		public static function getInstance():LVsConfig{
			if ( instance == null ) instance = new LVsConfig();
			return instance;
		}
		
		public static function updateObj(info:Object):LVsConfig{
			getInstance().updateObj(info);
			return instance;
		}
		
		/**
		 * 
		 */
		public var lvs:Array = BaseObjectVO.getClassArray(LVConfigVO);
		
		
		/**
		 * 所有等级相关配置信息
		 */
		public function LVsConfig(info:Object=null) {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			if(!info){
				info = BaseInfo.lvsInfo;//JSON.parse(String(LoadProxy.getLoadInfo("LVsInfo.json")));
			}
			instance.updateObj(info);
		}
		
//		private var checkArr:Array = [
//			"lv",
//			"playerExp",
//			"fairyExp0",
//			"fairyExp1",
//			"fairyExp2",
//			"fairyExp3",
//			"fairyExp4",
//			"fairyExp5"
//		]
//		public function testCheck(num:int):void{
//			var t:Number = getTimer();
//			for(var i:int=0; i<num; i++){
//				var vo:LVCheckVO = checkLvInfo(Math.floor(Math.random()*999999), checkArr[Math.floor(Math.random()*checkArr.length)]); 
//				if(i%100==0){
//					trace(vo.LV);
//				}
//			}
//			trace("测试经验值换取等级"+num+"次一共耗时："+(getTimer()-t)+"毫秒!!");
//		}
		
		/**
		 * 
		 * @param exp
		 * @param kind
		 * @return 
		 */
		public static function checkLvInfo(exp:Number, kind:String, lvs:Array=null):LVCheckVO{
			if(!lvs) lvs = getInstance().lvs;
			var isMax:Boolean = false;
			var vo:LVCheckVO = new LVCheckVO(exp);
			for(var i:int=lvs.length-1; i>1; i--){
				var max:Object = lvs[i];
				var last:Object = lvs[i-1];
				if(exp>=max[kind]){
					isMax = true;
					break;
				}else if(exp>=last[kind] && exp<max[kind]){
					break;
				}
			}
			vo.LV = isMax?max.lv:last.lv;
			vo.max = max[kind];
			vo.last = last[kind];
			return vo;
		}
		
	}
}
