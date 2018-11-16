package com.view.UI.button
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flas.events.MouseEvent;
	import flash.text.TextField;
	

	public class FriendEnergyButton extends MovieClip
	{
		private static const CD:int = 1800//21600;//seconds
		public var tf_countDown:TextField;
		public var btnPool:Array;
		private var targetTime:int=0;
		private var isCD:Boolean=true;
		//
		private var E_GiveEnergy:Function
		
		public function FriendEnergyButton()
		{
			this.gotoAndStop(1);
			this.addEventListener(Event.ENTER_FRAME,handle_frame);
		}
		private function handle_add(e:Event):void{
//			btn_add[FriendPanel.BAR_LABEL].text = "添加";
			btnPool=[]; 
		}
		public function setUsed():void{
			if(isCD)
			{
				this.changeStatus(false);
				var date:Date = new Date();
				targetTime=date.time/1000+CD;
			}
		}
		private function handle_frame(e:Event):void{
			this.tf_countDown.text = getCDText();
		} 
		private function getCDText():String{
			var oneHour:int = 3600;
			var date:Date = new Date();
			var cd:int = targetTime-date.time/1000;
			if(cd<=0){ 
				this.changeStatus(true);
				return "可挑战"
			}else if(cd< oneHour){
				var mins:String = String(Math.floor(cd/60));
				var temp_secs:int = cd%60;
				var secs:String
				if(temp_secs<=9){
					secs = "0"+String(temp_secs);
				}else{
					secs = String(temp_secs);
				}
				return mins+":"+secs;
			}else{
				var hours:String=String(Math.ceil(cd/oneHour));
				return hours+"小时"
			}
			return "Error"
		}
		public function open():void{
			this.visible=true;
		}
		public function close():void{
			this.visible=false;
		}
		public function setupFn(E_GiveEnergy:Function):void{
			this.E_GiveEnergy=E_GiveEnergy
		}
		public function changeStatus(canUse:Boolean):void{
			this.isCD=canUse;
			if(isCD){
				this.gotoAndStop(1)
			}else{
				this.gotoAndStop(2)
			}
		}
		public function get isReadyToUse():Boolean{
			return isCD;
		}
	}
}