package com.model.logic {
	import com.model.event.EventCenter;
	import com.model.vo.WuxingVO;
	import com.model.vo.chessBoard.BoardSkillActiveVO;
	import com.model.vo.chessBoard.ExchangeJudgeVO;
	import com.model.vo.chessBoard.GridPoint;
	import com.model.vo.chessBoard.QiuClearVO;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.chessBoard.SingleClearVO;
	import com.model.vo.config.board.BoardBaseVO;
	import com.model.vo.config.board.BoardConfigVO;
	import com.model.vo.skill.BoardBuffVO;
	import com.model.vo.skill.BoardSkillVO;
	import com.utils.ArrayFactory;
	import com.utils.Rander;
	
	import flas.events.EventDispatcher;
	
	public class ChessBoardLogic extends EventDispatcher{
		public static const NAME:String = "ChessBoardLogic";
		public static const SINGLETON_MSG:String = "single_ChessBoardLogic_only";
		protected static var instance:ChessBoardLogic;
		public static function getInstance():ChessBoardLogic{
			if(instance==null) instance=new ChessBoardLogic();
			return instance;
		}
		
		
		/** 回合驱动，每次用消除结束0.5秒后没有消除即完成一个回合。
		 * 由显示层判断，后台模拟时间间隔（显示控制数据是前台计算）*/
		public static const GAME_ACTIVE_MODE_TIME_TURN:int = 1;
		/** 单次驱动，游戏双方依次行动，不可连续移动*/
		public static const GAME_ACTIVE_MODE_TURN:int = 2;
		/** 时间驱动,以秒为单位*/
		public static const GAME_ACTIVE_MODE_TIME:int = 3;
		/**
		 * 1、回合驱动；2、单次驱动；3、时间驱动;
		 */
		public var gameActiveMode:int = 1;
		/** 横排数 */
		public var maxR:int=8;
		/** 纵排数 */
		public var maxL:int=8;
		/** 最大棋子类型 */
		public var maxKinds:int=7;
		/** 现有棋子类型 */
		public var kindArr:Array=[0, 1, 2, 3, 4];
		/** 棋子交换(以及失败交换回来)的用时 */
		public var exchangeTime:Number	= 0.2;
		/** 棋子掉落所用时间(不按距离，任何位置掉落都是这个时间) */
		public var fallTime:Number		= 0.2;
		/** 棋子消除所用时间 */
		public var clearTime:Number	= 0.5;
		/** 连击结束时间，下落结束后静止时间，毫秒<br>这个时间改成0后可以减少很大部分连击，以至于高连击需要运气（落下后需要可消）<br>也有对应技巧（如看到可消不消而是等落下期间消除另外的） */
		public var sequenceTime:Number	= 0;
		/** 连锁闪电棋子消失间隔 */
		public var lightningChainTime:Number = 0.1;
		/** 直排闪电棋子消失间隔 */
		public var lightningStreetTime:Number = 0.03;
		/** 生成新棋子展示间隔 */
		public var createQiuDelayTime:Number = 0.1;
		/** 挖矿模式下矿石层数，一般只在8x8棋盘模式下 */
		public var mineMaxNum:int = 4;
		/** 挖矿模式下向上移动的层数 */
		public var mineUpNum:int = 2;
		
		
		/** 新生成整盘棋子时其中是否允许有可消除的（3颗相同）存在 <br>如果允许就会看到开局有消除*/
		public var isInitCanClear:Boolean=false;
		/** 是否可不间断消除(消除时还能移动其他棋子)<br> true:流畅模式<br> false:每回合移动一颗然后等待 */
		public var isDelayFall:Boolean=true;
		/** 是否生成新的球，解谜关要求消除所有棋子*/
		public var isCreateNew:Boolean=true;
		/**
		 * 每个元素出现的概率（总体概率为100%）
		 */
		private var _kindChanceArr:Array=[1,1,1,1,1,1,1,1];
		public function set kindChanceArr(arr:Array):void{
			_kindChanceArr = arr;
			setSumChance();
		}
		/**
		 * 每个元素获得时的修正比率（技能增加的额外比例，数值上调整比较麻烦，需要跟随进度并且进度不能随便通过活动改变）
		 */
		private var kindRatArr:Array=[0,0,0,0,0,0,0];
		public function setKindRat(kind:int, value:Number):void{
			if(kindRatArr[kind] != null){
				kindRatArr[kind] += value;
			}
		}
		
		/**
		 * 每场战斗中单独的随机数获取器，用于计算棋盘逻辑中的概率;
		 */
		public var randomGeter:Rander = new Rander();
		public function updateSeed(initNum:int=945797944, seed:int=9999):void{
			randomGeter.Initialize(initNum);
			randomGeter.SetSeed(seed);
			
			EventCenter.traceInfo("board_seedInit:"+initNum+":"+seed);
		}
		
		public var sumChance:int = 0;
		public function setSumChance():void{
			sumChance = 0;
			for(var i:int=0; i<maxKinds; i++){
				sumChance += _kindChanceArr[i];
			}
		}
		/**
		 * 基础球数组
		 * @see com.model.vo.QiuPoint
		 */
		private var contentArray:Array	 = [];
		/**
		 * 格子技能数组
		 */
		private var gridArr:Array = [];
		/**
		 * 玩家操作带来的连续消除数组（push进去消除时shift出来）
		 * @see com.model.vo.fight.QiuClearVO
		 */
		private var continuedExchangeArr:Array=[];
		public function get hasExchangeClear():Boolean{
			return continuedExchangeArr.length>0;
		}
		/**
		 * 获取单次匹配(移动、下落)消除内容
		 * @param index		根据下标获取，如果没有下标就从第一个位置拿出
		 * @return 
		 */
		public function getExchangeClear(index:int=-1):QiuClearVO{
			if(index>=0){
				return continuedExchangeArr[index];
			}
			return continuedExchangeArr.shift();
		}
		/**
		 * 角色/精灵技能触发，技能带来的连续消除数组（push进去消除时shift出来）
		 * @see com.model.vo.skill.BoardSkillActiveVO
		 */
		private var continuedSkillArr:Array=[];
		public function setSkillEffect(vo:BoardSkillActiveVO):void{
			continuedSkillArr.push(vo);
		}
		public function getSkillEffect():BoardSkillActiveVO{
			return continuedSkillArr.shift();
		}
		/**
		 * 收集到的可消除point数组,用于消除以及数组重排
		 */
		private var _clearArr:Array=[];
		public function getClearPoint(index:uint):QiuPoint{
			return _clearArr[index];
		}
		/**
		 * 添加匹配消除数据
		 */
		private function setClearArr(arr:Array):Array{
			for(var i:int=0; i<arr.length; i++){//先执行球的消除，如果有buff2阻挡就不消
				var single:SingleClearVO = arr[i] as SingleClearVO;
				for(var j:int=0; j<single.clearArr.length; j++){
					pointClear(single.clearArr[j] as QiuPoint);
				}
			}
			for(i=0; i<arr.length; i++){//再执行球上的buff
				single = arr[i] as SingleClearVO;
				for(j=0; j<single.clearArr.length; j++){
					var point:QiuPoint = single.clearArr[j] as QiuPoint;
					if(point.kind==QiuPoint.KIND_NULL && point.buff1){//已经执行消除的球再触发buff1
						point.buff1.clear();//会触发移除效果，分发精灵效果和棋盘效果，棋盘效果会随事件push进boardEffectArr
					}
				}
			}
			
			_clearArr.sort(function(a:QiuPoint, b:QiuPoint):Number{return a.l>b.l?-1:1});
//			_clearArr.sortOn(["r", "l"], Array.DESCENDING | Array.NUMERIC);//排序后让消除的棋子按照先后顺序掉落
			return _clearArr;
		}
		public function resetClearArr():void{
			while(_clearArr.length) _clearArr.pop();
			while(continuedExchangeArr.length) continuedExchangeArr.pop();
			while(continuedSkillArr.length)continuedSkillArr .pop();
		}
		/**
		 * 收集到的可通过移动而达到消除目的的数组
		 */
		private var canChangeArr:Array = [];
		/**
		 * 能否通过移动达到消除效果
		 * @return 
		 */
		public function get isCanChangeFit():Boolean{
			canChangeToFit();
			return canChangeArr.length>0;
		}
		/**
		 * 随机返回2个可交换的球
		 */
		public function getCanChangePoints():Array{
			canChangeToFit(true);
			return canChangeArr[Math.floor(Math.random() * canChangeArr.length)];
		}
		/**
		 * 每个元素获得时的修正附加值（可以为负数，即受到debuff的情况）
		 */
		private var qiuPool:Array=[];
		private function getNewPoint(r:int, l:int):QiuPoint{
			var qiu:QiuPoint = new QiuPoint(r, l, QiuPoint.KIND_NULL);//qiuPool.length>0 ? qiuPool.pop().reset(r, l, QiuPoint.KIND_NULL) : new QiuPoint(r, l, QiuPoint.KIND_NULL);
			if(!isCreateNew){
				return qiu;
			}
			qiu.resetKind(getRandomKind(), true);
			return qiu;
		}
		/**
		 * 获取随机生成的棋子（待添加种子算法）
		 * @param isTrace
		 * @return 
		 */
		private function getRandomKind(isTrace:Boolean=false):int{
			var sum:Number = sumChance;
			var random:uint = randomGeter.GetNext("board_chess_");
			var temp:Number = random%sum;//sum*Math.random();//
			for(var i:int=0; i<maxKinds; i++){
				sum-=_kindChanceArr[i];
				if(temp>=sum){
					return kindArr[i]==_stopFallKind ? getRandomKind(isTrace) : kindArr[i];//如果获取的棋子类型被限制则递归
				}
			}
			return QiuPoint.KIND_NULL;
		}
		
		/** 设置下次掉落的棋子中限制出现的类型 */
		public function set stopFallKind(kind:int):void{
			_stopFallKind = kind;
		}
		/** 下次掉落的棋子中限制出现的类型 */
		private var _stopFallKind:int = QiuPoint.KIND_100;
		
		
		
		
		/**
		 * 
		 * 
		 */
		public function ChessBoardLogic() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
		}
		
		
		/**
		 * 初始化信息还是需要显示层来控制（如果含有不可消除时结束游戏的设定）
		 * @param maxR
		 * @param maxL
		 * @param maxKinds		如果小于kindArr.length就取kindArr的前几个(默认kindArr的情况下)
		 * @param isCreateNew
		 * @param isDelayFall
		 */
		public function initInfo(maxR:int=8, maxL:int=8, maxKinds:int=7, isCreateNew:Boolean=true, isDelayFall:Boolean=true):void{
			if(!randomGeter.m_nSeed && !randomGeter.m_cbInited){
				updateSeed();
			}
			setQiuArr = setSkillArr = null;
			this.maxR=maxR;
			this.maxL=maxL;
			this.maxKinds = maxKinds>kindArr.length ? kindArr.length : maxKinds;
			this.isCreateNew=isCreateNew;
			this.isDelayFall = isDelayFall;
			setSumChance();
			//			trace("maxR:"+maxR+"+maxL:"+maxL+"+maxKinds:"+maxKinds+"+isCreateNew:"+isCreateNew);
			for(var i:int=0; i<maxR; i++) {
				contentArray[i] = [];
				gridArr[i] = [];
				upSaveArr[i] = [];
				for(var j:int=0; j<maxL; j++) {
					contentArray[i][j] = getNewPoint(i,j);
				}
			}
			
			if(!isInitCanClear){
				resetInfo();
			}
		}
		
		private function resetInfo():void{
			if(allClearJudge()){
				addStart();
				resetClearArr();
				resetInfo();
			}
		}
		
		/**
		 * 执行消除并生成新球
		 */
		public function addStart():void{
			//trace("addStart");
			if(_clearArr.length == 0) {
				return;
			}
			
//			_clearArr.sortOn(["r", "l"], Array.DESCENDING | Array.NUMERIC);//再次进行排序，有可能后面技能增加了可消除球
			var point:QiuPoint;
			while(point=_clearArr.shift()){
				var tarArr:Array = contentArray[point.r] as Array;
				if(point.kind==QiuPoint.KIND_NULL){//未执行消除不执行？
					tarArr.push(getQiuSetKind(tarArr.splice(point.l, 1)[0]));//此处如果要处理成插入到空球前就会跟clearArr(经过排序)有冲突
				}
			}
			_stopFallKind = QiuPoint.KIND_100;//清除掉落限制
			
			setContentRL();
		}
		
		/**
		 * (挖矿模式)最下层生成新棋子<br>
		 * 最上层保留到棋子模版数组、技能模版数组，clone
		 */
		public function upAdd(num:int):void{
			for(var i:int=0; i<maxR; i++) {
				var tarArr:Array = contentArray[i] as Array;
				for(var j:int=0; j<num; j++) {
					var contentPoint:QiuPoint = tarArr.pop();//从顶部移除
					tarArr.unshift(contentPoint.cloneQiu());//从底部插入
					contentPoint.resetKind(getRandomKind(false), true);
					contentPoint.setBuff(new BoardBuffVO(10));//竖排消
					contentPoint.setBuff(new BoardBuffVO(45));//矿石1
					(upSaveArr[i] as Array).push(contentPoint);
				}
			}
		}
		
		/**
		 * 判断(挖矿模式)是否达到向上移动的条件——至少移动mineUpNum层，最多移动mineMaxNum层
		 * @return 需要移动的层数，0就是没达到条件;
		 */
		public function judgeUpAdd():int{
			for(var j:int=mineMaxNum-1; j>=0; j--){
				for(var i:int=0; i<maxR; i++) {
					if((contentArray[i][j] as QiuPoint).hasBuffEffect([45,46,47])){//第j层如果有矿石(ID:45、46、47)则返回
						return (j+1)<=mineUpNum ? mineMaxNum-j-1 : 0;//4-0/3-0/2-2/1-3/0-4
					}
				}
			}
			return mineMaxNum;
		}
		
		/**
		 * 整盘对应point的r、l重置；
		 */
		private function setContentRL():void{
			for(var i:int=0; i<maxR; i++) {
				for(var j:int=0; j<maxL; j++) {
					(contentArray[i][j] as QiuPoint).resetRL(i,j);
				}
			}
		}
		
		/**
		 * 整盘对应重排棋盘（打乱二维数组）
		 */
		public function setContentRandom():void{
			//			traceContent();
			for(var i:int=0; i<maxR; i++) {
				for(var j:int=0; j<maxL; j++) {
					var point:QiuPoint = contentArray[i][j] as QiuPoint;
					var tempR:int = randomGeter.GetNext("board_random_r")%maxR;
					var tempL:int = randomGeter.GetNext("board_random_l")%maxL;
					var point1:QiuPoint = contentArray[tempR][tempL] as QiuPoint;
					exchangeQiuPoint(point, point1);
				}
			}
			var num:int = reSetContentRandom();
			trace("____________每次不可消重排棋盘到可消的次数_________"+num);
			//			traceContent();
		}
		/**
		 * 对可消棋子进行随机打乱，达到整盘不可消的效果
		 * @param num
		 * @return 		返回重排棋盘到可消的次数
		 */
		private function reSetContentRandom(num:int=1):int{
			var vo:QiuClearVO = allClearJudge(false);
			if(vo){
				for(var i:int=0; i<vo.clearArr.length; i++){//每组消除球取中间那个进行调换
					var single:SingleClearVO = vo.clearArr[i] as SingleClearVO;
					var point:QiuPoint = single.clearArr[Math.floor(single.clearArr.length/2)] as QiuPoint;
					var tempR:int = randomGeter.GetNext("board_random_r")%maxR;
					var tempL:int = randomGeter.GetNext("board_random_l")%maxL;
					var point1:QiuPoint = contentArray[tempR][tempL] as QiuPoint;
					exchangeQiuPoint(point, point1);
				}
				return reSetContentRandom(++num);
			}
			return num;
		}
		
		/**
		 * 整盘判断是否有可消除的球（发生在新生成球向下移动结束后，变色技能结束后）<br>
		 * 同时生成可消除数组，
		 * @param isClear		是否需要清除可消棋子，作为判断就不需清除
		 * @return 
		 */
		public function allClearJudge(isClear:Boolean=true):QiuClearVO {
			resetClearArr();//消除、技能等展示完毕后才会执行此函数，因此理论上不会有未消除的数组
			//			var nowt:int = getTimer();
			var vo:QiuClearVO = new QiuClearVO(QiuClearVO.QIU_CLEAR_ALL);
			//			traceContent();
			for(var i:int=0; i<maxR; i++) {
				matching(vo, true, i);
			}
			for(i=0; i<maxL; i++) {
				matching(vo, false, i);
			}
			
			if(vo.clearArr.length>0){
				if(isClear){
					continuedExchangeArr.push(vo);
					setClearArr(vo.clearArr);
				}
//				if(!isDelayFall) {//这里禁掉，改为由界面驱动
//					addStart();
//				}
				return vo;
			}else{//没有消除棋子就判断是否有可以通过移动达到消除的棋子
//				trace(getTimer()-nowt, "__________测试匹配算法用时");//测试匹配算法用时
				canChangeToFit();
//				trace(getTimer()-nowt, "__________测试移动可消算法用时__", canChangeArr.length);//测试移动可消算法用时
			}
			return null;
		}
		
		
		/**
		 * 对交换的两个球进行可消除判断
		 * @param point
		 * @param tarPoint
		 * @return	0:不可消;1:球1可消;2:球2可消;3:两个都可消;
		 */
		public function exchangeJudge(nowPoint:QiuPoint, tarPoint:QiuPoint):ExchangeJudgeVO {
			var judgeVO:ExchangeJudgeVO = new ExchangeJudgeVO;
//			var judgeNum:int = 0;
			if(!nowPoint.canMove || !tarPoint.canMove){//空不能移动
				return judgeVO;
			}
			exchangeQiuPoint(nowPoint, tarPoint);
			
			//两个球的行列分别判断（利用现有逻辑判断正行，得出cleararr后判断是否有移动的棋子，后续有待优化）
			var vo:QiuClearVO = new QiuClearVO(QiuClearVO.QIU_CLEAR_EXCHANGE, nowPoint, tarPoint);
			var judge:Boolean = nowPoint.l==tarPoint.l ? matching(vo, true, nowPoint.r) : matching(vo, false, nowPoint.l)
			judge = matching(vo, true, tarPoint.r) || judge;
			judge = matching(vo, false, tarPoint.l) || judge;
			
			if(judge){//判断交换的球哪个可消
				judge=false;//如果在交换的时候消除的是跟交换无关的球就不做处理
				for(var i:int=0; i<vo.clearArr.length; i++){
					var single:SingleClearVO = vo.clearArr[i] as SingleClearVO;
					for(var j:int=0; j<single.clearArr.length; j++){
						var clearPoint:QiuPoint = single.clearArr[j];
						if(clearPoint.r==nowPoint.r && clearPoint.l==nowPoint.l){
							judge = true;
							judgeVO.setCanClear(nowPoint, 1);
//							judgeNum = judgeNum==2 ? 3: 1;//由于是交换后进行判断的，所以坐标也是相反的
						}else if(clearPoint.r==tarPoint.r && clearPoint.l==tarPoint.l){
							judge = true;
							judgeVO.setCanClear(nowPoint, 1);
//							if(judgeNum==0){
//								judgeNum = judgeNum==1 ? 3: 2;
//							}
						}
					}
				}
			}
			if(!judge){//如果不能消除就把两个棋子换回来
				exchangeQiuPoint(nowPoint, tarPoint);
				return judgeVO;
			}
			
			continuedExchangeArr.push(vo);
			setClearArr(vo.clearArr);
			return judgeVO;
		}
		private function exchangeQiuPoint(point1:QiuPoint, point2:QiuPoint):void{
			var tempr:int = point1.r;
			var templ:int = point1.l;
			point1.resetRL(point2.r, point2.l);
			point2.resetRL(tempr, templ);
			contentArray[point1.r][point1.l] = point1;
			contentArray[point2.r][point2.l] = point2;
		}
		
		/**
		 * 清除棋子，或者触发锁定技
		 * @param p
		 * @return 是否消除成功
		 */
		private function pointClear(p:QiuPoint):Boolean{
			var point:QiuPoint = contentArray[p.r][p.l];
			point.recordBuff();
			//			if(point.r==3 && point.l==5){
			//				trace("哈哈");
			//			}
			if(point.buff2){
				point.buff2.removeEffectTime();
				return false;
			}
			point.kind = QiuPoint.KIND_NULL;
			if(!_clearArr.some(function(item:QiuPoint, index:int, arr:Array):Boolean{return (point.r==item.r && point.l==item.l);})){
				_clearArr.push(point);
			}
			return true;
		}
		
		/**
		 * 递归，找到可消除的球push传入的数组，凡是可消的棋子都合并到_clearArr中；
		 * @param vo		一次行动消除的内容
		 * @param rowJudge	按行还是按列判断
		 * @param r_l		第几行/列
		 * @param n			某行/列的序号
		 * @param sum		已有总数
		 * @param kind		已有类型
		 * @return 
		 */
		public function matching(vo:QiuClearVO, rowJudge:Boolean, r_l:int, n:int=0, sum:int=0, kind:int=100):Boolean {
			var tarKind:int = rowJudge ? contentArray[r_l][n].kind : contentArray[n][r_l].kind;
			var num:int = rowJudge ? maxL : maxR;
			var kindJudge:Boolean = (kind==tarKind && kind!=QiuPoint.KIND_NULL && kind!=QiuPoint.KIND_GRAY);
			var sumJudge:Boolean = sum>=3;
			
			if(kindJudge) {
				sumJudge = (++sum >= 3);
				if(sumJudge && n>=num-1){
					createClearArr();
				}
			}else if(sumJudge){
				createClearArr(-1);//不包含当前球
			}
			if(++n >= num){
				return vo.clearArr.length>0;
			}
			return matching(vo, rowJudge, r_l, n, kindJudge?sum:1, kindJudge?kind:tarKind);
			
			function createClearArr(value:int=0):void{
				var tempArr:Array = [];
				for(var i:int=0; i<sum; i++){
					rowJudge ? tempArr.push(getPoint(r_l, n-i+value)) : tempArr.push(getPoint(n-i+value, r_l));
				}
				vo.addClear(tempArr);
				ArrayFactory.merge(_clearArr, tempArr);//合并去重，默认qiuPoint只有一份所以可以比对引用
			}
		}
		/**
		 * 检查地图是否有移动后可消除棋子
		 * 只要任何一个数字为A便有解
		 * 一:			二:						三:				四:
		 * -  1  -		-  1  -  -  2  -		-  3  -			-  -  1  -  -
		 * 2  -  3		3  -  A  A  -  4		-  A  -			3  A  -  A  4
		 * -  A  -		-  5  -  -  6  -		1  -  2			-  -  2  -  -
		 * -  A  -								-  A  -
		 * 4  -  5								-  4  -
		 * -  6  -
		 * @return
		 */
		private function canChangeToFit(findAll:Boolean=false):Array {
			canChangeArr=[];
			//横向测试
			for(var i:int=0; i<maxR; i++) {
				for(var j:int=0; j<maxL; j++) {
					if(!contentArray[i][j].canFitClear){
						continue;
					}
					if(j<maxL-1 && contentArray[i][j].kind == contentArray[i][j+1].kind) { //如果有两个相连  图一
						if(j-1>=0 && contentArray[i][j-1].canMove){
							if(j-2>=0) { //一.1
								if(contentArray[i][j].kind == contentArray[i][j-2].kind) {
									addChangeToFit([contentArray[i][j-2], contentArray[i][j-1]]);
									if(!findAll) return canChangeArr;
								}
							}
							if(i-1>=0) { //一.2
								if(contentArray[i][j].kind == contentArray[i-1][j-1].kind) {
									addChangeToFit([contentArray[i-1][j-1], contentArray[i][j-1]]);
									if(!findAll) return canChangeArr;
								}
							}
							if(i+1<maxR) { //一.3
								if(contentArray[i][j].kind == contentArray[i+1][j-1].kind) {
									addChangeToFit([contentArray[i+1][j-1], contentArray[i][j-1]]);
									if(!findAll) return canChangeArr;
								}
							} 
						}
						if(j+2<maxL && contentArray[i][j+2].canMove){
							if(i-1>=0) { //一.4
								if(contentArray[i][j].kind == contentArray[i-1][j+2].kind) {
									addChangeToFit([contentArray[i-1][j+2], contentArray[i][j+2]]);
									if(!findAll) return canChangeArr;
								}
							}
							if(i+1<maxR) { //一.5
								if(contentArray[i][j].kind == contentArray[i+1][j+2].kind) {
									addChangeToFit([contentArray[i+1][j+2], contentArray[i][j+2]]);
									if(!findAll) return canChangeArr;
								}
							}
							if(j+3<maxL) { //一.6
								if(contentArray[i][j].kind == contentArray[i][j+3].kind) {
									addChangeToFit([contentArray[i][j+2], contentArray[i][j+3]]);
									if(!findAll) return canChangeArr;
								}
							}
						}
					} else if(j+2<maxL) {
						if(contentArray[i][j].kind == contentArray[i][j+2].kind && contentArray[i][j+1].canMove) { //间隔相同  图三
							if(i-1 >= 0) { //三.1
								if(contentArray[i][j].kind == contentArray[i-1][j+1].kind) {
									addChangeToFit([contentArray[i-1][j+1], contentArray[i][j+1]]);
									if(!findAll) return canChangeArr;
								}
							}
							if(i+1<maxR) { //三.2
								if(contentArray[i][j].kind == contentArray[i+1][j+1].kind) {
									addChangeToFit([contentArray[i+1][j+1], contentArray[i][j+1]]);
									if(!findAll) return canChangeArr;
								}
							}
							if(j-1>=0) { //三.3 
								if(contentArray[i][j].kind == contentArray[i][j-1].kind) {
									addChangeToFit([contentArray[i][j+1], contentArray[i][j+2]]);
									if(!findAll) return canChangeArr;
								}
							}
							if(j+3<maxL) { //三.4
								if(contentArray[i][j].kind == contentArray[i][j+3].kind) {
									addChangeToFit([contentArray[i][j+1], contentArray[i][j]]);
									if(!findAll) return canChangeArr;
								}
							}
						}
					}
					if(i<maxR-1 && contentArray[i][j].kind == contentArray[i+1][j].kind) { //其中有两个相连  图二
						if(i-1>=0 && contentArray[i-1][j].canMove){//左1可以移动
							if(j-1>=0) { //二.1
								if(contentArray[i][j].kind == contentArray[i-1][j-1].kind) {
									addChangeToFit([contentArray[i-1][j-1], contentArray[i-1][j]]);
									if(!findAll) return canChangeArr;
								}
							}
							if(i-2>=0) { //二.3
								if(contentArray[i][j].kind == contentArray[i-2][j].kind) {
									addChangeToFit([contentArray[i-2][j], contentArray[i-1][j]]);
									if(!findAll) return canChangeArr;
								}
							}
							if(j+1<maxL) {//二.5
								if(contentArray[i][j].kind == contentArray[i-1][j+1].kind) {
									addChangeToFit([contentArray[i-1][j+1], contentArray[i-1][j]]);
									if(!findAll) return canChangeArr;
								}
							}
						}
						if(i+2<maxR && contentArray[i+2][j].canMove){
							if(j-1>=0) { //二.2
								if(contentArray[i][j].kind == contentArray[i+2][j-1].kind) {
									addChangeToFit([contentArray[i+2][j-1], contentArray[i+2][j]]);
									if(!findAll) return canChangeArr;
								}
							}
							if(i+3<maxR) { //二.4 
								if(contentArray[i][j].kind == contentArray[i+3][j].kind) {
									addChangeToFit([contentArray[i+3][j], contentArray[i+2][j]]);
									if(!findAll) return canChangeArr;
								}
							}
							if(j+1<maxL) { //二.6
								if(contentArray[i][j].kind == contentArray[i+2][j+1].kind) {
									addChangeToFit([contentArray[i+2][j+1], contentArray[i+2][j]]);
									if(!findAll) return canChangeArr;
								}
							}
						}
					} else if(i+2<maxR) {
						if(contentArray[i][j].kind == contentArray[i+2][j].kind && contentArray[i+1][j].canMove) { //两个相隔一格 图四
							if(j-1>=0) { //四.1
								if(contentArray[i][j].kind == contentArray[i+1][j-1].kind) {
									addChangeToFit([contentArray[i+1][j-1], contentArray[i+1][j]]);
									if(!findAll) return canChangeArr;
								}
							}
							if(j+1<maxL) { //四.2
								if(contentArray[i][j].kind == contentArray[i+1][j+1].kind) {
									addChangeToFit([contentArray[i+1][j+1], contentArray[i+1][j]]);
									if(!findAll) return canChangeArr;
								}
							}
							if(i-1>=0) { //四.3
								if(contentArray[i][j].kind == contentArray[i-1][j].kind) {
									addChangeToFit([contentArray[i+1][j], contentArray[i+2][j]]);
									if(!findAll) return canChangeArr;
								}
							}
							if(i+3<maxR) { //四.4
								if(contentArray[i][j].kind == contentArray[i+3][j].kind) {
									addChangeToFit([contentArray[i+1][j], contentArray[i][j]]);
									if(!findAll) return canChangeArr;
								}
							}
						}
					}
				}
			}
			
			return canChangeArr;
		}
		/**
		 * 
		 * @param arr
		 */
		private function addChangeToFit(arr:Array):void{
			canChangeArr.push(arr);
		}
		
		
		/**
		 * 挖矿模式上移过程中保留的“顶部消失棋子”数组
		 */
		private var upSaveArr:Array = [];
		
		
		/**
		 * 配置的球数组
		 */
		private var setQiuArr:Array;
		/**
		 * 获取模版球列最底下一个球的类型，掉落优先获取模版
		 * @param point				传入棋子
		 * @param isReplaceMoney	是否开局替换钻石为金，只有模版中的需要被替换
		 * @return 
		 */
		private function getQiuSetKind(point:QiuPoint):QiuPoint{
			if(upSaveArr[point.r].length>0){
				var tar:QiuPoint = upSaveArr[point.r].pop();
				point.resetKind(tar.kind, true);
				point.setBuff(tar.buff1);
				point.setBuff(tar.buff2);
			}else if(setQiuArr && setQiuArr[point.r] is Array && setQiuArr[point.r].length>0){
				var kind:int = setQiuArr[point.r].shift();
				if(isReplaceMoney && kind==QiuPoint.KIND_ZUAN){
					kind = QiuPoint.KIND_HUO;
				}
				point.resetKind(kind, true);
				getQiuSetSkill(point);
			}else if(isCreateNew){
				point.resetKind(getRandomKind(false), true);
			}
			return point;
		}
		
		/**
		 * 配置的球技能数组
		 */
		private var setSkillArr:Array;
		/**
		 * 获取模版球技能列中最底下一个技能
		 * @param point
		 */
		private function getQiuSetSkill(point:QiuPoint):void{
			if(setSkillArr && setSkillArr[point.r] is Array && setSkillArr[point.r].length>0){
				readBoardConfigBuff(point, setSkillArr[point.r].shift());
			}else{
				point.clearSkill();
			}
		}
		
		/**
		 * 配置的棋盘格子技能
		 */
		private var setGridArr:Array;
		/**
		 * 获取模版格子技能列中最底下一个技能
		 * @param point
		 */
		private function getGridSetSkill(point:QiuPoint):void{
			var i:int = point.r;
			var j:int = point.l;
			if(setGridArr && setGridArr[i] is Array && setGridArr[i][j]){
				gridArr[i][j] = new GridPoint(i, j, setGridArr[i][j], 1);
			}else if(gridArr[i][j]){
				(gridArr[i][j] as GridPoint).remove();
				gridArr[i][j] = null;
			}
		}
		
		/**
		 * 是否替换固定关卡中的钻石(为火棋子)
		 */
		private var isReplaceMoney:Boolean = false;
		/**
		 * 类型数组更新到对象
		 * @param boardInfo
		 * @param isReplace	是否替换固定关卡中的钻石(为火棋子)
		 */
		public function updateContent(boardInfo:BoardBaseVO, isReplace:Boolean=false):void{//qiuArr:Array, skillArr:Array=null, grids:Array=null):void{
			isReplaceMoney = isReplace
			setQiuArr = boardInfo.balls;
			setSkillArr = boardInfo.skills;
			setGridArr = boardInfo.grids;
			for(var i:int=0; i<maxR; i++){
				for(var j:int=0; j<maxL; j++){
					getGridSetSkill(getQiuSetKind(contentArray[i][j] as QiuPoint));
				}
			}
		}
		
		public function traceContent():void{
			for(var i:int=maxR-1; i>=0; i--){
				var str:String="";
				for(var j:int=0; j<maxL; j++){
					str+=contentArray[j][i].kind;
				}
				EventCenter.traceInfo(str);
			}
		}
		
		/**
		 * 获取阵列中球的副本
		 * @param row
		 * @param line
		 * @return 
		 */
		public function getPoint(row:int, line:int):QiuPoint{
			if(row>=0 && row<maxR && line>=0 && line<maxL){
				return contentArray[row][line];//.cloneQiu();
			}
			return null
		}
		public function getGrid(row:int, line:int):GridPoint{
			if(row>=0 && row<maxR && line>=0 && line<maxL){
				return gridArr[row][line];//.cloneQiu();
			}
			return null;
		}
		
		
//		/**
//		 * 把arr1根据去arr2重后合并至arr1
//		 * @param arr1
//		 * @param arr2
//		 */
//		public function concatSame(arr1:Array, arr2:Array):void{
//			for(var i:int=0; i<arr2.length; i++){
//				var point:QiuPoint = arr2[i] as QiuPoint;
//				if(!arr1.some(function(item:QiuPoint, index:int, arr:Array):Boolean{return (item.r==point.r && item.l==point.l)})){
//					arr1.push(point);
//				}
//			}
//		}
		
		
		/**
		 * 判断是否已经消除所有（或者某些类型）的棋子
		 * @param kinds 某些类型,如果为空那么就要全部清除
		 * @return 
		 */
		public function checkHasClearAll(kinds:Array=null):Boolean{
			for(var i:int=0; i<maxR; i++){
				for(var j:int=0; j<maxL; j++){
					var point:QiuPoint = contentArray[i][j];
					if(kinds){
						for(var k:int=0; k<kinds.length; k++){
							if(point.kind == kinds[k]){
								return false;
							}
						}
					}else if(point.kind!=QiuPoint.KIND_NULL && point.kind!=QiuPoint.KIND_GRAY){
						return false;
					}
				}
			}
			
			return true;
		}
		
		/**
		 * 判断棋盘上剩余棋子数量是否符合要求
		 * @param kind
		 * @param num	如果>8就表示棋盘上的棋子数要大于这个数，反之则小于这个数
		 * @return 
		 */
		public function fitBoardBallNum(kind:int, num:int):Boolean{
			var sum:int = 0;
			for(var i:int=0; i<maxR; i++){
				for(var j:int=0; j<maxL; j++){
					var point:QiuPoint = contentArray[i][j];
					if(point.kind == kind){
						if(++sum>num){
							if(num<8){
								return false;
							}else{
								return true;
							}
						}
					}
				}
			}
			return (num<8 && sum<=num);
		}
		
		/**
		 * 获取棋盘上指定棋子的数量
		 * @param kind
		 * @return 
		 */
		public function getTarBallNum(kind:int):int{
			var sum:int = 0;
			for(var i:int=0; i<maxR; i++){
				for(var j:int=0; j<maxL; j++){
					var point:QiuPoint = contentArray[i][j];
					if(point.kind == kind){
						sum++;
					}
				}
			}
			return sum;
		}
		/**
		 * 获取棋盘上包含某buff的棋子数量
		 * @param buffID
		 * @return 
		 */
		public function getTarBuffBalls(buffID:int):Array{
			var arr:Array = [];
			for(var i:int=0; i<maxR; i++){
				for(var j:int=0; j<maxL; j++){
					if((contentArray[i][j] as QiuPoint).hasBuff(buffID)){
						arr.push(contentArray[i][j]);
					}
				}
			}
			return arr;
		}
		/**
		 * 获取棋盘上有buff的棋子数量
		 * @param kind	某类棋子上包含buff
		 * @return 
		 */
		public function getBoardBuffNum(kind:int):int{
			var sum:int = 0;
			for(var i:int=0; i<maxR; i++){
				for(var j:int=0; j<maxL; j++){
					var point:QiuPoint = contentArray[i][j];
					if((point.buff1 || point.buff2) && (point.showKind==kind || kind==QiuPoint.KIND_100)){
						sum++;
					}
//					if((point.buff1 && (point.showKind==kind || kind==QiuPoint.KIND_100)) || (point.buff2 && (point.showKind==kind || kind==QiuPoint.KIND_100))){
//						sum++;
//					}
				}
			}
			return sum;
		}
		
		/**
		 * 生成新球，并附带上技能，只在消除的时候触发，因为需要在空位置生成新球
		 * @param r
		 * @param l
		 * @param kind
		 * @param buff
		 * @param activeBuff	生成技能后是否触发
		 */
		public function createSkillBall(r:int, l:int, kind:int=100, buff:BoardBuffVO=null, activeBuff:Boolean=false):BoardSkillActiveVO{
			var point:QiuPoint = (contentArray[r][l] as QiuPoint);
			var vo:BoardSkillActiveVO = new BoardSkillActiveVO(BoardSkillVO.CHESS_SKILL_KIND_4, createQiuDelayTime, point, 0)
			if(kind==QiuPoint.KIND_100){
				kind = getRandomKind();
			}
			if(kind!=QiuPoint.KIND_NULL){
				point.resetKind(kind);
				for(var i:int=0; i<_clearArr.length; i++){//生成新球后应该要在clearArr中去掉对应棋子，不然会被清掉
					var p:QiuPoint = (_clearArr[i] as QiuPoint);
					if(p.r==point.r && p.l==point.l){
						_clearArr.splice(i,1);
					}
				}
			}
			if(buff){
				if(activeBuff){
					point.setExtraBuff(buff.clone() as BoardBuffVO);
				}else if(point.kind!=QiuPoint.KIND_NULL){//直接替换棋子技能// && !point["buff"+buff.buffData.buffPosition]){//技能位置上没有技能才设置技能
					point.setBuff(buff.clone() as BoardBuffVO);
				}
			}
			vo.addClear([point]);
			
			return vo;
		}
		
		/**
		 * 从棋盘配置中读取棋子buff数据
		 * @param point
		 * @param buffInfo
		 */
		public function readBoardConfigBuff(point:QiuPoint, buffInfo:String):void{
			if(buffInfo=="" || buffInfo=="0"){
				return;
			}
			point.clearSkill();
			var arr:Array = ArrayFactory.stringToArray(buffInfo);
			for(var i:int=0; i<arr.length; i++){
				arr[i][0] = parseInt(arr[i][0]);
				arr[i][1] = parseInt(arr[i][1]);
				arr[i][2] = parseInt(arr[i][2]);
				if(arr[i][0]!=0){
					if(!arr[i][1]){//""/0/NaN/null就转换，至少1级 
						arr[i][1] = 1;
					}
					if(!arr[i][2]){//至少1层 
						arr[i][2] = 1;
					}
					var buff:BoardBuffVO = new BoardBuffVO(arr[i][0],arr[i][1]);
					if(arr[i][2]>0) buff.effectTime = arr[i][2];
					point.setBuff(buff);
				}
			}
		}
		
		
		//==============以下是棋盘技能获取的消除数组==============================================
		/**
		 * 数组判断添加棋子
		 * @param arr
		 * @param r
		 * @param l
		 * @param kind		
		 * @param hasBuff	是否有技能在棋子上(>0:技能ID,0:不判断；-1:有；-2:没有；-3:有buff1；-4:有buff2；-5:没有buff1；-6:没有buff2)
		 */
		public function setPoint(arr:Array, r:int, l:int, kind:int=100, hasBuff:int=0):void{
			var point:QiuPoint = getPoint(r, l);
			if(point && point.kind!=QiuPoint.KIND_NULL){
				if((kind==QiuPoint.KIND_100 || point.kind==kind) && point.hasBuff(hasBuff)){
					arr.push(point);
				}
			}
		}
		/**
		 * 获取棋盘上符合条件的棋子数组
		 * @param kind		指定类型
		 * @param excPoint	不包括某个点(技能触发原点)
		 * @param hasBuff	是否有技能在棋子上(>0:技能ID,0:不判断；-1:有；-2:没有；-3:有buff1；-4:有buff2；-5:没有buff1；-6:没有buff2)
		 */
		public function getFitPoints(kind:int=100, excPoint:QiuPoint=null, hasBuff:int=0):Array{
			var tarArr:Array=[];//符合标准的点
			//			this.traceContent();
			for(var i:int=0; i<maxR; i++){
				for(var j:int=0; j<maxL; j++){
					if(!(excPoint && excPoint.r==i && excPoint.l==j)){
						setPoint(tarArr, i, j, kind, hasBuff);
					}
				}
			}
			//			setRandomArray(tarArr);
			return tarArr;
		}
		/**
		 * 获取随机技能生效原点
		 * @param kind
		 */
		public function getRandomPoint(kind:int=100):QiuPoint{
			var tarArr:Array = getFitPoints();
			return tarArr[randomGeter.GetNext("board_skill_random_point_")%tarArr.length];
		}
		/**
		 * 用匹配seed的随机器打乱数组顺序
		 * @param arr
		 */
		private function setRandomArray(arr:Array):Array {
			var arr1:Array = arr.concat();
			var n:int=arr.length;
			for (var i:int=0; i<n; i++) {
				var random:uint = randomGeter.GetNext("board_random_arr_")%n;
				if(random!=i){
					var temp:* = arr1[i];
					arr1[i] = arr1[random];
					arr1[random] = temp;
				}
			}
			return arr1;
		}
		
		
		/**
		 * 按等级获取炸弹范围内的棋子
		 * [*,*,*,*,*,*,*,*]
		 * [*,*,*,*,*,*,*,*]
		 * [*,*,4,3,4,*,*,*]
		 * [*,4,2,1,2,4,*,*]
		 * [*,3,1,0,1,3,*,*]
		 * [*,4,2,1,2,4,*,*]
		 * [*,*,4,3,4,*,*,*]
		 * [*,*,*,*,*,*,*,*]
		 * @param lv 1-4
		 */
		public function skillUse_0(tarPoint:QiuPoint=null, lv:int=0):BoardSkillActiveVO{
			if(!tarPoint) tarPoint = getRandomPoint();
			var vo:BoardSkillActiveVO = new BoardSkillActiveVO(BoardSkillVO.CHESS_SKILL_KIND_2, 0, tarPoint, lv);
			var cArr:Array=[];
			//			setPoint(cArr, tarPoint.r, tarPoint.l);//禁掉，不包含自己
			if(vo.lv>0){
				setPoint(cArr, tarPoint.r-1, tarPoint.l),
				setPoint(cArr, tarPoint.r+1, tarPoint.l),
				setPoint(cArr, tarPoint.r, tarPoint.l-1),
				setPoint(cArr, tarPoint.r, tarPoint.l+1)
				if(vo.lv>1){
					setPoint(cArr, tarPoint.r-1, tarPoint.l-1),
					setPoint(cArr, tarPoint.r-1, tarPoint.l+1),
					setPoint(cArr, tarPoint.r+1, tarPoint.l-1),
					setPoint(cArr, tarPoint.r+1, tarPoint.l+1)
					if(vo.lv>2){
						setPoint(cArr, tarPoint.r-2, tarPoint.l),
						setPoint(cArr, tarPoint.r+2, tarPoint.l),
						setPoint(cArr, tarPoint.r, tarPoint.l-2),
						setPoint(cArr, tarPoint.r, tarPoint.l+2)
						if(vo.lv>3){
							setPoint(cArr, tarPoint.r-1, tarPoint.l-2),
							setPoint(cArr, tarPoint.r-1, tarPoint.l+2),
							setPoint(cArr, tarPoint.r-2, tarPoint.l-1),
							setPoint(cArr, tarPoint.r-2, tarPoint.l+1),
							setPoint(cArr, tarPoint.r+1, tarPoint.l-2),
							setPoint(cArr, tarPoint.r+1, tarPoint.l+2),
							setPoint(cArr, tarPoint.r+2, tarPoint.l-1),
							setPoint(cArr, tarPoint.r+2, tarPoint.l+1)
						}
					}
				}
			}	
			
			vo.addSkillSingleClear(cArr);
			setClearArr(vo.clearArr);
			return vo;
		}
		/**
		 * 按等级获取十字范围内的棋子,都有4排，改为1级全消
		 * [*,*,*,*,3,*,*,*]
		 * [*,*,*,*,2,*,*,*]
		 * [*,*,*,*,1,*,*,*]
		 * [*,*,*,*,1,*,*,*]
		 * [3,2,1,1,0,1,1,2]
		 * [*,*,*,*,1,*,*,*]
		 * [*,*,*,*,1,*,*,*]
		 * [*,*,*,*,2,*,*,*]
		 * @param tarPoint	原点
		 * @param lv 1-4
		 */
		public function skillUse_1(tarPoint:QiuPoint, lv:int=0):BoardSkillActiveVO{
			if(!tarPoint) tarPoint = getRandomPoint();
			var lvarr:Array = [7,3,4,7];
			var vo:BoardSkillActiveVO = new BoardSkillActiveVO(BoardSkillVO.CHESS_SKILL_KIND_3, lightningStreetTime, tarPoint, lv);
			var num:int = lvarr[lv];
			vo.addSkillSingleClear(skill_line("上", tarPoint, num), null, getPoint(tarPoint.r, (tarPoint.l+num)>maxL-1?maxL-1:tarPoint.l+num));
			vo.addSkillSingleClear(skill_line("下", tarPoint, num), null, getPoint(tarPoint.r, (tarPoint.l-num)<0?0:tarPoint.l-num));
			vo.addSkillSingleClear(skill_line("左", tarPoint, num), null, getPoint((tarPoint.r-num)<0?0:tarPoint.r-num, tarPoint.l));
			vo.addSkillSingleClear(skill_line("右", tarPoint, num), null, getPoint(tarPoint.r+num>maxR-1?maxR-1:tarPoint.r+num, tarPoint.l));
			
			setClearArr(vo.clearArr);
			return vo;
		}
		/**
		 * 按等级获取横排范围内的棋子
		 * [*,*,*,*,*,*,*,*]
		 * [*,*,*,*,*,*,*,*]
		 * [*,*,*,*,*,*,*,*]
		 * [2,2,2,2,2,2,2,2]
		 * [1,1,1,1,0,1,1,1]
		 * [3,3,3,3,3,3,3,3]
		 * [*,*,*,*,*,*,*,*]
		 * [*,*,*,*,*,*,*,*]
		 * @param tarPoint
		 * @param lv 1-3
		 */
		public function skillUse_2(tarPoint:QiuPoint, lv:int=0):BoardSkillActiveVO{
			if(!tarPoint) tarPoint = getRandomPoint();
			var vo:BoardSkillActiveVO = new BoardSkillActiveVO(BoardSkillVO.CHESS_SKILL_KIND_3, lightningStreetTime, tarPoint, lv);
			if(lv>0){
				vo.addSkillSingleClear(skill_line("左", tarPoint, 7), null, getPoint(0, tarPoint.l));
				vo.addSkillSingleClear(skill_line("右", tarPoint, 7), null, getPoint(maxR-1, tarPoint.l));
				if(lv>1){
					var l:int = tarPoint.l;
					if(l>0){
						if(lv>2 && l<maxL-1){
							vo.addSkillSingleClear(skill_line("左", getPoint(tarPoint.r, l+1), 7, true), getPoint(tarPoint.r, l+1), getPoint(0, l+1));
							vo.addSkillSingleClear(skill_line("右", getPoint(tarPoint.r, l+1), 7), getPoint(tarPoint.r, l+1), getPoint(maxR-1, l+1));
						}
						l -= 1;
					}else{//如果属于最下面那行，那么不论是2级还是3级都只消除2行
						l += 1;
					}
					vo.addSkillSingleClear(skill_line("左", getPoint(tarPoint.r, l), 7, true), getPoint(tarPoint.r, l), getPoint(0, l));
					vo.addSkillSingleClear(skill_line("右", getPoint(tarPoint.r, l), 7), getPoint(tarPoint.r, l), getPoint(maxR-1, l));
				}
			}
			
			setClearArr(vo.clearArr);
			return vo;
		}
		/**
		 * 按等级获取竖排范围内的棋子
		 * [*,*,*,2,1,3,*,*]
		 * [*,*,*,2,1,3,*,*]
		 * [*,*,*,2,1,3,*,*]
		 * [*,*,*,2,1,3,*,*]
		 * [*,*,*,2,0,3,*,*]
		 * [*,*,*,2,1,3,*,*]
		 * [*,*,*,2,1,3,*,*]
		 * [*,*,*,2,1,3,*,*]
		 * @param tarPoint
		 * @param lv 1-3
		 */
		public function skillUse_3(tarPoint:QiuPoint, lv:int=0):BoardSkillActiveVO{
			if(!tarPoint) tarPoint = getRandomPoint();
			var vo:BoardSkillActiveVO = new BoardSkillActiveVO(BoardSkillVO.CHESS_SKILL_KIND_3, lightningStreetTime, tarPoint, lv);
			if(lv>0){
				vo.addSkillSingleClear(skill_line("上", tarPoint, 7), null, getPoint(tarPoint.r, maxL-1));
				vo.addSkillSingleClear(skill_line("下", tarPoint, 7), null, getPoint(tarPoint.r, 0));
				if(lv>1){
					var r:int = tarPoint.r;
					if(r>0){
						if(lv>2 && r<maxR-1){
							vo.addSkillSingleClear(skill_line("上", getPoint(r+1, tarPoint.l), 7, true), getPoint(r+1, tarPoint.l), getPoint(r+1, maxL-1));
							vo.addSkillSingleClear(skill_line("下", getPoint(r+1, tarPoint.l), 7), getPoint(r+1, tarPoint.l), getPoint(r+1, 0));
						}
						r -= 1;
					}else{//如果属于最左面那行，那么不论是2级还是3级都只消除2行
						r += 1;
					}
					vo.addSkillSingleClear(skill_line("上", getPoint(r, tarPoint.l), 7, true), getPoint(r, tarPoint.l), getPoint(r, maxL-1));
					vo.addSkillSingleClear(skill_line("下", getPoint(r, tarPoint.l), 7), getPoint(r, tarPoint.l), getPoint(r, 0));
				}
			}
			setClearArr(vo.clearArr);
			return vo;
			
		}
		/**
		 * 随机获取x颜色的x个棋子，并且执行变色、创建、添加技能
		 * @param id			技能类型
		 * @param tarPoint		原始位置
		 * @param num			获取数量
		 * @param kind			获取类型
		 * @param tarKind		变为目标类型
		 * @param buff			添加的技能，如果需要添加技能而棋子上相应位置已有技能那么就不添加(那么就要获取相应位置不包含技能的棋子)
		 * @param activeBuff	生成技能后是否触发
		 */
		public function skillUse_4(id:int, tarPoint:QiuPoint, num:int, kind:int=100, tarKind:int=5, buff:BoardBuffVO=null, activeBuff:Boolean=false):BoardSkillActiveVO{
			if(!tarPoint) tarPoint = getRandomPoint();
			var vo:BoardSkillActiveVO = new BoardSkillActiveVO(id, lightningChainTime, tarPoint, 0);
			if(buff){//如果需要添加技能那么就要获取相应位置不包含技能的棋子
				var hasBuff:int = 0;//BaseInfo.getBuffPosition(buff.ID)==2 ? QiuPoint.HASNOT_BUFF_2 : QiuPoint.HASNOT_BUFF_1;
			}
			var tarArr:Array = setRandomArray(getFitPoints(kind, tarPoint, hasBuff)).slice(0, num);//符合标准的点，打乱
			vo.addSkillSingleClear(tarArr);
			if(tarKind!=QiuPoint.KIND_NULL || buff){
				for(var i:int=0; i<tarArr.length; i++){
					var point:QiuPoint = tarArr[i] as QiuPoint; 
					createSkillBall(point.r, point.l, tarKind, buff, activeBuff);
				}
			}
			switch(id){
				case BoardSkillVO.CHESS_SKILL_KIND_0:
				case BoardSkillVO.CHESS_SKILL_KIND_1: 
				case BoardSkillVO.CHESS_SKILL_KIND_2:
				case BoardSkillVO.CHESS_SKILL_KIND_3:
					setClearArr(vo.clearArr);
					break;
				
			}
			return vo;
		}
		
		/**
		 * 获取棋子旁边符合条件的一个棋子，用于复制buff
		 * @param tarPoint
		 * @param buff
		 */
		public function skillUse_5(tarPoint:QiuPoint, buff:BoardBuffVO):BoardSkillActiveVO{
			var cArr:Array=[];
			setPoint(cArr, tarPoint.r-1, tarPoint.l),
			setPoint(cArr, tarPoint.r+1, tarPoint.l),
			setPoint(cArr, tarPoint.r, tarPoint.l-1),
			setPoint(cArr, tarPoint.r, tarPoint.l+1)
			
			if(cArr.length==0) return null;
			
			var point:QiuPoint = cArr[randomGeter.GetNext("board_beside_")%cArr.length];
			if(point){
				return createSkillBall(point.r, point.l, point.kind, buff);
			}
			return null;
		}
		
		/**
		 * 单方向消除，2个等级，1级1排，2级3排
		 * @param direction 	上下左右4个方向选择一个
		 * @param tarPoint		原点必须要有，一般由之前的技能函数获得
		 * @param line			某方向上的排数
		 */
		public function skillUse_6(direction:String, tarPoint:QiuPoint, line:int=1):BoardSkillActiveVO{
			var vo:BoardSkillActiveVO = new BoardSkillActiveVO(BoardSkillVO.CHESS_SKILL_KIND_5, lightningStreetTime, tarPoint, line);
			var r:int = tarPoint.r;
			var l:int = tarPoint.l;
			vo.addSkillSingleClear(skill_line(direction,tarPoint,7));
			if(line==3){
				switch(direction){
					case "上":
					case "下":
						if(r<maxR-1)vo.addSkillSingleClear(skill_line(direction,getPoint(r+1, l),7));
						if(r>0)vo.addSkillSingleClear(skill_line(direction, getPoint(r-1, l), 7));
						break;
					case "左":
					case "右":
						if(l<maxL-1)vo.addSkillSingleClear(skill_line(direction,getPoint(r, l+1),7));
						if(l>0)vo.addSkillSingleClear(skill_line(direction, getPoint(r, l-1), 7));
						break;
				}
			}
			setClearArr(vo.clearArr);
			return vo;
		}
		
		/**
		 * 按等级获取叉字范围内的棋子,都有4排,改为1级全消
		 * [4,*,*,*,*,*,*,*]
		 * [*,3,*,*,*,*,*,3]
		 * [*,*,2,*,*,*,2,*]
		 * [*,*,*,1,*,1,*,*]
		 * [*,*,*,*,0,*,*,*]
		 * [*,*,*,1,*,1,*,*]
		 * [*,*,2,*,*,*,2,*]
		 * [*,3,*,*,*,*,*,3]
		 * @param tarPoint	原点
		 * @param lv 1-4
		 */
		public function skillUse_7(tarPoint:QiuPoint, lv:int=0):BoardSkillActiveVO{
			if(!tarPoint) tarPoint = getRandomPoint();
			var lvarr:Array = [7,2,3,7];
			var vo:BoardSkillActiveVO = new BoardSkillActiveVO(BoardSkillVO.CHESS_SKILL_KIND_3, lightningStreetTime, tarPoint, lv);
			var num:int = lvarr[lv];
			var tarNum:int = num;
			tarNum = Math.min(Math.min(tarPoint.r, num), Math.min(maxL-1-tarPoint.l, num));
			vo.addSkillSingleClear(skill_line("左上", tarPoint, num), null, getPoint(tarPoint.r-tarNum, tarPoint.l+tarNum));
			tarNum = Math.min(Math.min(tarPoint.r, num), Math.min(tarPoint.l, num));
			vo.addSkillSingleClear(skill_line("左下", tarPoint, num), null, getPoint(tarPoint.r-tarNum, tarPoint.l-tarNum));
			tarNum = Math.min(Math.min(maxR-1-tarPoint.r, num), Math.min(maxL-1-tarPoint.l, num));
			vo.addSkillSingleClear(skill_line("右上", tarPoint, num), null, getPoint(tarPoint.r+tarNum, tarPoint.l+tarNum));
			tarNum = Math.min(Math.min(maxR-1-tarPoint.r, num), Math.min(tarPoint.l, num));
			vo.addSkillSingleClear(skill_line("右下", tarPoint, num), null, getPoint(tarPoint.r+tarNum, tarPoint.l-tarNum));
			
			setClearArr(vo.clearArr);
			return vo;
		}
		
		/**
		 * 获取某个方向的棋子
		 * @param direction 	上下左右左上左下右上右下8个方向选择一个
		 * @param tarPoint		原点必须要有，一般由之前的技能函数获得
		 * @param num			某方向上的数量
		 * @param isAdd			是否添加原点进行消除
		 */
		public function skill_line(direction:String, tarPoint:QiuPoint, num:int=2, isAdd:Boolean=false):Array{
			var cArr:Array = isAdd?[tarPoint]:[];//包含原始点，展示时重复消除不会有叠加效果
			var i:int = 0;
			switch(direction){
				case "上":
					for(i=tarPoint.l+1; i<maxL && i<=tarPoint.l+num; i++){
						setPoint(cArr, tarPoint.r, i);
					}
					break;
				case "下":
					for(i=tarPoint.l-1; i>=0 && i>=tarPoint.l-num; i--){
						setPoint(cArr, tarPoint.r, i);
					}
					break;
				case "左":
					for(i=tarPoint.r-1; i>=0 && i>=tarPoint.r-num; i--){
						setPoint(cArr, i, tarPoint.l);
					}
					break;
				case "右":
					for(i=tarPoint.r+1; i<maxR && i<=tarPoint.r+num; i++){
						setPoint(cArr, i, tarPoint.l);
					}
					break;
				case "左上":
					i=1;
					while(tarPoint.r-i>=0 && tarPoint.l+i<maxL && i<=num){
						setPoint(cArr, tarPoint.r-i, tarPoint.l+i);
						i++;
					}
					break;
				case "左下":
					i=1;
					while(tarPoint.r-i>=0 && tarPoint.l-i>=0 && i<=num){
						setPoint(cArr, tarPoint.r-i, tarPoint.l-i);
						i++;
					}
					break;
				case "右上":
					i=1;
					while(tarPoint.r+i<maxR && tarPoint.l+i<maxL && i<=num){
						setPoint(cArr, tarPoint.r+i, tarPoint.l+i);
						i++;
					}
					break;
				case "右下":
					i=1;
					while(tarPoint.r+i<maxR && tarPoint.l-i>=0 && i<=num){
						setPoint(cArr, tarPoint.r+i, tarPoint.l-i);
						i++;
					}
					break;
			}
			return cArr;
		}
		
		public function updateBoardParam(vo:BoardConfigVO):void{
			this.gameActiveMode = vo.activeMode;
			this.isInitCanClear = Boolean(vo.isInitCanClear);
			this.exchangeTime = vo.exchangeTime;
			this.fallTime = vo.fallTime;
			this.clearTime = vo.clearTime;
			this.sequenceTime = vo.sequenceTime;
			this.kindArr = vo.kindArr;
			this.kindChanceArr = vo.chanceArr; 
			this.initInfo(vo.maxR, vo.maxL, vo.maxKinds, Boolean(vo.isCreateNew), Boolean(vo.isDelayFall));
		}
		
		/**
		 * 使用道具点击消除某颗球，规则之外的技能，需要记录玩家使用技能操作
		 * 不能在解谜关中使用
		 */
		public function skillUse_ouchClear(point:QiuPoint):BoardSkillActiveVO{
			var vo:BoardSkillActiveVO = new BoardSkillActiveVO(BoardSkillVO.CHESS_SKILL_KIND_2, 0, point, 0);
			vo.addSkillSingleClear([point]);
			setClearArr(vo.clearArr);
			return vo;
			
			//			var vo:QiuClearVO = new QiuClearVO(QiuClearVO.QIU_CLEAR_SKILL);
			//				vo.addClear([]);
			//			if(point && point.kind!=QiuPoint.KIND_NULL){
			//				pointClear(point);
			//			}
			//			_clearArr.sortOn(["r", "l"], Array.DESCENDING | Array.NUMERIC);
			//			return vo
		}
		
		/**
		 * 随机交换配置棋盘球的五行（解谜关使用，格局一样），使玩家看起来是不同的关卡
		 * 只改五行不改钻/灰/其他
		 * @param arr		棋盘布局(8*24)全部换掉
		 */
		public function randomSetBoardKind(arr:Array):void{
			var tempArr:Array = setRandomArray(WuxingVO.wuxingArr);
			for(var i:int=0; i<arr.length; i++){
				var arr1:Array = arr[i];
				for(var j:int=0; j<arr1.length; j++){
					var kind:int = arr1[j];
					if(WuxingVO.judgeIsWuxing(kind)){
						arr1[j] = tempArr[kind];
					}
				}
			}
		}
		
		/**
		 * 左右交换棋盘配置，为了看起来是一个全新的布局;
		 * 解法复盘也应该跟着变坐标
		 * @param arr	
		 * @param l		棋盘列(宽)
		 * @param solve	解谜解法
		 * @return 		返回修正后的解谜过程
		 */
		public function turnSetBoard(arr:Array, l:int, solve:String=""):String{
			var n:int = Math.ceil(l/2);//平均数，单数中间就不用动
			for(var i:int=0; i<n; i++){
				var temp:Array = arr[i];
				arr[i] = arr[l-1-i];
				arr[l-1-i] = temp;
			}
			
			if(!solve) return "";
			var excArr:Array = solve.match(/exc:\d:\d:\d:\d/g);
			for(i=0; i<excArr.length; i++){
				var str:String = excArr[i];
				var action:Array = str.split(":");//取出行动记录
				action[1] = l-1-parseInt(action[1]);
				action[3] = l-1-parseInt(action[3]);
				solve = solve.replace(str, action.join(":"));
			}
			//TODO:exc:2:1:2:0,可以改成exc2120,
			return solve;
		}
	}
}