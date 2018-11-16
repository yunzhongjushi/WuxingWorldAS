package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.vo.skill.SkillListVO;
	
	/**
	 * 请求修改装备
	 * @author hunterxie
	 */
	public class ServerVO_122{
		public static var ID:int = 0x7a;
		
		/**
		 * 请求查询技能
		 * 一级协议：0x7a
			参数：
			equip:[0,0,0,0,0];//-1:未装备或移除0：不变,值为物品ID
			返回：
			    equip:Map<String,Integer>;//String,
			        装备，按照装备位置排序，初始为1，最大为5
			 	     Integer,id：int;//物品id ，-1为未解锁
		 */
		public function ServerVO_122(obj:Object) {
//			SkillListVO.getInstance().updateInfo(obj.skills);
			SkillListVO.getInstance().updateObj(obj.skills);
		}
		
		/**
		 * 发送给server，5个装备好技能的位置
		 * @param kind equip:[0,0,0,0,0];//-1:未装备或移除0：不变,值为物品ID
		 */
		public static function sendInfo(arr:Array):void{
			MainNC.getInstance().sendInfo(ID, {equip:arr});
		}
	}
}
