package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.vo.fairy.FairyListVO;
	import com.model.vo.item.ItemListVO;
	import com.model.vo.skill.SkillListVO;
	import com.model.vo.user.UserVO;
	import com.view.UI.fairy.FairyListBoard;
	
	/**
	 * 请求修改数据，GM接口，调试接口
	 * @author hunterxie
	 */
	public class ServerVO_255{
		public static var ID:int = 0xff;
		
		public static var tempType:int;
		
		/**
		 * 请求修改对应属性或物品任务
			客户端 -> 服务器
			一级协议：0xff
			参数：
			    type:int;//2.增加经验3.增加精灵经验4.增加钻石5.增加元素6.物品7.技能8.解锁五行模块9.完成任务
				 kind:int;//针对种类的类型：精灵0全部，其他为id；针对元素，01234，金木土水火，5为全部；针对任务，为id
				 value:int;//改变的量
			
			    返回：无
		 */
		public function ServerVO_255(obj:Object) {
			if(obj.result!=0){
				switch(tempType){
					case 3:
						
						break;
					case 6:
						// 在服务器改变物品后，重新获取物品列表
						ServerVO_192.getItems();
						break;
					case 7:
						ServerVO_107.sendInfo();
						break;
					case 9:
						
						break;
					default:
						ServerVO_93.sendInfo();
						break;
				}
			}
		}
		
		/**
		 * 发送给server 	
		 * @param type:int;//2.增加经验3.增加精灵经验4.增加钻石5.增加元素6.物品7.技能8.解锁五行模块9.完成任务10.增加精力值
		 * @param kind:int;//针对种类的类型：精灵0全部，其他为id；针对元素，01234，金木土水火，5为全部；针对任务，为id；针对技能，为模版id；钻石、经验等没有类型
		 * @param value:int;//改变的量,技能、任务等没有数量
		 */
		public static function sendInfo(type:int, kind:int, value:int=0):void{
			if(BaseInfo.isTestLogin){
				switch(type){
					case 2:
						UserVO.testAddExp(value);
						break;
					case 3:
						FairyListVO.testAddExp(kind, value);
						break;
					case 4:
						UserVO.testBuyGold(value);
						break;
					case 5:
						UserVO.testAddResource(kind, value);
						break;
					case 6:
						ItemListVO.testAddItem(kind, value);
						break;
					case 7:
						SkillListVO.testAddSkill(kind, value);
						break;
					case 8:
						UserVO.testActivation(kind);
						break;
					case 9:
						break;
					case 10:
						UserVO.testAddEnergy(value);
						break;
				}
			}else{
				tempType = type;
				MainNC.getInstance().sendInfo(ID, {type:type, kind:kind, value:value});
			}
		}
	}
}
