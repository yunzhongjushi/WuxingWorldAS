package com.view.UI.activity {
	import com.model.event.ObjectEvent;
	import com.model.vo.activity.SignItemVO;
	import com.view.BasePanel;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flas.geom.Point;
	import flas.geom.Rectangle;

	import listLibs.TouchPadOptions;
	import listLibs.TouchPad;

	/**
	 * 
	 * @author hunterxie
	 */
	public class SignListPanel extends BasePanel {
		public var mc_cover:MovieClip;
		public var barList:TouchPad
		public var running_voList:Array;
		
		public function SignListPanel() {
			super();
		}

		public function updateInfo(voList:Array, gold:Object=null, resArr:Array=null):void {
			if(barList==null) {
				var vo:TouchPadOptions=new TouchPadOptions(mc_cover.width, mc_cover.height, SignBar, 10, 7);
				//创建ListPanel
				barList = new TouchPad(vo);
				barList.x = mc_cover.x;
				barList.y = mc_cover.y;
				this.addChild(barList);
			}
			running_voList=voList
			barList.updateInfo(running_voList);
			mc_cover.visible=false;
		}
	}
}
