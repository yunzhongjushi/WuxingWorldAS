package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.vo.skill.SkillListVO;
	
	/**
	 * 请求查询技能
	 * @author hunterxie
	 */
	public class ServerVO_107{
		public static var ID:int = 0x6b;
		
		/**
		 * 请求查询技能
		 * 一级协议：0x6b
			参数：
			type:String;//all：全部技能；equip：装备的技能
			
			返回：
			skills：Map<Integer,Object>;//Integer，全部技能，从0~技能 数 目-1装备技能，按照技能装备位置排序，初始为1，最大为5；Object，包含：id：技能id  lv：技能等级
			returnCode:int;//0:失败，1：成功
		 */
		public function ServerVO_107(obj:Object) {
			SkillListVO.getInstance().updateObj(obj.skills);
//			SkillListVO.getInstance().updateInfo(obj.skills);
		}
		
		/**
		 * 发送给server
		 * @param kind all：全部技能；equip：装备的技能
		 */
		public static function sendInfo(kind:String="all"):void{
			MainNC.getInstance().sendInfo(ID, {type:kind});
		}
	}
}
