package editor{
	import com.model.logic.ChessBoardLogic;
	import com.model.vo.chessBoard.GridPoint;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.config.board.BoardBaseVO;
	import com.model.vo.skill.BoardBuffVO;
	import com.view.BasePanel;
	import com.view.MovieShow;
	import com.view.UI.chessboard.BoardGrid;
	import com.view.UI.chessboard.Qiu;
	import com.view.touch.CommonBtn;
	
	import fl.containers.ScrollPane;
	
	import flas.events.MouseEvent;
	import flas.geom.Point;
	import flas.geom.Rectangle;
	import flas.utils.utils;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;

	/**
	 * 编辑器
	 * @author hunterxie
	 * 
	 */
	public class SetPanel extends BasePanel{
		public static const NAME:String = "SetPanel";
		public static const SINGLETON_MSG:String = "single_SetPanel_only";
		protected static var instance:SetPanel;
		public static function getInstance():SetPanel{
			if ( instance == null ) instance = new SetPanel();
			return instance;
		}

		public function get isInsertMove():Boolean{
			return _isInsertMove;
		}
		public function set isInsertMove(value:Boolean):void{
			_isInsertMove = value;
			btn_insertMove.setNameTxt(value?"插入":"不插入");
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
		public var mc_editorFocus:*;
		private var focusBall:*;
		private var focusMove:Boolean = false;
		
		/**
		 * 装球的容器
		 */
		public var qiuContainer:*;
		public var mc_mask:Sprite;
		/**
		 * 装格子的容器
		 */
		public var gridContainer:*;
		
		/**
		 * 装供选择的球的容器
		 */
		public var setQiuContainer:Sprite;
		public var sp_qiu:ScrollPane;
		
		/**
		 * 装供选择的球buff的容器
		 */
		public var setBuffContainer:Sprite;
		public var sp_buff:ScrollPane;
		
		/**
		 * 装供选择的格子的容器
		 */
		public var setGridContainer:Sprite;
		public var sp_grid:ScrollPane;
		
		/**
		 * 控制是插入还是替换，是拖动棋盘还是拖动插入一条
		 */
		public var btn_insertMove:CommonBtn;
		private var _isInsertMove:Boolean = false;
		
		
		/**
		 * 传入的总设置数组
		 */
		public var nowInfo:BoardBaseVO;
		
		/**
		 * 棋盘格子大小
		 */
		public var dragBallWidth:int=72;
		
		public var setR:int = 8;
		public var setL:int = 24;
		public var qiuArr:Array = [[],[],[],[],[],[],[],[]];
		public var gridArr:Array = [[],[],[],[],[],[],[],[]];
		
		
		public var ballSetArr:Array = [0, 1, 2, 3, 4, 5, 6, 7, 10];
		public var buffSetArr:Array = [2,4,5,6,40,
										7,10,12,13,15,
										16,19,41,44,
										50,51,52,53,54,0];
		public var gridSetArr:Array = [100,101,102,103,104,99];
		
		
		
		/*******************************************************
		 *
		 * 
		 * 
		 * 
		 * 
		 *******************************************************/
		public function SetPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			BaseInfo.boardWidth = this.dragBallWidth;
			btn_insertMove.setNameTxt("不插入");
			btn_insertMove.addEventListener(MouseEvent.CLICK, function(e:*):void{isInsertMove = !isInsertMove});
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			
			mc_editorFocus.scaleX = mc_editorFocus.scaleY = 0.7;
			mc_editorFocus.mouseEnabled  = mc_editorFocus.mouseChildren = false;
			mc_editorFocus.visible = false;
		}
		
		public function init(e:Event):void{
			gridContainer.mouseEnabled = gridContainer.mouseChildren = false;
			
			qiuContainer.isDrag = false;
			qiuContainer.mask = mc_mask;
			qiuContainer.dragRect = new Rectangle(qiuContainer.x, qiuContainer.y, 0, 1150);
			qiuContainer.addEventListener(MouseEvent.MOUSE_DOWN, onSetBoard);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onSetBoard);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSetBoard);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onSetBoard);
			stage.addEventListener(KeyboardEvent.KEY_UP, onSetBoard);
			
			setQiuContainer.scaleX = setQiuContainer.scaleY = 0.7;
