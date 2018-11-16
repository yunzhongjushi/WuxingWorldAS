package com.model.vo.fairy
{
	import com.model.vo.item.ItemVO;

	public class UseExpItemVO
	{
		
		public var targetVO:BaseFairyVO;
		
		public var itemVO:ItemVO;
		
		public var useNum:int;
		
		public function UseExpItemVO(targetVO:BaseFairyVO, itemVO:ItemVO)
		{
			this.targetVO = targetVO;
			
			this.itemVO = itemVO;
			
			useNum = 0;
		}
	}
}