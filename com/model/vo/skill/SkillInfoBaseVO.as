package com.model.vo.skill {
	import com.model.vo.BaseObjectVO;

	public class SkillInfoBaseVO extends BaseObjectVO{
		public var LV:int = 1;
		public var ID:int = 0;
		public var userSkillID:int = 1;
		
		public function SkillInfoBaseVO(info:Object=null) {
			super(info);
		}
	}
}
