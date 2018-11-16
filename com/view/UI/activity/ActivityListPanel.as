package com.view.UI.activity {
	import com.model.event.ObjectEvent;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flash.display.MovieClip;
	import flas.events.MouseEvent;

	public class ActivityListPanel extends BasePanel {
		public function ActivityListPanel() {
			btn_add.setNameTxt("添 加");
			this.addEventListener(MouseEvent.CLICK, handle_click);
		}

		public function handle_click(e:*):void {
			switch(e.target) {
				case btn_close:
					event(E_CLOSE);
					break;
				case btn_add:
					event(E_ADD);
					break;
			}
		}
		//****************   以上为模板，请勿随意改动。   *******************************
		//Function Names
		public static const E_CLOSE:String="E_CLOSE";
		public static const E_ADD:String="E_ADD";
		public static const E_BAR_CLICK:String="E_BAR_CLICK";
		//Event Names
		//场景含有组件
		public var mc_cover:MovieClip
		public var btn_add:CommonBtn;

//				public var barList:ListPanel
		public var running_voList:Array;

		public function updateInfo(voList:Array):void {
			running_voList=voList
//						barList.updateInfo(voList);
		}

		public function refreshList():void {
//					barList.refreshVOList();
		}

		private function handle_bar_click(e:ObjectEvent):void {
//					var vo:Object = e.data[ListBar.EVENT_DATA] as Object; 
//					event(E_BAR_CLICK,vo);
		}

	}
}
