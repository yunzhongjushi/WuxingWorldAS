package com.model.vo.task {
	import com.model.vo.BaseObjectVO;

	/**
	 * 
	 * @author hunterxie
	 * 
	 */
	public class TaskStoreVO extends BaseObjectVO{
//		public static function genEmpty(questID:int):AchStoreVO {
//			var xmllist:XMLList=BaseInfo.getQuestConditionByID(questID);
//			var obj:Object={questID:questID, isComplete:false, condition1:0, condition2:0, condition3:0, condition4:0, condition5:0};
//			for each(var conditionXMl:XML in xmllist) {
//				obj["condition"+(int(conditionXMl.@ConditionIndex)+1)]=int(conditionXMl.@Para2);
//			}
//			return new AchStoreVO(obj);
//		}

		public var questID:int;
		public var isComplete:Boolean;
		public var condition1:int;
		public var condition2:int;
		public var condition3:int;
		public var condition4:int;
		public var condition5:int;

		public function TaskStoreVO(info:Object=null):void {
			super(info);
		}

		public function setCondition(conditionIndex:int, change:int):void {
			var conditionNum:int=this["condition"+(conditionIndex+1)];

			// 因为condition的初始值为所需达到的目标数，每次完成一部分，是从condition减去对应的值，减至0为完成
			this["condition"+(conditionIndex+1)]=Math.max(0, conditionNum-change);
		}

		public function getServerPack():Array {
			var arr:Array=[];

			arr[0]=questID;
			arr[1]=isComplete?"1":"0";
			arr[2]=condition1
			arr[3]=condition2
			arr[4]=condition3
			arr[5]=condition4
			arr[6]=condition5

			return arr;
		}
	}
}
