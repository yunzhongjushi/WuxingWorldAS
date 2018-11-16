package com.model.vo.mail {
	import com.model.vo.item.ItemResourceVO;
	import com.model.vo.item.ItemVO;

	public class MailVO {
		
		public var title:String;
		public var content:String;
		public var attachmentStr:String = "";
		public var sender:String
		public var receiver:String;
		public var mailID:int;
		public var isRead:Boolean
		public var energy:int;
		public var itemArr:Array=[];
		public var sendTime:String;
		
		public function MailVO(xml:XML){
			if(xml==null){
				return;
			}
			this.title = xml.@Title;
			this.content = xml.@Content;
			this.sender = xml.@Sender;
			this.receiver = "";
			this.mailID = xml.@ID;
			this.isRead=(xml.@IsRead == "true");
			this.energy = xml.@Energy;
			this.sendTime=xml.@SendTime;
			
			var i:int=1;
			while(xml.@["Annex"+i+"ID"]!=""){
				var itemVO:ItemVO;
				itemVO= ItemVO.getItemVO(parseInt(xml.@["Annex"+i+"ID"]),1);
				itemArr.push(itemVO);
				i++
			}
			while(this.itemArr.length>5){
				this.itemArr.pop();
				trace("* 设置MailVO时附件量过大");
			}
			
			attachmentStr = getAttachmentStr();
		}
		public static function getFakeData(num:int):Array{
			var arr:Array =[];
			for (var i:int = 0; i < num; i++) 
			{
				var m:MailVO= MailVO.generateMailVO("title"+(i+1),"content","n/a",0);
				m.sendTime = "2013-1-1 00:00:00"
				arr.push(m);
				
			}
			return arr;
			
		}
		public function getIsContainItem():Boolean{
			if(itemArr.length!=0 || energy!=0){
				return true;
			}
			return false;
		}
		public function getEnergyItemVO():ItemVO{
			var vo:ItemVO;
			
			vo = new ItemVO(3, energy);//ItemResourceVO.getEnergy(energy);
			return vo;
		}
		public function getItemID(no:int):int{
			if(itemArr[no]!=null){
				return itemArr[no]
			}
			return 0;
		}
		public static function generateMailVO(title:String,content:String,receiver:String,energy:int=0):MailVO{
			var mailVO:MailVO=new MailVO(null);
			mailVO.title = title
			mailVO.content = content
			mailVO.receiver = receiver
			mailVO.energy = energy;
			return mailVO;
		}
		public static function genEnergyMail(receiver:String):MailVO{
			var mailVO:MailVO=new MailVO(null);
			mailVO.title = "给你送温暖啦～"
			mailVO.content = "小小礼物，不成敬意！"
			mailVO.receiver = receiver
			mailVO.energy = 2;
			return mailVO;
		}
		public static function genFriendMail(content:String,receiver:String):MailVO{
			var mailVO:MailVO=new MailVO(null);
			mailVO.title = "朋友来信"
			if(content==""){
				mailVO.content = "你好，"+receiver+":\n\t"
			}else{
				mailVO.content = content
			}
			mailVO.receiver = receiver 
			return mailVO;
		}
		private function getAttachmentStr():String{ 
			var str:String = "";
			if(this.energy)
			{
				str += ("活力值 + "+energy)
			}
			var item:ItemVO;
			for (var i:int = 0; i < itemArr.length; i++) 
			{
				addN();
				item = itemArr[i] as ItemVO;
				str += (item.data.label+" x "+item.num);
			}
			  
			return str;
			
			function addN():void
			{
				if(str.length)
				{
					str += "\n";
				}
			}
		}
		public function getAttachment():void
		{
			energy = 0;
			itemArr = [];
		}
		
		public function getSenderStr():String{
			return "发件人： "+this.sender;
		}
		public function getSendTimeStr():String{
			var strArr:Array = sendTime.split(" ");
			return strArr[0];
		}
		public function getMailContentStr():String{
			return content;
		}
	}
}
