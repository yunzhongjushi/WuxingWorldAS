package ui.chessboard {
	import com.view.BasePanel;
	import com.view.UI.level.ResourceCollectPanel;
	import com.view.touch.CommonBtn;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class PuzzlePanelUI extends BasePanel{
		public var tf_score:TextField;
		public var tf_steps:TextField;
		public var tf_turns:TextField;
		public var tf_target:TextField;
		
		public var btn_escape:CommonBtn; 
		public var btn_solving:CommonBtn;
		
		public var mc_targetYuansu:ResourceCollectPanel;
		
		
		public function PuzzlePanelUI() {
		}
	}
}
