package com.model.vo.skill {
	import com.model.logic.BaseGameLogic;
	import com.model.vo.WuxingVO;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.chessBoard.ResourceVO;
	import com.model.vo.user.ChessboardUserVO;
	
	
	/**
	 * 棋盘/角色技能，只对棋盘生效
	 * @author hunterxie
	 */
	public class BoardSkillVO extends BaseSkillVO{
		/**
		 * 棋子buff高亮显示
		 */
		public static const BOARD_ICON_KIND_LIGHT:String = "b亮"
		/**
		 * 棋子buff漩涡
		 */
		public static const BOARD_ICON_KIND_VORTEX:String = "b漩"
		/**
		 * 当前通过棋盘消除得到的资源量;
		 * 临时记录，用于获得资源时技能的触发
		 */
		public function get nowClearResource():ResourceVO{
			return BaseGameLogic.nowClearResource;
		}
		
		/**
		 * 技能所属棋子
		 */
		public var tarPoint:QiuPoint;
		/**
		 * 设置技能所属棋子
		 * @param point
		 */
		public function setQiuPoint(point:QiuPoint):void{
			this.tarPoint = point;
			if(point){
				this.equipKind = EQUIP_KIND_2;
			}
			for(var i:int=0; i<effectArr.length; i++){
				(effectArr[i] as BoardSkillEffectVO).setQiuPoint(point);
			}
		}
		
		
		
		/**
		 * 技能实现的效果
		 <effect effectKind="0" id="0" kind="-2" target="2" referTarget="1" refer="16" referKind="-2" value="0" value2="0" percent="1" percent2="1" chance="1">
			<trigger who="0" id="13" kind="-2" judge="0" value="0" percent="0" target="0" refer="0" referKind="-1" target2="0" refer2="0" referKind2="-1"/>
		</effect>
		 * @see com.model.vo.skill.BoardSkillEffectVO
		 */
		public var effectArr:Array = [];
		
//		/**
//		 * 技能五行消耗
//		 * <cost 金="0" 木="0" 土="0" 水="10" 火="0"/>
//		 */
//		public var wuxingCost:Array=[];
		
		
		private var _myUser:ChessboardUserVO;
		public function get myUser():ChessboardUserVO{
			return _myUser==null ? BaseGameLogic.bakeUserInfo : _myUser;
		}
		public function set myUser(user:ChessboardUserVO):void{
			this._myUser = user;
		}
//		public static function getBuffByConfig(info:String):BoardSkillVO{
//			
//		}
		
		
		
		
		/**
		 * 角色/棋盘技能
		 * @param id
		 * @param lv
		 * @param user 拥有此棋盘技能的user
		 */
		public function BoardSkillVO(id:int=0, lv:int=1, user:ChessboardUserVO=null):void {
			super(id, lv);
			this.myUser = user;
//			if(!user) this.myUser = BaseGameLogic.bakeUserInfo; 
		}
		
		override protected function init():void{			
//			this.wuxingCost = [int(data.cost.@金), int(data.cost.@木), int(data.cost.@土), int(data.cost.@水), int(data.cost.@火)];
//			for(var i:int=0; i<data.effect.length(); i++){
//				effectArr.push(new BoardSkillEffectVO(data.effect[i], this));
//			}
			effectArr = [];
			for(var i:int=0; i<data.effects.length; i++){
				effectArr.push(new BoardSkillEffectVO(data.effects[i], this));
			}
		}
		
		/**
		 * 对棋盘前提事件进行侦听,触发被动技能；<br>
		 * PK中调用不到！！！<br>
		 * 棋盘事件都会携带对应的qiupoint；<br>
		 * @param user		触发者
		 * @param triggerID	前提ID
		 * @param vo		消除事件，所有棋盘技能都是由消除事件或者回合事件触发的
		 * @param index		调用从第x个效果开始
		 */
		public function onBoardTrigger(user:ChessboardUserVO, triggerID:int, index:int=0):void{
			for(var i:int=index; i<this.effectArr.length; i++){
				var effect:BoardSkillEffectVO = this.effectArr[i]; 
				if(effect.trigger.data.id==triggerID && (effect.trigger.data.kind==QiuPoint.KIND_100 || BaseGameLogic.getKindString(effect.trigger.data.kind)==nowClearResource.kind)){
					if(effect.getBoardTrigger(user)){
						if(nowClearResource) effect.triggerPoint = nowClearResource.point;
//						myUser.onSkillEffect(effect);
						myUser.event(ChessboardUserVO.BOARD_SKILL_USE_SUCCESS, effect);
						if(i==0) onBoardTrigger(user, SkillTriggerVO.TRIGGER_KIND_24, 1);
					} 
				}
			}
		}
		
		/**
		 * 判断资源是否达到技能使用条件
		 * @param info
		 * @return 
		 */
		public function resourceFulfilJudge(info:WuxingVO):Boolean{
			return info.resourceArr.every(function(item:int, index:int, arr:Array):Boolean{return arr[index]<=item});
		}

		
		/**
		 * 判断是否属于模块激活技能ID
		 * @param id
		 * @return 
		 */
		public function get isSkillModeActive():Boolean{
			return judgeSkillModeActive(this.ID);
		}
		
		public static function judgeSkillModeActive(id:int):Boolean{
			return (id==CHESS_SKILL_MODE_JIN || id==CHESS_SKILL_MODE_MU || id==CHESS_SKILL_MODE_TU || id==CHESS_SKILL_MODE_SHUI || id==CHESS_SKILL_MODE_HUO)
		}
		
		
		//===棋盘棋子技能=============================================
		private static var skillIncrease:int = 0;
		/**
		 * 技能类型：消除——无特效
		 */
		public static const CHESS_SKILL_KIND_0:int=0;
		/**
		 * 技能类型：消除——连锁闪电
		 */
		public static const CHESS_SKILL_KIND_1:int=1;
		/**
		 * 技能类型：消除——炸弹
		 */
		public static const CHESS_SKILL_KIND_2:int=2;
		/**
		 * 技能类型：消除——直排闪电
		 */
		public static const CHESS_SKILL_KIND_3:int=3;
		/**
		 * 技能类型：创建新棋子
		 */
		public static const CHESS_SKILL_KIND_4:int=4;
		/**
		 * 技能类型：生成BUFF
		 */
		public static const CHESS_SKILL_KIND_5:int=5;
		/**
		 * 技能类型：生成BUFF,锁定，不能移动
		 */
		public static const CHESS_SKILL_KIND_6:int=6;
		/**
		 * 技能类型：生成BUFF,冰冻，不能移动
		 */
		public static const CHESS_SKILL_KIND_7:int=7; 
		/**
		 * 技能类型：变色
		 */
		public static const CHESS_SKILL_KIND_8:int=8;
		/**
		 * 棋盘目标：金模块激活
		 */
		public static const CHESS_SKILL_MODE_JIN:int=50;
		/**
		 * 棋盘目标：木模块激活
		 */
		public static const CHESS_SKILL_MODE_MU:int=51;
		/**
		 * 棋盘目标：土模块激活
		 */
		public static const CHESS_SKILL_MODE_TU:int=52;
		/**
		 * 棋盘目标：水模块激活
		 */
		public static const CHESS_SKILL_MODE_SHUI:int=53;
		/**
		 * 棋盘目标：火模块激活
		 */
		public static const CHESS_SKILL_MODE_HUO:int=54;
		
	}
}