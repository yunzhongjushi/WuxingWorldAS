package com.view.UI.task {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.PanelPointShowVO;
	import com.model.vo.config.mission.AchievementConfigVO;
	import com.model.vo.config.mission.MissionConfig;
	import com.model.vo.conn.ServerVO_180;
	import com.model.vo.conn.ServerVO_199;
	import com.model.vo.conn.ServerVO_200;
	import com.model.vo.task.TaskRecordVO;
	import com.model.vo.task.taskListVO;
	import com.view.BasePanel;
	import com.view.UI.item.ItemMainPanel;
	
	import flas.events.MouseEvent;

	/**
	 * 任务面板
	 * @author 饶境
	 */
	public class TaskPanel extends BasePanel {
		public static const NAME:String="TaskPanel";
		public static function getShowName():String{
			ServerVO_199.getInfo()
			return NAME;
		}
		private static const SINGLETON_MSG:String="single_TaskPanel_only";
		private static var instance:TaskPanel;

		public static function getInstance():TaskPanel {
			if(instance==null)
				instance=new TaskPanel();
			return instance as TaskPanel;
		}

		
		public static const tagArr:Array = ["全 部", "日 常","剧 情"];
		
		public var taskTagPanel:ItemMainPanel;
		public var taskListPanel:TaskListPanel;

		private var running_isLoad:Boolean=false;
		private var running_voList:Array=[];
		private var running_tag:int;
		
		private var serverVO_180:ServerVO_180;
		private var serverVO_200:ServerVO_200;

		/**
		 * 任务面板
		 * 
		 */
		public function TaskPanel() {
			if(instance!=null)
				throw Error(SINGLETON_MSG);
			instance=this;

			running_tag = AchievementConfigVO.TYPE_DAILY;
			
			taskTagPanel.addEventListener(ItemMainPanel.E_ON_TAG, onTag);
			taskListPanel.addEventListener(TaskListPanel.E_CLOSE, close);
			this.addEventListener(MouseEvent.CLICK, onTaskBar);
			
			serverVO_180 = ServerVO_180.getInstance();
			serverVO_180.on(ApplicationFacade.SERVER_INFO_OBJ, this, updateHadGetReward);
			
			serverVO_200 = ServerVO_200.getInstance();
			serverVO_200.on(ApplicationFacade.SERVER_INFO_OBJ, this, onServ200);
			
			EventCenter.on(ApplicationFacade.ACHIEVEMENT_UPDATE_TASK, this, updateInfo);
			
		}
		
		private function onServ200(e:ObjectEvent):void{
			if(serverVO_200.isTaskActive) {
				PanelPointShowVO.showPointGuide(TaskPanel.NAME, true);
			}
		}

		private function onTaskBar(e:*):void {
			if(e.target is TaskBar) {
				var bar:TaskBar = e.target as TaskBar;
				var vo:TaskRecordVO = bar.running_vo as TaskRecordVO;
				if(vo.state!=TaskRecordVO.STATE_FINISH_REWARDED && vo.state!=TaskRecordVO.STATE_FINISH_NO_REWARD) {
					ServerVO_180.getSendGetReward(vo.id);
				}
			}
		}

		private function onTag(e:ObjectEvent):void {
			running_tag = e.data as int;
			refreshPanel();
		}

		public function updateInfo(e:ObjectEvent=null):void {
			running_voList = taskListVO.getOpenedArr();
			taskTagPanel.updateInfo(tagArr);
			refreshPanel();// 当有奖励可以领取时，把表拉到顶

			if(taskListVO.canGetReward) {
				running_tag = AchievementConfigVO.TYPE_COMMON;
			} else {
				PanelPointShowVO.showPointGuide(TaskPanel.NAME, false);
			}
		}

		public function updateHadGetReward(e:ObjectEvent):void {
			if(serverVO_180.rs && ServerVO_180.rGetReward) {
				running_voList = taskListVO.getOpenedArr();
				
	//			var info:AchievementRecordVO = AchievementListVO.getAchievementByID(serverVO_180.id);
	////			var vo:AchievementVO=AchievementVO.getAchiVOByID(running_voList, serverVO_180.id);
	//			if(info==null) {
	//				return;
	//			}
	//			var index:int=running_voList.indexOf(info);
	//			running_voList.splice(index, 1);
				
				refreshPanel();
				if(taskListVO.canGetReward) {// 测试是否所有可获得奖励成就都完成了
					PanelPointShowVO.showPointGuide(TaskPanel.NAME, false);
				}
			}
		}

		private function refreshPanel():void {
			if(this.stage==null)
				return;
//			var questArr:Array=AchievementVO.getListOfAchiVO(running_voList, running_tag);
			taskListPanel.updateInfo(MissionConfig.getAchievementKindArr(running_tag));
		}

	}
}
