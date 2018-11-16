package com.model.vo.tip {
	import com.model.event.EventCenter;
	
	import flas.events.EventDispatcher;

	/**
	 * 展示/关闭loading面板携带的数据
	 * @author hunterxie
	 */
	public class LoadingVO extends EventDispatcher{
		protected static var instance:TipVO;
		public static function getInstance():TipVO{
			if (instance==null) instance=new TipVO(""); 
			return instance;
		}
		
		/**
		 * 等待服务器发送信息时需要展示loading状态（不能操作）
		 */
		public static const SHOW_LOADING:String 		= "SHOW_LOADING";
		;
		public static const connect_socket:String 	= "正在连接socket服务器......";
		public static const login_socket:String 		= "正在登录socket服务器......"
		public static const LOADING_ITEM_INFO:String = "正在获取物品信息.....";
		
		/**
		 * 临时存储的对应协议的loading信息，用于收到消息后关闭对应的loading界面
		 */
		private static var loadingInfoArr:Object = {};
		
		public static function showLoadingInfo(key:String, showJudge:Boolean, info:String=""):void{
			var infoL:LoadingVO = new LoadingVO(key, showJudge, info);
			loadingInfoArr[key] = infoL;
			getInstance().event(LoadingVO.SHOW_LOADING, infoL);
		}
		public static function closeLoadingInfo(key:String):void{
			var infoL:LoadingVO = loadingInfoArr[key];
			if(infoL){
				infoL.showJudge = false;
				getInstance().event(SHOW_LOADING, infoL);
			}
		}
		
		
		
		/**
		 * 显示的key，用于重复显示后的关闭
		 */
		public var key:String;
		
		/**
		 * 显示还是关闭
		 */
		public var showJudge:Boolean;
		
		/**
		 * 显示的文本信息
		 */
		public var info:String;
		
		/**
		 * 延迟展示，时间超过这个值以后才显示出来
		 */
		public var delay:Number = 1000;
		
		
		/**
		 * @param key		显示的key，用于重复显示后的关闭
		 * @param showJudge	显示还是关闭
		 * @param info		显示的文本信息
		 */
		public function LoadingVO(key:String, showJudge:Boolean, info:String="") {
			this.key = key;
			this.showJudge = showJudge;
			this.info = info;
		}
		
	}
}
