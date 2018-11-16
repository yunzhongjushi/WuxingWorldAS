package com.view.UI.tip {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.vo.tip.FairyConversationVO;
	import com.view.BasePanel;
	
	import flas.display.StageAlign;
	import flas.events.MouseEvent;
	import flas.utils.utils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	
	/**
	 * 精灵对话框
	 * @author hunterxie
	 */
	public class FairyConversationPanel extends BasePanel{
		public static const NAME:String = "FairyConversationPanel"; 
		public static const SINGLETON_MSG:String="single_FairyConversationPanel_only";
		protected static var instance:FairyConversationPanel;
		public static function getInstance():FairyConversationPanel{
			if ( instance == null ) instance=new FairyConversationPanel();
			return instance as FairyConversationPanel;
		}
		
		
		public var tf_name:TextField;
		public var tf_info:TextField; 
		
		public var mc_headContainer:Sprite;
		private var headImg:Bitmap = new Bitmap;
		
		public var vo:FairyConversationVO
		
		/**
		 * 带美女的对话框
		 */		
		public function FairyConversationPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			this.alignInfo = StageAlign.BOTTOM_LEFT;
			this.tf_info.mouseEnabled = false;
			this.mouseChildren = false;
			this.on(MouseEvent.CLICK, this, close);
			
			mc_headContainer.addChild(headImg);
		}
		
		override public function close(e:*=null):void{
			super.close(e);
			EventCenter.event(ApplicationFacade.GUIDE_MISSION_CONVERSATION_COMPLETE, vo);
		}
		
		public function updateInfo(vo:FairyConversationVO):void{
			this.vo = vo;
			this.tf_name.text = vo.head;
			this.tf_info.text = vo.info;
			this.headImg.bitmapData = utils.getDefinitionByName(vo.head);
		}
		
		public static function getShowName(vo:FairyConversationVO):String{
			getInstance().updateInfo(vo);
			return NAME;
		}
	}
}
