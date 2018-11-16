package com.view.UI.task{	
	import com.model.vo.task.TaskRecordVO;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import listLibs.ITouchPadBar;
	
	public class TaskBar extends MovieClip implements ITouchPadBar{		
		private static const FRAME_ISCOMPLETE:int = 1;
		private static const FRAME_PROCESSING:int = 2;
		private static const FRAME_ISREWARD:int = 3;
		//场景元素
		public var tf_reward:TextField;
		public var tf_lv:TextField;
		public var tf_title:TextField;
		public var tf_description:TextField;
		public var tf_point:TextField;
		public var achProgress:MovieClip;
		//
		public var running_vo:TaskRecordVO;
		
		
		public function TaskBar(){
			super();
		}
		
		public function updateInfo(_vo:*):void{
			running_vo = _vo as TaskRecordVO;
			//
			var tf_current:TextField=achProgress.getChildByName("tf_current") as TextField
			var tf_target:TextField=achProgress.getChildByName("tf_target") as TextField
			//
			tf_title.text = running_vo.getData().label;;
			tf_description.text = running_vo.getData().describe;
			tf_reward.text = running_vo.getData().getRewardDescription();
			
			switch(running_vo.state)
			{
				case TaskRecordVO.STATE_NO_INIT:
				case TaskRecordVO.STATE_OPEN:
					statusTurn(true,false);
					tf_current.text = "完成数";
					tf_target.text = "目标数";
					
//					if(running_vo.progressID==AchievementVO.PROGRESS_NUMBER){//进度条类型,显示当前值和目标值，否则用0，1表示是否完成任务
						tf_current.text = "完成"+String(running_vo.triggers);
						tf_target.text = "目标"+String(running_vo.getTotalScore());
						if(running_vo.getTotalScore()>=running_vo.getTarTotalScore()){
							tf_current.text = "已完成";
							tf_target.text = "";
						}
//					}
//					if(running_vo.progressID==AchievementVO.PROGRESS_BOOLEAN){//进度条类型,显示当前值和目标值，否则用0，1表示是否完成任务
//						tf_current.text = running_vo.isComplete?"是":"否";
//						tf_target.text = "是否完成？"; 
//					} 
					break;
				case TaskRecordVO.STATE_FINISH_NO_REWARD:
					statusTurn(false,true);
					break;
				case TaskRecordVO.STATE_FINISH_REWARDED:
					statusTurn(false,false);
					break;
			}
			
			
		}
		private function statusTurn(isProcessing:Boolean=false,isGetReward:Boolean=false):void{
			achProgress.visible=isProcessing
		}
	}
}