package com.model.vo.config.guide{
	import com.model.vo.BaseObjectVO;
	
	
	/**
	 * 引导任务配置信息
	 * @author hunterxie
	 */
	public class GuideConfigVO extends BaseObjectVO{
		public var id:int = 0;
		
		/**
		 * 需要提示的点击类型
		 */
		public var kind:int = 0;
		/**
		 * 类型对应的ID，如引导选择提示ID
		 */
		public var kindID:int=0;
		
		/**
		 * 出现提示的次数，0表示不限制
		 */
		public var times:int = 0;
		
		/**
		 * 引导提示触发前提ID
		 */
		public var premise:int = 0;
		/**
		 * 引导触发前提对应的关卡等ID
		 */
		public var premiseID:int=0;
		/**
		 * 选择(引导触发对应的)ID
		 */
		public var premiseChoice:int=0;
		
		/**
		 * 提示动画位置
		 */
		public var point:Array;
		public var points:Array;
		
		/**
		 * 提示框显示文字内容
		 */
		public var info:String = "";
		
		/**
		 * 相关说明(策划用)
		 */
		public var notes:String = "";
		
		
		
		/**
		 * 
		 * @param info
		 */
		public function GuideConfigVO(info:Object=null):void{
			super(info);
			this.points = [];
			for(var i:int=0; i<point.length; i++){
				points.push(new GuideTipPoint(String(point[i])));
			}
		}
		
		/**
		 * 判断展示次数是否满足展示条件
		 * @param num
		 */
		public function judgeIsShow(num:int):Boolean{
			if(times==0){
				return true; 
			}
			return num<times;
		}
		
		
		
		
		//========展示类型===========================================================
		/**
		 * 空类型，居中
		 */
		public static const GUIDE_KIND_NULL:int = 0;
		/**
		 * 引导点击类型
		 */
		public static const GUIDE_KIND_CLICK:int = 1;
		/**
		 * 引导一个交换类型
		 */
		public static const GUIDE_KIND_CHANGE:int = 2;
		/**
		 * 引导一个询问类型
		 */
		public static const GUIDE_KIND_ASK:int = 3;
		/**
		 * 引导一个提示类型(如多个目标棋子高亮)
		 */
		public static const GUIDE_KIND_FOCUS:int = 4;
		/**
		 * 引导一个提示类型(如多个目标棋子高亮)
		 */
		public static const GUIDE_KIND_QUICK_CHANGE:int = 5;
		
		
		//========展示类型===========================================================
		private static var guideFremiseIncrease:int = 0;
		/**
		 * 点击关闭一个guide提示，可能引发下一个guide提示
		 */
		public static const GUIDE_PREMISE_KIND_0:int = guideFremiseIncrease++;
		/**
		 * 打开关卡面板，根据关卡ID判断guideVO
		 */
		public static const GUIDE_PREMISE_KIND_1:int = guideFremiseIncrease++;
		/**
		 * 闯关成功，根据关卡ID判断guideVO
		 */
		public static const GUIDE_PREMISE_KIND_2:int = guideFremiseIncrease++;
		/**
		 * 闯关失败，根据关卡ID判断guideVO
		 */
		public static const GUIDE_PREMISE_KIND_3:int = guideFremiseIncrease++;
		/**
		 * 获得五行盒子
		 */
		public static const GUIDE_PREMISE_KIND_4:int = guideFremiseIncrease++;
		/**
		 * 引导询问玩家选择
		 */
		public static const GUIDE_PREMISE_KIND_5:int = guideFremiseIncrease++;
		/**
		 * 打开五行面板
		 */
		public static const GUIDE_PREMISE_KIND_6:int = guideFremiseIncrease++;
		/**
		 * 首次打开自编面板
		 */
		public static const GUIDE_PREMISE_KIND_7:int = guideFremiseIncrease++;
		/**
		 * 失败后再次闯关时
		 */
		public static const GUIDE_PREMISE_KIND_8:int = guideFremiseIncrease++;
		/**
		 * 空类型，居中
		 */
		public static const GUIDE_PREMISE_KIND_9:int = guideFremiseIncrease++;
		/**
		 * 空类型，居中
		 */
		public static const GUIDE_PREMISE_KIND_10:int = guideFremiseIncrease++;
	}
}
	
	