package com.model.vo {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.vo.user.UserVO;
	import com.utils.TimerFactory;
	
	import flas.net.SharedObject;
	
	
	/**
	 * 
	 * @author hunterxie
	 * 
	 */
	public class GameSO {
		public static const NAME:String="GameSO";
		public static const SINGLETON_MSG:String="single_"+NAME+"_only";
		protected static var instance:GameSO;
		public static function getInstance():GameSO {
			if (instance==null)
				instance=new GameSO();
			return instance;
		}
		
		private var mySO:SharedObject;
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		public var saveTimer:uint;
		
		public var loadUserJudge:Boolean = false;
		
		public var lastLoginUser:String = "";
		public var lastLoginPass:String = "";
		
		
		/**
		 * 游戏共享对象
		 */
		public function GameSO(gameName:String="WuxingWorld") {
			if (instance!=null)
				throw Error(SINGLETON_MSG);
			instance = this;
			
			try{
				mySO = SharedObject.getLocal(gameName);
				if(mySO.data.lastLoginUser){
					lastLoginUser = mySO.data.lastLoginUser["account"];
					lastLoginPass = mySO.data.lastLoginUser["pwd"];
//					getShareObject(mySO.data.lastLoginUser.account);//每次都是一套新数据（userVO）,登录成功后再读取
				}
			}catch(e:Error){
				return;
			}
			
			EventCenter.on(ApplicationFacade.UPDATE_USER_INFO, this, writInfo);
		}
		
		
		public function getShareObject(userName:String):Boolean {
			if(loadUserJudge && userInfo.userName==userName){
				return true;
			}

			var soInfo:Object = mySO.data["user_"+userName];
			if(soInfo){
				userInfo.updateObj(soInfo);
				loadUserJudge = true;
				TimerFactory.loop(10000, this, writInfo);
				return true;
			}
			return false;
		}
		
		public function writInfo(e:*=null):void{
			if(!userInfo.userName) return;
			userInfo.lastLoginTime = (new Date).time;
			mySO.data["user_"+userInfo.userName] = userInfo;//bta;//
			mySO.data.lastLoginUser = {account:userInfo.userName, pwd:userInfo.userPwd};
			mySO.flush();
		}
		
		public static function save():void{
			getInstance().writInfo();
		}
	}
}