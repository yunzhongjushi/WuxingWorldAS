package com.model.vo.fairy {
	import com.model.event.EventCenter;
	import com.model.vo.BaseObjectVO;
	import com.model.vo.config.fairy.FairyConfig;
	import com.model.vo.config.fairy.FairyConfigVO;
	import com.model.vo.config.lvs.LVCheckVO;
	import com.model.vo.config.lvs.LVsConfig;
	import com.model.vo.item.FairyEquipVO;
	import com.model.vo.skill.BaseSkillVO;
	import com.model.vo.skill.fight.BaseFairySkillVO;
	
	import flas.geom.Point;

	/**
	 * 基础精灵数据，用于展示/保存
	 * @author hunterxie
	 * 
	 */
	public class BaseFairyVO extends BaseObjectVO{
		public static const FAIRY_INFO_UPDATE:String = "FAIRY_INFO_UPDATE";
		/**
		 * 精灵属于人控制
		 */
		public static const FIGHT_ROLE_KIND_PERSON:int = 1;
		/**
		 * 精灵属于AI控制
		 */
		public static const FIGHT_ROLE_KIND_AI:int = 2;
		/**
		 * 精灵战斗类型——攻击型
		 */
		public static const FIGHT_KIND_AP:int = 0;
		/**
		 * 精灵战斗类型——防御型
		 */
		public static const FIGHT_KIND_DP:int = 1;
		/**
		 * 精灵战斗类型——生命型
		 */
		public static const FIGHT_KIND_HP:int = 2;
		/**
		 * 精灵战斗类型——辅助型
		 */
		public static const FIGHT_KIND_AID:int = 3;
		
		
		
		/**
		 * 精灵基础数据，保存的动态数据
		 */
		public function get baseInfo():FairySaveVO{
			return _baseInfo;
		}
		public function set baseInfo(value:FairySaveVO):void{
			_baseInfo = value;
//			this.ID = _baseInfo.ID;
			this.originID =_baseInfo.originID;
			this.starLV = _baseInfo.starLV;
			this.intensLV = _baseInfo.intensLV;
			this.LV = _baseInfo.LV;//先设LV再设经验，经验会改变等级
			this.EXP_cu = _baseInfo.EXP_cu;
			
			this.updateSkills(_baseInfo.skills);
			this.updateEquips(_baseInfo.equips);
			
			this.dispatchUpdate();
		}
		private var _baseInfo:FairySaveVO = new FairySaveVO();
		
		/**
		 * 战斗中控制的类型（1.玩家，2.电脑）
		 */
		public var roleKind:int = FIGHT_ROLE_KIND_PERSON;



		/**
		 * 
		 */
		public function get data():FairyConfigVO{
			return _data;
		}
		public function set data(value:FairyConfigVO):void{
			_data = value;
			if(!_data){
				trace("testtest");
			}
			wuxing = _data.getwuxing();
			if(value){
				this.HP_cu = value.HP;
				initSkill();
			}else{
				trace("错误的精灵信息！");
			}
		}
		private var _data:FairyConfigVO;
		
		public function get nickName():String{
			return data.label;
		}
		
		/**
		 * 战斗类别（攻击，防御，生命，辅助）
		 */
//		public var fightkind:int;
		
		/**
		 * 用户ID,0代表电脑AI
		 */
		public var userID:int = 0;
		
		/**
		 * 精灵ID
		 */
		public function get ID():int{
			return baseInfo.ID;
		}
		public function set ID(value:int):void{
			baseInfo.ID = value;
		}
		private var _ID:int;
		

		/**
		 * 精灵五行
		 * @return 
		 */
//		public function get wuxing():String{
//			return this.wuxingInfo.myWuxing;
//		}
		
		/**
		 * 精灵原始ID
		 */
		public function get originID():int{
			return baseInfo.originID;
		}
		public function set originID(value:int):void{
			baseInfo.originID = value;
			data = FairyConfig.getFairyConfigByID(value);
		}
		
		/**
		 * 五行数据
		 */
		public var wuxing:int;
		
		/**
		 * 等级
		 */
		public function get LV():int{
			return _LV;
		}
		public function set LV(value:int):void{
			_LV = baseInfo.LV = value;
			for(var i:int=0; i<this.baseSkillArr.length; i++){
				var skill:BaseFairySkillVO = baseSkillArr[i];
				//TODO:精灵技能等级限制，每10级开启一个技能
//				var skillLV:int = this.LV/10>=i ? 1 : 0;
//				if(skillLV>0 && skill.LV==0){
//					upgradeSkillLV(i, skillLV);
//				}
				skill.maxUpLV = value;
			}
			updateBaseValue();
		}
		protected var _LV:int = 1;
		
		
		/**
		 * 星级
		 */
		public function get starLV():int{
			return baseInfo.starLV;
		}
		public function set starLV(value:int):void{
			baseInfo.starLV = value;
			updateBaseValue();
		}
		
		/**
		 * 根据公式更新最新AP、DP、HP
		 */
		private function updateBaseValue():void{
			this.AP = calculateFairyBaseValue(data.AP, data.APinc1, data.APinc2, starLV, intensValue);
//			trace("AP:", AP, starLV, intensLV, intensValue)
			this.DP = calculateFairyBaseValue(data.DP, data.DPinc1, data.DPinc2, starLV, intensValue);
//			trace("DP:", DP, starLV, intensLV, intensValue)
			this.HP_cu = this.HP_max = calculateFairyBaseValue(data.HP, data.HPinc1, data.HPinc2, starLV, intensValue);
//			trace("HP:", HP_max, starLV, intensLV, intensValue)
			dispatchUpdate();
		}
		
		/**
		 * 强化等级,通过装备升级上去的
		 */
		public function get intensLV():int{
			return baseInfo.intensLV;
		}
		public function set intensLV(value:int):void{
			baseInfo.intensLV = value;
			intensValue = FairyConfig.getFairyIntensLV(value);
			updateBaseValue();
		}
		/**
		 * 根据强化等级计算得出的强化倍率
		 */
		private var intensValue:Number = 1;
		
		/**
		 * 基础技能数组
		 * @see com.model.vo.skill.BoardSkillVO
		 */
		public var baseSkillArr:Array = [];
		
		/**
		 * 前端模拟的精灵装备vo列表
		 * @see com.model.vo.item.FairyEquipVO
		 */
		public var equipArray:Array = [];
		
		
//		public var expKind:int;
		
		public function get needTotalExp():int{
			return EXP_max-EXP_last;//BaseInfo.getExpLvInfo(this.LV, expKindStr);
		}
		public function get needExp():int{ 
			return EXP_max-EXP_cu;
		}
		
		/**
		 * 最高经验（升级所需经验）
		 */
		public function get EXP_max():int{
			return _EXP_max;
		}
		public function set EXP_max(value:int):void{
			_EXP_max = value;
		}
		protected var _EXP_max:int;
		
		/**
		 * 经验
		 */
		public function get EXP_cu():int{
			return baseInfo.EXP_cu;
		}
		public function set EXP_cu(value:int):void{
			var vo:LVCheckVO = LVsConfig.checkLvInfo(value, expKindStr);
			baseInfo.EXP_cu = vo.cu;
			this.LV = vo.LV;
			this.EXP_last = vo.last;
			this.EXP_max = vo.max;
		}
		/**
		 * 上一级目标经验值
		 */
		public var EXP_last:int;
			
		
		public var expKindStr:String = "fairyExp0";
		
		
		
		/**
		 * 精灵碎片ID
		 */
//		public var mergeID:int;
		
		/**
		 * 可进阶ID
		 */
//		public var evoID:int;
		
		/**
		 * 进阶加成系数
		 */
//		public var evonum:Number;
		
		/**
		 * 精灵经验倍率
		 */
		public var expkind:Number;
		
		/**
		 * 精灵所在的全局坐标，用于动画展示
		 */
		public var globalPoint:Point;
		
		
		/**
		 * 当前生命
		 */
		public function get HP_cu():int{
			return _HP_cu;
		}
		public function set HP_cu(value:int):void{ 
			//			if(isAlive){//死亡后不能进行操作
			_HP_cu = value<0 ? 0 : value;
			if(_HP_cu>HP_max) _HP_cu = HP_max;
			
//			dispatchUpdate(); 
			//			}
		} 
		private var _HP_cu:int;
		/**
		 * 最大生命
		 */
		public function get HP_max():int{
			return Math.ceil((_HP_max+HP_max_add)*HP_max_per);
		}
		public function set HP_max(value:int):void{
			_HP_max = value;
		}
		private var _HP_max:int = 0;
		
//		protected var baseHP_max:Number;
		public function get HP_max_add():int{
			return _HP_max_add;
		}
		public function set HP_max_add(value:int):void{
			_HP_max_add = value;
			if(this.HP_cu>this.HP_max) this.HP_cu=this.HP_max;
			dispatchUpdate();
		}
		private var _HP_max_add:int;
		public var HP_max_per:Number = 1;
		/**
		 * 初始化关卡精灵生命上限百分比
		 */
		public var HP_max_first:Number = 1;
		/**
		 * HP成长系数1
		 */
//		public var HPinc1:Number;
		/**
		 * HP成长系数2
		 */
//		public var HPinc2:Number;
		
		
		/**
		 * 五行对应的攻击力
		 */
//		public function getWuxingAP(kind:String):int{
//			return this.wuxingInfo.getWuxingProperty(kind);
//		}
		/**
		 * 计算出来的最终AP
		 * @param kind
		 * @return 
		 */
		public function getFinalWuxingAP(kind:String):int{
			return Math.ceil((AP+AP_add)*AP_per);
//			return Math.ceil((getWuxingAP(kind)+AP_add)*AP_per);
		}
//		private var baseAP:Number = 0;
		protected var AP:int = 0;
		/**
		 * 攻击成长系数1
		 */
//		private var APinc1:Number;
		/**
		 * 攻击成长系数2
		 */
//		private var APinc2:Number;
		/**
		 * 攻击力增加量，通过Buff、被动加成
		 */
		public var AP_add:int = 0;
		/**
		 * 攻击力降低百分比，乘法合并
		 */
		public var AP_per:Number = 1;
		
		public function get finalAP():int{
			return Math.ceil((this.AP+AP_add)*AP_per);
		}
		
		/**
		 * 防御力
		 */
//		private var baseDP:Number = 0;
		protected var DP:int = 0;
		/**
		 * 防御成长系数1
		 */
//		private var DPinc1:Number;
		/**
		 * 防御成长系数2
		 */
//		private var DPinc2:Number;
		/**
		 * 防御力增加量，通过Buff、被动加成
		 */
		public var DP_add:int = 0;
		/**
		 * 防御力降低百分比，乘法合并
		 */
		public var DP_per:Number = 1;
		/**
		 * 计算出来的最终DP
		 * @return 
		 */
		public function get finalDP():int{
			return Math.ceil((DP+DP_add)*DP_per);
		}
		
		
		/**
		 * 暴击率critical
		 */
		public var CRI:Number = 0.05;
		/**
		 * 暴击率增量
		 */
		public var CRI_add:Number = 0.05;
		/**
		 * 暴击率增量百分比
		 */
		public var CRI_per:Number = 0.05;
		/**
		 * 计算出来的最终暴击率
		 */
		public function getFinalCRI():Number{
			return (CRI+CRI_add)*CRI_per;
		}
		
//		/**
//		 * 五行防御增量
//		 */
//		public var DP_add:int = 0;
//		/**
//		 * 五行防御增量百分比
//		 */
//		public var DP_per:int = 1;
		
		/**
		 * 五行防御
		 * @param wuxing
		 * @return
		 */
//		public function getWuxingDP(wuxing:*):int{
//			return this.wuxingInfo.getResource(WuxingVO.getWuxing(wuxing, WuxingVO.KE_WO))+5;//+this.LV
//		}
		/**
		 * 计算出的最终五行防御
		 * @param wuxing
		 * @return 
		 */
		public function getFinalWuxingDP(wuxing:int):int{
			return Math.ceil((DP+DP_add)*DP_per);
//			return Math.ceil((getWuxingDP(wuxing)+DP_wuxing_add[wuxing])*DP_wuxing_per[wuxing]);
		}
		/**
		 * 速度
		 */
		public var SP:int;
		public var SP_add:int;
		/**
		 * 针对五行减伤
		 */
		public var reduceArr:Array = [0,0,0,0,0];
		public var reduceArr_add:Array = [0,0,0,0,0];
		public var reduceArr_per:Array = [1,1,1,1,1];
		/**
		 * 针对五行减伤百分比
		 */
		public var reducePerArr:Array = [0,0,0,0,0];
		public var reducePerArr_add:Array = [0,0,0,0,0];
		public var reducePerArr_per:Array = [1,1,1,1,1];
		
		
		
		/**
		 * 基础精灵信息
		 * @param id
		 * @param originID
		 * @param lv		等级
		 * @param userID	角色ID
		 * @param starLV	星级
		 * @param intensLV	强化等级
		 */
		public function BaseFairyVO(id:int, originID:int, lv:int=1, userID:int=0, starLV:int=0, intensLV:int=0, hpPer:Number=1):void{
			this.ID = id;
			this.userID = userID;
			this.originID =originID;
			this.EXP_cu = 0;
			this.LV = lv;
			this.starLV = starLV;
			this.intensLV = intensLV;
			this.HP_max_per = this.HP_max_first = hpPer;
			
//			this.wuxingInfo.on(WuxingVO.WUXING_RESOURCE_UPDATE, updateResource);
		}
		
		/**
		 * 设精灵目标强化等级：X,精灵等级为：lv,精灵某条基础属性值：A，成长系数1：K1，成长系数2：K2
		 * 强化后对应属性值=((lv-1)*(A*K2)+A*(K1^(LV-1)))*(1+5%*X)+A*20%*X 最后结果向上取整;
		 * 等于是原属性每强化一次提升5%，并且额外增加基础数值（1级初始属性的10倍）的20%的属性
		 * 最终计算出来的值再乘以I(进阶等级带来的属性提升倍率)
		 * @param A
		 * @param K1
		 * @param K2
		 * @param X
		 * @param I
		 * @return 
		 */
		private function calculateFairyBaseValue(A:Number, K1:Number, K2:Number, X:Number, I:Number):int{
//			trace("Math.ceil(((LV-1)*(A*K2)+A*(Math.pow(K1,(LV-1)))*(1+0.05*X)+A*X*0.2)*I)")
//			EventCenter.traceInfo("A:"+A+"\n"+"K1:"+K1+"\n"+"K2:"+K2+"\n"+"强化等级X:"+X+"\n"+"进阶系数I:"+I)
//			EventCenter.traceInfo("(LV-1)*(A*K2):"+(LV-1)*(A*K2))
//			EventCenter.traceInfo("A*(Math.pow(K1,(LV-1))):"+A*(Math.pow(K1,(LV-1))))
//			EventCenter.traceInfo("A*(Math.pow(K1,(LV-1)))*(1+0.05*X):"+A*(Math.pow(K1,(LV-1)))*(1+0.05*X))
//			EventCenter.traceInfo("((LV-1)*(A*K2)+A*(Math.pow(K1,(LV-1)))*(1+0.05*X)+A*X*0.2):"+((LV-1)*(A*K2)+A*(Math.pow(K1,(LV-1)))*(1+0.05*X)+A*X*0.2))
//			trace(A, K1, K2, X, i, (LV-1)*(A*K2), A*(Math.pow(K1,(LV-1))), (1+0.05*X), A*X*0.2);
//			trace(A*(Math.pow(K1,(LV-1)))*(1+0.05*X))
			var value:int = Math.ceil((((LV-1)*(A*K2)+A*Math.pow(K1,(LV-1)))*(1+0.05*X)+A*X*0.2)*I);
			return value;
		}
		
		public function dispatchUpdate():void{
			event(FAIRY_INFO_UPDATE);
		}
		
		/**
		 * 
		 * @param pet
		 * @return 
		 */
		public function updateInfoByServer(pet:Object):BaseFairyVO{
			this.baseInfo = baseInfo.updateByServer(pet);
			
			return this;
		}
		
		protected function initSkill():void{
			this.baseSkillArr = [];
			for(var i:int=0; i<data.skills.length; i++){
				baseSkillArr.push(new BaseFairySkillVO(data.skills[i], 1, this));
				baseInfo.skills[i] = 1;
			}
		}
		
		/**
		 * 更新技能信息
		 * @param info
		 */
		public function updateSkills(info:Array):void{
			for (var j:int=0; j<info.length; j++){
				upgradeSkillLV(j, info[j]);
			}
		}
		
		/**
		 * 更新装备信息
		 * @param info
		 */
		public function updateEquips(info:Array):void{
			baseInfo.equips = info;
			for (var j:int=0; j<info.length; j++){
				var equipID:int = info[j];
//					(equipArray[j] as EquipFairyVO).LV = isEquip;//强化等级
				if(equipID>0){
					equipChange(new FairyEquipVO(equipID,0,0));
				}else{
					equipArray[j] = null;
					baseInfo.equips[j] = 0;
				}
			}
		}
		
		public function equipChange(vo:FairyEquipVO):void{
			equipArray[vo.data.equipInfo.position] = vo;
			
			this.AP_add += vo.data.equipInfo.addAP;
			this.DP_add += vo.data.equipInfo.addDP;
			this.HP_max_add += vo.data.equipInfo.addHP;
			
			baseInfo.equips[vo.data.equipInfo.position] = vo.templateID;
			dispatchUpdate();
		}
		
		public function upgradeIntensLV():void{
			intensLV ++;
			
			equipArray = [];
			while(baseInfo.equips.length) baseInfo.equips.pop();
			this.AP_add = 0;
			this.DP_add = 0;
			this.HP_max_add = 0;
			
			dispatchUpdate();
		}
		
		public function upgradeSkillLV(index:int, lv:int):void{
			var skill:BaseSkillVO = baseSkillArr[index] as BaseSkillVO;
//			var skillLV:int = this.LV/10>=index ? 1 : 0;
			if(skill && lv<=skill.maxUpLV){//skillLV>0 && 
				skill.LV = lv;
				baseInfo.skills[index] = lv;
				dispatchUpdate();
			}
		}
		
		public function testAddExp(value:int):void{
			this.EXP_cu += value;
			dispatchUpdate();
		}
	}
}
