package com.view.UI.mail
{
	import com.model.event.ObjectEvent;
	import com.model.vo.mail.MailVO;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flas.events.MouseEvent;
	import flash.text.TextField;
	
	import listLibs.ITouchPadBar;
	

	public class MailBar extends MovieClip implements ITouchPadBar
	{
		public var tf_title:TextField;
		public var tf_content:TextField;
		public var tf_sendTime:TextField;
		public var mc_cover:MovieClip;
		public var mail_arr:MovieClip;
		//
		//
		
		public var running_vo:MailVO
		public function MailBar()
		{
			super();
			this.mouseChildren = false;
		}
		public function updateInfo(_vo:*):void{ 
			running_vo = _vo as MailVO
			//
			tf_title.text = String(running_vo.title)
			tf_content.text = String(running_vo.getSenderStr())
			tf_sendTime.text = String(running_vo.getSendTimeStr())
			if(running_vo.isRead){
				mail_arr.gotoAndStop(2)
			}else{
				mail_arr.gotoAndStop(1);
			} 
		}  
		
		private function goIsRead():void{
			mail_arr.gotoAndStop(2);
		}
		
	}
}