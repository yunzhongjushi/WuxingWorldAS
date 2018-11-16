package com.view.UI.chessboard {
	import com.model.logic.ChessBoardLogic;
	import com.model.vo.chessBoard.QiuPoint;
	
	import flas.display.Bitmap;
	import flas.display.Sprite;
	import flas.events.MouseEvent;
	import flas.geom.Point;
	import flas.geom.Rectangle;
	import flas.utils.Tween;
	
	/**
	 * 棋子
	 * @author hunterxie
	 */
	public class Qiu extends Sprite {
		/**
		 * laya中额外事件用于触发mouse over
		 */
		public static const EXCHANGE_OVER:String = "EXCHANGE_OVER";
		public static const MOVE_STATE_CHANGE:String = "move_state_change";
		
//		/** 按照顺序排列，可以用来判断大于某个值就不能移动 */
//		public static var stateNum:int=0;
		/** 0:静止 */
		public static const MOVE_KIND_STATIC:int 				= 0;//stateNum++;//
		/** 1:下落结束回到静止的状态（此过程中触发的消除算连消） */
		public static const MOVE_KIND_GOING_STATIC:int 		= 1;//stateNum++;//
		/** 2:交换回来结束 */
		public static const MOVE_KIND_EXCHANGE_BACK_OVER:int 	= 2;//stateNum++;//
		/** 3:下落结束<br> 
		 * 如果下落后有消除，而且下落过程中有交换时，那么下落后的消除触发会被交换冲掉（大于这个值的棋子,就是有交换中的棋子不进行下落后消除）*/
		public static const MOVE_KIND_FALL_OVER:int 			= 3;//stateNum++;//
		/** 4:消除结束<br>
		 * 如果此值在上一个那么消除后不会下落 */
		public static const MOVE_KIND_CLEAR_OVER:int 			= 4;//stateNum++;//
		/** 5:交换结束 暂时没有用到*/
		public static const MOVE_KIND_EXCHANGE_OVER:int 		= 5;//stateNum++;//
		/** 6:交换回来 */
		public static const MOVE_KIND_EXCHANGE_BACK:int 		= 6;//stateNum++;//
		/** 7:下落过程中 */
		public static const MOVE_KIND_FALL:int 				= 7;//stateNum++;//
		/** 8:消除中 */
		public static const MOVE_KIND_CLEAR:int 				= 8;//stateNum++;//
		/** 9:交换中 */
		public static const MOVE_KIND_EXCHANGE:int 			= 9;//stateNum++;//
		
		public static var qiuPool:Array=[];
		public static function getNewQiu(point:QiuPoint):Qiu{
			return qiuPool.length>0 ? (qiuPool.pop() as Qiu).updateInfo(point) : new Qiu(point);
		}
		
		/**
		 * 球的最终目标x坐标
		 */
		public var tarX:Number = 0;
		/**
		 * 球的最终目标y坐标
		 */
		public var tarY:Number = 0;
		public var point:QiuPoint;
		public function get globalPoint():Point{
			return Point.changePoint(this.localToGlobal(new Point));
		}
		private var tween:Tween;
		
		private var isMouseDown:Boolean=false;
		
		/**
		 * 是否是编辑器上设置棋盘使用的棋子，设置用棋子不禁鼠标
		 */
		private var isSetBoard:Boolean = false;
		
		/** 棋子不可点的时候的黑色半透明覆盖 */
		public var cover:Bitmap = new Bitmap;
		public var displayShow:Bitmap = new Bitmap;
		public function get r():int {
			return point.r;
		}
		public function get l():int {
			return point.l;
		}
		public function get kind():int {
			return point.showKind;
		}
		public function set kind(value:int):void {
			if(isSetBoard){
				this.alpha = 1;
			}else{
				this.visible = true;
			}
			if(value==QiuPoint.KIND_NULL){
				if(isSetBoard){
					this.alpha = 0;
				}else{
					this.visible = false;
				}
			}
			displayShow.setBitmapDataClass(QiuPoint.getKindStrig(value), "imgs/chessboard/icon/", ".png");
//			displayShow.bitmapData = utils.getDefinitionByName(QiuPoint.getKindStrig(value));
//			displayShow.smoothing = true;
		}
		public function resetKind(value:int, isClearSkill:Boolean=false):int{
			point.resetKind(value, isClearSkill);
			this.kind = value;
			return value;
		}
		
		/**
		 * 能否正常交换
		 */
		public var canExchange:Boolean=false;
		/**
		 * 交换后能否消除
		 */
		public var canExchangeClear:Boolean=false;
		
		
		private var _moveKind:int = MOVE_KIND_STATIC;
		public function get moveKind():int{
			return _moveKind;
		}
		public function set moveKind(value:int):void{
			this._moveKind = value;
//			event(MOVE_STATE_CHANGE, _moveKind, true);
		}
		
		public var effectContainer:Sprite = new Sprite;
//		public function get effect():Array{
//			return point.skills;
//		}
		
//		override public function set mouseEnabled(enabled:Boolean):void{
//			super.mouseEnabled = enabled;
//			if(this.r==1 && this.l==0){
//				if(enabled==false)
//					trace(this.point.buff2);
//			}
//		}
		public var buff1:QiuEffect;
		public var buff2:QiuEffect;
		public function setBuffs(e:*=null, showJudge:Boolean=true):void{
			clearBuffs();
//			try{
				if(point.buff1){
					this.buff1 = QiuEffect.getQiuEffect(point.buff1);
					if(showJudge)this.effectContainer.addChild(buff1);
				}
				if(point.buff2){
					this.buff2 = QiuEffect.getQiuEffect(point.buff2);
					if(showJudge)this.effectContainer.addChild(buff2);
				}
				this.mouseEnabled = isSetBoard || point.canMove;
				this.cover.visible = !this.mouseEnabled;
//			}catch(e:Error){
//				throw("技能配置错误，请检查！");
//			}
		}
		private function clearBuffs():void{
			while(this.effectContainer.numChildren){
				var qiuEffect:QiuEffect = this.effectContainer.getChildAt(0) as QiuEffect;
				if(qiuEffect) qiuEffect.remove();
			}
			this.buff1 = this.buff2 = null;
		}
		
		
		
		
		
		/**
		 * @param info	@see QiuPoint
		 * @param isSet	是否是编辑器上设置棋盘使用的棋子
		 */
		public function Qiu(info:QiuPoint=null, isSet:Boolean=false):void{//row:int=0, line:int=0, kind:String=QiuPoint.KIND_NULL):void {
			this.isSetBoard = isSet;
			if(info){
				this.point = info;
			}else{
				point = new QiuPoint(0, 0, QiuPoint.KIND_GRAY);
			}
//			if(displayShow.hasOwnProperty("mouseEnabled"))
//				displayShow["mouseEnabled"] = true;
			displayShow.x = displayShow.y = -BaseInfo.boardWidth/2;
			this.addChild(displayShow);
			this.addChild(effectContainer);
			this.mouseChildren=false;
			this.buttonMode=true;
			this.effectContainer.mouseEnabled = this.effectContainer.mouseChildren = false;
			
			cover.setBitmapDataClass("QiuCover", "imgs/chessboard/icon/", ".png");
//			cover.bitmapData = utils.getDefinitionByName("QiuCover");
			cover.x = cover.y = -BaseInfo.boardWidth/2;
			cover.visible = false;
			this.addChild(cover);
			if(BaseInfo.isLayaProject){
				this["hitArea"] = new Rectangle(-BaseInfo.boardWidth/2, -BaseInfo.boardWidth/2, BaseInfo.boardWidth, BaseInfo.boardWidth);
//				this.width = this.height = BaseInfo.boardWidth;
			}
			if(BaseInfo.isLayaProject){
				this.on(MouseEvent.MOUSE_OVER, this, function(e){
					if(parent && parent.parent){
						parent.parent["event"](EXCHANGE_OVER, this);
					}
				});
			}
			
			updateInfo();
		}
		
		/**
		 * 
		 * @param qiuPoint
		 */
		public function updateInfo(info:QiuPoint=null):Qiu {
			if(info){
				if(this.point!=info){
					this.point.off(QiuPoint.UPDATE_QIU_BUFF_INFO, this, setBuffs);
				}
				this.point = info;
				this.point.on(QiuPoint.UPDATE_QIU_BUFF_INFO, this, setBuffs);
			}
			tarX = r * BaseInfo.boardWidth + BaseInfo.boardWidth / 2;
			tarY = -(l * BaseInfo.boardWidth + BaseInfo.boardWidth / 2);
			this.kind = point.kind;
			this.setBuffs();
			return this;
		}
		
		/**
		 * 生成带技能新球
		 * @param info
		 */
		public function createClearSkill(info:QiuPoint=null):void {
			Tween.clearAll(this);
			updateInfo(info);
			
			_moveKind = MOVE_KIND_STATIC;
			this.mouseEnabled = isSetBoard || point.canMove;
			this.cover.visible = !this.mouseEnabled;
//			event(MOVE_STATE_CHANGE, _moveKind, true);
		}
		
		/**
		 * 交换
		 * @param qiu			跟目标球交换
		 * @param canExchange	能否交换（不能交换将自动换回）
		 * @param canClear		交换后能否消除
		 * @param isChoosed		是否是玩家点选的那个
		 * @return 
		 */
		public function exchange(qiu:Qiu, canExchange:Boolean=false, canClear:Boolean=false, isChoosed:Boolean=false):Tween {
			this.canExchange = canExchange;
			if(canExchange){
				this.tarX = qiu.x;
				this.tarY = qiu.y;
			}
			this.canExchangeClear = canClear;
			this.mouseEnabled = isSetBoard || false;
			this.cover.visible = !this.mouseEnabled;
			_moveKind = Qiu.MOVE_KIND_EXCHANGE;
			var scale:Number = isChoosed?1:1;
			return Tween.to(this, ChessBoardLogic.getInstance().exchangeTime, {x:qiu.x, y:qiu.y, scaleX:scale, scaleY:scale, onComplete:moveOver, onCompleteParams:[qiu.kind]}, this);
		}
		
		/**
		 * 换回
		 * @param immediately是否立刻执行到位（否则缓动）
		 * @return 
		 */
		private function exchangeBack(immediately:Boolean=false):void {
			_moveKind = Qiu.MOVE_KIND_EXCHANGE_BACK;
			this.movePosition(immediately);
		}
		
		/**
		 * 下落
		 * @param immediately	是否立刻执行到位（否则缓动）
		 * @return 				是否开始下落
		 */
		public function fall(immediately:Boolean=false):Boolean {
			if (Math.abs(x-tarX)>5 || Math.abs(y-tarY)>5) {
				_moveKind = Qiu.MOVE_KIND_FALL;
				this.movePosition(immediately);
				return true;
			}
			return false
		}
		
		/**
		 * 匹配可消除可移动设置
		 */
		public function fitChange():void{
			this.mouseEnabled = isSetBoard || this.point.canMove;//false;//
			this.cover.visible = !this.mouseEnabled;
		}
		
		/**
		 * 消除
		 * @param immediately	是否立刻执行到位（否则缓动）
		 * @param delayTime		延迟（秒)执行,用于技能效果
		 * @return 
		 */
		public function clearMC(immediately:Boolean=false, delayTime:Number=0):Tween {
			this.mouseEnabled = isSetBoard || false;
			this.cover.visible = !this.mouseEnabled;
//			this.cover.visible = true;
			
			if(immediately){
				this.alpha=0;
				clearOver();
				return null;
			}
			Tween.clearAll(this);
//			if(this.r==5 && this.l==7){
//				trace("test:"+this.name);
//			}
			_moveKind = Qiu.MOVE_KIND_CLEAR;
			return Tween.to(this, ChessBoardLogic.getInstance().clearTime*BaseInfo.showActionBoardRunTimes, {alpha:0, delay:delayTime, onComplete:clearOver}, this);
		}
		private function clearOver():void{
			clearBuffs();
			_moveKind=Qiu.MOVE_KIND_CLEAR_OVER;
			this.kind = QiuPoint.KIND_NULL;
			event(MOVE_STATE_CHANGE, _moveKind, true);
		}
		
		
		/** 回到自己的位置上
		 * @param immediately 是否立刻执行到位（否则缓动）
		 */
		private function movePosition(immediately:Boolean=false):void {
//			trace(immediately, x, tarX, y, tarY,  this.name, "startMove",getTimer())
			this.mouseEnabled = this.isSetBoard || false;
			this.cover.visible = !this.mouseEnabled;
			if (immediately) {
				this.x = this.tarX;
				this.y = this.tarY;
				moveOver();
			} else if (Math.abs(x-tarX)>5 || Math.abs(y-tarY)>5) {
				this.alpha=1;
//				this.cover.visible = false;
				Tween.to(this, ChessBoardLogic.getInstance().fallTime*BaseInfo.showActionBoardRunTimes, {x:tarX, y:tarY, onComplete:moveOver}, this);
			}
		}
		
		/**
		 * 移动结束
		 */
		private function moveOver(kind:int=5):void {
			this.mouseEnabled = isSetBoard || point.canMove;
			this.cover.visible = !this.mouseEnabled;
			
			switch(_moveKind){
				case Qiu.MOVE_KIND_EXCHANGE:
//					if(canExchangeClear){
//						_moveKind=Qiu.MOVE_KIND_EXCHANGE_OVER;
//					}else{
						_moveKind = MOVE_KIND_STATIC;//交换结束后不可消的变为静止
//					}
					if(!this.canExchange){
						exchangeBack();
					}
					break;
				case Qiu.MOVE_KIND_EXCHANGE_BACK:
					_moveKind=Qiu.MOVE_KIND_EXCHANGE_BACK_OVER;
					event(MOVE_STATE_CHANGE, _moveKind, true);
					break;
				case Qiu.MOVE_KIND_FALL:
			//			trace(this.name, "fallOver:",getTimer());
					_moveKind=Qiu.MOVE_KIND_FALL_OVER;
					event(MOVE_STATE_CHANGE, _moveKind, true);
					break;
			}
		}
		
		public function remove():void{
			if(this.parent){
				this.parent.removeChild(this);
			}
			qiuPool.push(this);
		}
		
		/**
		 * 复制另一个球的数据
		 * @param tar
		 * @param cloneSkill	是否复制技能
		 */
		public function setFromAnother(tar:Qiu, cloneSkill:Boolean=false):void{
			this.kind = tar.kind;
			this.point.resetKind(tar.kind);
			if(cloneSkill){
				if(tar.buff1) this.point.setBuff(tar.buff1.buffVO);//直接转移buff，因为依次到最底下的棋子要setkind清除buff，所以不需要对原有buff做清除
				if(tar.buff2) this.point.setBuff(tar.buff2.buffVO);
			}else{
				this.point.clearSkill();
			}
			updateInfo();
		}
	}
}