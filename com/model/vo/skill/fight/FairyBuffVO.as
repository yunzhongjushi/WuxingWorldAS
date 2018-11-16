package com.model.vo.skill.fight{
	import com.model.vo.config.skill.SkillEffectConfigVO;
	import com.model.vo.fairy.FairyVO;
	import com.model.vo.skill.BaseSkillVO;
	import com.utils.Formula;
	
	
	
	/**
	 * 精灵产生的buff效果，装备在棋子/精灵身上
	 * @author hunterxie
	 */
	public class FairyBuffVO extends FairySkillVO{
		/**
		 * 使用此buff的精灵,生效时判断计算
		 */
		public var originFairy:FairyVO;
		/**
		 * 技能附在哪个精灵身上（如果附在棋子上此值就为null）
		 */
		public var ownFairy:FairyVO;
		/**
		 * 产生这个buff的精灵技能效果
		 */
		private var originEffect:FairySkillEffectVO;
		
		
		/**
		 * 技能按公式得出的描述；
		 * {}表示需要计算后显示的公式  ；
		 * lv表示技能等级；
		 * hp表示精灵生命；
		 * ap表示精灵攻击力；
		 * dp表示精灵防御；
		 * @1 表示取几位小数
		 * @return 
		 */
		override public function get describe():String{
			//			var str:String = "表示取几位小数{(ap+1.5*dp)%lv+hp@1}表示取几位小数";
			
			if(_describe.indexOf("{")!=-1) {
				var arr:Array = _describe.slice(_describe.indexOf("{")+1, _describe.indexOf("}")).split("@");
				var str1:String =arr[0];
				var value:int = Math.pow(10, parseInt(arr[1]));
				//				trace(arr[0], arr[1]);
				var str2:String = str1.replace(/ap/g, this.originFairy.finalAP).replace(/dp/g, this.originFairy.finalDP).replace(/hp/g, this.originFairy.HP_max).replace(/lv/g, LV)
				//				trace(str2);
				var str3:Number = Math.floor(Formula.calculateStr(str2)*value)/value;
				//				trace(str3);
				return (_describe.replace(_describe.slice(_describe.indexOf("{"), _describe.indexOf("}")+1), str3));
			}
			
			return _describe;
		}
		
		
		
		/***********************************
		 * 精灵产生的buff效果，装备在棋子/精灵身上
		 * <buff id="106" icon="SkillFreeze" label="防护罩" wuxing="2" buffPosition="0" collect="50" continuedTime="-1" effectTime="-1" layer="1" isDebuff="0" priority="0" replaceKind="0">
				<describe>防护罩</describe>
				<effect effectKind="0" id="0" kind="-1" target="0" referTarget="0" refer="0" referKind="-1" value="0" value2="0" percent="0" percent2="0">
					<trigger who="0" id="0" kind="-1" chance="1" judge="0" value="0" percent="0" target="0" refer="0" referKind="-1" target2="0" refer2="0" referKind2="-1"/>
				</effect>
			</buff>
		 * @param effect		生成此Buff的VO
		 **********************************/
		public function FairyBuffVO(effect:FairySkillEffectVO=null):void{
			this.originEffect = effect;
			this.originFairy = effect.useFairy;
			if(effect.data.target){
				
			}
			this.useFairy = effect.tarFairy;
			
			super(effect.data.value2, effect.skill.LV, useFairy, effect);
			
			var value:int = Math.ceil(effect.data.percent+(effect.data.percent2-effect.data.percent)/100*this.LV);
			switch(effect.data.value){
				case 1://如果配置了回合数
					continuedTime = value;
					break;
				case 2://如果配置了生效次数
					effectTime = value;
					break;
				case 3://如果配置了收集值
					collect = value;
					break;
			}
		}
		
		override protected function init():void{
//			this.wuxingCost = [parseInt(data.cost.@金), parseInt(data.cost.@木), parseInt(data.cost.@土), parseInt(data.cost.@水), parseInt(data.cost.@火)];
			effectArr = [];
			for(var i:int=0; i<buffData.effects.length; i++){
				effectArr.push(new FairySkillEffectVO(buffData.effects[i], this));
			}
		}
		
		/**
		 * 不是Skill，调用回boardSkillVO的updateInfo
		 * @param id
		 * @param lv
		 */
		override public function updateInfo(id:int=0, lv:int=1):void {
			super.sUpdate(id, lv);
		}
		/**
		 * 对前提事件进行侦听,触发BUFF, 修改buff相关的动态信息
		 * @param fairy		触发目标
		 * @param triggerID
		 */
		override public function onFairyTrigger(fairy:FairyVO, triggerID:int, index:int=0):void{
			for(var i:int=0; i<this.effectArr.length; i++){
				var effect:FairySkillEffectVO = this.effectArr[i];
				if(triggerID==effect.trigger.data.id){
//					if(this.ID==138){
//						trace("???");
//					}
					if(this.useFairy==fairy && effect.data.id==SkillEffectConfigVO.fairy_effect_114){//需要修改收集值/MP的效果，直接在此对目标生效而不当效果传出
						if(!effect.judgeFairyTrigger(fairy)){//未成功触发（未命中）
							break;
						}
						switch(effect.data.refer){
//							case BaseSkillVO.REFER_KIND_9://利用角色的MP吸收伤害
//								var wuxing:String = getKindString(effect.kind);
//								var num:int = this.tarUser.wuxingInfo.getResource(wuxing)*effect.percent;//能够吸收的值
//								if(this.useFairy.nowHurt>num){
//									this.useFairy.nowHurt_Absorb += num;
//									this.tarUser.wuxingInfo.setResource(wuxing, 0);
//									this.collect = 0;
//								}else{
//									this.collect = this.tarUser.wuxingInfo.addResource(wuxing, -this.useFairy.nowHurt/effect.percent);
//									this.useFairy.nowHurt_Absorb += this.useFairy.nowHurt;
//								}
//								break;
							case BaseSkillVO.REFER_KIND_25:
								if(this.useFairy.nowHurt>this.collect){
									this.useFairy.nowHurt_Absorb += this.collect;
									this.collect = 0;
								}else{
									this.collect -= this.useFairy.nowHurt;
									this.useFairy.nowHurt_Absorb += this.useFairy.nowHurt;
								}
								break;
						}
					}else if(effect.judgeFairyTrigger(fairy) && effect.getTargetFairys(fairy).length>0){
						this.useFairy.event(FairyVO.SKILL_USE_SUCCESS, effect);
						if(effectTime!=-1){
							effectTime--; 
						}
					}
				}
			}
		}
		
		/**
		 * 去掉buff
		 */
		override public function clear():void{
			super.clear();
			
//			this.tarUser		= null;
//			this.useFairy		= null;
//			this.originFairy	= null;
//			this.originEffect 	= null;
		}
		
		/**
		 * 清除buff效果上的引用参数；
		 * 因为电脑攻击会延迟执行动画展示，如果buff消失后再执行就找不到对应的对象；
		 * @return 
		 */
		public function clearBuffParam():void{
//			this.tarUser		= null;
			this.useFairy		= null;
			this.originFairy	= null;
			this.originEffect 	= null;
		}
		
		
		/**
		 * 把这个Buff的数据复制一份新的
		 * @param qiu
		 */
		override public function clone():BaseSkillVO{
			var buff:FairyBuffVO = new FairyBuffVO(this.originEffect);
			
			buff.collect 		= this.collect;
			buff.effectTime 	= this.effectTime;
			buff.continuedTime 	= this.continuedTime;
			
			return buff;
		}
	}
}
