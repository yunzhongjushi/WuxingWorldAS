package com.view.UI.friend {
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flash.display.MovieClip;
	import flas.events.MouseEvent;
	
	import listLibs.TouchPad;
	import listLibs.TouchPadOptions;

	public class FriendList extends BasePanel {
		public static const NAME:String="FriendList";
		private static const SINGLETON_MSG:String="single_FriendList_only";
		private static var instance:FriendList;
		
		public function FriendList() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			btn_addPanel.setNameTxt("添加好友");
			this.addEventListener(MouseEvent.CLICK, handle_click);
		}

		public function handle_click(e:*):void {
			switch(e.target) {
				case btn_open:
					event(E_Close);
					break;
				case btn_addPanel:
					event(E_OPEN_ADD);
					break;
			}
		}
		//****************   以上为模板，请勿随意改动。   *******************************
		//Function Names
		public static const E_Close:String="E_Close";
		public static const E_OPEN_ADD:String="E_OPEN_ADD";
		public static const E_BAR_CLICK:String="E_BAR_CLICK";
		//Event Names
		//场景含有组件
		public var btn_open:MovieClip;
		public var btn_addPanel:CommonBtn;
		public var mc_cover:MovieClip;
		//
		public var barList:TouchPad
//		public var running_voList:Array;

		public function updateInfo(voList:Array):void {
			if(barList==null) {
				var vo:TouchPadOptions=new TouchPadOptions(mc_cover.width, mc_cover.height, FriendBar);

				//创建ListPanel
				barList=new TouchPad(vo);

				barList.x=mc_cover.x;

				barList.y=mc_cover.y

				this.addChild(barList);

				mc_cover.visible=false;
			}
			barList.updateInfo(voList);
		}
	}
}
