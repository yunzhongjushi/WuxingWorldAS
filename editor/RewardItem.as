package editor{
	import com.model.vo.config.item.ItemConfigVO;
	import com.model.vo.config.level.LevelRewardBaseVO;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * 单个关卡奖励
	 * @author hunterxie
	 */
	public class RewardItem extends Sprite{
		public var info:LevelRewardBaseVO;
		
		public var cb_reward:ComboBox;
		
		public var tf_chance:TextField;
		
		public var tf_numMin:TextField;
		
		public var tf_numMax:TextField;
		
		public function RewardItem(data:DataProvider=null) {
			if(data){
				cb_reward.dataProvider = data;
			}
			cb_reward.rowCount = 15;
			cb_reward.addEventListener(Event.CHANGE, onChange);
			tf_chance.addEventListener(Event.CHANGE, onChange);
			tf_numMin.addEventListener(Event.CHANGE, onChange);
			tf_numMax.addEventListener(Event.CHANGE, onChange);
		}
		
		protected function onChange(event:Event):void{
			info.ID = (cb_reward.selectedItem as ItemConfigVO).id;
			info.label = cb_reward.selectedItem.label;
			info.chance = Number(tf_chance.text);
			info.numMin = parseInt(tf_numMin.text);
			info.numMax = parseInt(tf_numMax.text);
		}
		
		public function updateInfo(vo:LevelRewardBaseVO, index:int):void{
			this.info = vo;
			this.x = Math.floor(index%4)*85;
			this.y = Math.floor(index/4)*58;
			tf_chance.text = String(info.chance);
			tf_numMin.text = String(info.numMin);
			tf_numMax.text = String(info.numMax);
			for(var i:int=0; i<cb_reward.dataProvider.length; i++){
				if((cb_reward.dataProvider.getItemAt(i) as ItemConfigVO).id == vo.ID){
					cb_reward.selectedIndex = i;
					break;
				}
			}
		}
	}
}
