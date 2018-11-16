package com.model.vo.config.board {
	import com.model.vo.BaseObjectVO;

	/**
	 * 棋盘配置信息
	 * @author hunterxie
	 */
	public class BoardConfig extends BaseObjectVO {
		public static const NAME:String = "BoardConfig";
		public static const SINGLETON_MSG:String = "single_BoardConfig_only";
		protected static var instance:BoardConfig;
		public static function getInstance():BoardConfig{
			if ( instance == null ) instance = new BoardConfig();
			return instance;
		}
		
		public static function updateObj(info:Object):BoardConfig{
			getInstance().updateObj(info);
			return instance;
		}
		
		
		/**
		 * 棋盘配置列表
		 */
		public var boards:Array = BaseObjectVO.getClassArray(BoardBaseVO);
		private var nowBoard:BoardBaseVO;
		public function getNowInfo(index:int):BoardBaseVO{
			nowBoard = boards[index];
			return nowBoard;
		}
		
		/**
		 * 添加新棋盘配置
		 * @param now	是否复制当前关
		 * @return 		新增配置ID(用于定位选择)
		 */
		public function addBoard(copy:BoardBaseVO=null):int{
			var vo:BoardBaseVO = new BoardBaseVO();
			if(copy!=null){
				vo.updateObj(JSON.parse(JSON.stringify(copy)));
			}
			vo.ID = boards.length;
			boards.push(vo);
			return vo.ID;
		}
		/**
		 * 插入新棋盘配置
		 * @param now		当前棋盘，用于定位和复制
		 * @param isCopy	是否复制当前棋盘
		 * @return 		新增配置ID(用于定位选择)
		 */
		public function insertBoard(now:BoardBaseVO, isCopy:Boolean=false):int{
			var vo:BoardBaseVO = new BoardBaseVO();
			if(isCopy){
				vo.updateObj(JSON.parse(JSON.stringify(now)));
			}
			vo.ID = now.ID+1;
			boards.insertAt(vo.ID, vo);
			for(var i:int=vo.ID+1; i<boards.length; i++){
				(boards[i] as BoardBaseVO).ID = i;
			}
			return vo.ID;
		}
		/**
		 * 删除当前棋盘配置
		 * @param now
		 * @return 		新增配置ID(用于定位选择)
		 */
		public function deleteBoard(now:BoardBaseVO):int{
			boards.removeAt(now.ID);
			for(var i:int=now.ID; i<boards.length; i++){
				(boards[i] as BoardBaseVO).ID = i;
			}
			return now.ID;
		}
		
		/**
		 * 上移当前配置
		 * @param now
		 * @return 		新增配置ID(用于定位选择)
		 */
		public function upBoard(now:BoardBaseVO):int{
			if(!boards[now.ID-1]) return now.ID;
			(boards[now.ID-1] as BoardBaseVO).ID = now.ID;
			boards.insertAt(now.ID-1, boards.removeAt(now.ID));
			now.ID -= 1;
			return now.ID;
		}
		/**
		 * 下移当前配置
		 * @param now
		 * @return 		新增配置ID(用于定位选择)
		 */
		public function downBoard(now:BoardBaseVO):int{
			if(!boards[now.ID+1]) return now.ID;
			(boards[now.ID+1] as BoardBaseVO).ID = now.ID;
			boards.insertAt(now.ID+1, boards.removeAt(now.ID));
			now.ID += 1;
			return now.ID;
		}
		
		/**
		 * 
		 * 
		 */
		public function BoardConfig(info:Object=null) {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			if(!info){
				info = BaseInfo.boardInfo;//JSON.parse(String(LoadProxy.getLoadInfo("boardInfo.json")));
			}
			instance.updateObj(info);
		}
		 
		/**
		 * 解谜关卡棋盘配置
		 * @param id 配置id
		 * @return 
		 */
		public static function getBoardInfo(id:int):BoardBaseVO{
			if(id==0) return null;
			return getInstance().boards[id] as BoardBaseVO;
		}
		public static function getSolveInfo(id:int):String{
			return getBoardInfo(id).solve; 
		}
	}
}
