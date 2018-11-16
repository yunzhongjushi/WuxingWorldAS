package com.view.UI.shop {
	import com.view.BasePanel;

	import flash.display.MovieClip;
	import flas.geom.Point;
	import flas.geom.Rectangle;
	import flash.text.TextField;

	import listLibs.TouchPadOptions;
	import listLibs.TouchPad;

	public class ShopItemListPanel extends BasePanel {
		public static const E_BAR_CLICK:String="E_BAR_CLICK";

		/**
		 * 场景含有组件
		 */
		public var mc_cover:MovieClip;
		public var tf_gold:TextField;
		public var barList:TouchPad
		public var running_voList:Array;
		
		
		public function ShopItemListPanel() {
			
		}
		
		public function updateInfo(voList:Array):void {
			if(barList==null) {
				barList=new TouchPad(new TouchPadOptions(mc_cover.width, mc_cover.height, ShopItemBar, 10, 5));
				barList.x=mc_cover.x;
				barList.y=mc_cover.y
				this.addChild(barList);

				mc_cover.visible=false;
			}
			running_voList=voList
			barList.updateInfo(running_voList);
		}


	}
}
