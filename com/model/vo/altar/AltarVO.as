package com.model.vo.altar {
	import com.model.vo.WuxingVO;
	import com.model.vo.config.altar.AltarConfig;
	import com.model.vo.item.ItemResourceVO;
	import com.model.vo.item.ItemVO;
	import com.model.vo.tip.BuyResourceTipVO;
	import com.model.vo.user.UserVO;


	public class AltarVO {
		public static const BUY_ONE:int=1;
		public static const BUY_TEN:int=2;
		public static const BUY_FREE:int=3;
		public static const BUY_FIRST:int=4;

		/**
		 * 用元素抽奖
		 */
		public static const ITEM_WUXING:int=1;
		public static const ITEM_GOLD:int=2;

		public var currentBuyItem:int;
		public var currentBuyType:int;

		public var selectedWuxing:int;

		public var markDecreaseFreeTime:int;

		public var needGold:int;
		
		public var altarInfo:AltarConfig;

		public function AltarVO(usedWuxingFreeTime:int, wuxingFreeDate:Date, goldFreeDate:Date) {
			this.altarInfo = AltarConfig.getInstance();
			this.wuxingFreeTime = altarInfo.wuxing.freeTime-usedWuxingFreeTime;
			this.wuxingFreeDate=wuxingFreeDate;
			this.goldFreeDate=goldFreeDate;

			wuxingFreeDate.time
		}

		public function getBuyItem():int {
			if(currentBuyType==BUY_FIRST) {
				if(currentBuyItem==ITEM_WUXING) {
					return 6;
				}
				if(currentBuyItem==ITEM_GOLD) {
					return 7;
				}
			}
			if(currentBuyItem==ITEM_WUXING) {
				return selectedWuxing;
			}
			if(currentBuyItem==ITEM_GOLD) {
				return 5;
			}
			return -1;
		}

		public function getBuyType():int {
			return currentBuyType;
		}

		public function afterBuy():void {
			if(currentBuyType!=BUY_FREE)
				return;

			currentBuyType=BUY_ONE;// 购买后，把购买类型设为单抽，以供后面的再次购买使用。
			if(currentBuyItem==ITEM_WUXING) {// 更新CD，免费次数
				wuxingFreeDate=new Date();
				wuxingFreeTime-=markDecreaseFreeTime;
			}
			if(currentBuyItem==ITEM_GOLD) {
				goldFreeDate=new Date();
			}

			markDecreaseFreeTime=0;
		}

		/**
		 * 
		 * @param isWuxing	五行资源还是钻石
		 * @param isTen
		 */
		public function markBuy(isWuxing:Boolean, isTen:Boolean):void {
			var isFree:Boolean=false;
			if(isWuxing) {
				currentBuyItem=ITEM_WUXING;
				if(isTen==false&&wuxingFreeTime>0) {
					isFree=(getWuxingCDStr()=="")
				}
			}else{
				currentBuyItem=ITEM_GOLD;
				if(isTen==false) {
					isFree=(getGoldCDStr()=="")
				}
			}

			// free or ten or one
			if(isFree) {
				currentBuyType=BUY_FREE
				if(isWuxing) {
					markDecreaseFreeTime=1;
				}
			} else if(isTen) {
				currentBuyType=BUY_TEN
			} else {
				currentBuyType=BUY_ONE
			}
		}

		/**
		 * 获取 祭坛消耗
		 * @param isWuxing		五行资源还是钻石
		 * @param isMultiple	是否一次买10个
		 * @return 
		 */
		public function getCostVOBySetting(isWuxing:Boolean, isMultiple:Boolean):ItemVO {
			var cost:int=0;

			if(isWuxing) {
				if(isMultiple) {
					cost = altarInfo.wuxing.ten.costNum;
				} else {
					cost = altarInfo.wuxing.one.costNum;
				}
			}else{
				if(isMultiple) {
					cost = altarInfo.gold.ten.costNum;
				} else {
					cost = altarInfo.gold.one.costNum;
				}
			}

			var costVO:ItemVO;
			if(isWuxing) {
				costVO = new ItemVO(selectedWuxing+10, cost);//物品的五行资源ID需加10
			}else{
				costVO = new ItemVO(4, cost);//ItemResourceVO.getGold(cost);
			}

			return costVO;
		}

		/**  根据当前购买参数，返回消耗 */

		public function getAltarCostByBuyType():int {
			return getCostVO().num;
		}

		public function getCostVO():ItemVO {
			var costVO:ItemVO;

			if(currentBuyItem==ITEM_WUXING) {
				if(currentBuyType==BUY_ONE) {
					costVO = getCostVOBySetting(true, false);
				}
				if(currentBuyType==BUY_TEN) {
					costVO = getCostVOBySetting(true, true);
				}
			}
			if(currentBuyItem==ITEM_GOLD) {
				if(currentBuyType==BUY_ONE) {
					costVO = getCostVOBySetting(false, false);
				}
				if(currentBuyType==BUY_TEN) {
					costVO = getCostVOBySetting(false, true);
				}
			}

			return costVO;
		}

		public function getWuxingFreeTimeStr():String {
			if(wuxingFreeTime>=1) {
				return "免费次数： "+String(wuxingFreeTime)+" / "+altarInfo.wuxing.freeTime;
			}

			return "今日免费次数已用完";
		}

		public var wuxingFreeTime:int;

		private var wuxingFreeDate:Date;

		private var goldFreeDate:Date;


		/** 获取 元素祭坛CD 字符串
		 *
		 * 如果CD为0，返回""
		 *
		 * */

		public function getWuxingCDStr():String {
			var now:Date=new Date();
			var cd:int=wuxingFreeDate.time-now.time+altarInfo.wuxing.freeCD*1000;
			return parseMsToStr(cd)
		}

		/** 获取 钻石祭坛CD 字符串
		 *
		 *  如果CD为0，返回""
		 *
		 * */

		public function getGoldCDStr():String {
			var now:Date=new Date();
			var cd:int=goldFreeDate.time-now.time+altarInfo.gold.freeCD*1000;
			return parseMsToStr(cd)
		}

		public function parseMsToStr(ms:int):String {
			if(ms<=0) {
				return "";
			}

			var seconds:int=Math.ceil(ms/1000);
			var mins:int=seconds/60;
			var hrs:int=mins/60;
			mins=mins%60;
			seconds=seconds%60;

			var hrsStr:String=String(hrs).length==1?"0"+String(hrs):String(hrs);
			var minsStr:String=String(mins).length==1?"0"+String(mins):String(mins);
			var secondsStr:String=String(seconds).length==1?"0"+String(seconds):String(seconds);

			if(hrs!=0) {
				return hrsStr+":"+minsStr+":"+secondsStr+" 后免费"
			}

			if(mins!=0||seconds!=0) {
				return minsStr+":"+secondsStr+" 后免费"
			}

			return "";
		}
	}
}
