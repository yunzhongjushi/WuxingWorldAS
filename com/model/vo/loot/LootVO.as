package com.model.vo.loot
{
	import com.model.vo.altar.FairyTemplateVO;
	import com.model.vo.config.lvs.LVCheckVO;
	import com.model.vo.config.plunder.PlunderConfig;
	import com.model.vo.config.plunder.PlunderConfigVO;
	import com.model.vo.user.UserVO;

	public class LootVO
	{
		public static const POS_NULL:String="FAIRY_POS_NULL";
		public static const POS_1:String="FAIRY_POS_1";
		public static const POS_2:String="FAIRY_POS_2";
		public static const POS_3:String="FAIRY_POS_3";
		public static const FAIRY_ID_NULL:int = -1;
		public static const MATCH_COUNTDOWN:int =30;
		private var lootTimes:int
		private var lootDate:Date
		private var protectTime:Date
		private var feedTime:Date;
		private var matchTime:Date;
		
		/**
		 * 得分
		 */
		public function get rank():int{
			return _rank;
		}
		public function set rank(value:int):void{
			_rank = value;
			configData = PlunderConfig.checkLvInfo(rank);
		}
		private var _rank:int;
		/**
		 * 
		 */
		public var configData:PlunderConfigVO;
		
		private var fairy_1:FairyTemplateVO;
		private var fairy_2:FairyTemplateVO;
		private var fairy_3:FairyTemplateVO;
		
		private var fairyIDObj:Object={}
		private var fairyObj:Object={}
		
		/**
		 * 
		 * @param rank			排名得分
		 * @param lootTimes
		 * @param lootDate
		 * @param protectTime
		 * @param feedTime
		 * @param fairyID_1
		 * @param fairyID_2
		 * @param fairyID_3
		 */
		public function LootVO(rank:int,lootTimes:int,lootDate:Date,protectTime:Date,feedTime:Date,fairyID_1:int,fairyID_2:int,fairyID_3:int)
		{
			this.rank = rank;
			this.lootTimes=lootTimes;
			this.lootDate=lootDate
			this.protectTime = protectTime;
			this.feedTime=feedTime;
			
			fairyIDObj[POS_1] = fairyID_1;
			fairyIDObj[POS_2] = fairyID_2;
			fairyIDObj[POS_3] = fairyID_3;
			//获取守护兽信息
			fairyObj[POS_1] = FairyTemplateVO.genProtectorFairyVO(fairyIDObj[POS_1] as int,1);
		}


		public function getFairyID(pos:String):int{
			return fairyIDObj[pos];
		}
		private static var posArr:Array = [POS_1,POS_2,POS_3];
		public static function getPOSByIndex(index:int):String{
			return posArr[index-1];
		}
		public function setFairyVO(fairyVO:FairyTemplateVO,pos:String):void{
			fairyObj[pos] = fairyVO;
		}
		public function getFairyVO(pos:String):FairyTemplateVO{
			var fairyVO:FairyTemplateVO;
			fairyVO = fairyObj[pos] as FairyTemplateVO;
			if(fairyVO==null) return FairyTemplateVO.genEmptyFairyVO();
			return fairyVO
		}
		public function getDefaultShowPos():String{
			var pos:String = POS_NULL
			if(fairyObj[POS_3]!=null) pos = POS_3
			if(fairyObj[POS_2]!=null) pos = POS_2
			if(fairyObj[POS_1]!=null) pos = POS_1
			return pos
		}
		public function getMatchCostDescription():String{
			var matchCost:int = UserVO.getInstance().LV*10;
			return matchCost+" 元素"
		}
		public function getExtraDescription():String{
			var date:Date = new Date();
			var lootExtraTime:int = date.time-lootDate.time;
			lootExtraTime/=1000;
			lootExtraTime/=60;
			var extraPer:Number = lootExtraTime*0.05;
			if(extraPer>1){
				extraPer=1;
			}
			if(extraPer<0){
				extraPer=0;
			}
			return "掠夺加成："+(extraPer*100)+" %";
		}
		public function getProtectDescription():String{
			var date:Date = new Date();
			var protectLongTime:int = protectTime.time-date.time;
			if(protectLongTime<0){
				return "已失效";
			}else{
				protectLongTime/=1000;
				protectLongTime/=60;
				var mins:int = protectLongTime%60;
				var hrs:int = (protectLongTime-mins)/60;
				return String(hrs)+"小时 "+String(mins)+"分";
			}
		}
		//匹配倒计时
		public function newMatchTime():void{
			matchTime=new Date();
		}
		public function getMatchCountdown():String{
			var date:Date = new Date();;
			var time:int = matchTime.time - date.time;
			time/=1000;
			time+=MATCH_COUNTDOWN;
			if(time<0){
				time =0;
			}
			if(time>MATCH_COUNTDOWN){
				time =MATCH_COUNTDOWN;
			}
			return time+" s";
		}
		public function getIsMatchCountdownOver():Boolean{
			var date:Date = new Date();;
			var time:int = matchTime.time - date.time;
			time/=1000;
			time+=MATCH_COUNTDOWN;
			if(time<0){
				return true;
			}
			return false;
		}
		//喂养
		public function setFeedTime(feedTime:Date):void{
			this.feedTime=feedTime;
		}
		public function getFeedLabel():String{
			var date:Date = new Date();
			var lastTime:int = feedTime.time - date.time
			if(lastTime<=0){
				return "50 元素"
			}
			lastTime/=1000
			lastTime/=60
			var mins:int =lastTime%60;
			var hrs:int = (lastTime-mins)/60;
			return String(hrs)+"H "+mins+"M";
		}
		public function getIsFeedable():Boolean{
			var date:Date = new Date();
			var lastTime:int = feedTime.time - date.time
			if(lastTime<=0){
				return true;
			}
			return false;
		}
		public function getSummonFairyArr(pos:String):Array{
			if(pos==POS_1){
				return getFakeFairyArr();
			}
			return getFakeFairyArr();
		}
		
		public function getFakeFairyArr():Array{
			var f1:FairyTemplateVO = FairyTemplateVO.genProtectorFairyVO(2,1.2)
			var f2:FairyTemplateVO = new FairyTemplateVO(3,88,-1)
			var f3:FairyTemplateVO = new FairyTemplateVO(6,88,-1)
			var date1:Date=new Date(2014,4,31,18,0);
			var date2:Date=new Date(2014,4,31,18,0);
			var oppoVO:LootOpponentVO = new LootOpponentVO(-1,"哆啦A梦",[100,200,300,400,500],1500,2,3,6);
			var lootVO:LootVO = new LootVO(998,3,date1,date2,date2,2,3,6);
			return [f1,f2,f3];
		}
	}
}