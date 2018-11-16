package com.model.vo.editor {
	import com.model.vo.BaseObjectVO;
	import com.model.vo.config.PlayerEditConfig;
	import com.model.vo.config.board.BoardBaseVO;

	
	/**
	 * 玩家谜题编辑数据列表
	 * @author hunterxie
	 * 
	 */
	public class EditListVO extends BaseObjectVO{
		public static const NAME:String = "EditorListVO";
		public static const SINGLETON_MSG:String = "single_EditorListVO_only";
		protected static var instance:EditListVO;
		public static function getInstance():EditListVO{
			if ( instance == null ) instance = new EditListVO();
			return instance;
		}
		
		/**
		 * 自创谜题配置文件
		 */
		public var config:PlayerEditConfig;
		
		/**
		 * 棋盘配置列表
		 */
		public var edits:Array = BaseObjectVO.getClassArray(EditVO);
		public static function getEditByID(id:int):EditVO{
			return getInstance().edits[id];
		}
		
		/** 已经解锁可配置数 */
		public var unlockedBoardNum:int = 5;
		
		/** 设为防守的配置ID */
		public var defendConfigID:int = 0;
		/** 设为守卫关卡 */
		public function setDefend():void {
			(edits[defendConfigID] as EditVO).setDefend(false);
			defendConfigID = nowEditID;
			(edits[defendConfigID] as EditVO).setDefend(true);
		}
		
		/** 已经解锁可配置数 */
		public var unlockedBuffArr:Array = [1,4,9,10,13,41,0];
		
		/** 当前编辑的关卡ID，只保存ID确保只有一份被编辑 */
		public var nowEditID:int = 0;
		public function getNowInfo():EditVO{
			return edits[nowEditID];
		}
		public function setNowInfo(id:int):EditVO{
			getNowInfo().setNowEdit(false);
			this.nowEditID = id;
			getNowInfo().setNowEdit(true);
			nowInfoBackup.backupInfo(getNowInfo());
			return getNowInfo();
		}
		public function setRestoreNowInfo():void{
			getNowInfo().backupInfo(nowInfoBackup);
		}
		
		/**
		 * 备份一份当前谜题数据，可用于判断是否改变，还可以撤回数据<br>
		 * 还可以作为临时保存，编辑时意外退出后再进入可以复盘
		 */
		public var nowInfoBackup:EditVO = new EditVO();
		/** 判断是否对当前谜题有改动 */
		public function compareHasChanged():Boolean{
			return nowInfoBackup.compareHasChanged(getNowInfo());
		}
		
		public function EditListVO() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			config = PlayerEditConfig.getInstance();
			this.unlockedBoardNum = config.unlockedBoardNum;

			for(var i:int=0; i<config.totalBoardNum; i++){
				var vo:EditVO = new EditVO;
				vo.ID = i;
				vo.isUnlocked = i<this.unlockedBoardNum;
				edits.push(vo);
			}
		}
		override public function updateObj(info:Object):void{
			super.updateObj(info);
		}
		
		
		/**
		 * 解谜关卡棋盘配置
		 * @param id 配置id
		 * @return 
		 */
		public static function getEditorInfo(id:int):EditVO{
			if(id==0) return null;
			return getInstance().edits[id] as EditVO;
		}
		/**
		 * 个人编辑的解谜记录(防止玩家忘记自己编辑的谜题解法)
		 * @param id
		 * @return 
		 */
		public static function getSolveInfo(id:int):String{
			return getEditorInfo(id).solve; 
		}
	}
}