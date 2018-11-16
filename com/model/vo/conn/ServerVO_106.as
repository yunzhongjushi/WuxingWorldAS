package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.vo.skill.SkillListVO;
	
	/**
	 * 请求修改装备技能
	 * @author hunterxie
	 */
	public class ServerVO_106{
		public static var ID:int = 0x6a;
		/**
		 * 返回请求是否成功
		 */
		public var returnCode:Boolean = true;
		
		/**
		 * 请求修改装备技能
		 * 一级协议：0x6a
			参数：
			Skill：[0,0,0,0,0];//-1:移除，0：不变
			
		    返回：
		    skills：Map<Integer,Object>;//Integer,
		        装备技能，按照技能装备位置排序，初始为1，最大为5
		 	     Object,包含：id：int;//技能id  lv：int;//技能等级
		    returnCode:int;//0:失败，1：成功
		 */
		public function ServerVO_106(obj:Object) {
			SkillListVO.getInstance().updateObj(obj);
//			SkillListVO.getInstance().updateInfo(obj);
			this.returnCode = obj.returnCode==1?true:false;
		}
		
		/**
		 * 发送给server
		 * @param arr [0,0,0,0,0];//-1:移除，0：不变
		 * 
		 */
		public static function getSendInfo(arr:Array):void{
			MainNC.getInstance().sendInfo(ID, {Skill:arr});
		}
	}
}
