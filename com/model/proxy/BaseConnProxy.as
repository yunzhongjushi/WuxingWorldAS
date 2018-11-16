package com.model.proxy {
	import com.model.ApplicationFacade;
	import com.conn.MainNC;
	import com.model.vo.BaseObjectVO;

	/**
	 * 协议基类
	 * @author hunterxie
	 * 
	 */
	public class BaseConnProxy extends BaseObjectVO{
		public static const DEFAULT_LOAD_SHOW:String="正在连接...";

		/**
		 * 二级协议号，null为无
		 */
		public var mSubCodeObj:Object;

		/**
		 * 返回的状态码，0为成功，1，2，3...为失败
		 */
		public var rs:int;
		
		/**
		 * 后台传入的数据
		 */
		public var info:Object;
		
		public var id:int = -1;


		public function BaseConnProxy(obj:Object=null) {
			updateObj(obj);
			info=obj;
			return;
			var code:int=obj["code"]==null?-1:parseInt(obj["code"]);

			mSubCodeObj=getCodeObj(code);

			if(mSubCodeObj) {
				var loadWord:String=mSubCodeObj["load"];
				MainNC.closeLodingPanel(loadWord);
			}

			// 判断是否成功执行
			if(obj["result"]==null) {
				rs=0;
			} else if(obj["result"] is Boolean) {
				rs=obj["result"]==true?0:1;
			} else if(isNaN(Number(obj["result"]))==false) {
				rs=parseInt(obj["result"]);
			} else {
				throw new Error("未知 result!!!");
			}

			//处理执行成功与失败的流程
			if(isOK==false) {
				trace("协议执行失败");
			} else {
				handleReceive(obj);
			}
		}
		

		protected function handleReceive(obj:Object):void {
			throw new Error("协议中的 handleReceive() 方法需要重写");
		}

		protected function getCodeObj(code:int):Object {
			throw new Error("协议中的 getCodeObj() 方法需要重写");
			return null;
		}
		
		override public function updateObj(info:Object):void{
			super.updateObj(info);
			this.event(ApplicationFacade.SERVER_INFO_OBJ, this);
		}

		protected function sendInfoFromLocal(codeObj:Object):void {
			mSubCodeObj=codeObj["code"];
			this.event(ApplicationFacade.SERVER_INFO_OBJ, this);
		}

		public function get isOK():Boolean {
			return rs==0;
		}

		public function get resultCode():int {
			return rs;
		}

		public function get subCodeObj():Object {
			return mSubCodeObj;
		}
	}
}
