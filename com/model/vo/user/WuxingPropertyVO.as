package com.model.vo.user {
	import com.model.vo.item.ItemEquipVO;

	public class WuxingPropertyVO {
		public static const NAME:String="WuxingPropertyVO";
		public static const SINGLETON_MSG:String="single_WuxingPropertyVO_only";
		protected static var instance:WuxingPropertyVO;
		public static function getInstance():WuxingPropertyVO{
			if ( instance == null ) instance = new WuxingPropertyVO();
			return instance;
		}
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		private var arr:Array = [];
		
		public function WuxingPropertyVO() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
		}
		
		public function updateInfo(){
			for(var i:int=0; i<userInfo.wuxingInfo.wuxingPropertyArr.length; i++){
				arr[i] = new ItemEquipVO(i,userInfo.wuxingInfo.wuxingPropertyArr[i]);
			}
		}
		
		public function getItemEquip():ItemEquipVO{
			
		}
	}
}
