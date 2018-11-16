package com.model.vo.activity {
	import com.adobe.air.filesystem.VolumeMonitor;
	import com.model.vo.altar.FairyTemplateVO;
	import com.model.vo.item.ItemVO;

	public class SignVO {
		//UI里的Label，切勿改动
		public static const SIGNED:String="signed";
		public static const AVAILABLE:String="available";
		public static const NO_AVAILABLE:String="noAvailable";
		public var signID:int;
		public var num:int;
		public var status:String;
		public var pic:String;

		public function SignVO(id:int, pic:String, num:Number) {
			this.signID=id;
			this.num=num;
			this.pic=pic;
		}

		public function updateSignStatus(curAvailNO:Object, markNO:Object):void {
			status=NO_AVAILABLE;
			if(curAvailNO) {
				if(signID==curAvailNO)
					status=AVAILABLE;
			}
			if(markNO) {
				if(signID<=markNO)
					status=SIGNED;
			}
		}


	}
}
