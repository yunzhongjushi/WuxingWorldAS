package com.model.vo.config.level{
	import com.model.vo.BaseObjectVO;
	import com.model.vo.config.board.BoardConfigVO;
	
	
	/**
	 * 单个关卡建筑配置信息
	 * @author hunterxie
	 */
	public class BuildConfigVO extends BaseObjectVO{
		public var ID:int = 0;
		public var label:String = "关卡";
		/**关卡所属五行，主要怪物类型+资源产出类型*/
		public var wuxing:int = 0;
		/**关卡开启前提(通过关卡)*/
		public var trigger:String = "-1";
		/**每天可以闯关次数-1:不限*/
		public var crossTime:int = -1;
		/**是否可以携带技能*/
		public var skillCarry:int = 0;
		/**关卡所在地图坐标*/
		public var point:String = "35,-48";
		/**闯关需要花费精力*/
		public var energyCost:int = 5;
		
		/**关卡详细描述*/
		public var describe:String = "初入五行";
		
		/**关卡(过关前提)类型*/
		public var kind:int = 0;
		/**过关详细前提(all消除所有棋子;)*/
		public var target:String = "all";
		/**第一星获得前提*/
		public var star1:String = "0:50";
		/**第二星获得前提*/
		public var star2:String = "0:50";
		/**第三星获得前提*/
		public var star3:String = "0:100";

		/**一星奖励列表*/
		public var rewards1:Array = BaseObjectVO.getClassArray(LevelRewardBaseVO);
		/**三星奖励列表
		 */
		public var rewards3:Array = BaseObjectVO.getClassArray(LevelRewardBaseVO);
		/**关卡奖励列表*/
		public var rewards:Array = BaseObjectVO.getClassArray(LevelRewardBaseVO);
			
		/**
		 * 关卡棋盘配置（null就用默认的（节省存储空间）
		 */
		public function get boardConfig():BoardConfigVO{
			return _boardConfig;
		}
		public function boardChangeConfig():Object{
			return _boardConfig.getChangeVO();
		}
		public function set boardConfig(info:Object):void{
			if(!_boardConfig){
				_boardConfig = new BoardConfigVO;
			}
			_boardConfig.updateObj(info);
		}
		private var _boardConfig:BoardConfigVO;
		
		
		
		/**
		 * 
		 * @param info
		 */
		public function BuildConfigVO(info:Object=null):void{
//			rewards1.push(new LevelRewardBaseVO());
//			rewards3.push(new LevelRewardBaseVO());
			super(info);
		}
		
		/**
		 * 
		 * @param isAdd		增加还是减少
		 */
		public function setReward(kind:String, isAdd:Boolean):LevelRewardBaseVO{
			var vo:LevelRewardBaseVO;
			if(isAdd){
				vo = new LevelRewardBaseVO;
				switch(kind){
					case "reward1":
						rewards1.push(vo);
						break;
					case "reward3":
						rewards3.push(vo);
						break;
					case "rewards":
						rewards.push(vo);
						break;
				}
			}else{
				switch(kind){
					case "reward1":
						vo = rewards1.pop();
						break;
					case "reward3":
						vo = rewards3.pop();
						break;
					case "rewards":
						vo = rewards.pop();
						break;
				}
			}
			return vo;
		}
	}
}