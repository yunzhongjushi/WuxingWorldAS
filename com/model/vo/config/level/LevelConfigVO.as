package com.model.vo.config.level{
	import com.model.vo.BaseObjectVO;
	import com.model.vo.config.board.BoardConfigVO;
	
	import flas.geom.Point;
	
	
	/**
	 * 单个关卡配置信息
	 * @author hunterxie
	 */
	public class LevelConfigVO extends BaseObjectVO{
		public function get ID():int{
			return _ID;
		}
		public function set ID(value:int):void{
			_ID = value;
			LevelConfig.setLevel(this);
		}
		private var _ID:int = 0;
		
		public var icon:String = "";
		
		public var label:String = "关卡";
		/**
		 * 关卡详细描述
		 */
		public var describe:String = "初入五行";
		/**
		 * 关卡(过关前提)类型
		 */
		public var kind:String = "clearAll";
		/**
		 * 过关详细前提(all消除所有棋子;)
		 */
		public var target:String = "all";
		/**
		 * 关卡所属五行，主要怪物类型+资源产出类型
		 */
		public var wuxing:int = 0;
		/**
		 * 可以过关总次数(-1:无限制;0:只能闯一次;0<:每天能闯的次数
		 */
		public var crossTime:int = -1;

		/**
		 * 关卡开启前提(通过关卡，只能一个，-1默认不需要)
		 */
		public var trigger:int = -1;
		/**
		 * 是否可以携带技能
		 */
		public var skillCarry:int = 0;
		/**
		 * 闯关需要花费精力
		 */
		public var energyCost:int = 5;
		/**
		 * 关卡所在地图坐标
		 */
		public var point:String = "35,-48";
		/**
		 * 第一星获得前提
		 */
		public var star1:String = "0:50";
		/**
		 * 第二星获得前提
		 */
		public var star2:String = "0:100";
		/**
		 * 第三星获得前提
		 */
		public var star3:String = "0:150";
		
		/**
		 * 奖励信息
		 */
		public var rewards:LevelRewardConfigVO = new LevelRewardConfigVO;
			

		/**
		 * 关卡棋盘配置（null就用默认的（节省存储空间）
		 */
		public function get boardConfig():Object{
			if(!_boardConfig){
				return null;
			}
			return _boardConfig.getChangeVO();
		}
		public function set boardConfig(info:Object):void{
			if(info==null){
				_boardConfig = null;
				return;
			}
			if(!_boardConfig){
				_boardConfig = new BoardConfigVO;
			}
			_boardConfig.updateObj(info);
		}
		private var _boardConfig:BoardConfigVO;
		
		/**
		 * 关卡配置中配的棋盘ID
		 */
		public var boardID:int;
		
		private var mapPoint:Point;
		
		
		/**
		 * 
		 * @param info
		 */
		public function LevelConfigVO(info:Object=null):void{
			super(info);
//			LevelInfo.setLevel(this);
			
			if(this.point!=""){
				var arr:Array = point.split(",");
				this.mapPoint = new Point(parseInt(arr[0]), parseInt(arr[1]));
			}
		}
		
		public function getMapPoint():Point{
			return this.mapPoint;
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
						rewards.reward1.push(vo);
						break;
					case "reward3":
						rewards.reward3.push(vo);
						break;
					case "rewards":
						rewards.rewards.push(vo);
						break;
				}
			}else{
				switch(kind){
					case "reward1":
						vo = rewards.reward1.pop();
						break;
					case "reward3":
						vo = rewards.reward3.pop();
						break;
					case "rewards":
						vo = rewards.rewards.pop();
						break;
				}
			}
			return vo;
		}
		
		/**
		 * 是否是高级关卡
		 * @return 
		 */
		public function get isHighLevel():Boolean{
			return missionKind==LEVEL_SECTION_HIGH;
		}
		/**
		 * 是否引导关，引导关需要进行相关处理
		 * @return 
		 */
		public function get isGuide():Boolean{
			return this.missionKind==LEVEL_SECTION_GUIDE;
		}
		/**
		 * 任务类型（闯关，教程，任务）
		 */
		public function get missionKind():int{
			for(var i:int=0; i<levelSectionArr.length; i++){
				if(Math.floor(ID/levelSectionArr[i])==1){
					return levelSectionArr[i];
				}
			}
//			if(Math.floor(ID/LEVEL_SECTION_CHALLENGE)==1){
//				return LEVEL_SECTION_CHALLENGE;
//			}else if(Math.floor(ID/LEVEL_SECTION_BUILDER)==1){
//				return LEVEL_SECTION_BUILDER;
//			}else if(Math.floor(ID/LEVEL_SECTION_UNIVERSAL)==1){
//				return LEVEL_SECTION_UNIVERSAL;
//			}else if(Math.floor(ID/LEVEL_SECTION_GUIDE)==1){
//				return LEVEL_SECTION_GUIDE;
//			}else if(Math.floor(ID/LEVEL_SECTION_HIGH)==1){
//				return LEVEL_SECTION_HIGH;
//			}
			return LEVEL_SECTION_NORMAL;
		}
		public function resolveLevelTarget(str:String):Array{
			var tarArr:Array = [];
			var groups:Array = str.split(";");//多组精灵队列用";"分隔
			for(var j:int=0; j<groups.length; j++){
				var arr:Array = groups[j].split(",");
				for(var i:int=0; i<arr.length; i++){
					var arr1:Array = String(arr[i]).split(":");
					if(this.kind==KIND_GAME_FIGHT_PVE){//配置变更，精灵ID+30000起
						arr1[0] = parseInt(arr1[0])+30000;
					}
					tarArr.push(arr1);
				}
			}
			return tarArr;
		}
		
		
		/** 关卡类型是否是战斗(需要精灵)
		 * @param kind
		 * @return
		 */
		public function get isFight():Boolean{
			var str:String = kind.substring(0, 2);
			return (str=="pv");//前两个字符为"pv"(pvp/pve)
		}
		
		public function get isPuzzle():Boolean {
			return !isFight;
//			return kind==KIND_GAME_PUZZLE_CLEAR_All||kind==KIND_GAME_PUZZLE_CLEAR_KIND||kind==KIND_GAME_PUZZLE_CLEAR_NUM||kind==KIND_GAME_PUZZLE_CLEAR_POINT
//				||kind==KIND_GAME_PUZZLE_FIT_ELEMENTS||kind==KIND_GAME_PUZZLE_SCORE||kind==KIND_GAME_COLLECT_RESOURCE
		}
		public function get isPVE():Boolean {
			return kind==KIND_GAME_FIGHT_PVE || kind==KIND_GAME_FIGHT_PVE_GIVEN;
		}
		public function get isPVP():Boolean {
			return kind==KIND_GAME_FIGHT_PVP_REAL_TIME || kind==KIND_GAME_FIGHT_PVP_ROUND;
		}
		
		
		
		/** 普通闯关ID段:0 */
		public static const 	LEVEL_SECTION_NORMAL:int				= 0;
		/** 精英闯关ID段:10000 */
		public static const 	LEVEL_SECTION_HIGH:int					= 10000;
		/** 引导关ID段:20000 */
		public static const 	LEVEL_SECTION_GUIDE:int					= 20000;
		/** 模版关ID段:30000 */
		public static const 	LEVEL_SECTION_UNIVERSAL:int				= 30000;
		/** 任务关ID段:40000 */
		public static const 	LEVEL_SECTION_BUILDER:int				= 40000;
		/** 挑战关ID段:50000 */
		public static const 	LEVEL_SECTION_CHALLENGE:int				= 50000;
		
		/** ID为20000的关卡，引导关1 */
		public static const 	levelSectionArr:Array					= [LEVEL_SECTION_CHALLENGE, LEVEL_SECTION_BUILDER, LEVEL_SECTION_UNIVERSAL, LEVEL_SECTION_GUIDE, LEVEL_SECTION_HIGH];
		
		/** ID为20000的关卡，引导关1 */
		public static const 	LEVEL_ID_20000:int						= 20000;
		
		/** 解谜，消除所有棋子即过关 */
		public static const 	KIND_GAME_PUZZLE_CLEAR_All:String		= "clearAll";
		/** 解谜，消除初始棋盘上目标位置棋子即过关 */
		public static const 	KIND_GAME_PUZZLE_CLEAR_POINT:String		= "clearPoint";
		/** 解谜，消除棋盘上某个类型的所有棋子即过关 */
		public static const 	KIND_GAME_PUZZLE_CLEAR_KIND:String		= "clearKind";
		/** 解谜，使棋盘上棋子达到目标值（平均值为8，小于8就是要小于目标数，反则要大于目标数),即过关 */
		public static const 	KIND_GAME_PUZZLE_CLEAR_NUM:String		= "clearNum";
		/** 解谜，通过移动使得棋盘上某个区域填充某种颜色的棋子（如3颗一排、拐角、十字形状） */
		public static const 	KIND_GAME_PUZZLE_FIT_ELEMENTS:String	= "fit";
		/** 解谜，得到最高得分 */
		public static const 	KIND_GAME_PUZZLE_SCORE:String			= "score";
		/** 收集资源、收集到指定量即过关（某些物品游戏过程需要支持生成） */
		public static const 	KIND_GAME_COLLECT_RESOURCE:String		= "collect";
		/** PVE、跟电脑精灵对战 */
		public static const 	KIND_GAME_FIGHT_PVE:String				= "pve";
		/** PVE，使用特定的精灵进行战斗 */
		public static const 	KIND_GAME_FIGHT_PVE_GIVEN:String		= "pve_given";
		/** PVP，跟其他玩家对战，即时制 */
		public static const 	KIND_GAME_FIGHT_PVP_REAL_TIME:String	= "pvp_real_time";
		/** PVP，跟其他玩家对战，回合制 */
		public static const 	KIND_GAME_FIGHT_PVP_ROUND:String		= "pvp_round";
	}
}