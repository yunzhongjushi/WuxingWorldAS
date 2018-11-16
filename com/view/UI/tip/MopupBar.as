package com.view.UI.tip {
	import com.model.vo.item.ItemVO;
	import com.model.vo.tip.MopupBarVO;
	import com.view.UI.item.ItemBarMiddle;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;

	import listLibs.ITouchPadBar;


	public class MopupBar extends MovieClip implements ITouchPadBar {
		public var item_site:MovieClip;
		public var tf_label:TextField;
		public var tf_exp:TextField;
		public var mopupBar_bg:MovieClip;
		public var mopupBar_line:MovieClip;

//		public var barBottom:Bitmap;

		public var rVO:MopupBarVO

		public function MopupBar() {
			super();
			this.mouseChildren=false;
			item_site.visible=false;

//			barBottom = new Bitmap(new BitmapData(1,1,true,0x00FFFFFF)) ;
//			this.addChild(barBottom);
		}

		public function updateInfo(_vo:*):void {
			rVO=_vo as MopupBarVO;
			if(rVO.itemArr.length==0)
				return;

			if(rVO.state==MopupBarVO.STATE_HIDE) {
				this.visible=false;
			}
			if(rVO.state==MopupBarVO.STATE_SHOW) {
				this.visible=true;
			}
			if(rVO.state==MopupBarVO.STATE_SHOW_ITEM) {
				this.visible=true;
				startShow();
			}
			tf_label.text="第 "+(rVO.mopupNO+1)+" 次扫荡，获得：";
			tf_exp.text="+"+rVO.addExp;
		}
		private const itemNumInRow:int=4;
		private const itemIntervalX:int=110;
		private const itemIntervalY:int=105;
		private var count:int;
		private var step:int;
		private var showItemArr:Array;

		private function startShow():void {
			showItemArr=[];
			var itemBar:ItemBarMiddle
			var ix:int=0;
			var iy:int=0;

			for(var i:int=0; i<rVO.itemArr.length; i++) {
				ix=i%itemNumInRow;
				iy=Math.floor(i/itemNumInRow);
				itemBar=new ItemBarMiddle();
				itemBar.x=ix*itemIntervalX+item_site.x //+ itemBar.width/2;
				itemBar.y=iy*itemIntervalY+item_site.y //+ itemBar.height/2;
				itemBar.updateInfo(rVO.itemArr[i]);
				itemBar.visible=false;
				this.addChild(itemBar);
				showItemArr.push(itemBar);
			}
			mopupBar_bg.height=185+iy*itemIntervalY;
			mopupBar_line.y=187+iy*itemIntervalY;
//			barBottom.x = 0; 
//			barBottom.y = itemBar.y + itemIntervalY - barBottom.height;
			count=0;
			step=0;
			this.addEventListener(Event.ENTER_FRAME, handle_ef);
		}

		protected function handle_ef(e:Event):void {
			var maxCount:int=(step==0?20:5);
			if(count>=maxCount) {
				// action
				var t_itemVO:ItemVO=rVO.itemArr[step] as ItemVO;
				(showItemArr[step] as ItemBarMiddle).visible=true;
				count=0;
				step++;
				if(step>=showItemArr.length) {
					// end
					this.removeEventListener(Event.ENTER_FRAME, handle_ef);
					return;
				}
			} else {
				count++
			}
		}
	}
}
