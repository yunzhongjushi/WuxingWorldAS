package editor{
	import com.greensock.TweenLite;
	import com.model.event.ObjectEvent;
	import com.model.vo.config.skill.SkillEffectConfigVO;
	import com.model.vo.config.skill.SkillConfig;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class SkillEffectContainer extends Sprite{
		public var effect_0:SkillEffectBar;
		
		public var barArr:Array;
		
		public var effects:Array;
		
		public function SkillEffectContainer():void{
			barArr = [effect_0];
			this.addEventListener(SkillEffectBar.EFFECT_UP, onEffectUpDown);
			this.addEventListener(SkillEffectBar.EFFECT_DOWN, onEffectUpDown);
		}
		
		private function onEffectUpDown(e:ObjectEvent):void{
			var vo:SkillEffectConfigVO = e.data as SkillEffectConfigVO;
			var index = this.effects.indexOf(vo);
			switch(e.type){
				case SkillEffectBar.EFFECT_UP:
					if(index>0){
						effects.splice(index, 1);
						effects.splice(index-1, 0, vo);
					}
					break;
				case SkillEffectBar.EFFECT_DOWN:
					if(index<effects.length-1){
						effects.splice(index, 1);
						effects.splice(index+1, 0, vo);
					}
					break;
			}
		}
		
		public function updateInfo(effects:Array):void{
			this.effects = effects;
			//trace("?????_____");
			//trace(effects);
			for(var i:int=0; i<barArr.length; i++){
				if(this.contains(barArr[i])) this.removeChild(barArr[i]);
			}
			
			for(i=0; i<effects.length; i++){
				var effect:SkillEffectBar;
				if(i<barArr.length){
					effect = barArr[i] as SkillEffectBar;
				}else{
					effect = new SkillEffectBar;
					effect.init();
					effect.y = 95*i;
					barArr.push(effect);
				}
				addChild(effect);
				TweenLite.to(effect, 0.2, {onComplete:onTimerUpdate, onCompleteParams:[effect, effects[i]]});
			}
		}
		public function initInfo():void{
			for(var i:int=0; i<this.numChildren; i++){
				(this.getChildAt(i) as SkillEffectBar).init();
			}
		}
		public function saveInfo():void{
			for(var i:int=0; i<this.numChildren; i++){
				(this.getChildAt(i) as SkillEffectBar).saveInfo();
			}
		}
		
		public function onTimerUpdate(effect:SkillEffectBar, info:SkillEffectConfigVO):void{
			effect.updateInfo(info);
		}
		
		
	}
}
