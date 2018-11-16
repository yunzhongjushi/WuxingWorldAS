package com.model.vo.conn {
	import com.model.proxy.BaseConnProxy;
	import com.model.vo.config.mission.AchievementConfigVO;
	import com.model.vo.config.mission.MissionConfig;

	/**
	 * 收到成就完成信息，展示小红点
	 */
	public class ServerVO_200 extends BaseConnProxy{
		protected static var instance:ServerVO_200;
		public static function getInstance():ServerVO_200{
			if ( instance == null ) instance=new ServerVO_200();
			return instance;
		}
		
		public static var ID:int=0xc8;
		
		public var returnCode:Boolean=true;
		private var deletedArr:Object;


		public function ServerVO_200(obj:Object=null) {
			super(obj);
		}
		
		public function updateInfo(obj:Object):void{
			info=obj
			/* 	info内容
				任务QuestID的Array
			*/
			isAchievementActive=false;
			isTaskActive=false;

//			for (var i:String in info) 
//			{
//				if(i=="serverCMD") continue;
//				if(i=="code") continue;
			//
			var vo:AchievementConfigVO = MissionConfig.getAchievementConfigByID(parseInt(info["questId"]));
			if(vo.getKind()!=6){
				isAchievementActive=true;
			}
			if(vo.getKind()==6) {
				isTaskActive=true;
			}
//			}
		}

		public var isAchievementActive:Boolean=false;
		public var isTaskActive:Boolean=false;

	}
}
