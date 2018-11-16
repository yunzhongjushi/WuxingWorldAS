package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.proxy.BaseConnProxy;
	import com.model.vo.WuxingVO;
	import com.model.vo.activity.SignInfoVO;
	import com.model.vo.item.ItemVO;

	/**
	 * 获取签到信息
	 */
	public class ServerVO_195 extends BaseConnProxy {
		private static var instance:ServerVO_195;
		public static function getInstance():ServerVO_195{
			if ( instance == null ) instance=new ServerVO_195();
			return instance;
		}
		
		
		/** 协议号 */
		public static const ID:int=0xc3;

		public static const CODE_SIGN_INFO:Object={code:-1, load:"正在获取数据..."};

		/** 新协议拷贝以下 */
		private static const LOAD_SHOW_LIST:Array=[CODE_SIGN_INFO]

		private static function sendInfo(obj:Object, codeObj:Object):void {
			var code:int=codeObj["code"];
			if(code!=-1)
				obj.code=code;
			MainNC.getInstance().sendInfo(ID, obj, codeObj["load"]);
		}

		override protected function getCodeObj(code:int):Object {
			for each(var obj:Object in LOAD_SHOW_LIST) {
				if(obj["code"]==code)
					return obj;
			}
			return null;
		}
		/** 新协议拷贝以上 */

		public var signInfoVO:SignInfoVO;

		public function ServerVO_195(obj:Object=null) {
			super(obj);
		}

		override protected function handleReceive(obj:Object):void {
			var getReward:Object=obj["getReward"];
			var count:int=obj["count"];

			var canGetReward:Boolean;
			var curAvaiNO:int;
			var curSignNO:int;

			canGetReward=getReward==null?false:Boolean(getReward);
			curSignNO=count;

			if(canGetReward)
				curAvaiNO=curSignNO+1;
			else
				curAvaiNO=curSignNO;

			signInfoVO=new SignInfoVO(curAvaiNO, curSignNO, canGetReward);
		}

		/**
		 * 获取签到信息
		 *
		 */
		public static function get_sign_info():void {
			var obj:Object={};
			var codeObj:Object=CODE_SIGN_INFO;

			if(BaseInfo.isTestLogin==false) {
				//联网处理 - 发送至服务器
				sendInfo(obj, codeObj);
			} else {
				//本地处理 - 模拟接收
				obj.result=0;
				var vo:ServerVO_195=new ServerVO_195(obj);
				vo.sendInfoFromLocal(codeObj);
			}
		}
	}
}
