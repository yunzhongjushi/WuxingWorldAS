package com.view.UI.chessboard {
	import com.model.vo.chessBoard.GridPoint;
	import com.model.vo.skill.BoardBuffVO;
	
	import flas.display.Bitmap;
	import flas.display.Sprite;
	import flas.geom.Point;
	import flas.utils.utils;

	/**
	 * 棋盘格子buff显示
	 * @author hunterxie
	 */
	public class BoardGrid extends Sprite{
		
		public var point:GridPoint;
		public function get globalPoint():Point{
			return Point.changePoint(this.localToGlobal(new Point));
		}
		
		public var displayShow:Bitmap = new Bitmap;
		
		public function get r():int {
			return point.r;
		}
		public function get l():int {
			return point.l;
		}
		/**
		 * 球的最终目标x坐标
		 */
		public var tarX:Number;
		/**
		 * 球的最终目标y坐标
		 */
		public var tarY:Number;
		
		private static var pool:Array = [];
		public static function getGrid(info:GridPoint):BoardGrid{
			var grid:BoardGrid;
			if(pool.length>0){
				grid = pool.pop() as BoardGrid;
			}else{
				grid = new BoardGrid;
			}
			return grid.updateInfo(info);
		}
		
		
		
		public function BoardGrid() {
			this.mouseEnabled = this.mouseChildren = false;
			displayShow.x = displayShow.y = -BaseInfo.boardWidth/2;
			reset();
			this.addChild(displayShow);
		}
		
		public function updateInfo(info:GridPoint=null):BoardGrid{
			if(this.point) point.off(BoardBuffVO.CHANGE_BUFF_STATE, this, changeBuffState);

			this.point = info;
			point.on(BoardBuffVO.CHANGE_BUFF_STATE, this, changeBuffState, false, 0, true);
			this.x = tarX = r * BaseInfo.boardWidth + BaseInfo.boardWidth / 2;
			this.y = tarY = -(l * BaseInfo.boardWidth + BaseInfo.boardWidth / 2);
			changeBuffState();
			return this;
		}
		
		private function changeBuffState(e:*=null):void{
			this.displayShow.setBitmapDataClass(point.icon, "imgs/chessboard/icon/", ".png");
		}
		
		public function reset():void{
			this.displayShow.setBitmapDataClass("b空格", "imgs/chessboard/icon/", ".png");
			if(this.point) this.point.updateBuff(GridPoint.KIND_99);
		}
		
		public function clear():void{
//			this.displayShow.bitmapData.dispose();
			reset();
			if(this.point){
				point.off(BoardBuffVO.CHANGE_BUFF_STATE, this, changeBuffState);
			}
			if(this.parent){
				this.parent.removeChild(this);
			}
		}
	}
}
