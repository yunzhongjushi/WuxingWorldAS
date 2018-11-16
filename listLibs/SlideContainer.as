package listLibs {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flas.events.Event;
	import flas.events.MouseEvent;
	import flas.geom.Point;
	import flas.geom.Rectangle;

	/**
	 * 例子：
	 */
	public class SlideContainer extends Sprite {
		public static const MODE_NORMAL:Object={isLock:false, isTouchTrigger:false, isScrolling:false};
		public static const MODE_SCROLL:Object={isLock:true, isTouchTrigger:false, isScrolling:true};
		public static const MODE_TOUCH_END_SCROLL:Object={isLock:false, isTouchTrigger:true, isScrolling:true};


		protected var isLock:Boolean=false;
		protected var isTouchTrigger:Boolean=false;
		protected var isScrolling:Boolean=false;

		// ====================================

		/**
		 * 触摸层
		 */
		public var rCover:Sprite;
		/**
		 * 遮罩层
		 */
		public var rMask:Sprite;

		/**
		 * 移动点， 所有的显示物体都依照该点设置x,y
		 */
		protected var moveX:Number;
		protected var moveY:Number;
		/**
		 * 显示物体的总高度
		 */
		protected var _totalListHeight:Number=-1

		protected function get totalListHeight():Number {
			if(_totalListHeight==-1)
				refeshTotalHeight();
			return _totalListHeight;
		}
		/**
		 * 拖动时，轨迹点记录，用于计算惯性滑动
		 */
		protected var pointArr:Array=[];
		/**
		 * 拖动时，记录的初始点，产生拖动时每帧更新
		 */
		protected var pressPoint:Point;
		/**
		 * 检查是否已经在触摸层按下，用于判断是否要拖动
		 */
		protected var isPress:Boolean;
		/**
		 * 是否拖动中
		 */
		protected var isDrag:Boolean=false;
		/**
		 *  前一个动作是否拖动，用于判断是否产生点击
		 */
		protected var hadDrag:Boolean;
		/**
		 * 是否活动
		 */
		protected var isRunning:Boolean;
		/**
		 * 释放拖动后产生的滑动距离
		 */
		protected var tailBaseY:Number=0;
		/**
		 * * 循环显示 * 的视界，超出该范围的隐藏，通常要大于遮罩范围
		 */
		protected var list_viewRect:Rectangle;
		/**
		 * 原点，列表向上滚到顶时，移动点 = 原点
		 */
		protected var list_o_x:Number;
		protected var list_o_y:Number;
		/**
		 * 触摸层、遮罩层、整个列表宽高，
		 */
		protected var list_width:Number;
		protected var list_height:Number;
		/**
		 * 该容器在外部的x，y，默认为0，0 当TouchLIstVO 由cover生成时，等于cover的x,y
		 */
		protected var container_o_x:Number;
		protected var container_o_y:Number;

		/**
		 * 生成一张空的滑动列表
		 *
		 * 要添加显示对象用 addList();
		 *
		 * 如果要有 点击事件 和/或 循环显示，需实现ITouchList 的接口
		 *
		 * @param isInit 是否自动初始化，当需要外部改变参数时选否
		 *
		 */
		public function SlideContainer(width:int, height:int, isInit:Boolean=true) {
			list_width=width
			list_height=height

			list_o_x=0
			list_o_y=0

			container_o_x=0
			container_o_y=0

			list_viewRect=new Rectangle(0, 0, list_width, list_height);

			if(isInit) {
				init();
			}
		}

		protected function init(isCreatMask:Boolean=true):void {
			if(isCreatMask) {
				// 遮罩层
				rMask=new Sprite();
				rMask.graphics.beginFill(0x0000AA, 0.05);
				rMask.graphics.drawRect(0, 0, list_width, list_height);
				rMask.graphics.endFill();
				this.addChild(rMask);

				this.mask=rMask;
			}

			// 触摸层
			rCover=new Sprite();
			rCover.graphics.beginFill(0xFF0000, 0.00);
			rCover.graphics.drawRect(0, 0, list_width, list_height);
			rCover.graphics.endFill();
			this.addChild(rCover);

			rCover.addEventListener(MouseEvent.MOUSE_DOWN, handle_touch);
			rCover.addEventListener(MouseEvent.MOUSE_MOVE, handle_touch);
			rCover.addEventListener(MouseEvent.MOUSE_UP, handle_touch);
			rCover.addEventListener(MouseEvent.MOUSE_OUT, handle_touch);

			this.addEventListener(MouseEvent.MOUSE_UP, onTouchList);

			this.addEventListener(Event.ADDED_TO_STAGE, handle_add);
			this.addEventListener(Event.REMOVED_FROM_STAGE, handle_remove);

			this.x=container_o_x;
			this.y=container_o_y;

			moveX=list_o_x;
			moveY=list_o_y;

			listArr=new Vector.<listInfo>();
		}
		/**
		 *
		 */
		private var listArr:Vector.<listInfo>;

		public function addList(sp:Sprite, listX:int=0, listY:int=0):void {
			if(sp is DisplayObjectContainer) {
				(sp as DisplayObjectContainer).mouseEnabled=false;
			}

			listArr.push(new listInfo(sp, listX, listY));

			this.addChildAt(sp, 0);

			refreshListArrY();
		}

		public function refreshContainerVars():void {

		}

		/**
		 * 如果未拖动，则发出点击事件
		 * @param e
		 *
		 */
		protected function onTouchList(e:*):void {
			if(hadDrag)
				return;

			var sp:DisplayObjectContainer;
			var chd:*

			for(var i:int=0; i<listArr.length; i++) {
				if(listArr[i].sp is DisplayObjectContainer) {
					sp=listArr[i].sp as DisplayObjectContainer;
					for(var j:int=0; j<sp.numChildren; j++) {
						chd=sp.getChildAt(j)
						if(chd.getBounds(this.stage).contains(e.stageX, e.stageY))
							chd.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					}

				}
			}
		}

		protected function handle_remove(e:*):void {
			isRunning=false;
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, handle_enter);
		}

		protected function handle_add(e:*):void {
			isRunning=true;
			
			this.addEventListener(Event.ENTER_FRAME, handle_enter);
		}

		/**
		 * 滑动一段距离
		 *
		 * 向下滑：-100
		 * 向上滑：100
		 * @param moveListY
		 *
		 */
		public function toSlide(moveListY:int):void {
			if(isScrolling==false)
				return;
			tailBaseY=moveListY;
		}
		/**
		 * 设置模式
		 * MODE_NORMAL		普通模式
		 * MODE_SCROLL		强制滑动模式, 滑动结束才可交互
		 * MODE_TOUCH_END_SCROLL	自由滑动，交互后停止滑动
		 */
		protected var mode:Object;

		public function setMode(mode:Object):void {
			this.mode=mode;
			for(var i:String in mode) {
				this[i]=mode[i];
			}
		}

		/**
		 * 一次拖动后，重置参数
		 *
		 */
		protected function reset():void {
			hadDrag=isDrag;

			isRunning=true;

			isPress=false;

			isDrag=false;

			pressPoint=null;

			pointArr=[];

			setMode(MODE_NORMAL);
		}

		/**
		 * 拖动与鼠标事件
		 * @param e
		 *
		 */
		protected function handle_touch(e:*):void {
			if(isLock)
				return;
			switch(e.type) {
				case MouseEvent.MOUSE_DOWN:

					tailBaseY=0;
					isRunning=false;
					hadDrag=false;
					isPress=true;
					pressPoint=new Point(rCover.mouseX, rCover.mouseY);
//					listStartPoint = new Point(list.x, list.y);

					if(isTouchTrigger==true) {
						setMode(MODE_NORMAL);
					}

					break;
				case MouseEvent.MOUSE_MOVE:

					if(isPress==false)
						return;

					// 每次拖动开始，重新计算整个列表的高度
					refeshTotalHeight();

					var cPoint:Point=new Point(rCover.mouseX, rCover.mouseY);
					var dY:Number=cPoint.y-pressPoint.y;

					if(isDrag==false) {
						if(Math.abs(dY)>=10) {
							isDrag=true;
						} else {
							return;
						}
					}
					pressPoint=cPoint;

					addMoveY(dY);
					pointArr.unshift(cPoint);
					break;
				case MouseEvent.MOUSE_UP:
				case MouseEvent.MOUSE_OUT:

					if(isDrag==false||pointArr.length==0) {
						reset();
						return;
					}

					var slideY:Number=0;
					var max:int=Math.min(pointArr.length, 5);
					for(var i:int=0; i<max; i++) {
						slideY+=(pointArr[i] as Point).y;
					}
					slideY/=max;

					var cY:Number=rCover.mouseY;

					this.tailBaseY=(cY-slideY)*8;

					reset();
					break;
			}
		}

		/**
		 * 拖动结束后 与 回弹的滑动
		 * @param e
		 *
		 */
		protected function handle_enter(e:*):void {
			if(isRunning==false)
				return;

			var factor:Number=0;

			if(Math.abs(tailBaseY)<=2) {
				factor=1;
				tailBaseY=0
			} else if(Math.abs(tailBaseY)<=15) {
				factor=0.3;
			} else if(Math.abs(tailBaseY)<=30) {
				factor=0.2;
			} else {
				factor=0.1
			}

			if(isScrolling) {
				factor*=2;
			}

			var changeY:Number=tailBaseY*factor;
			tailBaseY-=changeY;


			var dY:Number=0;
			if(moveY>list_o_y) {
				dY=list_o_y-moveY;
			}

			var tempH:Number=Math.max(list_height, totalListHeight);
			tempH-=list_o_y;
			if((moveY+tempH)<list_height) {
				dY=list_height-tempH-moveY;
			}
//			trace(moveY,tempH,list_height);
			if(changeY==0&&dY==0)
				return;

			if(Math.abs(changeY)>Math.abs(dY*0.2)) {
				addMoveY(changeY)
				if(dY!=0) {
					tailBaseY*=0.5;
				}
			} else {
				addMoveY(dY*0.2);
				tailBaseY=0;
			}
		}

		/**
		 * Y轴上加减一段距离
		 * @param val
		 *
		 */
		protected function addMoveY(val:Number):void {
			setListY(moveY+val);
		}

		protected function setListY(val:Number):void {
			moveY=Math.round(val);

			if(moveY>=list_height/2) {
				moveY=list_height/2;
				tailBaseY=0;
			}
			var tempH:Number=Math.max(list_height, totalListHeight);
			if((moveY+tempH)<=list_height/2) {
				moveY=list_height/2-tempH;
				tailBaseY=0;
			}
			refreshListArrY()
		}

		/**
		 * 根据moveY，更新所有显示对象的位置
		 *
		 */
		protected function refreshListArrY():void {
			for(var i:int=0; i<listArr.length; i++) {
				listArr[i].sp.x=listArr[i].ox+moveX;
				listArr[i].sp.y=listArr[i].oy+moveY;
				// 实现循环显示
				if(listArr[i].sp is ITouchList)
					(listArr[i].sp as ITouchList).fixRect(list_viewRect);
			}
		}

		/**
		 *  更新显示对象的总高度
		 *
		 */
		protected function refeshTotalHeight():void {
			var minY:int=0;
			var maxY:int=0;
			for(var i:int=0; i<listArr.length; i++) {
				if(listArr[i].oy<minY)
					minY=listArr[i].oy;
				if(listArr[i].oy+listArr[i].sp.height>maxY)
					maxY=listArr[i].oy+listArr[i].sp.height;
			}
			_totalListHeight=maxY-minY
		}
	}
}
import flash.display.DisplayObject;
import flash.display.Sprite;

/**
 * 单个显示对象，记录原点的位置
 * @author CC5
 *
 */
class listInfo {

	public var sp:Sprite;
	public var ox:int;
	public var oy:int;

	public function listInfo(sp:Sprite, ox:int, oy:int) {
		this.sp=sp;
		this.ox=ox;
		this.oy=oy;
	}
}