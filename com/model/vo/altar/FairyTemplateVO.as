package com.model.vo.altar {

	import com.model.vo.config.fairy.FairyConfig;
	import com.model.vo.fairy.FairyVO;

	public class FairyTemplateVO {
		private static const INT_TO_BOOLEAN:String="INT_TO_BOOLEAN"
		private static const NORMAL:String="NORMAL"
		private static const STRING_TO_INT:String="STRING_TO_INT"

		private static const ID_MIN:int=1;
		private static const ID_MAX:int=30;

		private var xml:XML;

		public var templateID:int;
		public var petName:String;
		public var petAttr:String;
		public var petHP:int;
		public var petAP:int;
		public var petExp:int;
		public var randomAP:String;
		public var randomHP:String;
		public var jinDF:int
		public var muDF:int
		public var shuiDF:int
		public var huoDF:int
		public var tuDF:int
		//data
		private static const TEMPLATE_ID_NO:int=0;
		private static const TEMPLATE_ID_ERROR:int=-1;
		private static const PIC_ERROR:int=1;
		private static const PIC_NO:int=2;
		private static const LV_NO:int=-1;
		private static const FAIRY_ID_NO:int=-1;
		private var lv:int;
		public var fairyID:int;
		public var performance:Number=1;
		public var isProtector:Boolean=false;
		public var isEmpty:Boolean=false;
		public var pic:String

		public function FairyTemplateVO(_templateID:int, lv:int, fairyID:int) {

			//default
			this.lv=lv;
			this.fairyID=fairyID;
			//empty
			if(_templateID==TEMPLATE_ID_NO) {
				return;
			}
			//get XML
			this.templateID=_templateID;
			if(!FairyConfig.getFairyConfigByID(templateID)) {
				trace("警告：精灵xml没找到，ID：", templateID);
				return;
			}
			//templateInfo
			var paramArr:Object={petName:NORMAL, petAttr:NORMAL, petHP:STRING_TO_INT, petAP:STRING_TO_INT, petExp:STRING_TO_INT, randomAP:NORMAL, randomHP:NORMAL, jinDF:STRING_TO_INT, muDF:STRING_TO_INT, shuiDF:STRING_TO_INT, huoDF:STRING_TO_INT, tuDF:STRING_TO_INT, pic:NORMAL}
//			trace("--------",this.templateID)
			for(var i:String in paramArr) {
				setParam(i, paramArr[i]);
			}

		}

		public static function getFakeData(num:int):Array {
			var arr:Array=[];
			for(var i:int=0; i<num; i++) {
				var f:FairyTemplateVO=FairyTemplateVO.genTemplateFairyVO(i+1);
				arr.push(f);
			}
			return arr;

		}

		private function setParam(param:String, type:String):void {
			if(NORMAL==type) {
				this[param]=String(xml[param]);
//				trace("-",param,this[param],"<>",String(xml[param]));
			}
			if(STRING_TO_INT==type) {
				this[param]=int(xml[param]);
//				trace("-",param,this[param],"<>",int(xml[param]));
			}
			if(INT_TO_BOOLEAN==type) {
				this[param]=(xml[param]==1);
			}
		}

		public static function genTemplateFairyVO(_templateID:int):FairyTemplateVO {
			var fairyVO:FairyTemplateVO=new FairyTemplateVO(_templateID, LV_NO, FAIRY_ID_NO)
			return fairyVO
		}

		public static function genProtectorFairyVO(monsterID:int, performance:Number):FairyTemplateVO {
			var fairyVO:FairyTemplateVO=new FairyTemplateVO(monsterID, 99, FAIRY_ID_NO)
			fairyVO.performance=performance;
			fairyVO.isProtector=true;
			return fairyVO;
		}

		public static function genEmptyFairyVO():FairyTemplateVO {
			var fairyVO:FairyTemplateVO=new FairyTemplateVO(TEMPLATE_ID_NO, LV_NO, FAIRY_ID_NO)
			fairyVO.isEmpty=true;
			fairyVO.petName="无"
			return fairyVO
		}

		public function getPicID():int {
			if(templateID==TEMPLATE_ID_NO) {
				return PIC_NO;
			}
			if(templateID==TEMPLATE_ID_ERROR) {
				return PIC_ERROR;
			}
			return templateID+2;
		}

		public function getWuxingID():int {
			if(templateID==TEMPLATE_ID_NO) {
				return PIC_NO;
			}
			switch(petAttr) {
				case "JIN":
					return 3;
					break;
				case "MU":
					return 4;
					break;
				case "TU":
					return 5;
					break;
				case "SHUI":
					return 6;
					break;
				case "HUO":
					return 7;
					break;
			}
			return 1;
		}

		public function getLvNumber():String {
			if(lv==LV_NO) {
				return "";
			}
			return String(this.lv)
		}

		public function getPerformanceDescription():String {
			if(isProtector==false) {
				return "";
			}
			var temp:int=(performance-1)*100;
			return "能力加成: "+temp+" %"
		}

		public function getIsProtector():Boolean {
			return isProtector
		}

		public function getIsEmpty():Boolean {
			return isEmpty;
		}

		public function getAttributeDescription():String {
			var str:String="";
			str+="等  级："+String(this.getLvNumber());
			str+="\n";
			str+="生  命："+String(this.petHP);
			str+="\n";
			str+="攻击力："+String(this.petAP);
			str+="\n";
			str+="防御力："+String(this.huoDF);
			return str;
		}

		public function traceInfo():void {
			trace("------------------\n", this.templateID);
			for(var i:* in this as Object) {
				trace("-", i, ":", this[i], "\n");
			}
		}
	}
}