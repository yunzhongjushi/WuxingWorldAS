package com.model.vo.activity {

	/**
	 * 当前状态：未使用
	 * @author CC5
	 *
	 */
	public class ActivityVO {
		public var activeId:int;
		public var title:String;
		public var description:String;
		public var content:String;
		public var awardContent:String;
		public var startDate:String;
		public var endDate:String;
		public var type:String;
		public var questId:int;
		public var awardArr:Array=[];

		//
//		public var attach_aewardVO:ActivityAwardVO;
		//
		public function ActivityVO(activeId:int, title:String, description:String, content:String, startDate:String, endDate:String, type:String, questId:int) {
			this.activeId=activeId;
			this.title=title;
			this.description=description;
			this.content=content;
			this.startDate=startDate;
			this.endDate=endDate;
			this.type=type;
			this.questId=questId;
		}

		public function addAwardVO(a_vo:ActivityAwardVO):void {
			this.awardArr.push(a_vo);
		}

		public static function genEmptyVO():ActivityVO {
			var now:Date=new Date();
			var timeStr:String=now.fullYear+"-"+(now.month+1)+"-"+now.date+" "+"00:00:00";
			var vo:ActivityVO=new ActivityVO(0, "", "", "", timeStr, timeStr, "", 0);
			return vo;
		}

		public function getLastStr():String {
			var sd:Date=transStrToDate(startDate);
			var ed:Date=transStrToDate(endDate);
			var lastMS:Number=ed.time-sd.time;
			var lastHR:Number=lastMS/1000/60/60;
			var lastHRStr:String=lastHR.toFixed(2);
			return lastHRStr+" 小时";
		}

		public function getAwardContent():String {
			var a_str:String="";
			for(var i:int=0; i<awardArr.length; i++) {
				var a_vo:ActivityAwardVO=awardArr[i] as ActivityAwardVO;
				a_str+=a_vo.getAwardStr();
			}
			return a_str;
		}

		public function getAwardDescription():String {
			var a_str:String="";
			for(var i:int=0; i<awardArr.length; i++) {
				var a_vo:ActivityAwardVO=awardArr[i] as ActivityAwardVO;
				a_str+=a_vo.getAwardDescription();
				a_str+="\n"
			}
			a_str=a_str.slice(0, a_str.length-1);
			return a_str;
		}

		public function getMoney():String {
			for(var i:int=0; i<awardArr.length; i++) {
				var a_vo:ActivityAwardVO=awardArr[i] as ActivityAwardVO;
				if(a_vo.money!=0) {
					return String(a_vo.money);
				}
			}
			return "0";
		}

		public function transStrToDate(str:String):Date {
			var s1:String=str.split(" ")[0];
			var s2:String=str.split(" ")[1];
			var arr1:Array=s1.split("-");
			var arr2:Array=s2.split(":");
			var date:Date=new Date(arr1[0], arr1[1]-1, arr1[2], arr2[0], arr2[1], arr2[2]);
			return date;
		}

		public static function genFromStr(str:String):ActivityVO {
			var vo:ActivityVO=ActivityVO.genEmptyVO();
			var strArr:Array=str.split(",");
			var itemAward_1:ActivityAwardVO
			var itemAward_2:ActivityAwardVO
			var itemAward_3:ActivityAwardVO
			var itemAward_4:ActivityAwardVO
			var itemAward_5:ActivityAwardVO
			var itemAward_6:ActivityAwardVO
			for(var i:int=0; i<strArr.length; i++) {
				var subStr:String=strArr[i] as String;
				if(subStr.length) {
					var subStrArr:Array=subStr.split("=");
					var val:String=subStrArr[1] as String;
					switch(subStrArr[0]) {
						case "activeId":
							vo.activeId=int(val);
							break;
						case "type":
							vo.type=val
							break;
						case "title":
							vo.title=val
							break;
						case "description":
							vo.description=val
							break;
						case "questId":
							vo.questId=int(val);
							break;
						case "content":
							vo.content=val
							break;
						case "startDate":
							vo.startDate=val
							break;
						case "endDate":
							vo.endDate=val
							break;
						case "money":
							var money_vo:ActivityAwardVO=ActivityAwardVO.genMoneyAward(int(val));
							vo.addAwardVO(money_vo);
							break;
						case "itemId_1":
							itemAward_1=ActivityAwardVO.genItemAward(int(val), 0);
							break;
							;
						case "itemNum_1":
							itemAward_1.count=int(val);
							vo.addAwardVO(itemAward_1);
							break;
							;
						case "itemId_2":
							itemAward_2=ActivityAwardVO.genItemAward(int(val), 0);
							break;
							;
						case "itemNum_2":
							itemAward_2.count=int(val);
							vo.addAwardVO(itemAward_2);
							break;
							;
						case "itemId_3":
							itemAward_3=ActivityAwardVO.genItemAward(int(val), 0);
							break;
							;
						case "itemNum_3":
							itemAward_3.count=int(val);
							vo.addAwardVO(itemAward_3);
							break;
							;
						case "itemId_4":
							itemAward_4=ActivityAwardVO.genItemAward(int(val), 0);
							break;
							;
						case "itemNum_4":
							itemAward_4.count=int(val);
							vo.addAwardVO(itemAward_4);
							break;
							;
						case "itemId_5":
							itemAward_5=ActivityAwardVO.genItemAward(int(val), 0);
							break;
							;
						case "itemNum_5":
							itemAward_5.count=int(val);
							vo.addAwardVO(itemAward_5);
							break;
							;
						case "itemId_6":
							itemAward_6=ActivityAwardVO.genItemAward(int(val), 0);
							break;
							;
						case "itemNum_1":
							itemAward_6.count=int(val);
							vo.addAwardVO(itemAward_6);
							break;
							;

					}
				}
			}
			return vo;
		}
	}
}
