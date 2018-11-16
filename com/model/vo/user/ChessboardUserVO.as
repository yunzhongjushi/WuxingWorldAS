package com.model.vo.user{
	import com.model.event.EventCenter;
	import com.model.logic.BaseGameLogic;
	import com.model.logic.ChessBoardLogic;
	import com.model.vo.WuxingVO;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.chessBoard.ResourceVO;
	import com.model.vo.skill.BaseSkillVO;
	import com.model.vo.skill.BoardSkillVO;
	import com.model.vo.skill.SkillListVO;
	import com.model.vo.skill.SkillTriggerVO;
	
	import flas.events.EventDispatcher;
	
	
	
	/**
	 * 棋盘当前行动角色信息，其中包括角色的技能
	 * @author hunterxie
	 */	
	public class ChessboardUserVO extends EventDispatcher{
		/**
		 * 棋盘技能使用/触发成功
		 * @see com.model.vo.skill.BoardSkillEffectVO
		 */
		public static var BOARD_SKILL_USE_SUCCESS:String = "BOARD_SKILL_USE_SUCCESS";
		
		
		public var userID:int;
		
		public var LV:int=0;
		
		/**
		 * 角色五行资源信息
		 */
		public var wuxingInfo:WuxingVO = new WuxingVO();
		
		/**
		 * 角色能量值，用于施放技能
		 */
		public var skillEnergy:int = 100;
		/**
		 * 获取玩家五行等级
		 * @return 
		 */
		public function getWuxingLV(wuxing:*):int{
			return wuxingInfo.getWuxingProperty(wuxing);
		}
		
		public function get wuxing():int{
			return wuxingInfo.myWuxing;
		}
		
		/**
		 * 棋盘技能列表，通过消除等棋盘交互行为触发
		 * @see SkillVO
		 */
		public var boardSkills:Array = [];
		
		/**
		 * 经验增加百分比
		 */
		public var EXP_per:Number=0;
		
		/**
		 * 消除得分增量
		 */
		private var kindScoreAdd:Object = {};
		public function setKindScoreAdd(kind:int, value:int):void{
			if(kindScoreAdd[kind]==undefined) kindScoreAdd[kind]=0;
			kindScoreAdd[kind] += value;
//			if(kindScoreAdd.hasOwnProperty(kind)){
//				kindScoreAdd[kind] += value;
//			}
		}
		public function getKindScoreAdd(kind:int):int{
			if(kindScoreAdd.hasOwnProperty(kind)){
				return kindScoreAdd[kind];
			}
			return 0
		}
		
		/**
		 * 消除得分增量百分比
		 */
		private var kindScoreAdd_per:Object = {};
		public function setKindScoreAddPer(kind:int, value:Number):void{
			if(kindScoreAdd[kind]==undefined) kindScoreAdd_per[kind]=1;
			kindScoreAdd_per[kind] += value;
//			if(kindScoreAdd_per.hasOwnProperty(kind)){
//				kindScoreAdd_per[kind] *= value;
//			}
		}
		public function getKindScoreAddPer(kind:int):Number{
			if(kindScoreAdd_per.hasOwnProperty(kind)){
				return kindScoreAdd_per[kind];
			}
			return 1;
		}
		
		/**
		 * 当前通过棋盘消除得到的资源量;
		 * 临时记录，用于获得资源时技能的触发
		 */
		private function get nowClearResource():ResourceVO{
			return BaseGameLogic.nowClearResource;
		}
		
		/**
		 * 记录的资源收集情况
		 */
		public var resourceCollect:Object={};
		
		/**
		 * 记录的球收集情况（个数）
		 */
		public var qiuCollect:Object={};
		
		/**
		 * 当前游戏积累的总积分
		 */
		public var totalScore:int;
		
		/**
		 * 当前消耗的资源五行
		 */
		public var nowCostWuxing:int;
		/**
		 * 当前消耗的五行资源量
		 */
		public var nowCostWuxingNum:int;
		
		
		
		/**
		 * 连色消：上次移动且消除的棋子类型数组；
		 * 可以用来统计闯关信息；
		 */
		public var exchangeActives:Array = [];
		/**
		 * 设置连色消
		 * @param kind
		 */
		public function setExchangeActive(kind:int):int{
			//			exchangeActives.push(kind);
			exchangeActives.unshift(kind);
			return kind;
		}
		/**
		 * 当前记录交换的消除kind
		 * @return 
		 */
		public function get exchangeActive():int{
			if(exchangeActives.length==0){
				return QiuPoint.KIND_NULL;
			}
			return exchangeActives[0];
		}
		
		/**
		 * 获取当前移动数(开局到现在的移动次数)
		 * @return 
		 */
		public function getExchangeNum():uint{
			return exchangeActives.length;
		}
		
		
		
		/**
		 * ============================================================================
		 * 
		 * 
		 * 
		 * 
		 * ============================================================================
		 */
		public function ChessboardUserVO() {
			
		}
		
		/**
		 * 
		 * @param userID
		 * @param lv
		 * @param wuxing
		 * @param boardSkill
		 */
		public function initBase(userID:int, lv:int, wuxing:Array, boardSkill:Array):void{
			this.EXP_per = 0;
			this.userID = userID;
			this.LV = lv;
			
			for(var i:int=0; i<5; i++){
				this.wuxingInfo.setProperty(i, wuxing[i]);
			}
			this.updateSkills(boardSkill);
		}
		
		/**
		 * 角色技能触发点，前提是否触发某个角色技能；
		 * 角色技能只针对自己棋盘生效，只触发自己棋盘的事件；
		 * @param triggerID
		 */
		public function boardSkillTrigger(triggerID:int):void{
			for(var i:int=0; i<boardSkills.length; i++){
				var skill:BoardSkillVO = (boardSkills[i] as BoardSkillVO);
//				trace("判断角色技能：", skill.name);
				if(skill.data.useKind==BaseSkillVO.USE_KIND_PASSIVE){
					skill.onBoardTrigger(this, triggerID);
				}else{
					EventCenter.traceInfo("棋盘技能应该是被动技能！！");
					throw Error("棋盘技能应该是被动技能！！");
				}
			}
		}
		
		/**
		 * 棋盘消除—增加资源，此过程只做增加资源时的触发
		 * @param vo		消除数据
		 */
		public function addClearResource(vo:ResourceVO):void{
			boardSkillTrigger(SkillTriggerVO.TRIGGER_KIND_14);
			vo.addNum();
			
			if (!resourceCollect[vo.kind]) {
				resourceCollect[vo.kind] = 0;
				qiuCollect[vo.kind] = 0;
			}
			resourceCollect[vo.kind] += vo.num;
			qiuCollect[vo.kind] += vo.clearNum;
			totalScore += vo.num;
		}
		
		/**
		 * 更新玩家选择的角色技能
		 * @param arr
		 * @param istest	是否测试（不需要自己拥有技能）
		 */
		public function updateSkills(arr:Array, istest:Boolean=false):void{
			boardSkills = [];
			var skill:BoardSkillVO;
			for(var i:int=0; i<arr.length; i++){
				var obj:Object = arr[i];
				if(obj is int){
					if(istest){
						skill = new BoardSkillVO(obj as int, 1, this);
						trace("______________角色技：", skill.data.label)
						boardSkills.push(skill);
						continue;
					}
					var skillLV:int = SkillListVO.getSkillLV(obj as int);
					if(skillLV>0){
						skill = new BoardSkillVO(obj as int, skillLV, this);
//						if(skill.equipKind == BaseSkillVO.EQUIP_KIND_0){
							boardSkills.push(skill);
//						}else{
//							throw Error("玩家棋盘技能配置错误：精灵技能，技能装备位置不是玩家!!!");
//						}
					}else{
//						throw Error("玩家棋盘技能更新失败，原因：技能等级为0!!!");
					}
				}else if(obj && obj.skillId && obj.skillLv){
					skill = new BoardSkillVO(obj.skillId, obj.skillLv);
//					if(skill.equipKind == BaseSkillVO.EQUIP_KIND_0){
						boardSkills.push(skill);
//					}else{
//						throw Error("玩家棋盘技能配置错误：精灵技能，技能装备位置不是玩家!!!");
//					}
				}else{
//					throw Error("玩家棋盘技能更新失败，原因：后台传的技能问题!!!");
				}
			}
			trace("角色技能数量：",boardSkills.length);
		}
		
		/**
		 * 获得参照信息
		 * @param refer
		 * @param kind
		 * @return 
		 */
		public function getRefer(refer:int, wuxing:int):int{
			var num:int = 0;
			switch(refer){
				case BaseSkillVO.REFER_KIND_0://TODO:只有一份棋盘，所以获取的棋子数都是自己的。对方棋盘情况未做
					num = ChessBoardLogic.getInstance().getTarBallNum(wuxing);
					break;
				case BaseSkillVO.REFER_KIND_1:
					num = ChessBoardLogic.getInstance().maxKinds;
					break;
				case BaseSkillVO.REFER_KIND_15:
					num = this.nowClearResource.num;
					break;
				case BaseSkillVO.REFER_KIND_16:
					num = this.nowClearResource.kind;
					break;
				case BaseSkillVO.REFER_KIND_19:
					num = this.nowClearResource.clearNum;
					break;
				case BaseSkillVO.REFER_KIND_20:
					num = this.nowClearResource.sequenceNum;
					break;
				case BaseSkillVO.REFER_KIND_21:
					num = this.nowClearResource.exchangeSameNum;
//					if(num==2){//调试用
//						trace("!");
//					}
					break;
				case BaseSkillVO.REFER_KIND_26:
					num = ChessBoardLogic.getInstance().getBoardBuffNum(wuxing);
					break;
				case BaseSkillVO.REFER_KIND_29:
					num = wuxingInfo.getWuxingProperty(wuxing);
					break;
				case BaseSkillVO.REFER_KIND_30:
					num = BaseGameLogic.nowTurnAction.getKindScore(wuxing);
					break;
				default:
					throw Error("角色技能参照数据获取错误——不属于角色/棋盘信息——"+refer);
					break;
			}
			
			return num;
		}
		
		/**
		 * 获取连色消数量
		 * @param kind	当前clear棋子类型，如果这个类型跟记录的类型不一样就返回0
		 * @return 
		 */
		public function getExchangeActiveNum(kind:int):int{
			if(exchangeActives.length==0 || kind!=exchangeActive){
				return 0;
			}
			
			var num:int=1;
			var kind:int = exchangeActives[0];
			for(var i:int=1; i<exchangeActives.length; i++){
				if(exchangeActives[i]==kind){
					num++;
				}else{
					break;
				}
			}
			return num;
		}
	}
}
