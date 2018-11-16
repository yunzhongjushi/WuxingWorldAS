package com.model.vo.challenge {

	/**
	 * 竞技场信息
	 * @author hunterxie
	 */
	public class ArenaVO {
		public var myInfo:ArenaRoleVO;
		
		/**
		 * 竞技场当时对手列表
		 * @see ArenaRoleVO
		 */
		public var enemyArr:Array;
		
		
		
		public function ArenaVO() {
			
		}
		
		public function updateInfoByServer(info:Object):void{
			enemyArr = [];
			for(var i:int=0; i<info.list.length; i++){
				var vo:ArenaRoleVO = new ArenaRoleVO();
				
				enemyArr.push(vo);
			}
		}
	}
}
