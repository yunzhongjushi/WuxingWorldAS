package com.view.UI.playerEditor{
	import com.model.logic.ChessBoardLogic;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.editor.EditVO;
	import com.model.vo.skill.BoardBuffVO;
	import com.view.BasePanel;
	import com.view.MovieShow;
	import com.view.UI.chessboard.ChessboardPanel;
	import com.view.UI.chessboard.Qiu;
	
	import editor.QiuEffectSet;
	
	import flash.display.Sprite;
	import flas.events.MouseEvent;
	import flas.geom.Point;
	import flas.geom.Rectangle;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	/**
	 * 玩家自创关卡
	 * @author hunterxie
	 */
	public class PlayerEditorSetPanel extends BasePanel{
		public static const NAME:String = "PlayerEditorSetPanel";
		public static const SINGLETON_MSG:String = "single_PlayerEditorSetPanel_only";
		protected static var instance:PlayerEditorSetPanel;
		public static function getInstance():PlayerEditorSetPanel{
			if ( instance == null ) instance = new PlayerEditorSetPanel();
			return instance;
		}
		
		
		/**
		 * 当前拖动的棋子/buff/格子
		 */
		public var dragBall:*;
		/** 拖动初始位置，用于判断距离，来决定是否需要开启拖动 */
		private var dragPos:Point;
		/** 用于判断是否开始拖动的距离平方 */
		private var dragJudgeNum:int = 25;
		
		/**
		 * 选择棋子/技能的焦点
		 */
		public var mc_editorFocus:MovieClip;
		private var focusBall:MovieClip;
		private var focusMove:Boolean = false;
		
		/**
		 * 装球的容器
		 */
		public var qiuContainer:MovieClip;
		public var mc_mask:Sprite;
		
		/**
		 * 装格子的容器
		 */
		public var gridContainer:MovieClip;
		
		/**
		 * 装供选择的球的容器
		 */
		public var setQiuContainer:Sprite;
		private var setQiuArr:Array = [0,1,2,3,4,6,5];
		
		/**
		 * 装供选择的球buff的容器
		 */
		public var setBuffContainer:Sprite;
		
		/**
		 * 装供选择的格子的容器
		 */
		public var setGridContainer:Sprite;
		
		
		/**
		 * 传入的总设置数组
		 */
		public var nowInfo:EditVO;
		
		public var setR:int = 8;
		public var setL:int = 8;
		public var qiuArr:Array = [[],[],[],[],[],[],[],[]];
		//		public var gridArr:Array = [[],[],[],[],[],[],[],[]];
		
		
		/**
		 * 可以编辑的技能数据，需要通过解锁
		 */
		public var buffSetArr:Array = [1,4,9,10,13,41,0];
		//		public var gridSetArr:Array = [100,,101,102,103,104,99];
		
		
		
		/*******************************************************
		 *
		 * 
		 * 
		 * 
		 * 
		 *******************************************************/
		public function PlayerEditorSetPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			mc_editorFocus.visible = false;
//			mc_editorFocus.scaleX = mc_editorFocus.scaleY = 0.7;
//			mc_editorFocus.mouseEnabled  = mc_editorFocus.mouseChildren = false;
//			mc_editorFocus.visible = false;
			
			init();
		}
		
		public function init():void{
			gridContainer.mouseEnabled = gridContainer.mouseChildren = false;
			
			qiuContainer.isDrag = false;
			qiuContainer.mask = mc_mask;
			qiuContainer.dragRect = new Rectangle(qiuContainer.x, qiuContainer.y, 0, 1150);
//			qiuContainer.addEventListener(MouseEvent.MOUSE_DOWN, onSetBoard);
//			qiuContainer.addEventListener(MouseEvent.MOUSE_UP, onSetBoard);
			
			setQiuContainer.scaleX = setQiuContainer.scaleY = 0.7;
			setBuffContainer.scaleX = setBuffContainer.scaleY = 0.7;
			setGridContainer.scaleX = setGridContainer.scaleY = 0.6;
			
			for (var i:int=0; i<setR; i++) {
				for (var j:int=0; j<setL; j++) {
					var qiu:Qiu = new Qiu(new QiuPoint(i, j), true);
					qiu.fall(true);
					qiuContainer.addChild(qiu);
					qiuArr[i].push(qiu);
//					qiu.addEventListener(MouseEvent.MOUSE_OVER, onSetqiu);

//					if(j<8){
//						var grid:Grid = new Grid;
//						grid.updateInfo(new GridPoint(i, j, 100, 1));
//						grid.x = qiu.x;
//						grid.y = qiu.y;
//						gridContainer.addChild(grid);
//						gridArr[i].push(grid);
//					}
				}
			}
			
			for (var k:int=0; k<buffSetArr.length; k++) {
				var effect:QiuEffectSet = new QiuEffectSet(new BoardBuffVO(buffSetArr[k]), Math.floor(k%3)*BaseInfo.boardWidth, Math.floor(k/3)*BaseInfo.boardWidth);
				effect.addEventListener(MouseEvent.MOUSE_DOWN, action);
				effect.addEventListener(MouseEvent.MOUSE_UP, onSetBoard);
				setBuffContainer.addChild(effect);
			}
			
			//			for (k=0; k<gridSetArr.length; k++) {
			//				var gridE:GridEffectSet = new GridEffectSet(new BoardBuffVO(gridSetArr[k]), Math.floor(k%4)*BaseInfo.boardWidth, Math.floor(k/4)*BaseInfo.boardWidth);
			//				gridE.addEventListener(MouseEvent.MOUSE_DOWN, action);
			//				setGridContainer.addChild(gridE);
			//			}
			
			for (k=0; k<setQiuArr.length; k++) {
				var ball:Qiu = new Qiu();
				ball.x = ball.tarX = Math.floor(k%3)*BaseInfo.boardWidth;
				ball.y = ball.tarY = Math.floor(k/3)*BaseInfo.boardWidth;
				ball.resetKind(setQiuArr[k]);
				if(setQiuArr[k]==QiuPoint.KIND_NULL){
					ball.visible = true;
//					ball.displayShow.bitmapData = utils.getDefinitionByName("删棋子");
					ball.displayShow.setBitmapDataClass("删棋子", "imgs/chessboard/icon/", ".png");
				}
				ball.addEventListener(MouseEvent.MOUSE_DOWN, action);
				ball.addEventListener(MouseEvent.MOUSE_UP, onSetBoard);
				setQiuContainer.addChild(ball);
			}
		}
		
		/**
		 * 配置(棋子、技能、格子技)容器中的棋子鼠标点击处理
		 */
		public function action(e:*):void {
			var ball:* = e.target;
			dragPos = new Point(stage.mouseX, stage.mouseY);
			ball.parent.addChild(ball);//调整到最上层
			ball.startDrag(true);
			dragBall = ball;
//			if(ball is Qiu){
//				if(focusBall && focusBall==ball){
//					focusBall = null;
//					mc_editorFocus.visible = false;
//				}else{
//					focusBall = ball;
//					var point:Point = ball.parent.localToGlobal(new Point(ball.x, ball.y));
//					var point1:Point = this.globalToLocal(point);
//					mc_editorFocus.x = point1.x;
//					mc_editorFocus.y = point1.y;
//					mc_editorFocus.visible = true;
//				}
//			}
		}
		
		/**
		 * 清除设置棋盘和信息
		 * @param e
		 */
		public function clearInfo(e:*=null):void {
			for (var i:int=0; i<setR; i++) {
				for (var j:int=0; j<setL; j++) {
					var qiu:Qiu = qiuArr[i][j] as Qiu;
					qiu.resetKind(QiuPoint.KIND_NULL, true);
					qiu.updateInfo();
					//					if(j<8){
					//						(gridArr[i][j] as Grid).reset();
					//					}
				}
			}
			nowInfo.clearInfo();
		}
		
		public function randomInfo(arr:Array):void{
			clearInfo();
			for(var i:int=0; i<arr.length; i++){
				for(var j:int=0; j<arr[i].length; j++){
					nowInfo.setBall(i, j, (qiuArr[i][j] as Qiu).resetKind(arr[i][j]));
				}
			}
		}
		/**
		 * 棋子容器中的棋子鼠标点击处理
		 */
		//		public function onSetqiu(e:Event):void{
		//			var qiu:Qiu = e.target as Qiu;
		//			if(focusMove){
		//				nowInfo.setBall(qiu.r, qiu.l, focusBall.kind);
		//				qiu.kind = focusBall.kind;
		//				qiu.point.resetKind(focusBall.kind);
		//				qiu.point.setSkill("0");
		//				qiu.updateInfo();
		//			}
		//		}
		
		public function onSetBoard(e:*):void{
			switch (e.type) {
//				case MouseEvent.MOUSE_DOWN :
//					if(focusBall){
//						focusMove = true;
//						var point:Point = focusBall.parent.globalToLocal(new Point(stage.mouseX, stage.mouseY));
//						focusBall.x = point.x;
//						focusBall.y = point.y;
//						hitTestJudge(focusBall);
//						focusBall.x = focusBall.tarX;
//						focusBall.y = focusBall.tarY;
//					}else{
//					qiuContainer.startDrag(false, qiuContainer.dragRect);
//					}
//					break;
				case MouseEvent.MOUSE_UP :
//					focusMove = false;
					dragPos = null
					qiuContainer.stopDrag();
					if(dragBall){
						dragBall.stopDrag();
						hitTestJudge(dragBall);
						dragBall.x = dragBall.tarX;
						dragBall.y = dragBall.tarY;
						dragBall = null;
					}
					break;
//				case MouseEvent.MOUSE_MOVE :
//					if(dragPos && (Math.pow(dragPos.x-stage.mouseX, 2)+Math.pow(dragPos.y-stage.mouseY, 2) > dragJudgeNum)){
//						dragBall.startDrag(true);
//						focusBall = null;
//						mc_editorFocus.visible = false;
//					}
//					break;
			}
		}
		
		/**
		 * 拖动碰撞判断+棋盘修改
		 * @param ball
		 */
		public function hitTestJudge(drag:*):void {
			var point:Point = Point.changePoint(drag.localToGlobal(new Point));
			for (var i:int=0; i<setR; i++) {
				for (var j:int=0; j<setL; j++) {
					var qiu:Qiu = qiuArr[i][j];
					if (qiu.hitTestPoint(point.x,point.y)) {
						if(drag is Qiu){
							nowInfo.setBall(i, j, drag.kind);
							qiu.kind = drag.kind;
							qiu.point.resetKind(drag.kind);
							qiu.point.clearSkill();
						}else if(qiu.kind!=QiuPoint.KIND_NULL && drag is QiuEffectSet){
							if(drag.ID==0){
								qiu.point.clearSkill();
								nowInfo.setSkill(i, j, null);
							}else{
								qiu.point.setBuff(new BoardBuffVO(drag.ID));
								nowInfo.setSkill(i, j, qiu.point.outSkill());
							}
						}
						qiu.updateInfo();
					}
					
//					if(j<8){
//						var grid:Grid = gridArr[i][j] as Grid;
//						if (grid.hitTestPoint(point.x,point.y)) {
//							if(drag is GridEffectSet){
//								grid.point.updateBuff(drag.ID);
//								nowInfo.setGrid(i, j, drag.ID);
//							}
//						}
//					}
				}
			}
		}
		
		/**
		 * 把数组设置给棋盘
		 */
		public function setArrToBoard(info:EditVO):void{
			this.nowInfo = info;
			for (var i:int=0; i<setR; i++) {
				for (var j:int=0; j<setL; j++) {
					var balls:Array = nowInfo.balls;
					var skills:Array = nowInfo.skills;
					//					var grids:Array = nowInfo.grids;
					var qiu:Qiu = qiuArr[i][j];
					qiu.point.resetKind((balls[i] && balls[i][j])?balls[i][j]:QiuPoint.KIND_NULL, true);
					ChessBoardLogic.getInstance().readBoardConfigBuff(qiu.point, (skills[i] && skills[i][j])?skills[i][j]:"");
					qiu.updateInfo();
					
//					if(j<8){//棋盘(技能)最高为8
//						var grid:Grid = gridArr[i][j] as Grid;
//						grid.point.updateBuff(int((grids[i] && grids[i][j])?grids[i][j]:100));//buffID=100空格子编辑用
//					}
				}
			}
			var point:Point = ChessboardPanel.containerPositions["x"+nowInfo.getBoardConfig().maxR];
			qiuContainer.x = point.x;
			qiuContainer.y = point.y;
			mc_mask.width = mc_mask.height = BaseInfo.boardWidth*nowInfo.getBoardConfig().maxR;
			mc_mask.x = point.x;
			mc_mask.y = point.y-mc_mask.height;
		}
		
		
		/**
		 * 获取当前棋盘的截图
		 * @return
		 */
		public function getEditorMap():BitmapData{
			var rect:Rectangle = Rectangle.changeRectangle(qiuContainer.getRect(qiuContainer));
			rect.y = -578;
			rect.height = 580;
			qiuContainer.mask = null;
			var bmp:* = MovieShow.getMovieBMD(qiuContainer, rect);
			qiuContainer.mask = mc_mask;
			return bmp;
		}
	}
}
