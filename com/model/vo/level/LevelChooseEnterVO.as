package com.model.vo.level {
	import com.model.vo.BaseObjectVO;

	/**
	 * 玩家选择的技能、精灵列表信息
	 * 关卡选择进入后临时保存的必要数据
	 * @author hunterxie
	 */
	public class LevelChooseEnterVO extends BaseObjectVO{
		/**
		 * 选中的关卡ID
		 */
		public var levelID:int;
		
		/**
		 * 选中的技能列表
		 */
		public var skills:Array;
		
		/**
		 * 选中的精灵列表
		 */
		public var fairys:Array;
		
		
		/**
		 * 关卡选择进入后临时保存的必要数据
		 * @param id		选中的关卡ID
		 * @param skills	选中的技能列表
		 * @param fairys	选中的精灵列表
		 */
		public function LevelChooseEnterVO(id:int=0, skills:Array=null, fairys:Array=null) {
			updateInfo(id, skills, fairys);
		}
		public function updateInfo(id:int=0, skills:Array=null, fairys:Array=null):void {
			this.levelID = id;
			this.skills = skills?skills:[-1,-1,-1,-1,-1];
			this.fairys = fairys?fairys:[-1,-1,-1];
		}
	}
}
