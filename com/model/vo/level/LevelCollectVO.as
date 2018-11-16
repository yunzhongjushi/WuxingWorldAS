package com.model.vo.level{
	import com.model.logic.BaseGameLogic;
	
	/**
	 * 资源收集关卡数据结构
	 * @author hunterxie
	 */
	public class LevelCollectVO extends BaseGameLogic{
		public static const NAME:String = "LevelCollectVO";
		public static const SINGLETON_MSG:String="single_LevelCollectVO_only";
		protected static var instance:LevelCollectVO;
		public static function getInstance():LevelCollectVO{
			if ( instance == null ) instance=new LevelCollectVO();
			return instance;
		}
		
		/**
		 * 闯关需要得到的资源
		 * @see com.model.vo.QiuPoint
		 */
		public var tarResource:Object;
		
		
		
		public function LevelCollectVO(vo:LevelVO=null, gameID:int=0):void{
			super(vo);
			
			this.tarResource = vo.tarResource;
		}
		
		public static function newVO(lvInfo:LevelVO):LevelCollectVO{
			getInstance().initNew(lvInfo);
			
			return instance;
		}
	}
}