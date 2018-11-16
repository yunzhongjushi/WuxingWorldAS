package com.model.vo.skill{
	import com.model.vo.config.skill.BuffConfigVO;
	import com.model.vo.config.skill.SkillConfig;
	import com.model.vo.config.skill.SkillEffectConfigVO;
	import com.model.vo.user.ChessboardUserVO;
	
//	import listLibs.Glog;
	
	
	
	
	/**
	 * 棋子上的buff效果
	 * @author hunterxie
	 */
	public class BoardBuffVO extends BoardSkillVO{
		/** 移除buff */
		public static const CLEAR_BUFF:String = "CLEAR_BUFF";
		/** 改变buff状态 */
		public static const CHANGE_BUFF_STATE:String = "CHANGE_BUFF_STATE";
		/** buff效果触发，用于存储延迟展示 */
		public static const BUFF_EFFECT:String = "BUFF_EFFECT";
		
		
		
		/**
		 * 技能使用的时间(系统时间毫秒数)
		 */
		private var useSkillTime:int = 0;
		
		/**
		 * 技能附加的位置
		 */
//		public var buffPosition:int=0;
		
		/**
		 * 类型：buff/debuff
		 */
//		public var isDebuff:Boolean = false;
		/**
		 * 结束方式（27:到期, 28:收集值为0, 29:参照值为0）；这些方式已经废除，新的判断如下：
		 */
//		public var endKind:String;
		
		
		/**
		 * buff配置信息
		 */
		public var buffData:BuffConfigVO;
		
		
		/**
		 * 技能收集值（-1不判断），到0结束buff<br>
		 * 有收集值就不判断生效次数或者生效1次，所以展示的数字就是收集值而不是层数
		 */
		public function get collect():int{
			return _collect;
		}
		public function set collect(value:int):void{
			if(_collect==value) return;
			_collect = value;
			if(value==0){
				onBuffTrigger(SkillTriggerVO.TRIGGER_KIND_21);
				clear();
			}else{
				event(CHANGE_BUFF_STATE);
			}
		}
		private var _collect:int=0;
		
		
		/**
		 * 层数，生效次数（-1为永久），每生效一次减一，到0结束buff
		 */
		public function get effectTime():int{
			return _effectTime;
		}
		public function set effectTime(value:int):void{
			_effectTime = value;
			if(value==0){
				clear();
			}else{
				if(buffData.maxLayer!=-1 && _effectTime>buffData.maxLayer){
					_effectTime = buffData.maxLayer;
				}
				event(CHANGE_BUFF_STATE);
			}
		}
		private var _effectTime:int;
		
		
		/**
		 * 清除buff的层数
		 */
		public function removeEffectTime(n:int=1):void{
			if(effectTime>=n){
				effectTime -= n;
			}else{
				effectTime = 0;
			}
		}
		
		
		
		/**
		 * 持续时间（回合），每过一回合减一，到0结束buff
		 */
		public function get continuedTime():int{
			return _continuedTime;
		}
		public function set continuedTime(value:int):void{
			if(_continuedTime>0){
//				Glog.udbuff(this.buffData.label,value);
			}
			_continuedTime = value;
		}
		private var _continuedTime:int;
		
		
		/**
		 * 替代优先级
		 */
//		public var priority:int = 0;
		
		/**
		 * 类型（用于替代）
		 */
//		public var replaceKind:int = 0;
		
		/**
		 * 生成这个buff的效果VO
		 */
		private var originEffect:BoardSkillEffectVO;
		
		override public function get icon():String{
			if(!buffData) return "b默认";
			if(buffData.icon==BoardSkillVO.BOARD_ICON_KIND_LIGHT || buffData.icon==BoardSkillVO.BOARD_ICON_KIND_VORTEX){
				return buffData.icon+"_"+buffData.wuxing;
			}
			return buffData.icon;
		}
		
		
		
			
		/**
		 * 棋子buff,不同等级用不同ID表示
		 * @param id
		 * @param lv
		 * @param effect	生成此Buff的EffectVO
		 */
		public function BoardBuffVO(id:int, lv:int=1, effect:BoardSkillEffectVO=null):void{
			if(effect){
				this.originEffect = effect;
				this.myUser = effect.myUser;
			}
			super(id, lv, myUser);
		}
		
		/**
		 * 跳过当前的的updateInfo
		 * @param id
		 * @param lv
		 */
		protected function sUpdate(id:int=0, lv:int=1):void {
			super.updateInfo(id, lv);
		}
		override public function updateInfo(id:int=0, lv:int=1):void {
			this.ID = id;
			this.LV = lv;
			this.buffData = SkillConfig.getBuffInfo(id);
			if(!buffData){
				throw Error("找不到对应ID的技能配置！！"); 
				return;
			} 
			this.name = buffData.label;
			this._describe = buffData.describe;
//			this.wuxing = WuxingVO.getWuxing(buffData.wuxing, "", false);
			
			
			this.collect 		= buffData.collect;
			this.continuedTime 	= buffData.continuedTime;
			this.effectTime 	= buffData.effectTime;
//			this.isDebuff 		= Boolean(int(data.@isDebuff));
//			this.buffPosition 	= int(data.@buffPosition);
//			this.priority 	= int(data.@priority);
//			this.replaceKind 	= int(data.@replaceKind);
			
//			this.power = int(data.@power);
//			this.effectKind = int(data.@effectKind);
//			this.equipKind = int(data.@equipKind);
//			this.useKind = int(data.@useKind);
			
			init();
		}
		override protected function init():void{
			effectArr = [];
			for(var i:int=0; i<buffData.effects.length; i++){
				effectArr.push(new BoardSkillEffectVO(buffData.effects[i], this));
			}
		}
		
		/**
		 * buff内部的触发机制，不用判断其他五行、角色、精灵等前提 
		 * 如棋子消除时、回合结束时
		 */
		public function onBuffTrigger(triggerID:int):void{
			for(var i:int=0; i<this.effectArr.length; i++){
				var effect:BoardSkillEffectVO = this.effectArr[i]; 
				if(effect.trigger.data.id==triggerID && myUser){
//					trace(myUser, "???", ChessboardUserVO.BOARD_SKILL_USE_SUCCESS);
					event(BUFF_EFFECT, effect);
					myUser.event(ChessboardUserVO.BOARD_SKILL_USE_SUCCESS, effect);
				}
			}
		}
		
		
		
		/**
		 * 最多可叠加的层数
		 */
//		public var layer:int = 1;
		
		/**
		 * 是否可以叠加
		 * @return 
		 */
		public function get canAddLayer():Boolean{
			return buffData.maxLayer>1 || buffData.maxLayer==-1;
		} 
		/**
		 * 清除buff的层数
		 */
//		public function removeLayers(num:int=1):void{
////			layer-=num;
//			layer--;//每次减一层
//			if(layer==0){
//				clear();
//			}else{
//				event(CHANGE_BUFF_STATE);
//			}
//		}
		
		/**
		 * 添加buff的层数
		 */
		public function addLayers(num:int=1):void{
			if(!canAddLayer){
				throw Error("不可叠加层数");
				return;
			}
			effectTime += num;
//			layer += num;
//			if(layer>buffData.maxLayer){
//				layer = buffData.maxLayer;
//			}
			this.continuedTime 	= buffData.continuedTime;//增加层数要重置持续时间，主要用于精灵，棋子技能持续时间就是生效次数
//			this.effectTime 	= buffData.effectTime;//增加层数要重置生效次数？
		}
		
		public function refresh():void{
			this.collect 		= buffData.collect;
			this.continuedTime 	= buffData.continuedTime;
			this.effectTime 	= buffData.effectTime;
		}
		
		/**
		 * 去掉buff，会触发移除buff为前提的效果
		 * @param point	buff所属的球
		 */
		public function clear():void{//point:QiuPoint=null
			onBuffTrigger(SkillTriggerVO.TRIGGER_KIND_23);
			this.setQiuPoint(null);
			event(CLEAR_BUFF);
			
//			Glog.clbuff(this.name);
		}
		
		public function remove():void{
			this.buffData 	= null;
			this.myUser 	= null;
			this.effectArr 	= [];
		}
		
		
		/**
		 * 有此技能的棋子能否移动，限制技能将不能
		 * @return 
		 */
		public function checkCanMove():Boolean{
			for(var i:int=0; i<this.effectArr.length; i++){
				var effect:BoardSkillEffectVO = this.effectArr[i];
				if(effect.data.id==SkillEffectConfigVO.board_effect_8){// || effect.data.id==SkillEffectConfigVO.board_effect_9){//
					return effectTime==0;//>0或者==-1
				}
			}
			return true;
		}
		
		/**
		 * 检查是否包含某个效果ID
		 * @param id
		 */
		public function checkEffectID(id:int):Boolean{
			for(var i:int=0; i<this.effectArr.length; i++){
				var effect:BoardSkillEffectVO = this.effectArr[i];
				if(effect.data.id==id){
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 把这个Buff的数据复制一份新的
		 * @param qiu
		 */
		override public function clone():BaseSkillVO{
			var buff:BoardBuffVO = new BoardBuffVO(this.ID, this.LV, this.originEffect);
//			buff.wuxing			= this.wuxing;
			buff.collect 		= this.collect;
			buff.effectTime 	= this.effectTime;
			buff.continuedTime 	= this.continuedTime;
			
			return buff;
		}
		
		/**
		 * 回合结束，buff减少持续时间
		 */
		public function onTurnOver():void{
			if(continuedTime!=-1)
				continuedTime--;
		}
		
		/**
		 * 回合开始，buff减少持续时间
		 */
		public function onTurnStart():void{
			if(_continuedTime==0){
				onBuffTrigger(SkillTriggerVO.TRIGGER_KIND_20);
				clear();
			}else{
				event(CHANGE_BUFF_STATE);
			}
		}
		
		/**
		 * buff替换<br>
		 * 如果ID相同则添加层数<br>
		 * 如果ID不同则先清除buff再换成新ID<br>
		 * 这时如爆炸等buff触发是否要消除棋子？TODO
		 * @param buff
		 */
//		public function replace(buff:BoardBuffVO):void{
//			if(this.ID==buff.ID){
//				addLayers(buff.layer);
//			}else{
//				this.ID = buff.ID;
//				this.layer = 1;
//			}
//		}
	}
}

