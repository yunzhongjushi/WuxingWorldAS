package com.view.UI.task {
	import com.view.BasePanel;
	
	import flash.display.MovieClip;
	import flas.events.MouseEvent;
	
	import listLibs.TouchPad;
	import listLibs.TouchPadOptions;

	public class TaskListPanel extends BasePanel {
		public function TaskListPanel() {
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
		public var barList:TouchPad

		public function updateInfo(voList:Array):void {
			if(barList==null) {
				var vo:TouchPadOptions=new TouchPadOptions(mc_cover.width, mc_cover.height, TaskBar);
				//创建ListPanel
				barList=new TouchPad(vo);
				barList.x=mc_cover.x;
				barList.y=mc_cover.y;
				this.addChild(barList);
				mc_cover.visible=false;
			}
			barList.updateInfo(voList);
		}
	}
}
