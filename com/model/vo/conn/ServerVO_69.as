package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.proxy.BaseConnProxy;
	import com.model.vo.altar.AltarVO;
	import com.model.vo.item.ItemVO;

	/**
	 *****************************
	 获取祭坛信息
	 ******************************
	 # 服务器 -> 客户端
	 一级协议：0x45 / 69
	 二级协议：0x03

	 参数：
	 - ErnieCount:int	//元素抽剩余免费次数
	 - LastResErnieTimer:int	//免费元素抽可用时间，采用毫秒数
	 - LastMoneyErnieTimer:int	//免费钻石抽可用时间，采用毫秒数
	 */
	/**
	 *****************************
	 购买祭坛召唤
	 ******************************

	 # 客户端 -> 服务器
	 一级协议：0x45 / 69
	 二级协议：0x01

	 参数：
	 - item:int	// 0.金素抽,1.木元素抽.......，5.钻石抽 6.元素首抽 7.钻石首抽
	 - type:int	// 1.单抽，2.多抽，3.免费抽
	 - isCostMoney:int	//是否用钻石补足不够的元素	0.否，1.是

	 # 服务器 -> 客户端
	 一级协议：0x45 / 69
	 二级协议：0x01

	 参数：
	 - rs：int	//0.失败，1.成功
	 - rs_list: Array
	 {[1]		//单条奖励信息，格式：i-1010|2	i为类型标记，1010为ID，2为数量
	  [2]		//i为物品，f为精灵}
	 //数量：单抽为1个，多抽为10个
	 */
	public class ServerVO_69 extends BaseConnProxy{
		private static var instance:ServerVO_69;
		public static function getInstance():ServerVO_69{
			if ( instance == null ) instance=new ServerVO_69();
			return instance;
		}
		
		
		public static const LOAD_GET_INFO:String="正在获取数据...";
		public static const LOAD_BUY:String="正在购买...";

		public static var ID:int=0x45;

		public var altarVO:AltarVO;
		public var rewardArr:Array;
		public var code:int;
		public var isSuccessed:Boolean;

		public function ServerVO_69(obj:Object=null) {
			super(obj);
		}
		
		public function updateInfo(obj:Object):void{
			isSuccessed=false;
			code=obj["code"]?parseInt(obj["code"]):0;
			isSuccessed=obj["rs"]=="0"?true:false;

			if(obj["code"]&&obj["code"]==GET_ALTARINFO) {
				MainNC.closeLodingPanel(LOAD_GET_INFO);
				var usedTime:int=obj["ErnieCount"];
				var wuxingFreeDate:Date=obj["LastResErnieTimer"] //new Date( parseInt(obj["wuxingFreeDate"]) );
				var goldFreeDate:Date=obj["LastMoneyErnieTimer"] //new Date( parseInt(obj["goldFreeDate"]) );
				var today:Date=new Date();

				if(today.date!=wuxingFreeDate.date) {
					usedTime=0;
				}

				// 增加延迟，保证同步
				wuxingFreeDate.time+=7000;
				goldFreeDate.time+=7000;
				altarVO=new AltarVO(usedTime, wuxingFreeDate, goldFreeDate);
			}

			if(obj["code"]&&obj["code"]==ALTAR_BUY) {
				MainNC.closeLodingPanel(LOAD_BUY);
				rewardArr=[];
				var rewardList:Array=obj["rs_list"]?obj["rs_list"] as Array:[];
				for(var i:int=0; i<rewardList.length; i++) {
					var rewardInfo:String=rewardList[i] as String;
					var infoArr:Array=rewardInfo.split("|");
					var mixName:String=infoArr[0];
					var num:int=parseInt(infoArr[1]);
					var itemVO:ItemVO;
					var nameArr:Array=mixName.split("-")
					switch(nameArr[0]) {
						case "i":
						case "p":
							itemVO = ItemVO.getItemVO(parseInt(nameArr[1]), num);
							break;
						case "f"://精灵
							itemVO = new ItemVO(parseInt(nameArr[1]));
							break;
					}
					rewardArr.push(itemVO);
				}
			}
		}

		public static var GET_ALTARINFO:int=0x03;

		public static function getInfo():void {
			MainNC.getInstance().sendInfo(ID, {code:GET_ALTARINFO}, LOAD_GET_INFO);
		}

		public static var ALTAR_BUY:int=0x01;

		public static function altarBuy(item:int, type:int, buyToEnought:Boolean=false):void {
			MainNC.getInstance().sendInfo(ID, {code:ALTAR_BUY, item:item, type:type, isCostMoney:buyToEnought?1:0}, LOAD_BUY);
		}
	}
}
