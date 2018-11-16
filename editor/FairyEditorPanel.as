package editor{
	import com.greensock.TweenLite;
	import com.model.event.ObjectEvent;
	import com.model.vo.config.fairy.FairyConfig;
	import com.model.vo.config.fairy.FairyConfigVO;
	import com.model.vo.config.skill.SkillConfig;
	import com.model.vo.config.skill.SkillConfigVO;
	import com.model.vo.conn.ServerGameStartVO;
	import com.model.vo.fairy.FairyVO;
	import com.model.vo.user.UserVO;
	import com.utils.MainDispatcher;
	import com.utils.TextFactory;
	import com.view.UI.fight.FightFairyPanel;
	import com.view.touch.CommonBtn;
	
	import fl.containers.ScrollPane;
	import fl.controls.ComboBox;
	import fl.controls.List;
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flas.net.URLLoader;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 精灵编辑面板
	 * @author hunterxie
	 */
	public class FairyEditorPanel extends Sprite{
		public static const TEST_FAIRY_FIGHT:String = "TEST_FAIRY_FIGHT";
		
		public static const NAME:String = "FairyEditorPanel";
		public static const SINGLETON_MSG:String = "single_FairyEditorPanel_only";
		protected static var instance:FairyEditorPanel;
		public static function getInstance():FairyEditorPanel{
			if ( instance == null ) instance = new FairyEditorPanel();
			return instance;
		}
		
		public var btn_vs:Sprite;
		public var cb_boardRL:ComboBox;
		public static function getChooseBoard():int{
			return getInstance().cb_boardRL.selectedItem.id;
		}
		
		public var tf_AP:TextField;
		public var tf_DP:TextField;
		public var tf_HP:TextField;
		public var tf_金:TextField;
		public var tf_木:TextField;
		public var tf_土:TextField;
		public var tf_水:TextField;
		public var tf_火:TextField;
		
		public var tf_attack_金:TextField;
		public var tf_attack_木:TextField;
		public var tf_attack_土:TextField;
		public var tf_attack_水:TextField;
		public var tf_attack_火:TextField;
		public var tf_defend_金:TextField;
		public var tf_defend_木:TextField;
		public var tf_defend_土:TextField;
		public var tf_defend_水:TextField;
		public var tf_defend_火:TextField;
		
		public var tf_singleClearScore:TextField;
		public var tf_chessNum:TextField;
		
		/**
		 * 关闭当前面板
		 */
		public var btn_close:CommonBtn;
		/**
		 * 新增一个精灵
		 */
		public var btn_addFairy:CommonBtn;
		/**
		 * 输出fairyInfo.json
		 */
		public var btn_export:CommonBtn;
		/**
		 * 跳转到技能面板
		 */
		public var btn_goSkill:CommonBtn;
		/**
		 * 
		 */
		public var btn_skill_add:Sprite;
		public var btn_skill_reduce:Sprite;
		public var btn_attack_add:Sprite;
		public var btn_attack_reduce:Sprite;
		public var btn_defend_add:Sprite;
		public var btn_defend_reduce:Sprite;
		public var btn_attack_skill_add:Sprite;
		public var btn_attack_skill_reduce:Sprite;
		public var btn_defend_skill_add:Sprite;
		public var btn_defend_skill_reduce:Sprite;
		
		public var sp_attack_skill:ScrollPane;
		public var sp_defend_skill:ScrollPane;
		
		public var skill_attack_container:Sprite;
		public var skill_defend_container:Sprite;
		
//		public var fairylInfoT:XML = XML('<fairy id="0" name="火精灵" wuxing="火" wuxing2="火" expKind="0" 金="5" 木="5" 土="10" 水="0" 火="20" HP="30"><describe>火精灵</describe><skill>104</skill></fairy>')
		
		public var boardRLInfo:Array = [{id:30003,label:"8x8"},{id:30002,label:"6x6"},{id:30001,label:"5x5"}];
			
		//cb_boardRL.addEventListener(Event.CHANGE, asdfasdf);
		//function asdfasdf(e:Event):void {
		//	trace(cb_boardRL.selectedItem.id);
		//}
		
		public var mc_attackFairy0:FightFairyPanel;
		public var mc_attackFairy1:FightFairyPanel;
		public var mc_attackFairy2:FightFairyPanel;
		public var mc_defendFairy0:FightFairyPanel;
		public var mc_defendFairy1:FightFairyPanel;
		public var mc_defendFairy2:FightFairyPanel;
		
		public var cb_attack_star0:ComboBox;
		public var cb_attack_star1:ComboBox;
		public var cb_attack_star2:ComboBox;
		public var cb_defend_star0:ComboBox;
		public var cb_defend_star1:ComboBox;
		public var cb_defend_star2:ComboBox;
		public var cb_attack_intens0:ComboBox;
		public var cb_attack_intens1:ComboBox;
		public var cb_attack_intens2:ComboBox;
		public var cb_defend_intens0:ComboBox;
		public var cb_defend_intens1:ComboBox;
		public var cb_defend_intens2:ComboBox;
		public var cb_mc_attackFairy0:ComboBox;
		public var cb_mc_attackFairy1:ComboBox;
		public var cb_mc_attackFairy2:ComboBox;
		public var cb_mc_defendFairy0:ComboBox;
		public var cb_mc_defendFairy1:ComboBox;
		public var cb_mc_defendFairy2:ComboBox;


		public var tf_attack_lv0:TextField;
		public var tf_attack_lv1:TextField;
		public var tf_attack_lv2:TextField;
		public var tf_defend_lv0:TextField;
		public var tf_defend_lv1:TextField;
		public var tf_defend_lv2:TextField;
		
//		public var info:XML;
//		public var cuFairy:XML;
		public var cuFairy:FairyConfigVO;
		
		public var list_fairy:List;
		public var mc_fairyPanel:FightFairyPanel;
		public var cb_wuxing:ComboBox;
		public var tf_ID:TextField;
		public var tf_name:TextField;
		public var tf_fairyInfo:TextField;
		public var skill_container:MovieClip;
		public var skillData:DataProvider = new DataProvider;
		
		public var attackUserID:int = Math.floor(Math.random()*99999);
		public var defendUserID:int = 0;//Math.floor(Math.random()*99999);
		
		public var loader:URLLoader;
		
		private var fairyInfoVO:FairyConfig;//
		
		private function get skillInfo():SkillConfig{;// = SkillInfo.getInstance();
			return SkillConfig.getInstance();	
		}
		
		
		/*****************************
		 *
		 * 
		 * 
		 *  
		 * 
		 ****************************/
		public function FairyEditorPanel(){
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			list_fairy.addEventListener(Event.CHANGE, electLevel);
			
			cb_boardRL.dataProvider = new DataProvider(boardRLInfo);
			
			btn_close.setNameTxt("关闭");
			btn_close.addEventListener(MouseEvent.CLICK, closePanel);
			
			btn_addFairy.setNameTxt("增加精灵");
			btn_addFairy.addEventListener(MouseEvent.CLICK, addFairy);
			
			btn_export.setNameTxt("导出内容");
			btn_export.addEventListener(MouseEvent.CLICK, export);
			
			btn_goSkill.setNameTxt("编辑技能");
			btn_goSkill.addEventListener(MouseEvent.CLICK, goSkill);
			
			btn_skill_add.addEventListener(MouseEvent.CLICK, onSkillChange);
			btn_skill_reduce.addEventListener(MouseEvent.CLICK, onSkillChange);
			
			btn_attack_add.addEventListener(MouseEvent.CLICK, onSkillChange);
			btn_attack_reduce.addEventListener(MouseEvent.CLICK, onSkillChange);
			
			btn_defend_add.addEventListener(MouseEvent.CLICK, onSkillChange);
			btn_defend_reduce.addEventListener(MouseEvent.CLICK, onSkillChange);
			
			btn_attack_skill_add.addEventListener(MouseEvent.CLICK, onSkillChange);
			btn_attack_skill_reduce.addEventListener(MouseEvent.CLICK, onSkillChange);
			
			btn_defend_skill_add.addEventListener(MouseEvent.CLICK, onSkillChange);
			btn_defend_skill_reduce.addEventListener(MouseEvent.CLICK, onSkillChange);
			
			SkillEditorPanel.getInstance().addEventListener(SkillEditorPanel.SKILL_INFO_UPDATE, onSkillInfoUpdate);
			btn_vs.addEventListener(MouseEvent.CLICK, onFightTest);
			
			
			//var cb_fairyKind:ComboBox;
			//cb_fairyKind.addEventListener(Event.CHANGE, selectLevelKind);
			//function selectLevelKind(e:Event):void {
			//	var targetInfo:XML = info.clearKind.目标类型.(@id==cb_fairyKind.selectedIndex)[0];
			//	tf_fairyTargetInfo.text = targetInfo.describe+"    如：\n"+targetInfo.@info;
			//}
			
//			if(true){//BaseInfo.isLoadConfig){
//				loader = new URLLoader(new URLRequest("fairyInfo.xml"));
//				loader.addEventListener(Event.COMPLETE, onLoaded);
//			}else{
				TweenLite.to({}, 0.5, {onComplete:onLoaded});
//			}
			
			UserVO.getInstance().userID = attackUserID;
		}
		public function electLevel(e:Event):void {
			if(cuFairy) saveFairy();
//			showFairy(info.fairy[list_fairy.selectedIndex]);
			showFairy(list_fairy.selectedItem as FairyConfigVO);
		}
		
		public var intensDP:DataProvider = new DataProvider();
		public var starDP:DataProvider = new DataProvider();
		public function initFightfairys(dp:DataProvider):void{
			this.tf_AP.addEventListener(Event.CHANGE, saveFairy);
			this.tf_DP.addEventListener(Event.CHANGE, saveFairy);
			this.tf_HP.addEventListener(Event.CHANGE, saveFairy);
			for(var i:int=0; i<3; i++){
				var attackList:ComboBox 	= this["cb_mc_attackFairy"+i];
				attackList.dataProvider 	= dp;
				attackList.rowCount 		=10;
				attackList.addEventListener(Event.CHANGE, setFightFairy);
				
				var attackIntens:ComboBox 	= this["cb_attack_intens"+i];
				attackIntens.dataProvider 	= intensDP;
				attackIntens.rowCount 		=12;
				attackIntens.addEventListener(Event.CHANGE, setFightFairy);
				
				var attackStar:ComboBox 	= this["cb_attack_star"+i];
				attackStar.dataProvider 	= starDP;
				attackStar.rowCount 		=10;
				attackStar.addEventListener(Event.CHANGE, setFightFairy);
				//======================================================================
				
				var defendList:ComboBox 	= this["cb_mc_defendFairy"+i];
				defendList.dataProvider 	= dp;
				defendList.rowCount 		=10;
				defendList.addEventListener(Event.CHANGE, setFightFairy);
				
				var defendIntens:ComboBox 	= this["cb_defend_intens"+i];
				defendIntens.dataProvider 	= intensDP;
				defendIntens.rowCount 		=12;
				defendIntens.addEventListener(Event.CHANGE, setFightFairy);
				
				var defendStar:ComboBox 	= this["cb_defend_star"+i];
				defendStar.dataProvider 	= starDP;
				defendStar.rowCount 		=10;
				defendStar.addEventListener(Event.CHANGE, setFightFairy);
				
				this["mc_attackFairy"+i].init(new FairyVO(Math.floor(Math.random()*99999), 30001, 1, 99), []);
				this["mc_attackFairy"+i].addEventListener(MouseEvent.CLICK, checkFightFairy);
				this["mc_defendFairy"+i].init(new FairyVO(Math.floor(Math.random()*99999), 30001), []);
				this["mc_defendFairy"+i].addEventListener(MouseEvent.CLICK, checkFightFairy);
				
				this["tf_attack_lv"+i].addEventListener(Event.CHANGE, changeFairyLV);
				this["tf_defend_lv"+i].addEventListener(Event.CHANGE, changeFairyLV);
			}
		}
		public function updateFightFairys():void{
			nowAttackArr = [];
			nowDefendArr = [];
			for(var i:int=0; i<3; i++){
				if(i<attackNum){
					this["mc_attackFairy"+i].visible		=true;
					this["cb_mc_attackFairy"+i].visible	=true;
					this["tf_attack_lv"+i].visible		=true;
					this["cb_attack_intens"+i].visible	=true;
					this["cb_attack_star"+i].visible		=true;
					nowAttackArr.push(this["mc_attackFairy"+i].fairyInfo);
				}else{
					this["mc_attackFairy"+i].visible		=false;
					this["cb_mc_attackFairy"+i].visible	=false;
					this["tf_attack_lv"+i].visible		=false;
					this["cb_attack_intens"+i].visible	=false;
					this["cb_attack_star"+i].visible		=false;
				}
				if(i<defendNum){
					this["mc_defendFairy"+i].visible		=true;
					this["cb_mc_defendFairy"+i].visible	=true;
					this["tf_defend_lv"+i].visible		=true;
					this["cb_defend_intens"+i].visible	=true;
					this["cb_defend_star"+i].visible		=true;
					nowDefendArr.push(this["mc_defendFairy"+i].fairyInfo);
				}else{
					this["mc_defendFairy"+i].visible		=false;
					this["cb_mc_defendFairy"+i].visible	=false;
					this["tf_defend_lv"+i].visible		=false;
					this["cb_defend_intens"+i].visible	=false;
					this["cb_defend_star"+i].visible		=false;
				}
			}
		}
		public function changeFairyLV(e:Event):void{
			var str:String = e.target.name;
			var index:int = parseInt(str.charAt(str.length-1));
			var lv:int = parseInt(e.target.text);
			var fairy:FightFairyPanel;
			if(str.indexOf("attack")!=-1){
				fairy = this["mc_attackFairy"+index];
			}else{
				fairy = this["mc_defendFairy"+index];
			};
			fairy.fairyInfo.LV = lv;
		}
		public function setFightFairy(e:Event):void{
			var nameStr:String = e.target.name;
			var isAttack:Boolean = nameStr.indexOf("attack")!=-1;
			var str:String =  nameStr.charAt(nameStr.length-1);
			var fairy:FightFairyPanel = this[(isAttack?"mc_attackFairy":"mc_defendFairy")+str];
			
			if(nameStr.indexOf("Fairy")!=-1){
				list_fairy.selectedIndex = e.target.selectedIndex;
				list_fairy.dispatchEvent(new ObjectEvent(Event.CHANGE));
				fairy.fairyInfo.data = mc_fairyPanel.fairyInfo.data;
			}
			//fairy.fairyInfo.updateByFairyVO(mc_fairyPanel.fairyInfo);
			
			var lvStr:String = (isAttack ? "tf_attack_lv" : "tf_defend_lv")+str;
			fairy.fairyInfo.LV = parseInt(this[lvStr].text);
			
			var starStr:String = (isAttack ? "cb_attack_star" : "cb_defend_star")+str;
			fairy.fairyInfo.starLV = this[starStr].selectedItem.lv;
			
			var intensStr:String = (isAttack ? "cb_attack_intens" : "cb_defend_intens")+str;
			fairy.fairyInfo.intensLV = this[intensStr].selectedItem.lv;
			//trace("_________________________________________1",this[starStr].selectedItem.lv,this[intensStr].selectedItem.lv);
		}
		public function checkFightFairy(e:Event):void{
			var fairy:FightFairyPanel = e.target as FightFairyPanel;
			if(fairy.fairyInfo){
				trace("checkFightFairy：", fairy.fairyInfo.data.id)
				list_fairy.selectedIndex = getFairyIndex(fairy.fairyInfo.data.id);
				list_fairy.dispatchEvent(new ObjectEvent(Event.CHANGE));
			}
		}
		public function getFairyIndex(ogirinID:int):int{
			for (var i:int=0; i<fairyInfoVO.fairys.length; i++) {
				if(fairyInfoVO.fairys[i].id==ogirinID){
					return i;
				};
			}
			return 0
		}
		
		public function onLoaded(e:Event=null):void{
			fairyInfoVO = FairyConfig.getInstance();
			if(true){//BaseInfo.isLoadConfig){
//				info = XML(loader.data);
//				fairyInfoVO.updateByXML(XML(loader.data));
//				BaseInfo.setFairyInfo(info);
			}else{
//				info = BaseInfo.fairyInfo;
			}
//			BaseInfo.setFairyInfo(info);
			//trace(info.fairy[0])//.(@id == 1));
			
			var dp:DataProvider = new DataProvider(fairyInfoVO.fairys);
//			for (var i:int=0; i<info.fairy.length(); i++) {
//				dp.addItem({label:info.fairy[i].@id+":"+info.fairy[i].@name});
//			}
			starDP = new DataProvider(fairyInfoVO.infos.fairyStar);
			intensDP = new DataProvider(fairyInfoVO.infos.fairyIntens);
			list_fairy.dataProvider = dp;
//			cb_wuxing.dataProvider=new DataProvider(wuxingArr);
			
			list_fairy.selectedIndex = 0;
			list_fairy.dispatchEvent(new ObjectEvent(Event.CHANGE));
			initFightfairys(dp);
			updateFightFairys();
			UserVO.getInstance().fairyOpenNum = 3;
			
			TweenLite.to({}, 0.5, {onComplete:updateSkills});//重新刷新一次技能，因为新生成combobox不会立马刷新显示属性（初始化会延迟）
		}
		
		/**
		 * 增加精灵
		 * @param e
		 */
		public function addFairy(e:*=null):void {
//			if(info){
				saveFairy();
//				fairylInfoT.@id = parseInt(info.fairy[info.fairy.length()-1].@id)+1;
//				
//				var fairy:XML = new XML(fairylInfoT)
//				info.appendChild(fairy);
				
				var fairy:FairyConfigVO = fairyInfoVO.addFairy(cuFairy.id+1);
				
//				list_fairy.dataProvider.addItem({label:fairy.@id+":"+fairy.@name});
				list_fairy.dataProvider = new DataProvider(fairyInfoVO.fairys);
				list_fairy.selectedIndex = list_fairy.dataProvider.length;
				list_fairy.verticalScrollPosition = list_fairy.maxVerticalScrollPosition;
				
				showFairy(fairy);
//			}
		}
		
		/**
		 * 导出内容
		 * @param e
		 */
		public function export(e:*=null):void {
			saveFairy();
//			TextFactory.outputFile(info.toXMLString(), "fairyInfo.xml");
			var info:String = JSON.stringify(fairyInfoVO);
			TextFactory.outputFile(info, "fairyInfo.json");
		}
		
		/**
		 * 编辑技能
		 * @param e
		 */
		public function goSkill(e:*=null):void {
			saveFairy();
			this.visible = false;
			parent["skillEditorPanel"].visible = true;
		}
		
		
		public function saveFairy(e:Event=null):void {
			if(!cuFairy) return;
			
			cuFairy.id = parseInt(tf_ID.text);
			cuFairy.label = tf_name.text;
			cuFairy.describe = tf_fairyInfo.text;
//			cuFairy.@wuxing = WuxingVO.getWuxing(cb_wuxing.selectedIndex, "", false);
			//cuFairy.AP = parseInt(tf_AP.text);
			cuFairy.AP = Number(tf_AP.text);
			cuFairy.DP = Number(tf_DP.text);
			cuFairy.HP = Number(tf_HP.text);
			cuFairy.wuxings[0] = parseInt(tf_金.text);
			cuFairy.wuxings[1] = parseInt(tf_木.text);
			cuFairy.wuxings[2] = parseInt(tf_土.text);
			cuFairy.wuxings[3] = parseInt(tf_水.text);
			cuFairy.wuxings[4] = parseInt(tf_火.text);
			
			saveSkill();
			mc_fairyPanel.fairyInfo.data = cuFairy;
			
			this.tf_HP.addEventListener(Event.CHANGE, saveFairy);
			for(var i:int=0; i<3; i++){
				var attack:FightFairyPanel = this["mc_attackFairy"+i];
				if(attack.fairyInfo.data.id==cuFairy.id){
					attack.fairyInfo.data = cuFairy;
					this["cb_attack_intens"+i].dispatchEvent(new ObjectEvent(Event.CHANGE));
				}
				
				var defend:FightFairyPanel = this["mc_defendFairy"+i];
				if(defend.fairyInfo.data.id==cuFairy.id){
					defend.fairyInfo.data = cuFairy;
					this["cb_defend_intens"+i].dispatchEvent(new ObjectEvent(Event.CHANGE));
				}
			}
		}
		public function saveSkill():void{
//			delete cuFairy.skills;
			var arr:Array = [];
			for(var i:int=0; i<skillNum; i++){
//				cuFairy.appendChild(new XML("<skill>"+getSkillID(fairySkills[i].selectedIndex)+"</skill>"));
				arr.push(getSkillID(fairySkills[i].selectedIndex));
			}
			cuFairy.updateSkill(arr);
		}
		
		
		public function showFairy(fairyInfo:FairyConfigVO):void{
			cuFairy = fairyInfo;
			//trace("________________________________1\n",cuFairy.@AP,cuFairy.@DP,cuFairy.@HP);
			tf_ID.text = String(cuFairy.id);
			tf_name.text = cuFairy.label;
			tf_fairyInfo.text = cuFairy.describe;
			
			tf_AP.text = String(cuFairy.AP);
			tf_DP.text = String(cuFairy.DP);
			tf_HP.text = String(cuFairy.HP);
			tf_金.text = String(cuFairy.wuxings[0]);
			tf_木.text = String(cuFairy.wuxings[1]);
			tf_土.text = String(cuFairy.wuxings[2]);
			tf_水.text = String(cuFairy.wuxings[3]);
			tf_火.text = String(cuFairy.wuxings[4]);
			
//			cb_wuxing.selectedIndex = WuxingVO.getWuxing(String(cuFairy.@wuxing));
			skillNum = cuFairy.skills.length;
			updateSkills();
			
			var fairy:FairyVO = new FairyVO(0, cuFairy.id);
			fairy.data = cuFairy;
			mc_fairyPanel.init(fairy, []);
		}
		
		
		public var fairySkills:Array = [];
		public var skillNum:int = 0;
		
		public var attackNum:int = 1;
		public var nowAttackArr:Array = [];
		public var attackSkillNum:int = 0;
		public var attackSkillArr:Array = [];
		
		public var defendNum:int = 1;
		public var nowDefendArr:Array = [];
		public var defendSkillNum:int = 0;
		public var defendSkillArr:Array = [];
		
		
		public var sp_skill:ScrollPane;
		
		public function onSkillChange(e:*):void{
			switch(e.target){
				case btn_skill_add:
					skillNum++;
					if(skillNum>4) skillNum=4;
					updateSkills();
					break;
				case btn_skill_reduce:
					skillNum--;
					if(skillNum<0) skillNum=0;
					updateSkills();
					break;
				case btn_attack_skill_add:
					attackSkillNum++;
					if(attackSkillNum>5) attackSkillNum=5;
					updateAttackSkills();
					break;
				case btn_attack_skill_reduce:
					attackSkillNum--;
					if(attackSkillNum<0) attackSkillNum=0;
					updateAttackSkills();
					break;
				case btn_defend_skill_add:
					defendSkillNum++;
					if(defendSkillNum>5) defendSkillNum=5;
					updateDefendSkills();
					break;
				case btn_defend_skill_reduce:
					defendSkillNum--;
					if(defendSkillNum<0) defendSkillNum=0;
					updateDefendSkills();
					break;
				case btn_attack_add:
					attackNum++;
					if(attackNum>3) attackNum=3;
					updateFightFairys();
					break;
				case btn_attack_reduce:
					attackNum--;
					if(attackNum<1) attackNum=1;
					updateFightFairys();
					break;
				case btn_defend_add:
					defendNum++;
					if(defendNum>3) defendNum=3;
					updateFightFairys();
					break;
				case btn_defend_reduce:
					defendNum--;
					if(defendNum<1) defendNum=1;
					updateFightFairys();
					break;
			}
		}
		public function updateSkills():void{
			while(skill_container.numChildren){
				skill_container.removeChildAt(0);
			}
			
			var item:ComboBox;
			for(var i:int=0; i<skillNum; i++){
				if(i<fairySkills.length){
					item = fairySkills[i];
				}else{
					item = new ComboBox;
					item.dataProvider = skillData;
					fairySkills.push(item);
				}
				item.x = i*100;
				item.rowCount = 20;
				skill_container.addChild(item);
				if(i<cuFairy.skills.length){
					item.selectedIndex = skillInfo.getSkillIndex(cuFairy.skills[i]);
				}
			}
			sp_skill.source = skill_container;
//			saveSkill();
		}
		public function updateAttackSkills():void{
			while(skill_attack_container.numChildren){
				skill_attack_container.removeChildAt(0);
			}
			
			var item:ComboBox;
			for(var i:int=0; i<attackSkillNum; i++){
				if(i<attackSkillArr.length){
					item = attackSkillArr[i];
				}else{
					item = new ComboBox;
					item.dataProvider = skillData;
					attackSkillArr.push(item);
				}
				item.x = i%2*100;
				item.y = Math.floor(i/2)*25;
				item.rowCount = 20;
				if(i<cuFairy.skills.length){
					item.selectedIndex = skillInfo.getSkillIndex(cuFairy.skills[i]);
				}
				skill_attack_container.addChild(item);
			}
			sp_attack_skill.source = skill_attack_container;
			
		}
		public function updateDefendSkills():void{
			while(skill_defend_container.numChildren){
				skill_defend_container.removeChildAt(0);
			}
			
			var item:ComboBox;
			for(var i:int=0; i<defendSkillNum; i++){
				if(i<defendSkillArr.length){
					item = defendSkillArr[i];
				}else{
					item = new ComboBox;
					item.dataProvider = skillData;
					defendSkillArr.push(item);
				}
				item.x = i%2*100;
				item.y = Math.floor(i/2)*25;
				if(i<cuFairy.skills.length){
					item.selectedIndex = skillInfo.getSkillIndex(cuFairy.skills[i]);
				}
				skill_defend_container.addChild(item);
			}
			sp_defend_skill.source = skill_defend_container;
			
		}
		
		public function onSkillInfoUpdate(e:Event):void{
			//trace("skillInfoUpdate:"+skillInfo.skills.length());
			skillData = new DataProvider;
			for (var i:int=skillData.length; i<skillInfo.skills.length; i++) {
				var skill:SkillConfigVO = skillInfo.skills[i] as SkillConfigVO;
				skillData.addItem({label:skill.id+":"+skill.label});
			}
			for(i=0; i<fairySkills.length; i++){
				var item:ComboBox = fairySkills[i] as ComboBox;
				var index:int = item.selectedIndex;
				item.dataProvider = skillData;
				item.selectedIndex = index;
			}
		}
		
		public function getSkillID(index:int):int{
			return (skillInfo.skills[index] as SkillConfigVO).id;
		}
		
		
		public function onFightTest(e:Event):void{
			BaseInfo.SINGLE_CLEAR_SCORE = parseInt(tf_singleClearScore.text);
			this.visible = false;
			var fightvo:ServerGameStartVO = new ServerGameStartVO({gameid:1,
				atPlayerId:attackUserID,
				dePlayerId:defendUserID,
				boardNum:cb_boardRL.selectedItem.id,
				chessNum:parseInt(tf_chessNum.text),
				initNum:Math.floor(Math.random()*99999),
				seed:Math.floor(Math.random()*99999),
				skillInit:Math.floor(Math.random()*99999),
				skillSeed:Math.floor(Math.random()*99999),
				gameType:2,
				clear_kind:1,
				playerAttr:[parseInt(tf_attack_金.text),parseInt(tf_attack_木.text),parseInt(tf_attack_土.text),parseInt(tf_attack_水.text),parseInt(tf_attack_火.text)],
				defendAttr:[parseInt(tf_defend_金.text),parseInt(tf_defend_木.text),parseInt(tf_defend_土.text),parseInt(tf_defend_水.text),parseInt(tf_defend_火.text)],
				attackSkills:attackSkillArr.slice(0,attackSkillNum),
				defendSkills:defendSkillArr.slice(0,defendSkillNum)});
			fightvo.attackFairys = nowAttackArr;
			fightvo.defendFairys = nowDefendArr;
			//trace("________________1",cuFairy.skill, "1________________");
			//trace("________________2",mc_attackFairy0.fairyInfo.data, "2________________");
			MainDispatcher.dispatchInfo(new ObjectEvent(TEST_FAIRY_FIGHT, fightvo));
		}
		
		
		/**
		 * 关闭当前面板
		 * @param e
		 */
		public function closePanel(e:*=null):void {
			saveFairy();
			this.visible = false;
		}
	}
}
