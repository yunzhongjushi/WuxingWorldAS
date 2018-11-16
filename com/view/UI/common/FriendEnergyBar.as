
		package com.view.UI.common
		{
			import flash.display.MovieClip;
			import flash.text.TextField;
			
			public class FriendEnergyBar extends MovieClip
			{
				public var tf_energy:TextField
				public var mc_cover:MovieClip
				// 
				private var _currentEnergy:int
				public function FriendEnergyBar()
				{
					super();
				}
				public function updateInfo(attr:String,currentEnergy:int,maxEnergy:int):void{
					setProgressBar(currentEnergy,maxEnergy);
					this.gotoAndStop(attr);
				}
				public function setProgressBar(cur:int,max:int):void{
					var per:Number = cur/max;
					var targetX:int = (1-per)*mc_cover.width;
					if(targetX<0) targetX=0;
					mc_cover.x=targetX;
					tf_energy.text = String(cur)
				} 
			}
		} 