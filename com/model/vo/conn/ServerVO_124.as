	package com.model.vo.conn {
			import com.conn.MainNC;
			import com.model.vo.WuxingVO;
			import com.model.vo.item.ItemListVO;
			import com.model.vo.item.ItemVO;
			
			/**
			 * 物品出售
			 */
			public class ServerVO_124{
				
				public static const LOAD_SELL:String = "正在出售物品...";
				
				public static var ID:int = 0x7c;
				public var isSuccess:Boolean;
				private var itemArr:Array=[];
				private var errorCode:int;
				private var running_code:int=-1;
				
				public function ServerVO_124(obj:Object) {
						errorCode=-1
						if(obj["result"]==1){
							isSuccess=true;
						}else{
							errorCode=obj["result"];
							isSuccess=false;
						}
				}
				public function getIsSuccess():Boolean{
					return isSuccess;
				}
				public function getErrorCode():int{
					return errorCode
				}
				/**
				 * 发送给server
				 * @return 
				 */
				
				/**
				 * 卖出物品
				 */		
//				public static var SELL_ITEM:int = 1;
				public static function  getSendSellItem(itemVO:ItemVO):void{
					MainNC.getInstance().sendInfo(ID,{itemId:itemVO.itemID,value:itemVO.useItemNum},LOAD_SELL);
					
//					ItemListVO.testSellItem(itemVO,itemVO.useItemNum);
				}
			}
		}
