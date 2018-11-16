package com.view.UI.fairy
{
	import com.model.vo.fairy.BaseFairyVO;
	import com.view.BaseImgBar;
	
	public class FairyShowBar extends BaseImgBar
	{
		public function FairyShowBar()
		{
			super();
		}
		public function updateInfo(vo:BaseFairyVO):void
		{
			updateClass(vo.nickName + "head"); 
		}
	}
}