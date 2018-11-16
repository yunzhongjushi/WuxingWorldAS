package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.proxy.BaseConnProxy;
	import com.model.vo.WuxingVO;
	import com.model.vo.item.ItemListVO;
	import com.model.vo.item.ItemVO;
	import com.model.vo.tip.LoadingVO;
	import com.model.vo.user.UserVO;
	
	/**
	 * 物品获取与使用
	 */
	public class ServerVO_192 extends BaseConnProxy{
		private static var instance:ServerVO_192;
		public static function getInstance():ServerVO_192{
			if ( instance == null ) instance=new ServerVO_192();
			return instance;
		}
		
		
		public static var ID:int = 0xc0;
		public var isSuccess:Boolean;
		private var running_code:int=-1;
		
		private static function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		public function ServerVO_192(obj:Object=null) {
			super(obj);
		}
		
		public function updateInfo(obj:Object):void{
			running_code=obj["code"];
			switch(running_code){
				case ServerVO_192.GET_INFO:
					ItemListVO.getInstance().updateByServer(obj);
					break;
				case ServerVO_192.USE_INFO:
					break;
			}
			
		}
		public function getIsSuccess():Boolean{
			return isSuccess;
		}
		public function getCode():int{
			return running_code
		}
		/**
		 * 发送给server
		 * @return 
		 */
		
		/**
		 * 使用物品
		 */		
		public static var USE_INFO:int = 1;
		public static function  getSendUseItem(itemVO:ItemVO):void{
			MainNC.getInstance().sendInfo(ID,{
				code:USE_INFO,
				itemId:itemVO.itemID,
				itemcount:itemVO.useItemNum
			});
			trace("____",itemVO.useItemNum);
		}
		/**
		 * 获取物品信息
		 */		
		public static var GET_INFO:int = 2;
		public static function  getItems():void{
			MainNC.getInstance().sendInfo(ID,{code:GET_INFO}, LoadingVO.LOADING_ITEM_INFO);
		}
	}
}
