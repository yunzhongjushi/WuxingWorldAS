package com.model.vo.skill.fight {
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.skill.BaseSkillVO;
	import com.utils.Formula;
	
	
	/**
	 * 基础技能数据结构，精灵技能；
	 * 专用于得出相关技能描述
	 * @author hunterxie
	 */
	public class BaseFairySkillVO extends BaseSkillVO{
		
		/**
		 * 
		 */
		public var myFairy:BaseFairyVO;
		
		/**
		 * 技能按公式得出的描述；
		 * 金2连消时，对敌方一个精灵造成一次{120+2.4*lv@0}威力值的伤害；
		 * {}表示需要计算后显示的公式；
		 * lv表示技能等级；
		 * hp表示精灵生命；
		 * ap表示精灵攻击力；
		 * dp表示精灵防御；
		 * @1 表示取几位小数
		 * @return 
		 */
		override public function get describe():String{
//			var str:String = "表示取几位小数{(ap+1.5*dp)%lv+hp@1}表示取几位小数";
			
			if(_describe.indexOf("{")!=-1) {
				var arr:Array = _describe.slice(_describe.indexOf("{")+1, _describe.indexOf("}")).split("@");
				var str1:String =arr[0];
				var value:int = Math.pow(10, parseInt(arr[1]));
//				trace(arr[0], arr[1]);
				var str2:String = str1.replace(/ap/g, this.myFairy.finalAP).replace(/dp/g, this.myFairy.finalDP).replace(/hp/g, this.myFairy.HP_max).replace(/lv/g, LV)
//				trace(str2);
				var str3:Number = Math.floor(Formula.calculateStr(str2)*value)/value;
//				trace(str3);
				return (_describe.replace(_describe.slice(_describe.indexOf("{"), _describe.indexOf("}")+1), str3));
			}
			
			return _describe;
		}
		
		public function get nextLVDescribe():String{
			if(_describe.indexOf("{")!=-1) {
				var arr:Array = _describe.slice(_describe.indexOf("{")+1, _describe.indexOf("}")).split("@");
				var str1:String =arr[0];
				var value:int = Math.pow(10, parseInt(arr[1]));
				//				trace(arr[0], arr[1]);
				var str2:String = str1.replace(/ap/g, this.myFairy.finalAP).replace(/dp/g, this.myFairy.finalDP).replace(/hp/g, this.myFairy.HP_max).replace(/lv/g, LV+1)
				//				trace(str2);
				var str3:Number = Math.floor(Formula.calculateStr(str2)*value)/value;
				//				trace(str3);
				return (_describe.replace(_describe.slice(_describe.indexOf("{"), _describe.indexOf("}")+1), str3));
			}
			
			return _describe;
		}
		
		/**
		 * 精灵技能
		 * @param id
		 * @param lv
		 */
		public function BaseFairySkillVO(id:int, lv:int, fairy:BaseFairyVO):void {
			super(id, lv);
			
			myFairy = fairy;
		}
	}
}