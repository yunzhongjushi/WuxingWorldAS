package com.model.vo.config.board{
	import com.model.vo.BaseObjectVO;
	import com.model.vo.chessBoard.GridPoint;
	import com.model.vo.chessBoard.QiuPoint;
	
	
	/**
	 * 棋盘布局配置信息
	 * @author hunterxie
	 */
	public class BoardBaseVO extends BaseObjectVO{
		public var ID:int = 0;
		public var name:String = "谜题";
		
		/**
		 * 棋盘配置（null就用默认的（节省存储空间）
		 */
		public function get boardConfig():Object{
			if(!_boardConfig){
				return null;
			}
			return _boardConfig.getChangeVO();
		}
		public function set boardConfig(info:Object):void{
			if(info==null){
				_boardConfig = new BoardConfigVO;
				return;
			}
			if(!_boardConfig){
				_boardConfig = new BoardConfigVO;
			}
			_boardConfig.updateObj(info);
		}
		private var _boardConfig:BoardConfigVO = new BoardConfigVO;
		public function getBoardConfig():BoardConfigVO{
			return _boardConfig;
		}
		

		/**
		 * 球数组
		 */
		public function get balls():Array{
			return cloneArrs(_balls, true);
		}
		public function getBall(r:int, l:int):int{
			if(!_balls[r]){
				return QiuPoint.KIND_NULL;
			}
			return null==_balls[r][l] ? QiuPoint.KIND_NULL : _balls[r][l];
		}
		public function set balls(value:Array):void{
			this._balls = value;
		}
		private var _balls:Array = [[],[],[],[],[],[],[],[]];
		public function setBall(r:int, l:int, value:Object, skill:Object=null):void{
			if(_balls[r]==null){
				_balls[r] = [];
			}
			_balls[r][l] = value;
			setSkill(r, l, skill);//设置
		}
		
		/**
		 * 球技能数组
		 */
		public function get skills():Array{
			return cloneArrs(_skills);
		}
		public function getSkill(r:int, l:int):String{
			if(!_skills[r]){
				return "";
			}
			return _skills[r][l];
		}
		public function set skills(value:Array):void{
			this._skills = value;
		}
		private var _skills:Array = [];
		public function setSkill(r:int, l:int, value:Object):void{
			if(_skills[r]==null){
				_skills[r] = [];
			}
			_skills[r][l] = value;
		}
		
		public function updateSkills():void{
			for(var j:int=0; j<_skills.length; j++){
				if(_skills[j] is Array){
					for(var k:int=0; k<_skills[j].length; k++){
						if(_skills[j][k]=="0"){
//							_skills[j][k]="";
						}
					}
				}
			}
		}

		/**
		 * 棋盘格子技能数组
		 */
		public function get grids():Array{
			return cloneArrs(_grids);
		}
		public function set grids(value:Array):void{
			this._grids = value;
		}
		private var _grids:Array = [];
		public function setGrid(r:int, l:int, value:Object):void{
			if(_grids[r]==null){
				_grids[r] = [];
			}
			_grids[r][l] = value;
		}

		/**
		 * 棋盘技能数组
		 */
		public var boardSkills:Array = [];
		
		/**
		 * 解谜过程
		 */
		public var solve:String = "";
		
		
		/**
		 * 
		 * @param info
		 * <boardInfo boardID="1" maxR="8" maxL="8" maxKinds="6" ActiveMode="1" isInitCanClear="0" isDelayFall="1" isCreateNew="0" exchangeTime="0.2" fallTime="0.2" clearTime="0.5" sequenceTime="0.5">
		 <kindArr>金,木,土,水,火,经</kindArr>
		 <chanceArr>1,1,1,1,1,1</chanceArr>
		 </boardInfo>
		 */
		public function BoardBaseVO(info:Object=null):void{
			super(info);
		}
		
//		override public function updateObj(info:Object):void{
//			super.updateObj(info);
//			
//			for(var i:int=0; i<_balls.length; i++){
//				if(_balls[i]){
//					for(var j:int=0; j<_balls[i].length; j++){
//						_balls[i][j] = parseInt(_balls[i][j]);
//					}
//				}
//			}
//		}
		
		public function clearInfo():void{
			clearBalls();
			clearSkills();
			clearGrids();
		}
		public function clearBalls():void{
			for (var i:int=0; i<_balls.length; i++) {
				if(_balls[i]){
					for (var j:int=0; j<_balls[i].length; j++) {
						_balls[i][j] = QiuPoint.KIND_NULL;
					}
				}
			}
		}
		public function clearSkills():void{
			for (var i:int=0; i<_skills.length; i++) {
				if(_skills[i]){
					for (var j:int=0; j<_skills[i].length; j++) {
						_skills[i][j] = null;
					}
				}
			}
		}
		public function clearGrids():void{
			for (var i:int=0; i<_grids.length; i++) {
				if(_grids[i]){
					for (var j:int=0; j<_grids[i].length; j++) {
						_grids[i][j] = null;
					}
				}
			}
		}
		
		/**
		 * 克隆数组顺便去掉多余的棋子数据
		 * @param arr
		 * @return 
		 */
		private function cloneArrs(arr:Array, isBall:Boolean=false):Array{
			var popJudge:Boolean = false;
			var arr1:Array = [];
			for(var i:int=arr.length-1; i>=0; i--){
				if(arr[i] is Array){
					while(arr[i].length){
						if(judgeNull(arr[i][arr[i].length-1], isBall)){
							arr[i].pop();
						}else{
							for(var j:int=0; j<arr[i].length; j++){
								if(arr[i][j]==null || arr[i][j]=="null"){
									arr[i][j] = isBall ? QiuPoint.KIND_NULL : "";
								}
							}
							break;
						}
					}
				
					if(popJudge || arr[i].length>0){
						popJudge = true;
						arr1[i] = arr[i].concat();
					}
				}
			}
			return arr1;
		}
		private function judgeNull(value:*, isBall:Boolean):Boolean{
			var judge:Boolean = (value==null ||
				value=="null" ||
				(value=="" && value!=0) ||
				(isBall && value==QiuPoint.KIND_NULL) ||
				(!isBall && value==0) ||//空技能
				(!isBall && value==GridPoint.KIND_99) ||//空格子
				value=="空");
//			if(judge){
//				trace("判断棋子+buff+格子buff是否为空："， judge);
//			}
			return judge;
		}
	}
}