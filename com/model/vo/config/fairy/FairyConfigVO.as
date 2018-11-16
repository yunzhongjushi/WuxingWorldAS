package com.model.vo.config.fairy{
	import com.model.vo.BaseObjectVO;
	import com.model.vo.WuxingVO;
	import com.model.vo.config.item.ItemConfigVO;
	import com.model.vo.config.item.ItemConfig;
	
	
	/**
	 * 精灵配置信息
	 * @author hunterxie
	 */
	public class FairyConfigVO extends BaseObjectVO{
		/**
		 * 精灵id
		 */
		public function get id():int{
			return _id;
		}
		public function set id(value:int):void{
			_id = value;
			FairyConfig.setFairy(this);
			ItemConfig.setItem(new ItemConfigVO({id:value, label:this.label, icon:this.label+"head"}));
		}
		private var _id:int = 0;
		
		/**精灵名字*/
		public var label:String = "火精灵";
		/**精灵图片*/
		public var icon:String = "";
		/**精灵说明*/
		public var describe:String = "精灵说明";
		/**精灵五行种族值*/
		public var wuxings:Array = [0,0,0,0,0];
		
		/**
		* 精灵主五行（最大的）
		*/
		public function getwuxing():int{
			var index:int = 0;
			var num:int=wuxings[0];
			for(var i:int=1; i<wuxings.length; i++){
				if(wuxings[i]>num){
					num = wuxings[i];
					index = i;
				}
			}
			return index;
		}
		
		/**
		* 精灵第二五行(备用);
		 * 如果4个0那么跟第一五行相同
		*/
		public function getwuxing2():int{
			var first:int = getwuxing();
			var index:int = 0;
			var num:int=0;
			for(var i:int=0; i<wuxings.length; i++){
				if(i!=first && wuxings[i]>num){
					num = wuxings[i];
					index = i;
				}
			}
			if(num==0){
				return first;
			}
			return index;
		}
		
		/**战斗类别（攻击，防御，生命，辅助）*/
		public var fightkind:int = 0;
		/**精灵碎片ID*/
		public var mergeID:int;
		/**可进阶ID*/
		public var evoID:int;
		/**进阶加成系数*/
		public var evonum:Number;
		/**精灵经验倍率*/
		public var expkind:Number;
		/**技能列表*/
		public var skills:Array = [];
		/**精灵AP基数*/
		public var AP:Number;
		/**AP成长系数1*/
		public var APinc1:Number;
		/**AP成长系数2*/
		public var APinc2:Number;
		/**精灵DP基数*/
		public var DP:Number;
		/**DP成长系数1*/
		public var DPinc1:Number;
		/**DP成长系数2*/
		public var DPinc2:Number;
		/**精灵HP基数*/
		public var HP:Number;
		/**HP成长系数1*/
		public var HPinc1:Number;
		/**HP成长系数2*/
		public var HPinc2:Number;
		
		
		
		/**
		 * 
		 * @param info
		 */
		public function FairyConfigVO(info:Object=null):void{
			super(info);
//			FairyInfo.setFairy(this);
		}
		
		public function updateSkill(arr:Array):void{
//			while(skills.length){
//				skills.pop();
//			}
			this.skills = arr;
		}
		
		/**
		 * 
		 * @param fairy
		 * 
		 */		
//		public function updateByXML(fairy:XML):void{
//			this.id = int(fairy.@id);
//			this.label = String(fairy.@name);
//			this.describe = String(fairy.describe);
//			this.mergeID = int(fairy.@mergeid);
//			this.evoID = int(fairy.@evoid);
//			this.evonum = Number(fairy.@evonum);
//			this.wuxings[0] = int(fairy.@jin);
//			this.wuxings[1] = int(fairy.@mu);
//			this.wuxings[2] = int(fairy.@tu);
//			this.wuxings[3] = int(fairy.@shui);
//			this.wuxings[4] = int(fairy.@huo);
////			this.wuxing = String(fairy.@wuxing);
////			this.wuxing2 = String(fairy.@wuxing2);
//			this.fightkind = int(fairy.@fightkind);
//			this.expkind = Number(fairy.@expkind);
//			
//			this.AP = Number(fairy.@AP);
//			this.APinc1 = Number(fairy.@APinc1);
//			this.APinc2 = Number(fairy.@APinc2);
//			
//			this.DP = Number(fairy.@DP);
//			this.DPinc1 = Number(fairy.@DPinc1);
//			this.DPinc2 = Number(fairy.@DPinc2);
//			
//			this.HP = Number(fairy.@HP);
//			this.HPinc1 = Number(fairy.@HPinc1);
//			this.HPinc2 = Number(fairy.@HPinc2);
//			
//			this.skills = [];
//			for(var i:int=0; i<fairy.skill.length(); i++){
//				this.skills.push(int(fairy.skill[i]));
//			}
//		}
	}
}