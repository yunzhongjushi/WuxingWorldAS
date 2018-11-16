package com.model.vo {
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.config.wuxing.WuxingConfig;
	import com.model.vo.level.LevelListVO;
	import com.utils.ArrayFactory;
	import com.utils.TimerFactory;
	
	
	/**
	 * 
	 * @author hunterxie
	 * 
	 */
	public class WuxingVO extends BaseObjectVO{
		public static const WUXING_RESOURCE_UPDATE:String="WUXING_RESOURCE_UPDATE";
		
		/**
		 * 任意/总和，如果是五行改变就是全体改变
		 */
		public static const VALUE_KIND_ANY:int = 110;
		
		/**
		 * 五行资源/等级/上限中最大的那个
		 */
		public static const VALUE_KIND_MAX:int = 111;
		
		public static var wuxingNum:int = 5;
		/**
		 * 五行
		 */
		public static const wuxingArr:Array=["金", "木", "土", "水", "火"];
		public static const wuxingStrArr:Object={"金":0, "木":1, "土":2, "水":3, "火":4};
		public static const WO_KE:String="我克制的五行";
		public static const KE_WO:String="克制我的五行";
		public static const WO_SHENG:String="我生的五行";
		public static const SHENG_WO:String="生我的五行";
		
		
		/**
		 * 
		 */
		private static var wuxingColor:Array=[0xFFD700, 0x00CC33, 0xFF9900, 0x4A6FFF, 0xFF0000, 0xFF00FF, 0xFFFFFF];
		public static function getColor(kind:int):Number{
			if(wuxingColor[kind]){
				return wuxingColor[kind];
			}
			return 0xFFD700;
		}
		/**
		 * 把文字变成对应五行的颜色
		 * @param str
		 * @param kind
		 */
		public static function getColorStr(str:String, kind:int):String{
			var num:Number = getColor(kind);
			return "<font color='#"+num.toString(16)+"'>"+str+"</font>";
		}
		
		/**
		 * 五行html文字
		 * @param wuxing
		 */
		public static function getHtmlWuxing(wuxing:int):String{
			return getColorStr(getWuxing(wuxing), wuxing);
		}
		
		
		
		/**
		 * 是否是玩家（不是精灵）
		 */
//		public var isPlayer:Boolean = false;
		/**
		 * 五行模块等级
		 */
		public var wuxingPropertyArr:Array=[0, 0, 0, 0, 0];
		/**
		 * 五行模块等级临时附加值，战斗中用到
		 */
		private var wuxingPropertyArr_add:Array=[0, 0, 0, 0, 0];
		/**
		 * 五行模块等级临时附加百分比，战斗中用到
		 */
		private var wuxingPropertyArr_per:Array=[1, 1, 1, 1, 1];
		
		/**
		 * 五行等级上加的总点数
		 */
		public function get allAddProperty():int{
			var points:int = 0;
			for(var i:int=0; i<wuxingPropertyArr.length; i++){
				var lv:int = wuxingPropertyArr[i];
				if(lv>0){
					points += lv-1;
				}
			}
			return points
		}
		public function getWuxingPropertyArr():Array{
			return wuxingPropertyArr.concat();
		}
		public function setProperty(wuxing:int, lv:int):void{
			if(wuxingPropertyArr[wuxing] != lv){
				wuxingPropertyArr[wuxing] = lv;
				updateWuxingProperty(wuxing);
			}
		}
		private function updateWuxingProperty(wuxing:int):void{
			var finalLV:int = getTotalWuxingProperty(wuxing);//对应五行最终等级
//			if(isPlayer){
				increaseArr[wuxing] = LevelListVO.getIncreaseRes(wuxing);
				maxResourceArr[wuxing] = WuxingConfig.getLevelCapacity(finalLV);
//			}else{
//				increaseArr[index] = BaseInfo.getWuxingLvInfo(finalLV, "f_inc");
//				maxResourceArr[index] = BaseInfo.getWuxingLvInfo(finalLV, "f_max");
//			}
			//			increaseStart();
			dispatchResource(wuxing);
		}
		public function getWuxingProperty(wuxing:int):int{
			if(wuxing==VALUE_KIND_MAX){
				return ArrayFactory.getMax(wuxingPropertyArr);
			}else if(wuxing==VALUE_KIND_ANY){
				return ArrayFactory.getSum(wuxingPropertyArr);
			}parseInt
			return wuxingPropertyArr[wuxing];
		}
		/**
		 * 对应五行最终等级
		 * @param wuxing
		 * @return 
		 */
		public function getTotalWuxingProperty(wuxing:int):int{
			return wuxingPropertyArr[wuxing]+wuxingPropertyArr_add[wuxing];
		}
		
		/**
		 * 修改五行等级增量
		 * @param wuxing	
		 * @param value		值
		 * @param per		百分比（小于1大于0）
		 * @param isRemove	是否移除buff
		 */
		public function setWuxingProperty_add(wuxing:int, value:int, per:Number=1, isRemove:Boolean=false):void{
			if(isRemove){
				wuxingPropertyArr_add[wuxing] -= value;
				wuxingPropertyArr_add[wuxing] /= per;
			}else{
				wuxingPropertyArr_add[wuxing] += value;
				wuxingPropertyArr_add[wuxing] *= per;
			}
			
			updateWuxingProperty(wuxing);
		}
		
		/**
		 * 五行资源的数量
		 */
		public var resourceArr:Array = [0, 0, 0, 0, 0];
		/**
		 * 五行资源的上限
		 */
		private var maxResourceArr:Array = [0, 0, 0, 0, 0];
		/**
		 * 资源上限临时附加值，战斗中用到
		 */
		private var maxResourceArr_add:Array = [0, 0, 0, 0, 0];
		/**
		 * 资源上限临时附加百分比，战斗中用到
		 */
		private var maxResourceArr_per:Array = [1, 1, 1, 1, 1];
		
		/**
		 * buff改变资源上限值，上限值增加时对应的现有值增加对应百分比，而上限值减少时现有值不改变，只对超出上限值的部分进行减少
		 * @param wuxing	
		 * @param value		值
		 * @param per		百分比（小于1大于0）
		 * @param isRemove	是否移除buff
		 */
		public function changeMaxResAdd(wuxing:int, value:int, per:Number=1, isRemove:Boolean=false):void{
			if(isRemove){
				maxResourceArr_add[wuxing] -= value;
				maxResourceArr_per[wuxing] /= per;
			}else{
				maxResourceArr_add[wuxing] += value;
				maxResourceArr_per[wuxing] *= per;
			}
		}
		
		/**
		 * 获取最大资源数量
		 * @param info 中文（金木土水火）或者下标
		 * @return
		 */
		public function getMaxResource(wuxing:int):int {
			return (maxResourceArr[wuxing]+maxResourceArr_add[wuxing])*maxResourceArr_per[wuxing];
		}
		public function getMaxResourceArr():Array{
			return maxResourceArr.concat();
		}
		
		//============================================================================================
		/**
		 * 五行资源的增长速度(按秒增长)
		 */
		private var increaseArr:Array = [0, 0, 0, 0, 0];
		private var increaseArr_add:Array = [0, 0, 0, 0, 0];
		private var increaseArr_per:Array = [1, 1, 1, 1, 1];
		
		/**
		 * buff改变五行资源的增长速度
		 * @param wuxing	
		 * @param value		值
		 * @param per		百分比（小于1大于0）
		 * @param isRemove	是否移除buff
		 */
		public function changeIncreaseAdd(wuxing:int, value:int, per:Number=1, isRemove:Boolean=false):void{
			if(isRemove){
				increaseArr_add[wuxing] -= value;
				increaseArr_per[wuxing] /= per;
			}else{
				increaseArr_add[wuxing] += value;
				increaseArr_per[wuxing] *= per;
			}
		}
		
		/**
		 * 记录的当前更新资源的时间（毫秒数）
		 */
		private var _nowTime:Number;
		public function get nowTime():Number{
			return _nowTime
		}
		public function set nowTime(value:Number):void{
			_nowTime = value;
		}
		/**
		 * 五行主属性
		 */
		public var myWuxing:int;
		
		
		/**
		 * 
		 * @param wuxing
		 */
		public function WuxingVO(wuxing:int=0):void {//, isPlayer:Boolean=false):void {
			this.myWuxing = wuxing;
//			this.isPlayer = isPlayer;
		}
		
		/**
		 * 资源增长计时开始，UserInfo中的五行模拟增长;
		 * 每次使用资源后都重新计时;
		 * 
		 * 一是战斗开始，自动增长;
		 * 二是游戏中一直模拟增长;
		 */
		public function increaseStart():void{
			if(nowTime==0){
				nowTime = (new Date).time;
			}else{
				increaseRun();
			}
			TimerFactory.loop(2000, this, increaseRun);
			
//			if(!increaseTimer){
//				increaseTimer = new Timer(2000);
//				increaseTimer.addEventListener(TimerEvent.TIMER, increaseRun);
//				if(nowTime==0){
//					nowTime = (new Date).time;
//				}else{
//					increaseRun();
//				}
//				
//				increaseTimer.start();
//			}
		}
		
		public function updateWuxingResource(resourceArr:Array, maxResourceArr:Array=null, increaseArr:Array=null):void {
			this.resourceArr=resourceArr;
			if(maxResourceArr) this.maxResourceArr=maxResourceArr;
			if(increaseArr) this.increaseArr=increaseArr;
		}
		
		/**
		 * 派发元素变动事件
		 */
		public function dispatchResource(wuxing:int):void{
			event(WUXING_RESOURCE_UPDATE, wuxing);
		}
		
		
		/**
		 * 获取资源数量
		 * @param info 中文（金木土水火）或者下标
		 * @return
		 */
		public function getResource(wuxing:int):int {
			if(wuxing==VALUE_KIND_MAX){
				return ArrayFactory.getMax(resourceArr);
			}else if(wuxing==VALUE_KIND_ANY){
				return ArrayFactory.getSum(resourceArr);
			}
			return resourceArr[wuxing];
		}
		
		/**
		 * 增加资源
		 * @param wuxing
		 * @param num	改变的数量
		 * @param per	改变后的百分比
		 * @return 		改变后的数量
		 */
		public function addResource(wuxing:int, num:int, per:Number=1):int{
			if(wuxing==QiuPoint.KIND_100){//五项都加
				for(var i:int=0; i<5; i++){
					setResource(i, (num+resourceArr[i])*per);
				}
				return 0;
			}
			return setResource(wuxing, (num+resourceArr[wuxing])*per);
		}
		
		public function setResource(wuxing:int, num:Number):int{
			var max:int = getMaxResource(wuxing);
			if(num>max){
				num = max;
			}else if(num<0){
				num = 0;
			}
			resourceArr[wuxing] = num;
			dispatchResource(wuxing);
			return num;
		}
		
		/**
		 * 检查资源是否满足使用条件；或者减掉对应使用资源；
		 * 技能、升级等资源使用都通过此函数；
		 * @param arr	长度为5的数组，对应相应的资源量
		 * @param isUse	是否使用资源，如果使用即减掉对应资源
		 * @return 
		 */
		public function useRes(arr:Array, isUse:Boolean=true):Boolean{
			if(isUse && !useRes(arr, false)){//使用前先检查
				throw Error("五行资源扣除错误：未达到扣除条件");
				return false;
			}
			for(var i:int=0; i<5; i++){
				if(isUse){
					if(arr[i]>0){
						this.resourceArr[i] -= arr[i];
						dispatchResource(i);
					}
				}else if(this.resourceArr[i]<arr[i]){
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 模拟五行增长
		 * @return 
		 */
		public function increaseRun(e:* = null):void{
			var dispatchJudge:Boolean=false;
			var fullJudge:Boolean = false;
			var time:Number = (new Date).time;
			var num:int = Math.floor((time-nowTime)/1000);
				nowTime = time;
			if(num>0){
				for(var i:int=0; i<resourceArr.length; i++){
					if(increaseArr[i]>0){
						setResource(i, resourceArr[i]+increaseArr[i]*num);
					}
				}
			}
		}
		
		/**
		 * 获取五行相生相克信息，或者中文和下标的转换
		 * @param wuxing	下标或者中文（金木土水火）
		 * @param kind		与传入五行的关系,空就返回跟传入值相反的类型
		 * @param returnInt	为true就返回int型的wuxing，否则返回string
		 * @return 			如果kind是空那么函数返回传入值的数组转换结果（中文就返回数字），否则返回跟传入值相同类型
		 */
		public static function getWuxing(wuxing:*, kind:String="", returnInt:Boolean=true):* {
//			if(wuxing==QiuPoint.KIND_101) return QiuPoint.KIND_NULL;
			if(wuxingArr[wuxing]==null && wuxingStrArr[wuxing]==null){
				trace(wuxingArr[wuxing], wuxingStrArr[wuxing]);
				throw Error("获取的五行超出范围："+wuxing); 
			}
			
			var index:int = (wuxing is int) ? wuxing : wuxingStrArr[wuxing];
			if(kind==""){//空就返回跟传入值相反的类型
				return (wuxing is int) ? wuxingArr[index] : index;
			}
			switch (kind) {
				case WO_KE:
					index=getCircleInfo(0, 4, index+1);
					break;
				case KE_WO:
					index=getCircleInfo(0, 4, index-1);
					break;
				case WO_SHENG:
					index=getCircleInfo(0, 4, index+3);
					break;
				case SHENG_WO:
					index=getCircleInfo(0, 4, index-3);
					break;
			}
			return returnInt ? index : wuxingArr[index];
		}
		/**
		 * 检查是否属于五行：0-4，金木土水火
		 * @param wuxing
		 * @return 
		 */
		public static function judgeIsWuxing(wuxing:*):Boolean{
			if(wuxingArr[wuxing]==null) return false;
			return true;
		}
		
		/**
		 * 获取环形数组中的增量值，如果传入的值超出了范围即通过环形计算返回范围中的值
		 * @param minNum	必须<maxNum
		 * @param maxNum	必须>minNum
		 * @param num		目标值
		 * @return
		 */
		public static function getCircleInfo(minNum:int, maxNum:int, num:int):int {
			var range:int=maxNum - minNum + 1;
			if (range <= 0) {
				return 0;
			}
			if (num > maxNum) {
				var addNum:int = (num-maxNum) % range;
				return addNum == 0 ? maxNum : minNum + addNum - 1;
			}
			if (num < minNum) {
				addNum=(minNum - num) % range;
				return addNum == 0 ? minNum : maxNum - addNum + 1;
			}
			return num;
		}
		
		/**
		 * 获取伤害相克系数
		 * @param attack
		 * @param defend
		 * @return 
		 */
		public static function getHurt_ke(attackWuxing:int, defendWuxing:int):Number{ 
			var num:Number = 1;
			
			if(attackWuxing == getWuxing(defendWuxing, WuxingVO.KE_WO)){//被克，攻击1.5倍
				num = BaseInfo.DAMEGE_FROME_KE_WO;
			}else if(attackWuxing == getWuxing(defendWuxing, WuxingVO.WO_KE)){//相克，攻击减半
				num = BaseInfo.DAMEGE_FROME_WO_KE;
			}
			
			return num;
		}
		
		override public function updateObj(info:Object):void{
			super.updateObj(info);
			for(var i:int=0; i<wuxingPropertyArr.length; i++){ 
				this.setProperty(i, wuxingPropertyArr[i]);
			}
		}
//		public function updateInfo(info:Object):WuxingVO{
//			for (var i:Object in info) {
//				EventCenter.traceInfo(i+":"+info[i], "this_"+i+":"+this[i]);
//				if (this.hasOwnProperty(i)) {
//					if(i=="wuxingPropertyArr"){
//						for(var j:* in info[i]){
//							this.setProperty(j, info[i][j]);
//						}
//					}else{
//						this[i]=info[i];
//					}
//				} else {
//					EventCenter.traceInfo("WuxingVO.updateInfo没有找到对应值："+i);
//				}
//			}
//			return this;
//		}
		
//		/**
//		 * 设置战斗资源，战斗中的精灵资源跟玩家资源公用一个五行资源
//		 * @param vo
//		 * @return
//		 */
//		public function setFightRes(vo:WuxingVO):WuxingVO{
//			this.resourceArr = vo.resourceArr;
//			this.maxResourceArr = vo.maxResourceArr;
//			this.maxResourceArr_add = vo.maxResourceArr_add;
//			this.maxResourceArr_per = vo.maxResourceArr_per;
//			return this;
//		}
		
		public function updateByVO(vo:WuxingVO):WuxingVO{
			this.myWuxing = vo.myWuxing;
			for(var i:int=0; i<5; i++){
				this.setProperty(i, vo.getWuxingProperty(i));
				this.setResource(i, vo.getResource(i));
				this.increaseArr_add[i] = 0;
				this.maxResourceArr_add[i] = 0;
				this.maxResourceArr_per[i] = 1;
			}
			
			return this;
		}
		
		/**
		 * 当前资源的平均分配，技能效果使用
		 * @return 
		 */
		public function setAverageResourceNum():void{
			var sum:int = 0;
			for(var i:int=0; i<5; i++){
				sum += this.resourceArr[i];
			}
			
			var num:int = Math.round(sum/5);
			for(i=0; i<5; i++){
				setResource(i, num);
			}
		}
	}
}