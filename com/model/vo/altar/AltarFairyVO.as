package com.model.vo.altar
{
	public class AltarFairyVO
	{
		public var ImgID:int;
		public var name:String;
		public function AltarFairyVO(name:String,ImgID:int)
		{
			this.ImgID=ImgID;
			this.name=name;
		}
		public function getFrameID():int{
			return ImgID
		}
		public function getName():String{
			return name;
		}
	}
}