//			sp_qiu.source = setQiuContainer;
			sp_qiu.visible = false;
			setBuffContainer.scaleX = setBuffContainer.scaleY = 0.5;
//			sp_buff.source = setBuffContainer;
			sp_buff.visible = false;
			setGridContainer.scaleX = setGridContainer.scaleY = 0.6;
//			sp_grid.source = setGridContainer;
			sp_grid.visible = false;
			
			for (var i:int=0; i<setR; i++) {
				for (var j:int=0; j<setL; j++) {
					var qiu:Qiu = new Qiu(new QiuPoint(i, j), true);
					qiu.fall(true);
					qiuContainer.addChild(qiu);
					qiuArr[i].push(qiu);
					qiu.addEventListener(MouseEvent.MOUSE_OVER, onSetqiu);
					
					if(j<8){
						var grid:BoardGrid = new BoardGrid;
						grid.updateInfo(new GridPoint(i, j, GridPoint.KIND_99, 1));
						grid.x = qiu.x;
						grid.y = qiu.y;
						gridContainer.addChild(grid);
						gridArr[i].push(grid);
					}
				}
			}
			
			for (var k:int=0; k<buffSetArr.length; k++) {
				var effect:QiuEffectSet = new QiuEffectSet(new BoardBuffVO(buffSetArr[k]), Math.floor(k%5)*dragBallWidth, Math.floor(k/5)*dragBallWidth);
				effect.addEventListener(MouseEvent.MOUSE_DOWN, action);
				setBuffContainer.addChild(effect);
			}
			
			for (k=0; k<gridSetArr.length; k++) {
				var gridE:GridEffectSet = new GridEffectSet(new BoardBuffVO(gridSetArr[k]), Math.floor(k%4)*dragBallWidth, Math.floor(k/4)*dragBallWidth);
				gridE.addEventListener(MouseEvent.MOUSE_DOWN, action);
				setGridContainer.addChild(gridE);
			}
			
			for (k=0; k<ballSetArr.length; k++) {
				var ball:Qiu = new Qiu();
				ball.x = ball.tarX = Math.floor(k%3)*dragBallWidth;
				ball.y = ball.tarY = Math.floor(k/3)*dragBallWidth;
				ball.resetKind(ballSetArr[k]);
				if(ballSetArr[k]==QiuPoint.KIND_NULL){
					ball.visible = true;
					ball.displayShow.bitmapData = utils.getDefinitionByName("删棋子");
				}
				ball.addEventListener(MouseEvent.MOUSE_DOWN, action);
				setQiuContainer.addChild(ball);
			}
