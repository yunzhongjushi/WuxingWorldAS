package listLibs {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flas.events.MouseEvent;
	import flas.geom.Rectangle;

	public class TouchPad extends SlideContainer {
		public var options:TouchPadOptions

		public function TouchPad(vo:TouchPadOptions) {
			super(vo.listWidth, vo.listHeight, false);

			this.options=vo;

			list_o_x=vo.originPoint.x;
			list_o_y=vo.originPoint.y;

			container_o_x=vo.posiPoint.x;
			container_o_y=vo.posiPoint.y;

			list_viewRect=vo.viewRect;

			init();
			initList();
		}

		private var touchList:TouchList;

		public function initList():void {
			touchList=new TouchList(options);
			this.addList(touchList, 0, 4);
		}

		public function updateInfo(volist:Array):void {
			touchList.updateInfo(volist);
			this.refreshListArrY();
			this.refeshTotalHeight();
		}

		public function getSPbyVO(vo:Object):DisplayObject {
			return touchList.getSPbyVO(vo);
		}

		public function callFnOfBars(fnName, ... args):void {
			touchList.callFnOfBars(fnName, args);
		}

		public function appendVO(vo:*):Number {
			var slideY:int=touchList.appendVO(vo);
			this.refeshTotalHeight();
			return slideY;
		}
	}
}
