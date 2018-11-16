package com.model.vo.conn.player {
	import com.model.vo.conn.BaseReturnVO;
	import com.model.vo.conn.level.LevelListReturnVO;
	import com.model.vo.level.LevelSaveVO;

	/**
	 * 后台发送过来的(更新)用户信息
	 * @author hunterxie
	 */
	public class TotalInfoReturnVO extends BaseReturnVO{
		public var	userID:int;
		public var	nickName:String;
		public var	EXP_cu:int;
		public var	energy:int;
		public var	gold:int;
		public var	sex:Boolean;
		public var	allPoint:int;
		public var	title:String;
		public var	repute:int;
		public var	birthday:String;
		public var	antiAddictionTime:Number;
		public var	lastLoginTime:String;
		public var	visualURL:String;
		public var	LV:int;
		public var	state:int;
		public var	fightPower:int;
		public var	payedMoney:int;
		public var	vipLv:int;
		
		public var wuxingPropertyArr:Array=[];
		public var wuxingResourceArr:Array=[];
		
		public var levelInfo:LevelListReturnVO = new LevelListReturnVO();
		
		public var jsonInfo:Object;
		
		public function TotalInfoReturnVO(info:Object=null) {
			super(info);
			this.jsonInfo = info;
		}
	}
}
