package com.view.UI.achievement{
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.PanelPointShowVO;
	import com.model.vo.config.mission.AchievementConfigVO;
	import com.model.vo.config.mission.MissionConfig;
	import com.model.vo.conn.ServerVO_180;
	import com.model.vo.conn.ServerVO_200;
	import com.model.vo.friend.FriendVO;
	import com.model.vo.task.TaskRecordVO;
	import com.model.vo.task.taskListVO;
	import com.view.BasePanel;
	import com.view.UI.item.ItemMainPanel;
	
	import flas.events.MouseEvent;
	
	/**
	 * 成就面板
	 * @author 饶境
	 */
	public class AchievementPanel extends BasePanel{
		public static const NAME:String="AchievementPanel";
		public static function getShowName(vo:FriendVO):String{
//			getInstance().updateInfoOfFriend(vo);
			return NAME;
		}
		private static const SINGLETON_MSG:String="single_AchievementPanel_only";
		private static var instance:AchievementPanel;
		public static function getInstance():AchievementPanel{
			if ( instance == null ) instance=new AchievementPanel();
			return instance;
		}
		
		private var serverVO_180:ServerVO_180;
		private var serverVO_200:ServerVO_200;
		
		
		
		
		
		/**
		 * 
		 * 
		 */		
		public function AchievementPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			achievementTagPanel.addEventListener(ItemMainPanel.E_ON_TAG, onTag);
			achievementTagPanel.updateInfo(tagArr);
			
			running_tag=AchievementConfigVO.TYPE_ACHIEVEMENT;
			achievements = MissionConfig.getInstance().achievements
//			running_voList = AchievementVO.genEmptyListOfAchVO();
			achievementListPanel.updateInfo(running_tag);
			this.addEventListener(MouseEvent.CLICK, onAchiBar);
			
			EventCenter.on(ApplicationFacade.QUEST_INFO_UPDATE, this, updateInfo);
			
			serverVO_180 = ServerVO_180.getInstance()
			serverVO_180.on(ApplicationFacade.SERVER_INFO_OBJ, this, updateHadGetReward);
			
			serverVO_200 = ServerVO_200.getInstance();
			serverVO_200.on(ApplicationFacade.SERVER_INFO_OBJ, this, updateRedPoint);
			
		}
		
		private function updateRedPoint(e:ObjectEvent):void{
			if(serverVO_200.isAchievementActive) {
				PanelPointShowVO.showPointGuide(AchievementPanel.NAME, true);
			}
		}
		
		
		/**
		 * 
		 */
		public static const ACHIEVEMENT_GET_INFO:String="ACHIEVEMENT_GET_INFO";
		/**
		 * 
		 */
		public static const ACHIEVEMENT_VERIFICATION:String="ACHIEVEMENT_VERIFICATION"; 
		/**
		 * 展示领取的成就奖励
		 */
		public static const ACHIEVEMENT_SHOW_REWARD:String="ACHIEVEMENT_SHOW_REWARD";
		
		
		
		public static const tagArr:Array = ["总 览","通 用","战 斗","解 谜"];
		/**
		 * 切页按钮面板
		 */
		public var achievementTagPanel:ItemMainPanel;
		public var achievementListPanel:AchievementListPanel
		public var isLoad:Boolean=false;
		/**
		 * 当前展示列表类型
		 */
		private var running_tag:int;
		/**
		 * 当前数据是否是自己的（不是好友的）
		 */
		private var running_is_self_achi:Boolean
//		private var running_voList:Array;
		
		private var achievements:Array;
		
		
		public function onAchiBar(e:*):void{
			if(e.target is AchievementBar){
				var tar:AchievementBar = e.target as AchievementBar;
				if(	running_is_self_achi==true && tar.running_vo.state==TaskRecordVO.STATE_FINISH_NO_REWARD){
					ServerVO_180.getSendGetReward(tar.running_vo.id);
				}
			}
		}
		private var updateFnArr:Array=[];
		
		public function onTag(e:ObjectEvent):void{
			switch(e.data as String) {
				case "总 览":
					this.running_tag = AchievementConfigVO.TYPE_ACHIEVEMENT;
					break;
				case "通 用":
					this.running_tag = AchievementConfigVO.TYPE_COMMON;
					break;
				case "战 斗":
					this.running_tag = AchievementConfigVO.TYPE_FIGHT;
					break;
				case "解 谜":
					this.running_tag = AchievementConfigVO.TYPE_PUZZLE;
					break;
			}
			achievementListPanel.updateInfo(running_tag);
		}
		/**
		 * 请求成就数据
		 * 
		 */							
		public function requestData():void{
			if(!isLoad){ 
				event(AchievementPanel.ACHIEVEMENT_GET_INFO);
			}
		}
		/**
		 * 更新数据，自己的
		 * @param voList
		 */							
		public function updateInfo(e:ObjectEvent=null):void{
			running_is_self_achi=true;
//			running_voList = voList;
			
			// 存在有奖励可以领取时，把成就表拉到顶
			
			if(taskListVO.canGetReward){
				running_tag = AchievementConfigVO.TYPE_ACHIEVEMENT;
				achievementTagPanel.reset();
			}
			achievementListPanel.updateInfo(running_tag);
		}
		/**
		 * 更新数据，好友的
		 * @param voList
		 */	 
		public function updateInfoOfFriend(voList:Array):void{
			running_is_self_achi=false;
//			for (var i:int = 0; i < voList.length; i++){
//				var achiVO:AchievementVO = voList[i] as AchievementVO;
//				for (var j:int = 0; j < achievements.length; j++){
//					var vo:AchievementConfigVO = achievements[j] as AchievementConfigVO;
//					if(vo.id==achiVO.questID){
//						vo=achiVO;
//					}
//				}
//			}
			achievementListPanel.updateInfo(running_tag);
		}
		
		public function updateHadGetReward(e:ObjectEvent):void{
			taskListVO.setRewarded(serverVO_180.id);
			
			
			var info:TaskRecordVO = taskListVO.getAchievementByID(serverVO_180.id);
//			var vo:AchievementVO = AchievementVO.getAchiVOByID(running_voList,questID);
//			if(vo == null){
//				return;
//			}
//			vo.setRewarded();
			achievementListPanel.updateInfo(running_tag);
//			var reward:AchRewardVO=vo.reward;
			event(AchievementPanel.ACHIEVEMENT_SHOW_REWARD, info);
			
			if(taskListVO.canGetReward){// 测试是否所有可获得奖励成就都完成了
				PanelPointShowVO.showPointGuide(AchievementPanel.NAME, false);//关闭小红点
			}
		}
//		private function updateByTag():void{
////			if(!running_voList) return;
//			achievementListPanel.updateInfo(running_tag)
//		}
	}
}