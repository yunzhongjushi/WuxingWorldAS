package com.model.vo.level {
	import com.model.vo.config.item.ItemConfigVO;
	import com.model.vo.item.ItemBaseVO;

	/**
	 * 关卡奖励
	 * @author hunterxie
	 */
	public class LevelRewardVO {
		public function get exp():int{
			return getRewardByID(1);
		}
		public function get gold():int{
			return getRewardByID(4);
		}
		/**
		 * 过关奖励的精力
		 */
		public function get live():int{
			return getRewardByID(3);
		}
		public function get resource():Array{
			return _resource;
		}
		/**
		 * 
		 * @param arr
		 * @param isClear	是否清除现有资源
		 */
		public function addRes(arr:Array, isClear:Boolean=false):Array{
			if(isClear){
				_resource = [0,0,0,0,0];
			}
			return _resource
		}
		private var _resource:Array = [0,0,0,0,0];
		
		public function get fairys():Array{
			return getRewardsPhase(ItemConfigVO.TYPE_FAIRY);
		}
		public function get items():Array{
			return getRewardsPhase(ItemConfigVO.TYPE_ITEM);
		}
		public function get skills():Array{
			return getRewardsPhase(ItemConfigVO.TYPE_SKILL);
		}
//		public var data:XML;

		public var rewardArr:Array = [];
		
		private function getRewardByID(id:int):int{
			for(var i:int=0; i<rewardArr.length; i++){
				var vo:ItemBaseVO = rewardArr[i] as ItemBaseVO;
				if(vo._itemID==id){
					return vo.num;
				}
			}
			return 0;
		}
		/**
		 * 获取某个ID段的奖励列表
		 * @param phase ID段
		 */
		private function getRewardsPhase(phase:int):Array{
			var arr:Array = [];
			for(var i:int=0; i<rewardArr.length; i++){
				var vo:ItemBaseVO = rewardArr[i] as ItemBaseVO;
				if(Math.floor(vo._itemID/phase)==1){
					arr.push(vo);
				}
			}
			return arr;
		}
		
		
		/**
		 *
		 * 
		 * 
		 * 
		 *  
		 * 
		 */
		public function LevelRewardVO() {
			
		}
		
		public function updateInfoByServer(info:Object):void{
			//info.res
		}
		

		/**
		 * 前端本地测试任务奖励获取
		 * @param gold	钻石
		 * @param exp	经验（角色/精灵）
		 * @param stars 此关获得的星星列表——[true, false, false]
		 */
		public function testGetReward(rewards:Array, gold:int=0, exp:int=0):void{
			this.rewardArr = rewards;
			
			resource[0] += getRewardByID(10);
			resource[1] += getRewardByID(11);
			resource[2] += getRewardByID(12);
			resource[3] += getRewardByID(13);
			resource[4] += getRewardByID(14);
			
//			this.exp = int(data.exp)+exp+general.exp;
//			this.gold = int(data.gold)+gold+general.gold;
//			
//			resource[0] = int(data.金)+int(general.resource[0]);
//			resource[1] = int(data.木)+int(general.resource[1]);
//			resource[2] = int(data.土)+int(general.resource[2]);
//			resource[3] = int(data.水)+int(general.resource[3]);
//			resource[4] = int(data.火)+int(general.resource[4]);
//			
//			fairys = [].concat(general.fairys);
//			for(var i:int=0; i<data.fairy.length(); i++){
//				var fairy:XML = data.fairy[i][0];
//				if(fairy && !FairyListVO.getIsFairyExist(int(fairy.@ID)) && Math.random()<Number(fairy.@chance)){
//					fairys.push(int(fairy.@ID));
//				}
//			}
//			
//			items = [].concat(general.items);
//			for(i=0; i<data.item.length(); i++){
//				var item:XML = data.item[i][0];
//				if(item && Math.random()<Number(item.@chance)){
//					items.push(int(item.@ID));
//				}
//			}
//			
//			skills = [].concat(general.skills);
//			for(i=0; i<data.skill.length(); i++){
//				var skill:XML = data.skill[i][0];
//				if(skill && !SkillListVO.getSkillByID(int(skill.@ID)) && Math.random()<Number(skill.@chance)){
//					skills.push(int(skill.@ID));
//				}
//			}
//			
//			//首次获得星星的奖励
//			if(!stars || stars.length==0) 
//				return;
//			
//			for(var j:int=0; j<stars.length; j++){
//				var star:XML = xml["star"+(j+1)][0];
//				if(stars[j] && star){
//					this.exp += int(star.exp);
//					this.gold += int(star.gold);
//					
//					resource[0] += int(star.金);
//					resource[1] += int(star.木);
//					resource[2] += int(star.土);
//					resource[3] += int(star.水);
//					resource[4] += int(star.火);
//					
//					for(i=0; i<star.fairy.length(); i++){
//						fairy = star.fairy[i][0];
//						if(fairy && !FairyListVO.getIsFairyExist(int(fairy))){
//							fairys.push(int(fairy));
//						}
//					}
//					
//					for(i=0; i<star.item.length(); i++){
//						item = star.item[i][0];
//						if(item){
//							items.push(int(item));
//						}
//					}
//					
//					for(i=0; i<star.skill.length(); i++){
//						skill = star.skill[i][0];
//						if(skill && !SkillListVO.getSkillByID(int(skill))){
//							skills.push(int(skill));
//						}
//					}
//				}
//			}
		}
	}
}
