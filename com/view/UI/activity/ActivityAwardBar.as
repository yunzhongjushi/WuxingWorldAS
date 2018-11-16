
		package com.view.UI.activity
		{
			import com.model.vo.activity.ActivityAwardVO;
			
			import flash.display.MovieClip;
			import flash.text.TextField;
			
			import listLibs.ITouchPadBar;
			
			public class ActivityAwardBar extends MovieClip implements ITouchPadBar
			{
				public var tf_award:TextField;
				public var tf_title:TextField;
				public var btn_valid:MovieClip;
				//
				//
				
				public var running_vo:ActivityAwardVO;
				public function ActivityAwardBar()
				{
					super(); 
				}
				public function updateInfo(_vo:*):void{
					running_vo=_vo as ActivityAwardVO;
					tf_title.text = String(running_vo.getAwardDescription())
					var a_str:String = "itemID:"+running_vo.itemID+"\n"+"count:"+running_vo.count+"\n"+"money:"+running_vo.money;
					tf_award.text = String(a_str)
					if(running_vo.isValid){
						btn_valid.gotoAndStop(2);
					}else{
						btn_valid.gotoAndStop(1);
					}
				} 
				
				
			}
		}