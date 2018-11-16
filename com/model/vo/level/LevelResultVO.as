package com.model.vo.level {
	import com.model.vo.chessBoard.GameResultVO;
	import com.model.vo.fairy.FairyListVO;

	public class LevelResultVO extends GameResultVO{
		
		public var myFairys:Array;
		
		public function LevelResultVO(vo:LevelVO) {
			super(vo);
			
			myFairys = FairyListVO.getFightFairy();
		}
	}
}
