package com.model.vo.chessBoard {
	import com.model.vo.skill.BoardBuffVO;
	import com.model.vo.skill.BoardSkillEffectVO;

	/**
	 * 单个格子buff数据，静态，包含横竖坐标
	 * @author hunterxie
	 */
	public class GridPoint extends BoardBuffVO {
		public static const UPDATE_GRID_BUFF_INFO:String = "UPDATE_GRID_BUFF_INFO";
		
		/**
		 * 空格
		 */
		public static const KIND_99:int = 99;
		/**
		 * 金格
		 */
		public static const KIND_100:int = 100;
		/**
		 * 木格
		 */
		public static const KIND_101:int = 101;
		/**
		 * 土格
		 */
		public static const KIND_102:int = 102;
		/**
		 * 水格
		 */
		public static const KIND_103:int = 103;
		/**
		 * 火格
		 */
		public static const KIND_104:int = 104;
		
		private var _r:int;
		public function get r():int{
			return _r;
		}
		private var _l:int;
		public function get l():int{
			return _l;
		}
		
		public function GridPoint(r:int, l:int, id:int, lv:int=1, effect:BoardSkillEffectVO=null):void{
			this._r = r;
			this._l = l;
			super(id, lv, effect);
		}
		
		/**
		 * 
		 * @param id
		 */
		public function updateBuff(id:int):void{
			super.updateInfo(id, this.LV)
			event(BoardBuffVO.CHANGE_BUFF_STATE, "");
		}
	}
}
