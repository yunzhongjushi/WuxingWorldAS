package com.model.vo.editor {
	import com.model.vo.config.board.BoardBaseVO;
	import com.utils.ArrayFactory;

	
	
	/**
	 * 单个玩家谜题编辑数据
	 * @author hunterxie
	 */
	public class EditVO extends BoardBaseVO{
		public static const UPDATE_EDIT_INFO:String = "UPDATE_EDIT_INFO";
		/** 确认覆盖现有自创解谜过程 */		
		public static const COVER_EDIT_INFO:String = "COVER_EDIT_INFO";
		
		/**
		 * 这关是否解锁
		 */
		public var isUnlocked:Boolean = false;
		
		/**
		 * 是否是当前编辑谜题
		 */
		public var isNowEdit:Boolean = false;
		public function setNowEdit(judge:Boolean):void{
			if(judge!=this.isNowEdit){
				this.isNowEdit = judge;
				event(UPDATE_EDIT_INFO);
			}
		}
		
		/**
		 * 是否设置为防守关卡
		 */
		public var isSetDefend:Boolean = false;
		public function setDefend(judge:Boolean):void{
			if(judge!=this.isSetDefend){
				this.isSetDefend = judge;
				event(UPDATE_EDIT_INFO);
			}
		}
		
		/** 棋盘大小(5,6,8) */
		public var boardScale:int = 5;
		
		
		/**
		 * 此谜题是否编辑了解决方案<br>
		 * 有解才能设置为谜题让其他人玩，同时改变按钮视觉效果
		 */
		public function getIsSolve():Boolean{
			return Boolean(this.solve);
		}
		
		public function setSolve(info:String):void{
			this.solve = info;
			event(UPDATE_EDIT_INFO);
		}
		
		override public function updateObj(info:Object):void{
			super.updateObj(info);
			event(UPDATE_EDIT_INFO);
		}
		
		
		public function EditVO(info:Object=null):void{
			super(info);
			
		}
		
		/**
		 * 备份/还原数据，可用于判断是否改变，还可以撤回数据
		 * @param vo
		 */
		public function backupInfo(vo:EditVO):EditVO{
			var info:String = JSON.stringify(vo);
			var obj:Object = JSON.parse(info);
//			var amfBta:ByteArray = new ByteArray()  ;
//			var obj = (new ByteArray()).writeObject(this);
			this.updateObj(obj);
			return vo;
		}
		
		/**
		 * 对比备份的数据是否有改变
		 * @param vo
		 */
		public function compareHasChanged(vo:EditVO):Boolean{
			if(this.solve != vo.solve){
				return true;
			}else if(!ArrayFactory.compareArr(this.balls, vo.balls)){
				return true;
			}else if(!ArrayFactory.compareArr(this.skills, vo.skills)){
				return true;
			}else if(!ArrayFactory.compareArr(this.grids, vo.grids)){
				return true;
			}
			return false;
		}
	}
}
