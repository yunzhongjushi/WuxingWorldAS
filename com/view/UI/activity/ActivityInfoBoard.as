package com.view.UI.activity {
	import com.model.event.ObjectEvent;
	import com.model.vo.activity.ActivityVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flash.display.MovieClip;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	public class ActivityInfoBoard extends BasePanel {
		public function ActivityInfoBoard() {
			btn_delete.setNameTxt("删 除");
		}

		public function handle_click(e:*):void {
			switch(e.target) {
				case btn_close:
					this.close();
					break;
				case btn_delete:
					event(E_DELETE);
					break;
			}
		}
		//****************   以上为模板，请勿随意改动。   *******************************
		//Function Names
		public static const E_DELETE:String="E_DELETE";
		public static const E_BAR_CLICK:String="E_BAR_CLICK";
		//Event Names
		//场景含有组件
		public var mc_cover:MovieClip;
		public var btn_delete:CommonBtn;

		public var tf_title:TextField
		public var tf_active_id:TextField
		public var tf_start_date:TextField
		public var tf_end_date:TextField
		public var tf_last:TextField
		public var tf_questId:TextField
		public var tf_type:TextField
		public var tf_content:TextField
		public var tf_awar_content:TextField
		public var tf_description:TextField

//				public var barList:ListPanel
		public var running_vo:ActivityVO;

		public function updateInfo(a_vo:ActivityVO):void {
			set_running_vo(a_vo);
		}

		private function set_running_vo(vo:ActivityVO):void {
			running_vo=vo;
			tf_title.text=running_vo.title
			tf_active_id.text=String(running_vo.activeId)
			tf_start_date.text=running_vo.startDate
			tf_end_date.text=running_vo.endDate
			tf_last.text=running_vo.getLastStr()
			tf_questId.text=String(running_vo.questId);
			tf_type.text=running_vo.type
			tf_content.text=running_vo.content
			tf_awar_content.text=running_vo.getAwardContent()
			tf_description.text=running_vo.description
//					barList.updateInfo(running_vo.awardArr);
		}

		private function handle_bar_click(e:ObjectEvent):void {
//					var vo:ActivityAwardVO = e.data[ListBar.EVENT_DATA] as ActivityAwardVO;
		}

	}
}
