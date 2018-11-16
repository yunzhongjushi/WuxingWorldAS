package com.view.UI.level {
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.fairy.FairyListVO;
	import com.model.vo.level.LevelVO;
	import com.model.vo.user.UserVO;
	import com.view.UI.fairy.FairyBarSmall;
	import com.view.choose.BaseChoosePanel;
	
	/**
	 * 关卡精灵选择面板
	 * @author hunterxie
	 */
	public class LevelFairyChoosePanel extends BaseChoosePanel{ 
		public static const NAME:String = "LevelFairyChoosePanel";
		public static const SINGLETON_MSG:String="single_LevelFairyChoosePanel_only";
		protected static var instance:LevelFairyChoosePanel;
		public static function getInstance():LevelFairyChoosePanel{
			if ( instance == null ) instance = new LevelFairyChoosePanel();
			return instance;
		}
		
		public var vo:LevelVO;	
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		
		/**
		 * 
		 * 
		 */
		public function LevelFairyChoosePanel() {
			super(true);
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
		}
		
		public function updateLevelInfo(vo:LevelVO):void{
			this.vo = vo;
			updateInfo(FairyBarSmall, FairyListVO.fairyList, userInfo.skillOpenNum);
			
			updateChooseItem();
		}
		
		public function updateChooseItem():void{
			
		}
		
		/**
		 * 玩家选择的关卡精灵列表
		 * @return [-1,-1,-1]
		 */
		public function getFairyArr():Array{
			var arr:Array = [];
			for(var i:int=0; i<BaseInfo.maxFairyNum; i++){
				if(i<chooseVOArr.length){
					arr.push((chooseVOArr[i] as BaseFairyVO).ID);
				}else{
					arr.push(-1);
				}
			}
			if(arr[0]==-1 && FairyListVO.fairyNum>0){
				arr[0] = FairyListVO.firstFairy.ID;
			}
			return arr;
		}
	}
}