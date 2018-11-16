package com.model.proxy.mail {
	import com.model.vo.mail.MailVO;
	import com.model.vo.user.*;
	
	import flas.events.Event;
	import flas.events.EventDispatcher;
	import flas.net.URLLoader;
	import flas.net.URLLoaderDataFormat;
	import flas.net.URLRequest;
	import flas.utils.ByteArray;

	/**
	 * 处理基本用户信息
	 * @author xie
	 *
	 */
	public class MailProxy extends EventDispatcher{
		/**
		 * 接收信件事件
		 */ 
		public static const MAIL_RECEIVE_INFO:String = "MAIL_RECEIVE_INFO";
		
		public static const NAME:String="MailProxy";
		private static const SINGLETON_MSG:String="single_MailProxy_only";
		private static var instance:MailProxy;
		public static function getInstance():MailProxy {
			if(instance==null)
				instance=new MailProxy();
			return instance as MailProxy;
		}

		public var loader:URLLoader;
		
		public var mailList:Array = [];
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}

		public function MailProxy() {
			
		}


		public function getMailInfo():void {
			try{
				loader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.addEventListener(Event.COMPLETE, receveList);
				loader.load((new URLRequest(BaseInfo.getUrl(BaseInfo.loadUserMail)+"selfid="+userInfo.userID+"&r="+Math.random()*99999)).info);
			}catch(e:Error)
			{
			}
		}
		
		private function receveList(e:*):void {
			var n:ByteArray = e.target.data as ByteArray;
			n.uncompress();
			var xml:XML = XML(n.readUTFBytes(n.length));
			trace(xml);
			var itemList:XMLList = xml.Item;
			var info:Array = [];
			mailList=[];
			for (var i:int=0; i<itemList.length(); i++) {
				var oneXML:XML = itemList[i];
				var newMail:MailVO = new MailVO(oneXML)
				mailList.push(newMail);
			}
			event(MAIL_RECEIVE_INFO);
		}
}
}