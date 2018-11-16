package com.view.UI.tip{
	import com.greensock.TweenLite;
	import com.model.event.ObjectEvent;
	import com.view.UI.chessboard.Qiu;
	
	import flash.events.Event;
	
	import flash.display.MovieClip;
	
	/**
	 * 选中状态
	 * @author hunterxie
	 */
	public class FocusShow extends MovieClip{
		public static const CHOOSE_MC_CLEAR_OVER:String="chooseMcClearOver";
		private var tween:TweenLite;
		
		public function FocusShow(){
			this.mouseEnabled=false;
			this.mouseChildren=false;
			this.addEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		private function onEnter(e:Event):void{
			this.rotation+=2;
		}
		
		public function clearMC():void{
			this.mouseEnabled=this.mouseChildren=this.buttonMode=false;
			tween=TweenLite.to(this, 0.2, {scaleX:2, scaleY:2, alpha:0, onComplete:clearOver});
		}
		
		/**
		 * 
		 * @param mc
		 * @param side
		 */
		public function showMC(mc:Qiu, side:int):void{
			if(tween){
				tween.kill();
				reset();
			}
			
			this.x=mc.x;
			this.y=mc.y;
			this.gotoAndStop(side);
		}
		
		private function clearOver():void{
			dispatchEvent(new ObjectEvent(CHOOSE_MC_CLEAR_OVER));
			exit();
		}
		
		private function reset():void{
//			this.mouseEnabled=this.buttonMode=true;
			this.scaleX=this.scaleY=this.alpha=1;
		}
		
		public function exit():void{
			if(parent) parent.removeChild(this);
			reset();
		}
		
		public function close():void{
			if(parent){
				parent.removeChild(this);
			}
		}
	}
}