package com.model.vo.conn {
	import com.model.ApplicationFacade;
	import com.conn.MainNC;
	import com.model.event.EventCenter;
	import com.model.proxy.BaseConnProxy;
	import com.model.vo.friend.FriendVO;
	import com.model.vo.user.UserVO;

	/**
	 * 获取成就信息
	 */
	public class ServerVO_199 extends BaseConnProxy {
		/** 协议号 */
		public static const ID:int=0xc7;

		public static const CODE_GET_INFO:Object={code:-1, load:"正在获取数据..."};

		/** 新协议拷贝以下 */
		private static const LOAD_SHOW_LIST:Array=[CODE_GET_INFO]

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

		public function ServerVO_199(obj:Object) {
			super(obj);
		}

		override protected function handleReceive(obj:Object):void {
			updateData(obj);
			if(BaseInfo.isTestLogin) {
				for each(var arr:Array in obj) {
					trace("Q:", arr);
				}
			}
		}
		/**
		 * 由ServerVO_199和ServerVO_8调用，进行数据更新
		 * 更新分为两种情况，第一次请求时，更新所有成就的，第二次以后，只更新有变化的成就
		 * @param data
		 */
		public static function updateData(data:Object):void {
			isDataInit=true;
			if(requestPlayerVO==null||requestPlayerVO.playerID==UserVO.getInstance().userID) {
				for(var i:String in data) {
					if(i=="serverCMD") continue;
					var questObj:Object = data[i];
					var questID:int = parseInt(questObj[0]);
					
					if(questID<=0) {
						trace("成就ID会小于0？？？？？");
						continue;
					}
				}
			} else {
				// 朋友的数据
			}
			EventCenter.event(ApplicationFacade.QUEST_INFO_UPDATE);
			requestPlayerVO=null;
		}

		/**
		 * 第一次获取信息
		 * @return
		 */
		public static function first_get_info(playerID:int):void {
			// 根据玩家ID来获取成就的功能未做。
			var obj:Object={};
			var codeObj:Object=CODE_GET_INFO;
			if(BaseInfo.isTestLogin==false) {
				//联网处理 - 发送至服务器
				obj.type="0";
				sendInfo(obj, codeObj);
			} else {
				return;
				//本地处理 - 模拟接收
//				obj = TaskLogic.getInstance().getTotalAchInfo();

				var vo:ServerVO_199=new ServerVO_199(obj);
				vo.sendInfoFromLocal(codeObj);
			}
		}

		/**
		 * 初始化以后获取信息
		 * @return
		 */
		public static function update_get_info(playerID:int):void {
			var obj:Object={};
			var codeObj:Object=CODE_GET_INFO;
			if(BaseInfo.isTestLogin==false) {
				//联网处理 - 发送至服务器
				obj.type="1";
				sendInfo(obj, codeObj);
			} else {
				return;
				//本地处理 - 模拟接收
//				obj = TaskLogic.getInstance().getTotalAchInfo();

				var vo:ServerVO_199=new ServerVO_199(obj);
				vo.sendInfoFromLocal(codeObj);
			}
		}
		
		
		/**
		 * 最低重复获取成就间隔，毫秒
		 */
		private static const QUEST_REQUEST_INTERVAL:int=0;
		
		private static var showPanelName:String;
		
		/**
		 * 请求查找的朋友成就信息
		 */
		public static var requestPlayerVO:FriendVO;
		
		private static var isDataInit:Boolean=false;
		
		private static var lastUpdateDate:Date;
		
		
		public static function getInfo(vo:FriendVO=null):void {
			if(lastUpdateDate&&(new Date()).time-lastUpdateDate.time<=QUEST_REQUEST_INTERVAL)
				return;
			
			requestPlayerVO = vo ? vo : FriendVO.selfFriend;
			lastUpdateDate=new Date();
			
			if(isDataInit==false)
				ServerVO_199.first_get_info(requestPlayerVO.playerID);
			else
				ServerVO_199.update_get_info(requestPlayerVO.playerID);
			
		}
	}
}
