package com.view.UI.fairy
{
	import com.model.vo.fairy.BaseFairyVO;
	import com.view.BaseImgBar;
	
	public class TipFairyBar extends BaseImgBar
	{
		public function TipFairyBar()
		{
			super();
		}
		public function updateInfo(vo:BaseFairyVO):void
		{
			this.updateClass(vo.nickName+"big");
		}
	}
}