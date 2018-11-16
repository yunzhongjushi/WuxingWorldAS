package com.model.vo {

	public class WebParams {
		/**
		 * 配置文件  
		 */
		public static var config:XML;
		/**
		 * qzone平台参数（QQ号和appid，对应用户名）
		 */
//		public static var openid:String = "82F5B4EDDBECFBB7298958F7B271F9F9";//153649338
		public static var openid:String = "2AB4BAB86CF94B899A337A666E8D29EF";//1658926430
		/**
		 * qzone平台参数（对应密码验证）
		 */
//		public static var openkey:String = "DCE9FD9F5E9F7705F990C253811B7F7A";//153649338
		public static var openkey:String = "8700058F12C7F6B0EE6538605451E8FA";//1658926430
		/**
		 * 平台信息
		 */
//		public static var pfkey:String = "9a176c362873032d34aeb92df61c8451";//153649338
		public static var pfkey:String = "a214b6430746e232e2cb5581207b5f01";//1658926430
		
		/**
		 * 平台
		 */
		public static var pf:String = "qzone"; 
		
		public function WebParams() {
			
		}
		
		public static function updateInfo(info:Object):void{
			for (var i:Object in info) {
				WebParams[i]=info[i]; 
				if(i=="config") updateConfig();
			}
		}
		
		private static function updateConfig():void{
			BaseInfo.isShowDebug = String(config.Params.version.@isShowTest)=="true";
			BaseInfo.platform = String(config.Params.platform.@name);
			BaseInfo.mainIP = String(config.Params.platform.@mainIP);
			
		}
		
		/**
		 * 版本号
		 * @return 
		 */
		public static function get version():String{
			if(config){
				return String(config.Params.version.@no);
			}
			return "0";
		}
		
		/**
		 * 客服链接
		 * @return 
		 */
		public static function get viewPrevent():String{
			if(config){
				return String(config.Params.version.@no);
			}
			return "0";
		}
		
		/**
		 * 黄钻特权页面
		 * @return 
		 */
		public static function get openQzoneVip():String{
			if(config){
				return String(config.Params.version.@no);
			}
			return "0";
		}
		
		/**
		 * 钻石购买页面
		 * @return 
		 */
		public static function get exchangeCoin():String{
			if(config){
				return String(config.Params.version.@no);
			}
			return "0";
		}
		
		/**
		 * 游戏主页面
		 * @return 
		 */
		public static function get openHomePage():String{
			if(config){
				return String(config.Params.version.@no);
			}
			return "0";
		}
	}
}
