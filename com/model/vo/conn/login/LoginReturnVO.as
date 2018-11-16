package com.model.vo.conn.login {
	import com.model.event.EventCenter;
	import com.model.vo.conn.BaseReturnVO;


	/** 登录/注册后台返回信息
	 * @author hunterxie
	 */
	public class LoginReturnVO extends BaseReturnVO{

		public var socketIP:String;
		public var socketPort:int;
		public var userID:int;

		public function LoginReturnVO(isRegist:Boolean, info:String) {
			super(JSON.parse(info));
			
			EventCenter.traceInfo("注册/登录结果:"+info);
			switch(this.ret){
				case 0:
					return;
				case 1:
					EventCenter.traceInfo(isRegist?"数据库链接异常":"没有注册");
					break;
				case 2:
					EventCenter.traceInfo(isRegist?"用户名重复":"账号没有注册");
					break; 
				case 3:
					EventCenter.traceInfo("昵称重复");
					break; 
				case 4: 
					EventCenter.traceInfo("超时");
					break;
				case 5: 
					EventCenter.traceInfo("服务器错误");
					break;
			}
		}
	}
}
