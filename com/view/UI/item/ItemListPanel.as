package com.view.UI.item {
	import com.view.BasePanel;

	import flash.display.MovieClip;
	import flas.events.MouseEvent;

	import listLibs.TouchPad;
	import listLibs.TouchPadOptions;

	public class ItemListPanel extends BasePanel {
		public function ItemListPanel() {
			super();
			this.addEventListener(MouseEvent.CLICK, handle_click);
		}

		public function handle_click(e:*):void {
			switch(e.target) {
				case btn_close:
					event(E_CLOSE);
					break;
			}
		}
		//****************   以上为模板，请勿随意改动。   *******************************
		//Function Names
		public static const E_CLOSE:String="E_CLOSE";
		public static const E_BAR_CLICK:String="E_BAR_CLICK";
		//Event Names
		//场景含有组件
		public var mc_cover:MovieClip;
		//

		public var running_voList:Array;

		//
		public function updateInfo(voList:Array):void {
			set_running_voList(voList);
		}
		//
		private var barList:TouchPad;

		private function set_running_voList(arr:Array):void {
			if(barList==null) {
				var vo:TouchPadOptions=new TouchPadOptions(mc_cover.width, mc_cover.height, ItemBarMiddle, 10, 4);

				//创建ListPanel
				barList=new TouchPad(vo);

				barList.x=mc_cover.x;

				barList.y=mc_cover.y

				this.addChild(barList);

				mc_cover.visible=false;
			}
			running_voList=arr;
			barList.updateInfo(running_voList);
		}

	}
}
