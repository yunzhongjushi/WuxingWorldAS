package com.model.vo.level {
	import com.model.vo.config.board.BoardConfig;

	public class SolvePuzzleVO {
		public var levelID:int;
		
		public var solveInfo:String;
		
		public function SolvePuzzleVO(vo:LevelVO) {
			this.levelID = vo.id;
			this.solveInfo = vo.boardBallConfig.solve;
		}
	}
}
