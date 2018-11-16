package com.model.vo.tip {

	/**
	 * 对话界面用到的信息结构
	 * @author hunterxie
	 */
	public class FairyConversationVO {
		
		/**
		 * 显示的key，用于重复显示后的关闭
		 */
		public var key:String;
		
		/**
		 * 显示的文本信息
		 */
		public var info:String;
		
		/**
		 * 对话框头像类名
		 */
		public var head:String = "金仙子conv";
		
		
		/**
		 * 对话界面用到的信息结构，点击交互
		 * @param key		显示的key，用于重复显示后的关闭
		 * @param showJudge	显示还是关闭
		 * @param info		显示的文本信息
		 */
		public function FairyConversationVO(key:String, info:String="") {
			this.key = key;
			this.info = info;
		}
	}
}
