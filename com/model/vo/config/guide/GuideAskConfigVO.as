package com.model.vo.config.guide{
	import com.model.vo.BaseObjectVO;
	
	
	/**
	 * 购买(时间/资源)配置信息
	 * @author hunterxie
	 */
	public class GuideAskConfigVO extends BaseObjectVO{
		public var id:int = 0;
		
		/**
		 * 选择按钮1内容
		 */
		public var choose1:String = "";
		
		/**
		 * 选择按钮2内容
		 */
		public var choose2:String = "";
		
		/**
		 * 提示框显示文字内容
		 */
		public var info:String = "";
		
		/**
		 * 相关说明(策划用)
		 */
		public var notes:String = "";
		
		
		
		/**
		 * 触发的guideID
		 */
		public var guideID:int;
		
		/**
		 * 询问的引导类型
		 */
		public var kind:int = GuideConfigVO.GUIDE_KIND_ASK;
		
		/**
		 * 选择了哪个按钮
		 */
		public var choosed:int;
		
		
		/**
		 * 
		 * @param info
		 */
		public function GuideAskConfigVO(info:Object=null):void{
			super(info);
		}
	}
}