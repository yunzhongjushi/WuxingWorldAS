package listLibs {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flas.events.EventDispatcher;
	import flas.geom.Rectangle;

	public class TouchList extends Sprite implements ITouchList {
		public var rVO:TouchPadOptions;


		public function TouchList(vo:TouchPadOptions) {
			this.rVO=vo;
		}

		private var rBarList:Array=[];
		private var rVOList:Array;
		private var rVODict:Object = {};

		public function updateInfo(volist:Array):void {
			this.rVOList = volist;

			var newList:Array=[];
			var bar:ITouchPadBar
			var vo:*

			var max:int=Math.max(volist.length, rBarList.length);
			for(var i:int=0; i<max; i++) {
				bar=rBarList[i] as ITouchPadBar;
				vo=volist[i];

				if(vo!=null) {
					if(bar==null) {
						var cl:Class=rVO.barClass;
						bar=new cl();
						this.addChild((bar as DisplayObject));
					}

					bar.updateInfo(vo);
					rVODict[vo]=bar;
					newList.push(bar);
				} else {
					if(bar) {
						(bar as DisplayObject).parent.removeChild((bar as DisplayObject));
					}
				}
			}
			rBarList=newList;
			refreshSite();
		}

		public function dispatchEventToBar(e:*):void {
			for(var i:int=0; i<rBarList.length; i++) {
				(rBarList[i] as EventDispatcher).dispatchEvent(e);
			}

		}

		public function getSPbyVO(vo:Object):DisplayObject {
			return rVODict[vo];
		}

		public function callFnOfBars(fnName:String, args:Array):void {
			for(var i:int=0; i<rBarList.length; i++) {
				var fn:Function;
				if(rBarList[i].hasOwnProperty(fnName)&&rBarList[i][fnName]!=null&&rBarList[i][fnName] is Function) {
					fn=rBarList[i][fnName] as Function;
					if(fn.length==0)
						fn();
					if(fn.length==1)
						fn(args[0]);
					if(fn.length==2)
						fn(args[0], args[1]);
					if(fn.length==3)
						fn(args[0], args[1], args[2]);
					if(fn.length==4)
						fn(args[0], args[1], args[2], args[3]);
					if(fn.length==5)
						fn(args[0], args[1], args[2], args[3], args[4]);
					if(fn.length>=6)
						fn(args[0], args[1], args[2], args[3], args[4], args[5]);
				}
			}
		}

		public function appendVO(vo:*):Number {

			var bar:ITouchPadBar
			var cl:Class=rVO.barClass;
			bar=new cl();

			bar.updateInfo(vo);
			rVODict[vo]=bar;

			var columnNO:int=getColumnNO();

			(bar as DisplayObject).x=columnNO*(rVO.barWidth+rVO.intervalX);

			(bar as DisplayObject).y=heightArr[columnNO];

			heightArr[columnNO]+=((bar as DisplayObject).height+rVO.intervalY);

			this.addChild((bar as DisplayObject));

//			rVOList.push(vo);
			rBarList.push(bar);

			return (bar as DisplayObject).height+rVO.intervalY;
		}

		private var heightArr:Array;

		public function refreshSite():void {
			var bar:DisplayObject
			heightArr=[];
			for(var j:int=0; j<rVO.columns; j++) {
				heightArr[j]=0;
			}
			var columnNO:int;
			for(var i:int=0; i<rBarList.length; i++) {
				columnNO=getColumnNO();

				bar=rBarList[i] as DisplayObject;

				bar.x=columnNO*(rVO.barWidth+rVO.intervalX);

				bar.y=heightArr[columnNO];

				heightArr[columnNO]+=(bar.height+rVO.intervalY);
			}
		}

		private function getColumnNO():int {
			if(rVO.columns==1)
				return 0;

			var no:int=0;
			for(var k:int=0; k<heightArr.length; k++) {
				if(heightArr[k]<heightArr[no]) {
					no=k;
				}
			}
			return no;
		}

		public function fixRect(viewRect:Rectangle):void {
			var bar:DisplayObject
			for(var i:int=0; i<rBarList.length; i++) {
				bar=rBarList[i] as DisplayObject;

				var testY:Number=bar.y+this.y;

				if(testY<viewRect.top||(testY+bar.height)>viewRect.bottom) {
					bar.visible=false;
				} else {
					bar.visible=true;
				}
			}
		}

//		public function getBar(listX:Number, listY:Number):DisplayObject
//		{
//			var bar:DisplayObject
//			for (var i:int = 0; i < rBarList.length; i++) 
//			{
//				bar = rBarList[i] as DisplayObject;
//				
//				var p:Point = bar.localToGlobal(new Point(bar.x,bar.y));
//				
//				
//				var barRect:Rectangle = bar.getBounds(this.stage);//new Rectangle(bar.x, bar.y, bar.width, bar.height);
//				if(barRect.contains(listX,listY))
//				{
//					return bar;
//				}
//			}
//			return null
//		}
//		public function onTouch(touchX:Number, touchY:Number):void
//		{
//			var bar:DisplayObject = getBar(touchX, touchY);
//			if(bar)
//			{
//				bar.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));
//			}
//		}
	}
}