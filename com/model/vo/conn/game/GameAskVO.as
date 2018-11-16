package com.model.vo.conn.game {
	import com.conn.MainNC;
	import com.model.vo.WebParams;
	import com.model.vo.conn.BaseAskVO;
	
	/**
	 * socket登录请求信息
	 * @author hunterxie
	 */
	public class GameAskVO extends BaseAskVO{
		/**
		 * 请求指令
		 */
		public var code:String;
		/**
		 * qzone平台参数（QQ号和appid，对应用户名）
		 */
		public var levelid:int;
		/**
		 * qzone平台参数（对应密码验证）
		 */
		public var openkey:String;
		/**
		 * 
		 */
		public var platform:String = "0";
		
		/**
		 * 设备号
		 */
		public var udid:String;
		//		/**
		//		 * 微信登录串
		//		 */
		//		public var openid:String;
		
		public function GameAskVO(username:String, password:String, code:String="") {
			this.cmd = MainNC.CLIENT_LOGIN;
			this.description = "socket请求登录";
			
			this.username = username;
			this.password = password;
			this.logincode = code!="" ? code : BaseInfo.UDID;
			this.openid = WebParams.openid;
			this.openkey = WebParams.openkey;
		}
	}
}
