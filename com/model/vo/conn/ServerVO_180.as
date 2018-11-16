package com.model.vo.conn
{
	import com.conn.MainNC;
	import com.model.proxy.BaseConnProxy;
	import com.model.vo.WuxingVO;
	
	/**
	 * 接收成就奖励
	 */
	public class ServerVO_180 extends BaseConnProxy{
		protected static var instance:ServerVO_180;
		public static function getInstance():ServerVO_180{
			if ( instance == null ) instance=new ServerVO_180();
			return instance;
		}
		
		public static const LOAD_GET_REWARD:String = "正在获取奖励...";
		
		public static var ID:int = 0xb4;
		public var returnCode:Boolean = true;
		private var deletedArr:Object;

		
		/**
		 * 玩家申请领取奖励，领到后变为false
		 */
		public static var rGetReward:Boolean=false;
		
		public function ServerVO_180(obj:Object=null) {
			super(obj);

			/* info
				id:已领取的Quest的id
				rs:是否成功，1为成功
			*/
//			id = info["id"];
//			rs = info["rs"] == "1"?true:false;
		}
		
		override public function updateObj(info:Object):void{
			super.updateObj(info);
			
			
			if(this.rs) {
				if(rGetReward) {
//					var achiVO:TaskRecordVO = taskListVO.getAchievementByID(vo180.id);
//					TipPanel.showPanel("收到奖励",achiVO.reward.getDescription(AchRewardVO.DESCRIPTION_TIP));
//					RewardTipPanel.showReward(achiVO.reward, RewardTipPanel.TITLE_REWARD);
				}
			}
			rGetReward=false;
		}
		
		public function getInfo():Object{
			return info;
		}
		/**
		 * 发送给server
		 * @return 
		 */
		public static function  getSendGetReward(questID:int):Boolean{
			rGetReward = true;
			return MainNC.getInstance().sendInfo(ID, {id:questID},LOAD_GET_REWARD);
		}
	}
}