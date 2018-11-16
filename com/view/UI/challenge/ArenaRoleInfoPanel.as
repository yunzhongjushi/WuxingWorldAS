package com.view.UI.challenge {
	import com.view.BasePanel;
	
	import flash.display.MovieClip;
	import flas.events.MouseEvent;
	import flash.text.TextField;
	
	public class ArenaRoleInfoPanel extends BasePanel{
		public static const SHOW_ARENA_ROLE_INFO:String = "SHOW_ARENA_ROLE_INFO";
		
		public static const NAME:String = "ArenaRoleInfoPanel";
		public static const SINGLETON_MSG:String="single_ArenaRoleInfoPanel_only";
		protected static var instance:ArenaRoleInfoPanel;
		public static function getInstance():ArenaRoleInfoPanel{
			if ( instance == null ) instance=new ArenaRoleInfoPanel();
			return instance as ArenaRoleInfoPanel;
		}
		
		public var tf_name:TextField;
		public var tf_rank:TextField;
		public var tf_win:TextField;
		public var tf_capacity:TextField;
		
		public var headContainer:MovieClip;
		public var fairy0:MovieClip;
		public var fairy1:MovieClip;
		public var fairy2:MovieClip;
		
		
		public function ArenaRoleInfoPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			this.addEventListener(MouseEvent.CLICK, onclick);
		}
		
		protected function onclick(event:*):void{
			event(SHOW_ARENA_ROLE_INFO);
		}
	}
}
