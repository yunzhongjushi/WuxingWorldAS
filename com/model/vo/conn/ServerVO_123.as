package com.model.vo.conn {
	import com.conn.MainNC;
	
	/**
	 * 请求修改装备
	 * @author hunterxie
	 */
	public class ServerVO_123{
		public static var ID:int = 0x7b;
		
		/**
		 * 请求查询技能
		 * 一级协议：0x7b
			参数：
			type:String;//all：全部装备；equip：当前装备的技能
			
			返回：
			.全部装备：
			    equip:Map<String,Object>;//String,
			        全部装备，按顺序排列，从0开始，带装备种类-1
			 	     Object,包含：id：int;//物品id 
			                      Value:int;//物品数量
			    装备中的装备:
			equip:Map<String,Integer>;//String,
			        装备，按照装备位置排序，初始为1，最大为5
			 	     Integer,id：int;//物品id ，-1为未解锁
		 */
		public function ServerVO_123(obj:Object) {
			trace(obj);
		}
		
		/**
		 * 发送给server，5个装备好技能的位置
		 * @param kind type:String;//all：全部装备；equip：当前装备的技能
		 */
		public static function sendInfo(kind:String="all"):void{
			MainNC.getInstance().sendInfo(ID, {type:kind});
		}
	}
}
