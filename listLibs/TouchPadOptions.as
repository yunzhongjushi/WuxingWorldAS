package listLibs {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flas.geom.Point;
	import flas.geom.Rectangle;

	public class TouchPadOptions {
		public var viewRect:Rectangle;
		public var barClass:Class;
		public var originPoint:Point;
		public var posiPoint:Point;
		public var barWidth:Number;
		public var listWidth:Number;
		public var listHeight:Number;

		public var columns:int;
		public var intervalX:Number;
		public var intervalY:Number;

		public function TouchPadOptions(width:Number, height:Number, barClass:Class, intervalY:Number=10, columns:int=1, listX:Number=0, listY:Number=0) {
			this.barClass=barClass;
			this.listWidth=width;
			this.listHeight=height;

			var temp:DisplayObject=new barClass();
			var barRect:Rectangle = Rectangle.changeRectangle(temp.getBounds(temp));

			originPoint=new Point(listX, listY);
			originPoint.x-=barRect.x;
			originPoint.y-=barRect.y;

			barWidth=temp.width;

			viewRect=new Rectangle(originPoint.x, -1*(2*barWidth+20), width, height+2*(2*barWidth+20));

			var fixedWidth:Number=width-listX;
			this.intervalX=Math.max(0, (fixedWidth-temp.width*columns)/Math.max(1, columns-1));

			this.intervalY=intervalY;
			this.columns=columns;

			posiPoint=new Point();
		}

		public static function genFromCover(cover:DisplayObject, barClass:Class, intervalY:Number=10, columns:int=1, listX:Number=0, listY:Number=0):TouchPadOptions {
			var vo:TouchPadOptions = new TouchPadOptions(cover.width, cover.height, barClass, intervalY, columns, listX, listY);
			vo.posiPoint = new Point(cover.x, cover.y);
			return vo;
		}

		public function setupListVars(columns:int, intervalX:Number):void {
			this.columns=columns;
			this.intervalX=intervalX;
		}
	}
}
