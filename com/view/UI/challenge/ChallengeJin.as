package com.view.UI.challenge {
	import com.model.vo.challenge.ArenaVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	public class ChallengeJin extends BasePanel {
		
		public static const NAME:String = "ChallengeJin";
		public static const SINGLETON_MSG:String="single_ChallengeJin_only";
		protected static var instance:ChallengeJin;
		public static function getInstance():ChallengeJin{
			if ( instance == null ) instance=new ChallengeJin();
			return instance as ChallengeJin;
		}
		
		
		public var btn_ajust:CommonBtn;

		public var btn_info:CommonBtn;

		public var btn_change:CommonBtn;

		public var tf_rank:TextField;

		public var tf_capacity:TextField;

		public var fairy0:MovieClip;

		public var fairy1:MovieClip;

		public var fairy2:MovieClip;

		public var mc_enemy0:ArenaRolePanel;

		public var mc_enemy1:ArenaRolePanel;

		public var mc_enemy2:ArenaRolePanel;

		public function ChallengeJin() {
			super(false);
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			tf_capacity.mouseEnabled=false;

			btn_ajust.setNameTxt("调  整");
			btn_ajust.addEventListener(MouseEvent.CLICK, onAjust);
			
			btn_info.setNameTxt("规则说明");
			btn_info.addEventListener(MouseEvent.CLICK, onInfo);
			
			btn_change.setNameTxt("换一批");
			btn_change.addEventListener(MouseEvent.CLICK, onChange);
		}

		protected function onInfo(event:*):void {
			// TODO Auto-generated method stub

		}

		protected function onAjust(event:*):void {
			// TODO Auto-generated method stub

		}

		protected function onChange(event:*):void {
			// TODO Auto-generated method stub

		}

		public function updateInfo(info:ArenaVO=null):void {
			tf_capacity.text = String(info.myInfo.rank);

		}
	}
}
