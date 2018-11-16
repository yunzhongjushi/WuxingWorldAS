package com.model.vo.skill.fight {
	import com.model.event.EventCenter;
	import com.model.logic.BaseGameLogic;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.fairy.FairyVO;
	import com.model.vo.skill.BaseSkillVO;
	import com.model.vo.skill.BoardBuffVO;
	import com.model.vo.skill.SkillTriggerVO;
	import com.model.vo.user.FightUserVO;
	
	import listLibs.Glog;
	
	
	/**
	 * 精灵技能，对精灵/棋盘生效
	 * @author hunterxie
	 */
	public class FairySkillVO extends BoardBuffVO{
		/**
		 * 技能使用失败：
		 * 被动技能触发失败就是没有效果；
		 * 主动技能使用失败如果是资源问题即提示
		 */
		public static var SKILL_TRIGGER_FAIL:String = "SKILL_TRIGGER_FAIL";
		/**
		 * 通用公共CD
		 */
		public static var PUBLIC_CD:int = 1;
		
		/**
		 * 刷新CD时间
		 */
		public static var CD_INFO_UPDATE:String = "CD_INFO_UPDATE";

		
		
		/**
		 * 技能冷却时间（回合）,被动技能/buff没有冷却时间
		 */
		public function get cd():uint{
			return (_cd+nowCD_add)*nowCD_per;
		}
		protected var _cd:uint;

		/**
		 * 当前倒计时的CD，现为AI控制精灵技能施放倒计时
		 * @return 
		 */
		public function get nowCD():int{
			return _nowCD;
		}
		public function set nowCD(value:int):void{
			if(value<0){
				_nowCD = 0;
			}else if(value>cd){
				_nowCD = cd;
			}else{
				_nowCD = value;
			}
			event(CD_INFO_UPDATE);
		}
		private var _nowCD:int = 0;
		/**
		 * 技能影响的CD改变值
		 */
		public var nowCD_add:int = 0;
		/**
		 * 技能影响的CD改变百分比
		 */
		public var nowCD_per:Number = 1;
		/**
		 * buff改变五行资源的增长速度
		 * @param value		值
		 * @param per		百分比（小于1大于0）
		 * @param isRemove	是否移除buff
		 */
		public function changeCDAdd(value:int, per:Number=1, isRemove:Boolean=false):void{
			if(isRemove){
				nowCD_add -= value;
				nowCD_per /= per;
			}else{
				nowCD_add += value;
				nowCD_per *= per;
			}
		}
		
		
		private var isInPublicCd:Boolean = false;
		
		/**
		 * 是否可以使用,冷却中不能使用
		 */
		public var isActivating:Boolean = true;
		
		
		/**
		 * 技能当前属于哪个精灵
		 */
//		public var ownFairy:FairyVO;
		
		/**
		 * 拥有/附带此技能的精灵,生效时判断计算
		 */
		public var useFairy:FairyVO;
		/**
		 * 技能的生效目标用户
		 * @return 
		 */
		public function get tarUser():FightUserVO{
			return (myUser as FightUserVO).tarUser;
		}
		
		/**
		 * 生效目标精灵
		 * @return 
		 */
		public function get targetFairy():FairyVO{
			return tarUser.getFirstFairy();
		}
		
		
		
		
		
		/**
		 * 精灵技能
		 * @param id
		 * @param lv
		 * @param useFairy		携带者
		 * @param effect		透传到上一层
		 */
		public function FairySkillVO(id:int, lv:int, useFairy:FairyVO, effect:FairySkillEffectVO=null):void {
			this.useFairy = useFairy;
			this.myUser = useFairy.myUser;
			super(id, lv, effect);
//			if(!(this.myUser is FightUserVO)){
//				trace("!");
//			}
		}
		
		/**
		 * 不是buff，调用回boardSkillVO的updateInfo
		 * @param id
		 * @param lv
		 */
		override public function updateInfo(id:int=0, lv:int=1):void {
			super.sUpdate(id, lv);
		}
		override protected function sUpdate(id:int=0, lv:int=1):void {
			super.updateInfo(id, lv);
		}
		
		public function updateLV(lv:int):void{
			this.LV = lv;
		}
		
		override protected function init():void{
//			var num:int = ;
//			this.wuxing = getKindString(data.wuxing);//(num==QiuPoint.KIND_101 && useFairy) ? useFairy.wuxing : WuxingVO.getWuxing(num,"",false);
			
			this.nowCD = this._cd = data.cd;
			effectArr = [];
			for(var i:int=0; i<data.effects.length; i++){
				effectArr.push(new FairySkillEffectVO(data.effects[i], this));
			}
		}
		
		/**
		 * 技能使用/生效，从效果列表里面计算具体数据然后通过事件发出去，由逻辑层收到事件后处理
		 * @param tar	目标精灵
		 * @param isAI	是否AI倒计时触发
		 * @return 
		 */
		public function useSkill(tar:FairyVO, isAI:Boolean=false):Boolean{
			if(isActivating){
				if(this.cd>0){
					nowCD = this.cd;
//					this.isActivating = false;//暂时去掉CD限制，CD改为AI倒计时
				}
				for(var i:int=0; i<effectArr.length; i++){
					var effect:FairySkillEffectVO = effectArr[i];
					if((isAI || effect.judgeFairyTrigger(this.useFairy)) && effect.getTargetFairys(tar).length>0){//自己使用触发、计算目标数组
						this.useFairy.event(FairyVO.SKILL_USE_SUCCESS, effect);
					}
				}
				this.useFairy.event(SkillTriggerVO.SKILL_TRIGGER_SEND, SkillTriggerVO.TRIGGER_KIND_11);//主动技能使用后触发
				return true;
			}

			EventCenter.traceInfo("技能冷却中，不能使用!!!");
			return false;
		}
		
		override public function onTurnOver():void{
//			--nowCD;//CD改为AI施放倒计时，所以回合结束不减CD
			if(nowCD==0){
				this.isActivating = true;
			}
		}
		
		/**
		 * 对精灵前提事件进行侦听,触发被动技能；
		 * @param fairy
		 * @param triggerID
		 * @param index		用于递归调用
		 */
		public function onFairyTrigger(fairy:FairyVO, triggerID:int, index:int=0):void{
			if(this.LV==0){
				return;
			}
//			if(this.ID==177 && triggerID==SkillTriggerVO.TRIGGER_KIND_4){
//				trace("!!!"); 
//			} 
			for(var i:int=index; i<this.effectArr.length; i++){ 
				var effect:FairySkillEffectVO = this.effectArr[i];
				var kind:int = nowClearResource ? nowClearResource.kind : null;
//				if(triggerID==SkillTriggerVO.TRIGGER_KIND_5){//攻击技能的ID 
//					kind = this.wuxing;
//				}
				
				if(effect.trigger.data.id==triggerID && (effect.trigger.data.kind==QiuPoint.KIND_100 || kind==BaseGameLogic.getKindString(effect.trigger.data.kind, QiuPoint.KIND_100, this.useFairy.wuxing))){//如果有kind就表明需要对比消除kind
					if(effect.judgeFairyTrigger(fairy)){
						Glog.trig(this.useFairy.userID+"-"+this.useFairy.nickName,this.name);
						if(i==0) onFairyTrigger(fairy, SkillTriggerVO.TRIGGER_KIND_24, 1);//如果第一个条件满足就直接用24判断触一次其他效果
						if(effect.getTargetFairys(fairy).length>0){
//							if(this.ID==127){//调试用寻找触发技能ID
//								trace(this.name);
//							}
							if(BaseSkillVO.judgeBoardEffectKind(effect.data.effectKind)){
								effect.triggerPoint = nowClearResource.point;
							}
							EventCenter.traceInfo(this.useFairy.nickName+"技能触发____："+this.name); 
							this.useFairy.event(FairyVO.SKILL_USE_SUCCESS, effect);
						}
					} 
				}
			}
		}
	}
}