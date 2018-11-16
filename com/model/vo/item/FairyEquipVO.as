package com.model.vo.item {
	import com.model.vo.config.item.ItemConfigVO;
	import com.model.vo.level.LevelListVO;

	public class FairyEquipVO extends ItemVO {

		override public function set templateID(value:int):void {
			super.templateID=value;

			this.data.describe = genDescription(this.data.equipInfo.addHP, this.data.equipInfo.addAP, this.data.equipInfo.addDP);

			function genDescription(addHP:int, addAP:int, addDP:int):String {
				var description:String="";
				if(addHP!=0) {
					description+="生命:+"+String(addHP)
				}
				if(addAP!=0) {
					if(description.length>0) {
						description+="\n";
					}
					description+="攻击:+"+String(addAP)
				}
				if(addDP!=0) {
					if(description.length>0) {
						description+="\n";
					}
					description+="防御:+"+String(addDP)
				}
				return description;
			}
		}


		public function FairyEquipVO(templateID:int=ItemConfigVO.TYPE_ITEM_FAIRY_EQUIP, num:int=0, itemID:int=0):void {
			super(templateID, num, itemID);

		}

		public function getLevelVOList():Array {
			return LevelListVO.getItemDropLevels(templateID);
		}

		public function updateInfo(id:int):FairyEquipVO {
			this.templateID=id;
			return this;
		}
	}

}
