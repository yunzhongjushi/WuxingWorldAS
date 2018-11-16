package com.view.UI.tip {
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flas.display.StageAlign;
	import flas.events.MouseEvent;
	
	import flash.display.Stage;
	import flash.text.TextField;

	public class ItemGetPanel extends BasePanel {
		public static const NAME:String = "ItemGetPanel";
		public static const SINGLETON_MSG:String="single_ItemGetPanel_only";
		protected static var instance:ItemGetPanel;
		public static function getInstance():ItemGetPanel{
			if ( instance == null ) instance=new ItemGetPanel();
			return instance as ItemGetPanel;
		}
		
		public var btn_ok:CommonBtn;
		public var tf_title:TextField;
		public var tf_info:TextField;
		
		public static var stage:Stage;
		
		private var key:Object;
		
		public function ItemGetPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			this.alignInfo = StageAlign.BOTTOM_LEFT;
			btn_ok.addEventListener(MouseEvent.CLICK, confirm);
		}
		
		public static function show(title:String, info:String, key:Object=null):void{
			if(stage){
				stage.addChild(getInstance());
			}
			instance.tf_title.text = title;
			instance.tf_info.text = info;
			
			instance.key = key;
		}
		
		public function confirm(e:*=null):void{
			close();
		}
	}
}
