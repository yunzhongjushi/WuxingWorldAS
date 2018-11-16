package com.model.vo.config.lvs{	
	
	/**
	 * 根据exp寻找出的等级配置信息
	 * @author hunterxie
	 */
	public class LVCheckVO{
		/**
		 * 当前等级
		 */
		public var LV:int = 0;
		/**
		 * 当前经验值
		 */
		public var cu:Number = 0;
		/**
		 * 上一级目标经验值
		 */
		public var last:Number = 0;
		/**
		 * 当前升级所需经验
		 */
		public var max:Number = 0;
		
		
		/**
		 * 根据exp寻找出的等级配置信息
		 * @param info
		 */
		public function LVCheckVO(num:Number):void{
			this.cu = num;
			if(this.cu<0){
				this.cu = 0;
			}
		}
	}
}