package editor{
	import com.model.event.ObjectEvent;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.config.skill.SkillConfig;
	import com.model.vo.config.skill.SkillEffectConfigVO;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flas.events.MouseEvent;
	import flash.text.TextField;
	

	public class SkillEffectBar extends Sprite {
		/**
		 * 技能效果向上移动
		 */
		public static const EFFECT_UP:String = "EFFECT_UP";
		/**
		 * 技能效果向下移动
		 */
		public static const EFFECT_DOWN:String = "EFFECT_DOWN";
		
		public var cbWuxingJudges:Array=[1,2,3,4,17,18,19];//需要把“值”展示为五行的effectID数组,只针对棋盘效果
		public var effectReferDishows:Array=[0,1,2];//不需显示参考值/百分比的effectID数组
		
		public var cb_trigger:ComboBox;
		public var cb_referTarget:ComboBox;
		public var cb_referTarget2:ComboBox;
		public var cb_targetRefer:ComboBox;
		public var cb_targetRefer2:ComboBox;
		public var cb_buffID:ComboBox;
		public var cb_judge:ComboBox;
		public var cb_effectKind:ComboBox;
		public var cb_effect:ComboBox;
		public var cb_buffConfigKind:ComboBox;
		public var cb_wuxing:ComboBox;
		public var cb_kind:ComboBox;
		public var cb_effectRefer:ComboBox;
		public var cb_referKind:ComboBox;
		public var cb_triggerKind:ComboBox;
		public var cb_triggerBuffID:ComboBox;
		public var cb_targetReferKind:ComboBox;
		public var cb_targetReferKind2:ComboBox;
		public var cb_effectReferTarget:ComboBox;
		public var cb_target:ComboBox;
		public var cb_targetKind:ComboBox;
		public var cb_who:ComboBox;
		
		public var tf_info:TextField;
		public var tf_valueTitle:TextField;
		public var tf_value:TextField;
		public var tf_value2:TextField;
		public var tf_percent_title:TextField;
		public var tf_judge_title:TextField;
		public var tf_triggerValue_title:TextField;
		public var tf_triggerValue:TextField;
		public var tf_triggerPercent_title:TextField;
		public var tf_triggerPercent:TextField;
		public var tf_targetKind_title:TextField;
		public var tf_targetRefer_title:TextField;
		public var tf_targetKind2_title:TextField;
		public var tf_targetRefer2_title:TextField;
		public var tf_refer_title:TextField;
		public var tf_referTarget_title:TextField;
		public var tf_num:TextField;
		public var tf_percent:TextField;
		public var tf_percent2:TextField;
		public var tf_chance:TextField;
		public var tf_chance2:TextField;
		
		public var btn_up:SimpleButton;
		public var btn_down:SimpleButton;
		
		public var effectInfo:SkillEffectConfigVO;
//		public var skillInfo:XML;
		
		private var skillInfo:SkillConfig = SkillConfig.getInstance();
		
		public function SkillEffectBar(){
			cb_buffID.visible=false;
			cb_effectKind.addEventListener(Event.CHANGE, selectEffectKind);
			cb_effect.addEventListener(Event.CHANGE, selectEffect);
			btn_up.visible = btn_down.visible = false;
			btn_up.addEventListener(MouseEvent.CLICK, updownSkill);
			btn_down.addEventListener(MouseEvent.CLICK, updownSkill);
			
			cb_kind.addEventListener(Event.CHANGE, cb_kind1);
			cb_buffID.addEventListener(Event.CHANGE, selectBuffID);
			cb_buffConfigKind.addEventListener(Event.CHANGE, selectBuffConfig);
			cb_wuxing.addEventListener(Event.CHANGE, selectWuxing);
			cb_effectRefer.addEventListener(Event.CHANGE, selectRefer);
			cb_trigger.addEventListener(Event.CHANGE, selectTrigger);
			cb_judge.addEventListener(Event.CHANGE, selectJudge);
			cb_referTarget.addEventListener(Event.CHANGE, targetKindSelected);
			cb_referTarget2.addEventListener(Event.CHANGE, targetKindSelected2);
			
			cb_effectReferTarget.addEventListener(Event.CHANGE, effectReferTarget);
			cb_triggerBuffID.addEventListener(Event.CHANGE, triggerBuffIDChange);
			cb_targetRefer.addEventListener(Event.CHANGE, selectTargetRefer);
			cb_targetRefer2.addEventListener(Event.CHANGE, selectTargetRefer2);
		}
		
		/**
		 * 
		 * @param e
		 */
		public function selectEffectKind(e:Event):void {
			var item:Object = cb_effectKind.selectedItem;
			if(item.id==0 || item.id==1){
				cb_effect.dataProvider=fairyEffectsData;
			}else{
				cb_effect.dataProvider=boardEffectsData;
			}
			cb_effect.selectedIndex = 0;
			cb_effect.dispatchEvent(new ObjectEvent(Event.CHANGE));
		}
		
		/**
		 * 
		 * @param e
		 */
		public function selectEffect(e:Event):void {
			//trace(cb_effect.selectedIndex, cb_effect.selectedItem);
			var item:Object = cb_effect.selectedItem;
			tf_info.text = item.info;
			
			cb_buffConfigKind.visible = false;
			cb_buffID.visible = false;
			cb_wuxing.visible = false;
			tf_valueTitle.visible = tf_value.visible = tf_value2.visible = true;
			tf_valueTitle.text = item.id == SkillEffectConfigVO.fairy_effect_100 ? "威力:" : "值:";
			switch(item.id){
				case SkillEffectConfigVO.board_effect_1://随机value颗kind类棋子上增加id为value2的buff并消除
				case SkillEffectConfigVO.board_effect_3://棋子buff
				case SkillEffectConfigVO.board_effect_4://生成新棋子
				case SkillEffectConfigVO.board_effect_37://格子buff
				case SkillEffectConfigVO.board_effect_38://合成棋子
					tf_value2.visible = false;
					cb_buffID.visible = true;
					break;
				case SkillEffectConfigVO.fairy_effect_119://精灵buff
					tf_valueTitle.visible = tf_value.visible = tf_value2.visible = false;
					cb_buffID.visible = true;
					tf_percent_title.visible = tf_percent.visible = tf_percent2.visible = true;
					cb_buffConfigKind.visible = true;
					cb_buffConfigKind.selectedIndex = parseInt(tf_value.text);
					break;
				case SkillEffectConfigVO.board_effect_2://随机变色
					tf_value2.visible = false;
					cb_wuxing.visible = true;
					break;
			}
			cb_kind.visible = item.kind!=0;
			//trace(cb_buffID.visible+"__"+cb_wuxing.visible+"__"+tf_value2.visible);
		}
		
		public function cb_kind1(e:Event):void {
			trace(cb_kind.selectedItem.id);
		}
		
		public function selectBuffID(e:Event):void {
			tf_value2.text = cb_buffID.selectedItem.id;
		}
		public function selectBuffConfig(e:Event):void {
			tf_value.text = cb_buffConfigKind.selectedItem.id;
			tf_percent_title.text = cb_buffConfigKind.selectedItem.label;
		}
		public function selectWuxing(e:Event):void {
			tf_value2.text = cb_wuxing.selectedItem.id;
		}
		public function selectRefer(e:Event):void {
			var item:Object = cb_effectRefer.selectedItem;
			cb_referKind.visible = item.kind!=0;
		}	
		
		public function selectTrigger(e:Event):void {
			var item:Object = cb_trigger.selectedItem;
			
			setJudgeVisible(item.id!=0);
			
			cb_triggerKind.visible = item.kind!=0;
			//tf_triggerValue_title.visible = cb_triggerBuffID.visible = item.id==23;
		}
		
		//===================================================================================
		public function selectJudge(e:Event):void {
			//setJudgeVisible1(cb_judge.selectedItem.id!=0);
		}
		
		public function targetKindSelected(e:Event):void {
			setJudgeVisible2(cb_referTarget.selectedItem.id!=0);
		}
		
		public function targetKindSelected2(e:Event):void {
			setJudgeVisible3(cb_referTarget2.selectedItem.id!=0);
		}
		
		public function setJudgeVisible(value:Boolean):void{//
			tf_judge_title.visible = value;
			cb_judge.visible = value;
			tf_triggerValue_title.visible = value;
			tf_triggerValue.visible = value;
			
			setJudgeVisible1(value);
			if(value){
				cb_judge.dispatchEvent(new ObjectEvent(Event.CHANGE));
				cb_referTarget.dispatchEvent(new ObjectEvent(Event.CHANGE));
			}
		}
		
		public function setJudgeVisible1(value:Boolean):void{//
			tf_triggerValue_title.visible = value;
			tf_triggerValue.visible = value;
			tf_triggerPercent_title.visible = value;
			tf_triggerPercent.visible = value;
			tf_targetKind_title.visible = value;
			cb_referTarget.visible = value;
			
			setJudgeVisible2(value);
		}
		
		public function setJudgeVisible2(value:Boolean):void{
			tf_triggerPercent_title.visible = value;
			tf_triggerPercent.visible = value;
			tf_targetRefer_title.visible = value;
			cb_targetRefer.visible = value;
			cb_triggerBuffID.visible = value;
			if(cb_triggerBuffID.visible) cb_triggerBuffID.selectedIndex = getIndex(cb_triggerBuffID.dataProvider, parseInt(tf_triggerValue.text));
			cb_targetReferKind.visible = value;
			tf_targetKind2_title.visible = value;
			cb_referTarget2.visible = value;
			
			setJudgeVisible3(value);
			if(value){
				cb_targetRefer.dispatchEvent(new ObjectEvent(Event.CHANGE));
				cb_referTarget2.dispatchEvent(new ObjectEvent(Event.CHANGE));
			}
		}
		
		public function setJudgeVisible3(value:Boolean):void{
			tf_targetRefer2_title.visible = value;
			cb_targetRefer2.visible = value;
			cb_targetReferKind2.visible = value;
			if(value) cb_targetRefer2.dispatchEvent(new ObjectEvent(Event.CHANGE));
		}
		//======================================================================================
		
		//===================================================================================
		public function effectReferTarget(e:Event):void {
			var judge:Boolean = cb_effectReferTarget.selectedItem.id!=0;
			tf_refer_title.visible = judge;
			cb_effectRefer.visible = judge;
			cb_referKind.visible = judge;
			tf_percent_title.visible = tf_percent.visible = tf_percent2.visible = judge;
			//tf_percent.visible = tf_percent2.visible = judge;
			
			if(judge) cb_effectRefer.dispatchEvent(new ObjectEvent(Event.CHANGE));
		}
		
		public function triggerBuffIDChange(e:Event):void {
			tf_triggerValue.text = cb_triggerBuffID.selectedItem.id;
		}
		//======================================================================================
		
		public function selectTargetRefer(e:Event):void {
			var item:Object = cb_targetRefer.selectedItem;
			cb_targetReferKind.visible = item.kind!=0;
			
			cb_triggerBuffID.visible = (item.id==27 || item.id==28);
			if(cb_triggerBuffID.visible) cb_triggerBuffID.selectedIndex = getIndex(cb_triggerBuffID.dataProvider, parseInt(tf_triggerValue.text));
			tf_triggerValue.visible = !cb_triggerBuffID.visible;
		}
		
		public function selectTargetRefer2(e:Event):void {
			var item:Object = cb_targetRefer2.selectedItem;
			cb_targetReferKind2.visible = item.kind!=0;
		}
		
		
		public var fairyEffectsData:DataProvider;
		public var boardEffectsData:DataProvider;
		public var buffData:DataProvider;
		public var wuxingKind:DataProvider;
		public var targetKind:DataProvider;
		

		
		public function init():void{
//			var fairyEffects:XML = <fairyEffects></fairyEffects>;
//			var boardEffects:XML = <boardEffects></boardEffects>;
//			for(var i:int=0; i<skillInfo.infos.effects.length; i++){
//				var effect:SkillEffectConfigVO = skillInfo.infos.effects[i];
//				if(effect.effectKind==1){
//					fairyEffects.appendChild(effect);
//				}else{
//					boardEffects.appendChild(effect);
//				}
//			}
//			var arr:Array = []
//				arr.concat()
			buffData = new DataProvider(skillInfo.buffs);
//			buffData = new DataProvider(skillInfo.infos.effects.boardEffects.concat(skillInfo.infos.effects.fairyEffects));
//			for(i=0; i<buffData.length; i++){
//				var item:Object = buffData.getItemAt(i);
//				item.label = item.id+item.label;
//			}
			
			fairyEffectsData 	= new DataProvider(skillInfo.infos.effects.fairyEffects);//info.infos.fairyEffects);
			boardEffectsData 	= new DataProvider(skillInfo.infos.effects.boardEffects);//info.infos.boardEffects);
			wuxingKind 			= new DataProvider(skillInfo.infos.wuxing);
			targetKind 			= new DataProvider(skillInfo.infos.referTargetKind);
			
			cb_effectKind.dataProvider		= new DataProvider(skillInfo.infos.effectKind);
			cb_effect.dataProvider			= fairyEffectsData;
			cb_target.dataProvider			= new DataProvider(skillInfo.infos.targetKind);
			cb_targetKind.dataProvider 		= wuxingKind;
			cb_effectRefer.dataProvider		= new DataProvider(skillInfo.infos.refer);
			cb_buffID.dataProvider 			= buffData;
			cb_triggerBuffID.dataProvider	= new DataProvider(skillInfo.infos.replaceKind);
			cb_wuxing.dataProvider 			= wuxingKind;
			cb_buffConfigKind.dataProvider 	= new DataProvider(skillInfo.infos.effectBuffKind);
			cb_triggerKind.dataProvider 	= wuxingKind;
			cb_targetReferKind.dataProvider = wuxingKind;
			cb_targetReferKind2.dataProvider = wuxingKind;
			cb_kind.dataProvider 			= wuxingKind;
			cb_referKind.dataProvider 		= wuxingKind;
			cb_trigger.dataProvider			= new DataProvider(skillInfo.infos.trigger);
			cb_judge.dataProvider			= new DataProvider(skillInfo.infos.judge);
			cb_who.dataProvider 			= targetKind;
			cb_referTarget.dataProvider 	= targetKind;
			cb_referTarget2.dataProvider 	= targetKind;
			cb_effectReferTarget.dataProvider = targetKind;
			cb_targetRefer.dataProvider 	= cb_targetRefer2.dataProvider = cb_effectRefer.dataProvider;
		}
		
		public function updateInfo(info:SkillEffectConfigVO):void{
			this.effectInfo = info;
			
			tf_triggerValue.text 			= String(info.trigger.value);
			tf_chance.text 					= String(info.trigger.chance);
			tf_chance2.text 				= String(info.trigger.chance2);
			tf_triggerPercent.text 			= String(info.trigger.percent);
			cb_trigger.selectedIndex 		= info.trigger.id;
			cb_triggerKind.selectedIndex 	= getIndex(wuxingKind, info.trigger.kind);
			cb_who.selectedIndex 			= info.trigger.who;
			cb_judge.selectedIndex 			= info.trigger.judge;
			cb_referTarget.selectedIndex 	= getIndex(cb_referTarget.dataProvider, info.trigger.target);
			cb_referTarget2.selectedIndex 	= getIndex(cb_referTarget2.dataProvider, info.trigger.target2);
			cb_targetRefer.selectedIndex 	= info.trigger.refer;
			cb_targetRefer2.selectedIndex 	= info.trigger.refer2;
			
			cb_targetReferKind.selectedIndex = getIndex(wuxingKind, info.trigger.referKind);
			cb_targetReferKind2.selectedIndex = getIndex(wuxingKind, info.trigger.referKind2);
			cb_targetRefer.dispatchEvent(new Event(Event.CHANGE));
			cb_referTarget2.dispatchEvent(new Event(Event.CHANGE));
			cb_judge.dispatchEvent(new Event(Event.CHANGE));
			cb_trigger.dispatchEvent(new Event(Event.CHANGE));
			cb_referTarget.dispatchEvent(new Event(Event.CHANGE));
			
			tf_num.text 						= String(info.id);
			//tf_hit.text 						= String(info.hit);
			tf_value.text 						= String(info.value);
			tf_value2.text 						= String(info.value2);
			tf_percent.text 					= String(info.percent);
			tf_percent2.text 					= String(info.percent2);
			
			cb_effectKind.selectedIndex 		= info.effectKind;
			cb_effectKind.dispatchEvent(new Event(Event.CHANGE));
			cb_effect.selectedIndex 			= getIndex(cb_effect.dataProvider, info.id);
			cb_effect.dispatchEvent(new Event(Event.CHANGE));
			cb_target.selectedIndex 			= info.target;
			cb_targetKind.selectedIndex 		= getIndex(wuxingKind, info.targetKind);
			cb_effectReferTarget.selectedIndex 	= getIndex(targetKind, info.referTarget);
			cb_effectRefer.selectedIndex 		= info.refer;
			cb_effectRefer.dispatchEvent(new Event(Event.CHANGE));
			//tf_info.text 						= cb_effectRefer.selectedItem.info;
			cb_buffID.selectedIndex 			= getIndex(cb_buffID.dataProvider, Math.floor(info.value2));
			cb_wuxing.selectedIndex 			= getIndex(wuxingKind, info.value2);
			cb_kind.selectedIndex 				= getIndex(wuxingKind, info.kind);
			cb_referKind.selectedIndex 			= getIndex(wuxingKind, info.referKind);
			cb_effectReferTarget.dispatchEvent(new Event(Event.CHANGE));
		}
		
		//<effect effectKind="0" id="0" kind="-1" target="0" referTarget="0" refer="0" referKind="-1" value="0" value2="0" percent="0" percent2="0">
		//	<trigger who="0" id="0" kind="-1" chance="1" chance2="1" judge="0" value="0" percent="0" target="0" refer="0" referKind="-1" target2="0" refer2="0" referKind2="-1"/>
		//</effect>
		public function saveInfo():void{
			effectInfo.trigger.who 		= cb_who.selectedIndex;
			effectInfo.trigger.id 		= cb_trigger.selectedIndex;
			effectInfo.trigger.kind 	= cb_triggerKind.visible ? cb_triggerKind.selectedItem.id : QiuPoint.KIND_100;
			effectInfo.trigger.chance 	= parseInt(tf_chance.text);
			effectInfo.trigger.chance2 	= parseInt(tf_chance2.text);
			effectInfo.trigger.value 	= parseInt(tf_triggerValue.text);
			effectInfo.trigger.percent 	= parseInt(tf_triggerPercent.text);
			effectInfo.trigger.judge 	= cb_judge.selectedIndex;
			effectInfo.trigger.target 	= cb_referTarget.selectedItem.id;
			effectInfo.trigger.target2 	= cb_referTarget2.selectedItem.id;
			effectInfo.trigger.refer 	= cb_targetRefer.selectedIndex;
			effectInfo.trigger.referKind = cb_targetReferKind.selectedItem.id;
			effectInfo.trigger.refer2 	= cb_targetRefer2.selectedIndex;
			effectInfo.trigger.referKind2 = cb_targetReferKind2.selectedItem.id;
			
			//effectInfo.hit = tf_hit.text;
			effectInfo.value 		= parseInt(tf_value.text);
			effectInfo.value2 		= parseInt(tf_value2.text);
			effectInfo.kind 		= cb_kind.visible ? cb_kind.selectedItem.id : 100;
			effectInfo.percent 		= parseInt(tf_percent.text);
			effectInfo.percent2 	= parseInt(tf_percent2.text);
			
			effectInfo.effectKind 	= cb_effectKind.selectedIndex;
			effectInfo.id 			= cb_effect.selectedItem.id;
			effectInfo.target 		= cb_target.selectedIndex;
			effectInfo.targetKind 	= cb_targetKind.selectedItem.id;
			effectInfo.referTarget 	= cb_effectReferTarget.selectedItem.id;
			effectInfo.refer 		= cb_effectRefer.selectedIndex;
			effectInfo.referKind 	= cb_referKind.visible ? cb_referKind.selectedItem.id : 100;
		}
		public function getIndex(d:DataProvider, id:int):int{
			for(var i:int=0; i<d.length; i++){
				if(d.getItemAt(i).id==id){
					return i;
				}
			}
			return 0;
		}
		
		
		public function updownSkill(e:*=null):void {
			dispatchEvent(new ObjectEvent(e.target==btn_up ? EFFECT_UP : EFFECT_DOWN, effectInfo));
		}
	}
}
