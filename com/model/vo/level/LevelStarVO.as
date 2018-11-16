package com.model.vo.level {
	import com.model.vo.WuxingVO;
	import com.model.logic.BaseGameLogic;
	import com.model.vo.chessBoard.QiuPoint;
	

	/**
	 * 关卡中星星的记录
	 * @author hunterxie
	 */
	public class LevelStarVO {
		/**
		 * 达到目标分数 
		 */
		public static const STAR_KIND_0:int = 0;
		
		/**
		 * 目标时间内过关
		 */
		public static const STAR_KIND_1:int = 1;
		
		/**
		 * 目标回合内过关
		 */
		public static const STAR_KIND_2:int = 2;
		
		/**
		 * 目标步数内过关
		 */
		public static const STAR_KIND_3:int = 3;
		
		/**
		 * 达到X次多消
		 */
		public static const STAR_KIND_4:int = 4;
		
		/**
		 * 达到X连消
		 */
		public static const STAR_KIND_5:int = 5;
		
		/**
		 * 达到X次连色消
		 */
		public static const STAR_KIND_6:int = 6;
		
		/**
		 * 触发某个技能
		 */
		public static const STAR_KIND_7:int = 7;
		
		/**
		 * 达到交换消除数(60秒)
		 */
		public static const STAR_KIND_8:int = 8;
		
		
		
		
		
		/**
		 * 获得条件ID
		 */
		public var tarKind:int;
		/**
		 * 获得条件2——如4消、5连、2连色、技能ID
		 */
		public var tarKind2:int;
		/**
		 * 获得目标数量
		 */
		public var tarNum:int;
		
		/**
		 * 目标五行——如“火4消”目标中的五行
		 */
		public var tarWuxing:int = QiuPoint.KIND_100;
		
		/**
		 * 是否已经获得此星星
		 */
		public function get hasOwn():Boolean{
			return _hasOwn;
		}
		public function set hasOwn(value:Boolean):void{
			_hasOwn = value;
		}
		private var _hasOwn:Boolean = false;
		
		/**
		 * 达到目标星星前提描述
		 */
		public var tarInfo:String = "";
		
		
		/**
		 * 
		 * @param info
		 * 
		 */
		public function LevelStarVO(info:String=null) {
			if(info) init(info);
		}
		
		public function init(info:String):void{
			var arr:Array = info.split(":");
			for(var i:int=0; i<arr.length; i++){
				switch(i){
					case 0:
						tarKind = parseInt(arr[i]);
						break;
					case 1:
						tarNum = parseInt(arr[i]);
						break;
					case 2:
						tarKind2 = parseInt(arr[i]);
						break;
					case 3:
						tarWuxing = arr[i];
						break;
				}
			}
			switch(this.tarKind){
				case STAR_KIND_0:
					this.tarInfo = "关卡得分达到 "+tarNum+" 分";
					break;
				case STAR_KIND_1:
					this.tarInfo = "在 "+tarNum+" 秒以内过关";
					break;
				case STAR_KIND_2:
					this.tarInfo = "在 "+tarNum+" 回合以内过关";
					break;
				case STAR_KIND_3:
					this.tarInfo = "移动 "+tarNum+" 次以内过关";
					break;
				case STAR_KIND_4:
					if(this.tarWuxing!=QiuPoint.KIND_100){
						this.tarInfo = "达到 "+WuxingVO.getHtmlWuxing(tarWuxing)+" 棋子 "+tarNum+" 次 "+tarKind2+" 消";
					}else{
						this.tarInfo = "达到 "+tarNum+" 次 "+tarKind2+" 消";
					}
					break;
				case STAR_KIND_5:
					this.tarInfo = "达到 "+tarNum+" 次 "+tarKind2+" 连消";
					break;
				case STAR_KIND_6:
					if(this.tarWuxing!=QiuPoint.KIND_100){
						this.tarInfo = "达到 "+WuxingVO.getHtmlWuxing(tarWuxing)+" 棋子 "+tarNum+" 次 "+tarKind2+" 消";
					}else{
						this.tarInfo = "达到 "+tarNum+" 次 "+tarKind2+" 连色消";
					}
					break;
				case STAR_KIND_7:
					this.tarInfo = "触发 "+tarNum+" 次 "+tarKind2+" 技能"; 
					break;
				case STAR_KIND_8:
					this.tarInfo = "达到 "+tarNum+" 次交换消除";
					break;
			}
		}
		
		/**
		 * 根据闯关信息判断星星是否获得
		 * @param vo
		 */
		public function updateInfo(vo:BaseGameLogic):void{
			switch(this.tarKind){
				case STAR_KIND_0:
					this.hasOwn = this.tarNum<=vo.passScore;
					break;
				case STAR_KIND_1:
					this.hasOwn = this.tarNum>=vo.timeUse;
					break;
				case STAR_KIND_2:
					this.hasOwn = this.tarNum>=vo.turnNum;
					break;
				case STAR_KIND_3:
					this.hasOwn = this.tarNum>=vo.totalMoveTime;
					break;
				case STAR_KIND_4:
					this.hasOwn = this.tarNum<=vo.getGameMultipleClear(this.tarKind2, this.tarWuxing);
					break;
				case STAR_KIND_5:
					this.hasOwn = this.tarNum<=vo.getGameContinuousClear(this.tarKind2);
					break;
				case STAR_KIND_6:
					this.hasOwn = this.tarNum<=vo.getGameSameContinuousClear(this.tarKind2, this.tarWuxing);
					break;
				case STAR_KIND_7:
					this.hasOwn = this.tarNum<=vo.getSkillEffectedNum(this.tarKind2);
					break;
				case STAR_KIND_8:
					this.hasOwn = this.tarNum<=vo.totalMoveTime;
					break;
			}
		}
	}
}
