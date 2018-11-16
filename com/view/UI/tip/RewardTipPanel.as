package com.view.UI.tip {
	import com.model.vo.task.TaskRewardVO;
	import com.view.BasePanel;
	
	import flash.events.Event;
	import flas.geom.Point;
	import flas.geom.Rectangle;
	
	import flash.display.MovieClip;
	
	import listLibs.TouchPad;
	import listLibs.TouchPadOptions;

	/**
	 * 扫荡获得奖励面板
	 * @author raojing
	 */
	public class RewardTipPanel extends BasePanel {
		public static const NAME:String="RewardTipPanel";
		private static const SINGLETON_MSG:String="single_RewardTipPanel_only";
		private static var instance:RewardTipPanel;

		public static function getInstance():RewardTipPanel {
			if(instance==null)
				instance=new RewardTipPanel();
			return instance as RewardTipPanel;
		}

		public static function showReward(reward:TaskRewardVO, title:String):void {
			getInstance().updateInfo(reward, title);
			getInstance().event(BasePanel.SHOW_PANEL);
		}

		public static const TITLE_REWARD:String="获得奖励";
		public static const TITLE_ITEM:String="获得物品";
		public static const TITLE_MOPUP:String="扫荡成功";

		private const ITEM_2_X_ARR:Array=[53, 213];
		private const ITEM_3_X_ARR:Array=[0, 133, 266];

		private const TO_3_ADD_Y:int=-80;
		private const TO_3_ADD_HEIGHT:int=150;
		private const TO_3_BTN_ADD_Y:int=-76;

		public var rewardTipTitle_arr:MovieClip;
		public var item_1:RewardBar;
		public var item_2:RewardBar;

		public var rewardTipPanle_BG9:MovieClip;

		public var mc_cover:MovieClip;

		private var reward:TaskRewardVO;
		public var barList:TouchPad

		public var rect_bg_origin:Rectangle;
		public var rect_title_origin:Rectangle;
		public var point_btn_close:Point;

		public function RewardTipPanel() {
			if(instance!=null)
				throw Error(SINGLETON_MSG);
			instance=this;

			point_btn_close=new Point();
			point_btn_close.x=btn_close.x;
			point_btn_close.y=btn_close.y;

			rect_bg_origin=new Rectangle();
			rect_bg_origin.x=rewardTipPanle_BG9.x;
			rect_bg_origin.y=rewardTipPanle_BG9.y;
			rect_bg_origin.width=rewardTipPanle_BG9.width;
			rect_bg_origin.height=rewardTipPanle_BG9.height;

			rect_title_origin=new Rectangle();
			rect_title_origin.x=rewardTipTitle_arr.x;
			rect_title_origin.y=rewardTipTitle_arr.y;
			rect_title_origin.width=rewardTipTitle_arr.width;
			rect_title_origin.height=rewardTipTitle_arr.height;
		}


		public function updateInfo(reward:TaskRewardVO, title:String):void {
			if(barList==null) {
				var vo:TouchPadOptions=new TouchPadOptions(mc_cover.width, mc_cover.height, RewardBar, 14, 3);
				barList=new TouchPad(vo);//创建ListPanel
				barList.x=mc_cover.x;
				barList.y=mc_cover.y
				mc_cover.visible=false;

				var index:int=this.getChildIndex(mc_cover);
				this.addChildAt(barList, index);
			}
			this.reward = reward;
			fitPanelBG();
			rewardTipTitle_arr.gotoAndStop(title);
		}

		private function fitPanelBG():void {
			if(reward.itemVOList.length==0) {
				item_1.visible=item_2.visible=barList.visible=false
				return;
			}

			var o_point:Point=new Point(mc_cover.x, mc_cover.y);
			item_1.visible=item_2.visible=barList.visible=true

			if(reward.itemVOList.length==1) {
				item_2.x=o_point.x+ITEM_3_X_ARR[1];
				item_1.visible=barList.visible=false;
				item_2.updateInfo(reward.itemVOList[0]);
				setShortPanel();
			}
			if(reward.itemVOList.length==2) {
				item_1.x=o_point.x+ITEM_2_X_ARR[0];
				item_2.x=o_point.x+ITEM_2_X_ARR[1];

				barList.visible=false;

				item_1.updateInfo(reward.itemVOList[0]);
				item_2.updateInfo(reward.itemVOList[1]);

				setShortPanel();
			}
			if(reward.itemVOList.length>=3) {
				item_1.visible=item_2.visible=false
				barList.updateInfo(reward.itemVOList);
				if(reward.itemVOList.length>3) {
					setLongPanel();
				} else {
					setShortPanel();
				}
			}
			/* mode_6:
			238,52, h480
			btn 425,528
			*/
			function setLongPanel():void {
				rewardTipPanle_BG9.y=rect_bg_origin.y;
				rewardTipPanle_BG9.height=rect_bg_origin.height;

				rewardTipTitle_arr.y=rect_title_origin.y;
				barList.y=mc_cover.y;
				btn_close.y=point_btn_close.y;
			}
			/* mode_3:
			238,132, h377
			btn 428,452
			*/
			function setShortPanel():void {
				rewardTipPanle_BG9.y=rect_bg_origin.y-TO_3_ADD_Y;
				rewardTipPanle_BG9.height=rect_bg_origin.height-TO_3_ADD_HEIGHT;

				rewardTipTitle_arr.y=rect_title_origin.y-TO_3_ADD_Y;
				barList.y=mc_cover.y-TO_3_ADD_Y;
				btn_close.y=point_btn_close.y-TO_3_BTN_ADD_Y;
			}
		}
		private const SLIDE_INTERVAL:int=40;
		private const BAR_HEIGHT:int=145;
		private var count:int;
		private var totalRow:int

		protected function handle_ef(event:Event):void {
			if(count>=SLIDE_INTERVAL) {
				barList.toSlide(-1*BAR_HEIGHT);
				count=0;
				totalRow--;
				if(totalRow<=0) {
					this.removeEventListener(Event.ENTER_FRAME, handle_ef);
				}
			} else {
				count++;
			}
		}

	}
}
