package com.model.vo.activity
{
	import com.model.vo.item.ItemVO;

	/**
	 *	当前状态：未使用 
	 * @author CC5
	 * 
	 */	
	public class ActivityAwardVO
	{
		public var itemID:int;
		public var count:int;
		public var money:int;
		public var isValid:Boolean;
		public function ActivityAwardVO(itemID:int=0,count:int=0,money:int=0,isValid:Boolean=true)
		{
			this.itemID=itemID;
			this.count=count;
			this.money=money;
			this.isValid=isValid;
		}
		public static function genItemAward(itemID:int=0,count:int=0):ActivityAwardVO{
			var vo:ActivityAwardVO = new ActivityAwardVO(itemID,count,0,true);
			return vo;
		}
		public static function genMoneyAward(money:int):ActivityAwardVO{
			var vo:ActivityAwardVO = new ActivityAwardVO(0,0,money,true);
			return vo;
		}
		public function getAwardStr():String{
			var a_str:String = ""
			if(itemID!=0){ 
				a_str+="item-"
				a_str+=itemID;
				a_str+=":"
				a_str+=count
				a_str+=","
			}
			if(money!=0){
				a_str+="gold-0:"
				a_str+=money;
				a_str+=","
			}
			return a_str;
		}
		public function getAwardDescription():String{
			if(itemID==0){
				return "钻石 x "+money;
			}
			var itemVO:ItemVO = new ItemVO();
//			itemVO.getItemVO(itemID);
			return itemVO.data.label+" x "+count;
		}
	}
}