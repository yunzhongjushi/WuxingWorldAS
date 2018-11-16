package com.model.vo.config.guide {
	import com.model.logic.ChessBoardLogic;
	import com.view.UI.chessboard.ChessboardPanel;
	
	import flas.geom.Point;

	/**
	 * 记录的
	 * @author hunterxie
	 */
	public class GuideTipPoint extends Point{
		/**
		 * 横向交换还是竖向交换
		 * 0：无
		 * 1：横
		 * 2：竖
		 */
		public var rotation:int=0;
		
		private var str:String = "";
		/**
		 * 棋子坐标列表
		 */
		private var poArr:Array;
		
		/**
		 * 提示坐标/n颗棋子位置
		 * @param str	442,473/0102
		 */
		public function GuideTipPoint(str:String) {
			this.str = str;
			if(str.indexOf(",")!=-1){
				var arr:Array = str.split(",");
				super(parseInt(arr[0]), parseInt(arr[1]));
			}else{
				poArr = changeStrToInt(str);
				if(str.length>=4){
					rotation = getRotation(poArr[0], poArr[1]);
				}
			}	
		}
		
		public function setChessboardPoint():void{
			if(!poArr || poArr[0] || poArr[1]) return;
			var point:Point = ChessboardPanel.getMiddlePoint(poArr[0],poArr[1]);
			this.x = point.x;
			this.y = point.y;
		}
		
		/**
		 * 获取两颗棋子交换提示的角度
		 * @param p1
		 * @param p2
		 * @return 
		 */
		public function getRotation(p1:Point, p2:Point):int{
			if(p1.x>p2.x){
				return 180;
			}else if(p1.x<p2.x){
				return 0;
			}else if(p1.y>p2.y){
				return 90;
			}else if(p1.y<p2.y){
				return -90;
			}
			return 0;
		}
		
		private function changeStrToInt(str:String):Array{
			var arr:Array = [];
			for(var i:int=0; i<str.length; i++){
//				arr.push(int(str.charAt(i)));
				if(i%2==1){
					arr.push(new Point(parseInt(str.charAt(i-1)), parseInt(str.charAt(i))));
				}
			}
			return arr;
		}
	}
}