//			this.addEventListener(Event.ENTER_FRAME, function(e){trace(setGridContainer.visible, setGridContainer.parent, setGridContainer.x,setGridContainer.numChildren)});
		}
		
		/**
		 * 配置(棋子、技能、格子技)容器中的棋子鼠标点击处理
		 */
		public function action(e:*):void {
			var ball:* = e.target;
			dragPos = new Point(stage.mouseX, stage.mouseY);
//			ball.startDrag(true);
			dragBall = ball;
			if(ball is Qiu){
				if(focusBall && focusBall==ball){
					focusBall = null;
					mc_editorFocus.visible = false;
				}else{
					focusBall = ball;
					var point:Point = Point.changePoint(ball.parent.localToGlobal(new Point(ball.x, ball.y)));
					var point1:Point = Point.changePoint(this.globalToLocal(point));
					mc_editorFocus.x = point1.x;
					mc_editorFocus.y = point1.y;
					mc_editorFocus.visible = true;
				}
			}
		}
		
		public function showEdite():void{
			this.visible = true;
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
					if(j<8){
						(gridArr[i][j] as BoardGrid).reset();
					}
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
		public function onSetqiu(e:Event):void{
			var qiu:Qiu = e.target as Qiu;
			if(focusMove){
				nowInfo.setBall(qiu.r, qiu.l, focusBall.kind);
				qiu.setFromAnother(focusBall as Qiu);
			}
		}
		public function onSetBoard(e:Event):void{
			switch (e.type) {
				case MouseEvent.MOUSE_DOWN :
					stage.focus = this;
					if(focusBall){
						focusMove = true;
						var point:Point = Point.changePoint(focusBall.parent.globalToLocal(new Point(stage.mouseX, stage.mouseY)));
						focusBall.x = point.x;
						focusBall.y = point.y;
						hitTestJudge(focusBall);
						focusBall.x = focusBall.tarX;
						focusBall.y = focusBall.tarY;
					}else{
						qiuContainer.startDrag(false, qiuContainer.dragRect);
					}
					break;
				case MouseEvent.MOUSE_UP :
					focusMove = false;
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
				case MouseEvent.MOUSE_MOVE :
					if(dragPos && (Math.pow(dragPos.x-stage.mouseX, 2)+Math.pow(dragPos.y-stage.mouseY, 2) > dragJudgeNum)){
						dragBall.startDrag();
						focusBall = null;
						mc_editorFocus.visible = false;
					}
					break;
				case KeyboardEvent.KEY_UP :
					if(!(stage.focus is TextField)){
						if((e as KeyboardEvent).keyCode==17){
							isInsertMove = false;
						}
					}
					break;
				case KeyboardEvent.KEY_DOWN :
					if(!(stage.focus is TextField)){
						dragBall = null;
//						trace((e as KeyboardEvent).keyCode);
						switch((e as KeyboardEvent).keyCode){
							case 48://0,删除置空
							case 68://D,删除置空
								dragBall = setQiuContainer.getChildAt(5) as Qiu;
								break;
							case 49://1,金
							case 81://Q,金
								dragBall = setQiuContainer.getChildAt(0) as Qiu;
								break;
							case 50://2,木
							case 87://W,木
								dragBall = setQiuContainer.getChildAt(1) as Qiu;
								break;
							case 51://3,土
							case 69://E,土
								dragBall = setQiuContainer.getChildAt(2) as Qiu;
								break;
							case 52://4,水
							case 82://R,水
								dragBall = setQiuContainer.getChildAt(3) as Qiu;
								break;
							case 53://5,火
							case 84://T,火
								dragBall = setQiuContainer.getChildAt(4) as Qiu;
								break;
							case 54://6,钻
							case 65://A,钻
								dragBall = setQiuContainer.getChildAt(7) as Qiu;
								break;
							case 55://7,灰
							case 83://S,灰
								dragBall = setQiuContainer.getChildAt(6) as Qiu;
								break;
							case 56://8,删除列
							case 70://F,删除列
								dragBall = setQiuContainer.getChildAt(8) as Qiu;
								break;
							case 57://9，
							case 71://G,
//								dragBall = setBuffContainer.getChildAt(7) as QiuEffects;
								break;
							case 90://Z,
								dragBall = setGridContainer.getChildAt(0) as GridEffectSet;
								break;
							case 88://X,
								dragBall = setGridContainer.getChildAt(1) as GridEffectSet;
								break;
							case 67://C,
								dragBall = setGridContainer.getChildAt(2) as GridEffectSet;
								break;
							case 86://V,
								dragBall = setGridContainer.getChildAt(3) as GridEffectSet;
								break;
							case 66://B,
								dragBall = setGridContainer.getChildAt(4) as GridEffectSet;
								break;
							case 78://N,
								dragBall = setGridContainer.getChildAt(5) as GridEffectSet;
								break;
							case 17://N,
								isInsertMove = true;
							case 27://ESC
								focusBall = null;
								break;
						};
						if(dragBall){
							var point:Point = Point.changePoint(dragBall.parent.globalToLocal(new Point(stage.mouseX, stage.mouseY)));
							dragBall.x = point.x;
							dragBall.y = point.y;
							dragBall.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
						}
					}
					break;
			}
		}
		
		/**
		 * 拖动碰撞判断+棋盘修改
		 * @param ball
		 */
		public function hitTestJudge(drag:*, isDeleteLine:Boolean=false):void {
			var point:Point = Point.changePoint(drag.localToGlobal(new Point));
			for (var i:int=0; i<setR; i++) {
				for (var j:int=0; j<setL; j++) {
					var qiu:Qiu = qiuArr[i][j];
					if (qiu.hitTestPoint(point.x,point.y)) {
						if(drag is Qiu){
							if(drag.kind==QiuPoint.KIND_DELETE_LINE){
								deleteLine(qiu.r);
							}else{
								if(isInsertMove) insertQiu(qiu.r, qiu.l, drag.kind);
								if(!isInsertMove || drag.kind!=QiuPoint.KIND_NULL){//插入以后再设置棋子
									qiu.setFromAnother(drag as Qiu);
									nowInfo.setBall(i, j, drag.kind);
								}
							}
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
					
					if(j<8){
						var grid:BoardGrid = gridArr[i][j] as BoardGrid;
						if (grid.hitTestPoint(point.x,point.y)) {
							if(drag is GridEffectSet){
								grid.point.updateBuff(drag.ID);
								nowInfo.setGrid(i, j, drag.ID);
							}
						}
					}
				}
			}
		}
		
		/**
		 * 插入棋子，还要修改数据（包括技能）
		 * @param qiu
		 */
		private function insertQiu(R:int, L:int, kind:int):void{
			if(kind==QiuPoint.KIND_NULL){//空球就掉落
				for (var j:int=L; j<setL-1; j++) {
					nowInfo.setBall(R, j, nowInfo.getBall(R, j+1), nowInfo.getSkill(R, j+1));
					qiuArr[R][j].setFromAnother(qiuArr[R][j+1], true);
				}
			}else{//不是空就插入
				for (var j:int=setL-1; j>L; j--) {
					if(qiuArr[R][j-1].kind != QiuPoint.KIND_NULL){
						nowInfo.setBall(R, j, nowInfo.getBall(R, j-1), nowInfo.getSkill(R, j-1));
						qiuArr[R][j].setFromAnother(qiuArr[R][j-1], true);
					}
				}
			}
		}
		
		/**
		 * 删除列，根据鼠标判断？
		 */
		private function deleteLine(R:int):void{
			if(isInsertMove){
				for(var i:int=setR-1; i>R; i--){
					for(var j:int=0; j<setL; j++){
						nowInfo.setBall(i, j, nowInfo.getBall(i-1, j), nowInfo.getSkill(i-1, j));
						(qiuArr[i][j] as Qiu).setFromAnother(qiuArr[i-1][j], true);
						if(i==R+1){
							(qiuArr[R][j] as Qiu).setFromAnother(setQiuContainer.getChildAt(5) as Qiu);
							nowInfo.setBall(R, j, QiuPoint.KIND_NULL);
						}
					}
				}
			}else{
				for(var i:int=R; i<setR-1; i++){
					for(var j:int=0; j<setL; j++){
						nowInfo.setBall(i, j, nowInfo.getBall(i+1, j), nowInfo.getSkill(i+1, j));
						(qiuArr[i][j] as Qiu).setFromAnother(qiuArr[i+1][j], true);
						if(i==setR-2){
							(qiuArr[setR-1][j] as Qiu).setFromAnother(setQiuContainer.getChildAt(5) as Qiu);
							nowInfo.setBall(i, j, QiuPoint.KIND_NULL);
						}
					}
				}
			}
		}
		
		
		
		/**
		 * 把数组设置给棋盘
		 */
		public function setArrToBoard(info:BoardBaseVO):void{
			this.nowInfo = info;
			for (var i:int=0; i<setR; i++) {
				for (var j:int=0; j<setL; j++) {
					var balls:Array = nowInfo.balls;
					var skills:Array = nowInfo.skills;
					var grids:Array = nowInfo.grids;
					var qiu:Qiu = qiuArr[i][j];
					qiu.point.resetKind((balls[i] && balls[i][j]!=null) ? balls[i][j] : QiuPoint.KIND_NULL, true);
					ChessBoardLogic.getInstance().readBoardConfigBuff(qiu.point, (skills[i] && skills[i][j])?skills[i][j]:"");
					qiu.updateInfo();
					
					if(j<8){//棋盘(技能)最高为8
						var grid:BoardGrid = gridArr[i][j] as BoardGrid;
						grid.point.updateBuff(int((grids[i] && grids[i][j])?grids[i][j]:GridPoint.KIND_99));//buffID=99空格子编辑用
					}
				}
			}
		}
		
		
		/**
		 * 获取当前棋盘的截图
		 * @return
		 */
		public function getSetPanel():BitmapData{
			var rect:Rectangle = Rectangle.changeRectangle(qiuContainer.getRect(qiuContainer));
			rect.y = -578;
			rect.height = 580;
			qiuContainer.mask = null;
			var bmp:BitmapData = MovieShow.getMovieBMD(qiuContainer, rect);
			qiuContainer.mask = mc_mask;
			return bmp;
		}
	}
}
