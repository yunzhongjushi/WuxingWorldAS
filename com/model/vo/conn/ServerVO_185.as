package com.model.vo.conn{
	import com.conn.MainNC;
	import com.model.proxy.BaseConnProxy;
	import com.model.vo.WuxingVO;
	import com.model.vo.config.shop.ShopConfig;
	import com.model.vo.item.ItemVO;

	/**
	 * 商城相关
	 */
	public class ServerVO_185 extends BaseConnProxy{
		protected static var instance:ServerVO_185;
		public static function getInstance():ServerVO_185{
			if ( instance == null ) instance=new ServerVO_185();
			return instance;
		}
		
		
		public static const LOAD_GET_INFO:String = "正在获取数据...";
		public static const LOAD_BUY_ITEM:String = "正在购买...";
		
		public static var ID:int = 0xb9;
		public var code:int;
		public var isBuySuccess:Boolean;
		
		public var subCode:int;
		
		public function ServerVO_185(obj:Object=null) {
			super(obj);
		}
		
		public function updateInfo(obj:Object):void{
			subCode= parseInt(obj["code"]);
			switch(subCode){
				case GET_INFO:
					MainNC.closeLodingPanel(LOAD_GET_INFO);
					ShopConfig.getInstance().updateObj(obj);
					ShopConfig.getInstance().dispatchUpdate();
					break;
				case BUY_ITEM:
					MainNC.closeLodingPanel(LOAD_BUY_ITEM);
					if(obj["rs"]==0){ 
						isBuySuccess=true;
					}else{
						isBuySuccess=false;
					}
					break;
			}
			
		}
		public function getIsBuySuccess():Boolean{
			return isBuySuccess;
		}
		/**
		 * 获取商品列表
		 */
		public static const GET_INFO:int = 0x01;
		public static function  getShopInfo():void{
			MainNC.getInstance().sendInfo(ID,{code:GET_INFO},LOAD_GET_INFO);
		}
		/**
		 * 购买
		 */
		public static const BUY_ITEM:int = 0x02;
		public static function  getSendBuyItem(id:String):void{
			MainNC.getInstance().sendInfo(ID, {code:BUY_ITEM,buy_id:id},LOAD_BUY_ITEM);
		}
	}
}
