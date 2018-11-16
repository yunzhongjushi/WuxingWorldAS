package editor{
	import com.model.vo.skill.UserSkillVO;
	import com.view.UI.skill.SkillChooseBtn;
	
	import flash.display.Sprite;

	public class SkillSelectPanel extends Sprite{
		public var mc_skill_0:SkillChooseBtn;
		public var mc_skill_1:SkillChooseBtn;
		public var mc_skill_2:SkillChooseBtn;
		public var mc_skill_3:SkillChooseBtn;
		public var mc_skill_4:SkillChooseBtn;
		public var mc_skill_5:SkillChooseBtn;
		public var mc_skill_6:SkillChooseBtn;
		public var mc_skill_7:SkillChooseBtn;
		public var mc_skill_8:SkillChooseBtn;
		public var mc_skill_9:SkillChooseBtn;
		public var mc_skill_10:SkillChooseBtn;
		public var mc_skill_11:SkillChooseBtn;
		public var mc_skill_12:SkillChooseBtn;
		public var mc_skill_13:SkillChooseBtn;
		public var mc_skill_14:SkillChooseBtn;
		public var mc_skill_15:SkillChooseBtn;
		public var mc_skill_16:SkillChooseBtn;

		public var userSkillArr:Array = [0,10,20,30,40,54];
//											11,12,13,
//											21,22,23,
//											31,32,33,
//											41,42,43,
//											51];
		
		public function SkillSelectPanel() {
			for(var i:int=0; i<16; i++){
				var s:SkillChooseBtn = this["mc_skill_"+i] as SkillChooseBtn;
				if(i<userSkillArr.length){
					s.updateInfo(new UserSkillVO(userSkillArr[i], 1));
				}else{
					s.visible = false;
				}
			}
		}
		
		public function setBoardSkills(arr:Array):void{
			for(var i:int=0; i<userSkillArr.length; i++){
				var s:SkillChooseBtn = this["mc_skill_"+i] as SkillChooseBtn;
				s.isChoose = false;
				
				for(var j:int=0; j<arr.length; j++){
					if(s.skillInfo.ID==arr[j]){
						s.isChoose = true;
						break;
					}
				}
			}
		}
		public function getBoardSkills():Array{
			var arr:Array = [];
			for(var i:int=0; i<userSkillArr.length; i++){
				var s:SkillChooseBtn = this["mc_skill_"+i] as SkillChooseBtn;
				if(s.isChoose) arr.push(s.skillInfo.ID);
			}
			return arr;
		}
	}
}
