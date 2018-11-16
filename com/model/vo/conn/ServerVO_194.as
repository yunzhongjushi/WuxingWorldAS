package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.proxy.BaseConnProxy;
	import com.model.vo.WuxingVO;
	import com.model.vo.item.ItemVO;

	/**
	 * 发送签到命令
	 */
	public class ServerVO_194 extends BaseConnProxy {
		private static var instance:ServerVO_194;
		public static function getInstance():ServerVO_194{
			if ( instance == null ) instance=new ServerVO_194();
			return instance;
		}
		
		
		/** 协议号 */
		public static const ID:int=0xc2;

		public static const CODE_SIGN_UP:Object={code:-1, load:"正在签到..."};

		/** 新协议拷贝以下 */
		private static const LOAD_SHOW_LIST:Array=[CODE_SIGN_UP]

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

		public function ServerVO_194(obj:Object=null) {
			super(obj);
		}

		override protected function handleReceive(obj:Object):void {
		}

		/**
		 * 匹配谜题 和 挑战好友谜题
		 *
		 */
		public static function sign_up():void {
			var obj:Object={};
			var codeObj:Object=CODE_SIGN_UP;

			if(BaseInfo.isTestLogin==false) {
				//联网处理 - 发送至服务器
				sendInfo(obj, codeObj);
			} else {
				//本地处理 - 模拟接收
				obj.result=0;
				var vo:ServerVO_194=new ServerVO_194(obj);
				vo.sendInfoFromLocal(codeObj);
			}
		}
	}
}
