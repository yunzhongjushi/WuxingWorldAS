package com.view.UI.mail {
	import com.view.BasePanel;

	import flash.display.MovieClip;
	import flas.geom.Point;
	import flas.geom.Rectangle;
	import flash.text.TextField;

	import listLibs.TouchPadOptions;
	import listLibs.TouchPad;

	public class MailList extends BasePanel {
		public static const NAME:String="MailList";
		private static const SINGLETON_MSG:String="single_MailList_only";
		private static var instance:MailList;
		public static function getInstance():MailList {
			if(instance==null)
				instance=new MailList();
			return instance as MailList;
		}
		
		
		public function MailList(backClose:Boolean=true){
			super(backClose);
			
			if(instance!=null)
				throw Error(SINGLETON_MSG);
			instance=this;
			
		}
		//****************   以上为模板，请勿随意改动。   *******************************
		//Function Names
		public static const E_Close:String="E_Close";
		public static const E_BAR_CLICK:String="E_BAR_CLICK";
		//Event Names
		//场景含有组件
		public var tf_info:TextField;
		public var mc_cover:MovieClip;
		//
		public var running_voList:Array;
		public var barList:TouchPad

		public function updateInfo(voList:Array):void {
			if(barList==null) {
				var vo:TouchPadOptions=new TouchPadOptions(mc_cover.width, mc_cover.height, MailBar);

				//创建ListPanel
				barList=new TouchPad(vo);

				barList.x=mc_cover.x;

				barList.y=mc_cover.y

				this.addChild(barList);

				mc_cover.visible=false;
			}
			running_voList=voList
			barList.updateInfo(running_voList);
		}

		public function refreshVOList():void {

		}
	}
}
