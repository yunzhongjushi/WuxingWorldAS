package com.model.vo.chessBoard {
	import com.model.event.ObjectEvent;
	import com.model.vo.skill.BoardBuffVO;
	
	import flas.events.EventDispatcher;
	
	
	public class QiuPoint extends EventDispatcher{
		public static const UPDATE_QIU_INFO:String = "UPDATE_QIU_INFO";
		public static const UPDATE_QIU_BUFF_INFO:String = "UPDATE_QIU_BUFF_INFO";
		
		/**
		 * 棋子类型：0-金
		 */
		public static const KIND_JIN:int = 0;
		/**
		 * 棋子类型：1-木
		 */
		public static const KIND_MU:int = 1;
		/**
		 * 棋子类型：2-土
		 */
		public static const KIND_TU:int = 2;
		/**
		 * 棋子类型：3-水
		 */
		public static const KIND_SHUI:int = 3;
		/**
		 * 棋子类型：4-火
		 */
		public static const KIND_HUO:int = 4;
		/**
		 * 棋子类型：5-空
		 */
		public static const KIND_NULL:int = 5;
		/**
		 * 棋子类型：6-灰
		 */
		public static const KIND_GRAY:int = 6;
		/**
		 * 棋子类型：7-钻
		 */
		public static const KIND_ZUAN:int = 7;
		/**
		 * 棋子类型：8-经
		 */
		public static const KIND_JING:int = 8;
		/**
		 * 棋子类型：10-删除列
		 */
		public static const KIND_DELETE_LINE:int = 10;
		
		
		/**
		 * 任意类型，如果是五行改变就是全体改变
		 */
		public static const KIND_100:int = 100;
		/**
		 * 跟随精灵五行
		 */
		public static const KIND_101:int = 101;
		/**
		 * 跟随技能五行————技能五行现在跟随精灵五行
		 */
		public static const KIND_102:int = 102;
		/**
		 * 跟随附在棋子的类型
		 */
		public static const KIND_103:int = 103;
		/**
		 * 跟随当前消除的五行
		 */
		public static const KIND_104:int = 104;
		/**
		 * 所有五行
		 */
		public static const KIND_105:int = 105;
		
		
		/**
		 * 是否拥有buff
		 */		
		public static const HAS_BUFF:int = -1;
		/**
		 * 是否没有buff
		 */
		public static const HASNOT_BUFF:int = -2;
		/**
		 * 是否拥有buff1
		 */
		public static const HAS_BUFF_1:int = -3;
		/**
		 * 是否拥有buff2
		 */
		public static const HAS_BUFF_2:int = -4;
		/**
		 * 是否没有buff1
		 */
		public static const HASNOT_BUFF_1:int = -5;
		/**
		 * 是否没有buff2
		 */
		public static const HASNOT_BUFF_2:int = -6;
		
		
		private var _r:int;
		public function get r():int{
			return _r;
		}
		private var _l:int;
		public function get l():int{
			return _l;
		}
		public var tarX:Number = 0;
		public var tarY:Number = 0;
		
//		public function get kind():String{
//			return _kind;
//		}
//		public function set kind(value:String):void{
//			_kind = value;
//			if(value==""){
//				trace("!!!!!");
//			}
//		}
		public var kind:int;
		
		/**
		 * 用来展示的内容，在判定结束重置类型后改变
		 * 如：消除后技能触发时kind已经为空了，就需要通过这个判断
		 */
		public var showKind:int = KIND_NULL;
		public var showBuff1:BoardBuffVO;
		public var showBuff2:BoardBuffVO;
		/**
		 * 展示buff效果数组，用于视觉层处理，不影响数据逻辑
		 * @see BoardSkillEffectVO
		 */
		public var showBuffEffect:Array = [];
		public function recordBuff():void{
			if(buff1){
				showBuff1 = buff1.clone() as BoardBuffVO;
			}
			if(buff2){
				showBuff2 = buff2.clone() as BoardBuffVO;
			}
		}
		/**
		 * 清除棋子上的附加信息(buff等)
		 */
//		public function clearRecord():void{
//			this.showBuff1 = null;
//			this.showBuff2 = null;
////			this.showKind = KIND_NULL;
//		}
		
		/**
		 * 通过技能消除的单个棋子的得分
		 */
		public var skillClearScore:int;
		/**
		 * 默认棋子类型
		 * 金,木,土,水,火,空,灰,钻,经,五,宝,秘
		 */
		public static const kindStringArr:Array=["金", "木", "土", "水", "火", "空", "灰", "钻", "经", "五", "删除列", "宝", "秘"];
		/**
		 * 技能效果中，根据类型数组位置获取类型中文
		 * @param kind
		 */
		public static function getKindStrig(kind:int):String{
			return kindStringArr[kind];
		}
		
		/**
		 * 附加在球上的技能，效果技能1，如爆炸、毒针；
		 */
		public var buff1:BoardBuffVO;
		/**
		 * 消除前判断的技能2，效果技能2，如冰冻、锁定；
		 */
		public var buff2:BoardBuffVO;
		
		/**
		 * 额外技能效果数组<br>
		 * 用来存储临时生成的技能，生成技能随后触发
		 */
		public var extraBuffs:Array = [];
		
		/**
		 * 设置额外技能效果，生成技能随后触发
		 */
		public function setExtraBuff(buff:BoardBuffVO):void{
			extraBuffs.push(buff);
			buff.setQiuPoint(this);
			buff.clear();
		}
		/**
		 * 设置棋子技能：<br>
		 * 为null、""、"0"时清空；<br>
		 * 为string时或者为BaseSkillVO时设置BUFF<br>
		 * 设置为生成替换是因为可能有精灵生成的FairySkillVO
		 * @param buffInfo
		 */
		public function setBuff(buff:BoardBuffVO):void{//buff:BuffVO=null):void{
			if(!buff) return;
			var correspond:BoardBuffVO = (this["buff"+buff.buffData.buffPosition] as BoardBuffVO);
//			if(this["buff"+buff.buffData.buffPosition] && (this["buff"+buff.buffData.buffPosition] as BoardBuffVO).ID==buff.ID){//ID相同就增加层数
//				(this["buff"+buff.buffData.buffPosition] as BoardBuffVO).addLayers(buff.effectTime);
//				return;
//			}
			
//			if(buff.buffData.buffPosition==1){
//				if(this.buff1){
//					this.buff1.setQiuPoint(null);
//					this.buff1.off(BoardBuffVO.CLEAR_BUFF, this, clearBuff);
//				}
//				this.buff1 = buff;
//			}else if(buff.buffData.buffPosition==2){
//				if(this.buff2){
//					this.buff2.setQiuPoint(null);
//					this.buff2.off(BoardBuffVO.CLEAR_BUFF, this, clearBuff);
//				}
//				this.buff2 = buff;
//			}
			if(correspond){
				if(correspond.ID==buff.ID){//ID相同就增加层数
					correspond.addLayers(buff.effectTime);
					return;
				}
				correspond.off(BoardBuffVO.CLEAR_BUFF, this, clearBuff);//clear也会触发移除，这里放前面就少触发一次事件
				correspond.clear();
			}
			this["buff"+buff.buffData.buffPosition] = buff;
			buff.setQiuPoint(this);
			buff.on(BoardBuffVO.CLEAR_BUFF, this, clearBuff, false, 0, true);
			buff.on(BoardBuffVO.BUFF_EFFECT, this, onBuffEffect, false, 0, true);
			
//			buff.on(BoardBuffVO.CHANGE_BUFF_STATE, changeBuffState, false, 0, true);
		}
		
		
		/**
		 * 返回棋子技能的字符串表达形式
		 * @return "ID_LV_layer:ID_LV_layer"
		 */
		public function outSkill():String{
			var str:String = "";
			if(this.buff1){
				str += this.buff1.ID;
				if(buff1.LV>1){
					str += "_"+buff1.LV;
				}
				if(buff1.effectTime>1){
					if(buff1.LV==1){//等级等于1上面就没有添加，而层数前是等级
						str += "_"+buff1.LV;
					}
					str += "_"+buff1.effectTime;
				}
			}
			if(this.buff2){
				if(str!=""){
					str += ":";
				}
				str += this.buff2.ID;
				if(buff2.LV>1){
					str += "_"+buff2.LV;
				}
				if(buff2.effectTime>1){
					if(buff2.LV==1){//等级等于1上面就没有添加，而层数前是等级
						str += "_"+buff2.LV;
					}
					str += "_"+buff2.effectTime;
				}
			}
			return str;
		}
		
		/**
		 * 判断是否符合buff条件<br>
		 * @param hasBuff	
		 * >0:固定技能ID	是否有技能在棋子上（用来判断是否可消除）<br>
		 * 0:不判断；<br>
		 * -1:有任意buff；<br>
		 * -2:是否没有buff；<br>
		 * -3:有1号位buff；<br>
		 * -4:有2号位buff；<br>
		 * -5:1号位没有buff；<br>
		 * -6:2号位没有buff；<br>
		 */
		public function hasBuff(hasBuff:int):Boolean{
			switch(hasBuff){
				case 0:
					return true; 
				case HAS_BUFF:
					return Boolean(buff1 || buff2);
				case HASNOT_BUFF:
					return Boolean(!buff1 && !buff2);
				case HAS_BUFF_1:
					return Boolean(buff1);
				case HAS_BUFF_2:
					return Boolean(buff2);
				case HASNOT_BUFF_1:
					return !buff1;
				case HASNOT_BUFF_2:
					return !buff2;
					break;
				default:
					return ((buff1 && buff1.ID==hasBuff) || (buff2 && buff2.ID==hasBuff));
			}
//			return false;
		}
		
		
		/**
		 * 是否有某个技能（用来判断是否可消除）
		 * @param skillID
		 * @return 
		 */
		public function hasBuffEffect(arr:Array):Boolean{
			for(var i:int=0; i<arr.length; i++){
				if((buff1 && buff1.ID==arr[i]) || (buff2 && buff2.ID==arr[i])){
					return true;
				}
			}
			return false;
		}
		
//		/**
//		 * buff状态改变，引发图形效果(等级数字改变)
//		 */
//		private function changeBuffState(e:*):void{
//			var vo:BoardBuffVO = e.target as BoardBuffVO;
//			
//		}
		
		private function onBuffEffect(e:ObjectEvent):void{
			showBuffEffect.push(e.data);
		}
		private function clearBuff(e:ObjectEvent):void{
//			e.target.off(BoardBuffVO.CHANGE_BUFF_STATE, changeBuffState);
			e.target.off(BoardBuffVO.CLEAR_BUFF, this, clearBuff);
			if(buff1 == e.target){
				buff1 = null;
			}else if(buff2 == e.target){
				buff2 = null;
			}
		}
		
		/**
		 * 重置棋子时，直接清理棋子buff，不做相关触发
		 */
		public function clearSkill():void{
			if(buff1){
//				buff1.off(BoardBuffVO.CHANGE_BUFF_STATE, this, changeBuffState);
				buff1.off(BoardBuffVO.CLEAR_BUFF, this, clearBuff);
			}
			if(buff2){
//				buff1.off(BoardBuffVO.CHANGE_BUFF_STATE, this, changeBuffState);
				buff2.off(BoardBuffVO.CLEAR_BUFF, this, clearBuff);
			}
			buff1 = buff2 = null;
			while(this.extraBuffs.length>0){
				var buff:BoardBuffVO = this.extraBuffs.pop();
				buff.setQiuPoint(null);
			}
		}
		
		/**
		 * @param row	行
		 * @param line	列
		 * @param kind	类型
		 */
		public function QiuPoint(row:int=0, line:int=0, kind:int=QiuPoint.KIND_NULL) {
			resetRL(row, line);
			resetKind(kind);
		}
		
		/**
		 * 
		 * @param kind
		 * @param isClearSkill
		 * @return 
		 */
		public function resetKind(kind:int=QiuPoint.KIND_NULL, isClearSkill:Boolean=false):QiuPoint {
			if(kind!=QiuPoint.KIND_100) this.kind = this.showKind = kind;
			if(kind==QiuPoint.KIND_NULL || isClearSkill) clearSkill();
			return this;
		}
		
		public function resetRL(row:int, line:int):QiuPoint {
			if(row!=-1) this._r = row;
			if(line!=-1) this._l = line;
			return this;
		}
		
		/**
		 * 把这个球的数据复制一份新的
		 * @param qiu
		 */
		public function cloneQiu():QiuPoint{
			var point:QiuPoint = new QiuPoint(this.r, this.l, this.kind);
			if(buff1) point.buff1 = buff1.clone() as BoardBuffVO;
			if(buff2) point.buff2 = buff2.clone() as BoardBuffVO;
			return point;
		}
		
		
		/**
		 * 返回是否可以进行消除匹配
		 * @return 
		 */
		public function get canFitClear():Boolean{
			return !(this.kind==QiuPoint.KIND_NULL || this.kind==QiuPoint.KIND_GRAY);
		}
		
		
		/**
		 * 返回是否可以进行移动交换,空或者有限制技能将不能移动，影响到整盘可移动后消除判断
		 * @return 
		 */
		public function get canMove():Boolean{
			return !(this.kind==QiuPoint.KIND_NULL || (this.buff2 && !this.buff2.checkCanMove()));
		}
		
		public function dispatchUpdate(showJudge:Boolean=true):void{
			event(UPDATE_QIU_INFO, showJudge);
		}
	}
}