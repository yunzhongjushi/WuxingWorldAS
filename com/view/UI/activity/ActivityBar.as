package  com.view.UI.activity
{
	import com.model.vo.activity.ActivityVO;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import listLibs.ITouchPadBar;
	
	public class ActivityBar extends MovieClip implements ITouchPadBar
	{
		public var tf_title:TextField;
		public var tf_active_id:TextField;
		public var tf_start_date:TextField;
		public var tf_end_date:TextField;
		public var tf_last:TextField;
		//
		//
		
		public var running_vo:ActivityVO
		public function ActivityBar()
		{
			super();
		}
		public function updateInfo(_vo:*):void{
			running_vo = _vo as ActivityVO
			//
			tf_title.text = String(running_vo.title)
			tf_active_id.text = String(running_vo.activeId)
			tf_start_date.text = String(running_vo.startDate)
			tf_end_date.text = String(running_vo.endDate)
			tf_last.text = String(running_vo.getLastStr())
		} 
		
	}
}