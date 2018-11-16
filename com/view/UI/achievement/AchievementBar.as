package com.view.UI.achievement{	
	import com.model.vo.task.TaskRecordVO;
	import com.view.touch.CommonBtn;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import listLibs.ITouchPadBar;

	/**
	 * 单条成就信息
	 * @author hunterxie
	 */
	public class AchievementBar extends MovieClip implements ITouchPadBar{		
		private static const FRAME_ISCOMPLETE:int = 1;
		private static const FRAME_PROCESSING:int = 2;
		private static const FRAME_ISREWARD:int = 3;
		//场景元素
		public var tf_reward:TextField;
		public var tf_title:TextField;
		public var tf_description:TextField;
		public var tf_point:TextField;
		public var achProgress:MovieClip;
		public var achEmblem:MovieClip;   
		public var btn_get:CommonBtn;
		//
		public var running_vo:TaskRecordVO;
		
		 
		public function AchievementBar(){
			super();
			
			this.mouseChildren = false;
			
			btn_get.setNameTxt("领取奖励");
			tf_point = achEmblem["tf_point"];
			achEmblem.stop(); 
		}
		 
			
		public function updateInfo(_vo:*):void{
			running_vo = _vo as TaskRecordVO;

			var tf_current:TextField=achProgress.getChildByName("tf_current") as TextField
			var tf_target:TextField=achProgress.getChildByName("tf_target") as TextField
			tf_title.text = running_vo.getData().label;
			tf_point.text = String(running_vo.getData().score);
			tf_description.text = running_vo.getData().getRewardDescription();
			
			switch(running_vo.state){
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
			}
			setLevel(running_vo.getData().LV);
			tf_reward.text = running_vo.getData().describe;
		}
		private function statusTurn(isProcessing:Boolean=false,isComplete:Boolean=false):void{
			achProgress.visible=isProcessing
			btn_get.visible=isComplete   
		}
		private function setLevel(lv:int):void{
			if(lv>5){
				lv=5;
			}
			achEmblem.gotoAndStop(lv);
		}
		
	}
}