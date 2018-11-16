package com.model.vo.skill {
	import com.model.vo.chessBoard.QiuPoint;
	
	/**
	 * 通过棋盘消除生成的技能球
	 * @author hunterxie
	 */
	public class ClearSkillPoint extends QiuPoint {
		public static var isCanCover:Boolean = true;
		
		/**
		 * 生成新球上面携带的技能——buff1位置
		 */
		public var skillID:int;
		
		/**
		 * 通过棋盘消除生成的技能球
		 * @param point		
		 * @param skillID	
		 * @param arr		记录的所在消除数组
		 */
		public function ClearSkillPoint(point:QiuPoint, skillID:int) {
			super(point.r, point.l, point.kind);
			this.skillID = skillID;
		}
		
		/**
		 * 如果有重复即根据技能得分/等级确定是否替换
		 * @param id
		 */
		public function coverSkill(id:int):void{
			if(id<skillID){
				this.skillID = id;
			}
		}
	}
}