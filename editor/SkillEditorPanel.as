package editor{
	import com.greensock.TweenLite;
	import com.model.event.ObjectEvent;
	import com.model.vo.WuxingVO;
	import com.model.vo.config.skill.BuffConfigVO;
	import com.model.vo.config.skill.SkillConfig;
	import com.model.vo.config.skill.SkillConfigVO;
	import com.utils.ArrayFactory;
	import com.utils.TextFactory;
	import com.view.touch.CommonBtn;
	
	import fl.containers.ScrollPane;
	import fl.controls.ComboBox;
	import fl.controls.List;
	import fl.data.DataProvider;
	
	import flas.net.URLLoader;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 技能编辑器面板
	 * @author hunterxie
	 */
	public class SkillEditorPanel extends Sprite {
		public static const SKILL_INFO_UPDATE:String = "skillInfoUpdate";
		
		public static const NAME:String = "SkillEditorPanel";
		public static const SINGLETON_MSG:String = "single_SkillEditorPanel_only";
		protected static var instance:SkillEditorPanel;
		public static function getInstance():SkillEditorPanel{
			if ( instance == null ) instance = new SkillEditorPanel();
			return instance;
		}
		
		public var skillInfoVO:SkillConfig;// = SkillInfo.getInstance();
		public var cuSkill:SkillConfigVO;
		public var cuBuff:BuffConfigVO;
		
		public var tf_cost_金:TextField;
		public var tf_cost_木:TextField;
		public var tf_cost_土:TextField;
		public var tf_cost_水:TextField;
		public var tf_cost_火:TextField;
		
		public var tf_priority:TextField;
		public var tf_replaceKind:TextField;
		
		public var tf_ID:TextField;
		public var tf_name:TextField;
		public var tf_CD:TextField;
		public var tf_power:TextField;
		public var tf_hit:TextField;
		public var tf_buffID:TextField;
		public var tf_buffName:TextField;
		public var tf_buffInfo:TextField;
		public var tf_buffCollect:TextField;
		
		public var btn_close:CommonBtn;
		public var btn_addSkill:CommonBtn;
		public var btn_addBuff:CommonBtn;
		public var btn_addEffect:CommonBtn;
		public var btn_reduceEffect:CommonBtn;
		public var btn_addBuffSkill:CommonBtn;
		public var btn_reduceBuffSkill:CommonBtn;
		public var btn_goFairy:CommonBtn;
		public var btn_export:CommonBtn;
		
		public var list_skill:List;
		public var cb_wuxing:ComboBox;
		public var cb_useKind:ComboBox;
		public var cb_effect:ComboBox;
		public var cb_skillEquipKind:ComboBox;
		public var cb_buffPosition:ComboBox;
		public var tf_skillInfo:TextField;
		public var skillEffectContainer:SkillEffectContainer;
		public var buffEffectContainer:SkillEffectContainer;
		public var sp_skillEffects:ScrollPane;
		public var sp_buffEffects:ScrollPane;
		public var cb_buffWuxing:ComboBox;
		
		public var cb_icon:ComboBox;
		public var cb_buffIcon:ComboBox;
		public var cb_effectTurn:ComboBox;
		public var cb_continueTurn:ComboBox;
		public var cb_layer:ComboBox;
		public var cb_isDebuff:ComboBox;
		public var cb_replaceKind:ComboBox;
		public var cb_priority:ComboBox;
		
		public var wuxingKind:DataProvider;
		public var list_buff:List;
		
		public var loader:URLLoader;
		
		
		
		
		/*********************************
		 *
		 * 
		 * 
		 *********************************/
		public function SkillEditorPanel(){
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			sp_skillEffects.source = skillEffectContainer;
			sp_buffEffects.source = buffEffectContainer;
			
			
			list_skill.addEventListener(Event.CHANGE, electSkill);
			list_buff.addEventListener(Event.CHANGE, electBuff);
			
			btn_close.setNameTxt("关闭");
			btn_close.addEventListener(MouseEvent.CLICK, closePanel);
			
			btn_addSkill.setNameTxt("增加技能");
			btn_addSkill.addEventListener(MouseEvent.CLICK, addSkill);
			
			btn_addBuff.setNameTxt("增加buff");
			btn_addBuff.addEventListener(MouseEvent.CLICK, addBuff);
			
			btn_addEffect.setNameTxt("增加效果");
			btn_addEffect.addEventListener(MouseEvent.CLICK, addSkillEffect);
			
			btn_reduceEffect.setNameTxt("减少效果");
			btn_reduceEffect.addEventListener(MouseEvent.CLICK, reduceSkillEffect);
			
			btn_addBuffSkill.setNameTxt("加buff效");
			btn_addBuffSkill.addEventListener(MouseEvent.CLICK, addBuffEffect);
			
			btn_reduceBuffSkill.setNameTxt("减buff效");
			btn_reduceBuffSkill.addEventListener(MouseEvent.CLICK, reduceBuffEffect);
			
			btn_goFairy.setNameTxt("编辑精灵");
			btn_goFairy.addEventListener(MouseEvent.CLICK, goFairy);
			
			btn_export.setNameTxt("导出内容");
			btn_export.addEventListener(MouseEvent.CLICK, export);
			
//			if(true){//BaseInfo.isLoadConfig){
//				loader = new URLLoader(new URLRequest("skillInfo.json"));
//				loader.addEventListener(Event.COMPLETE, onLoaded);
//			}else{
				TweenLite.to({}, 0.5, {onComplete:onLoaded});
//			}
		}
		
		
		public function onLoaded(e:Event=null):void{
			skillInfoVO = SkillConfig.getInstance();
			skillInfoVO.updateObj(BaseInfo.skillInfo);//JSON.parse(String(LoadProxy.getLoadInfo("skillInfo.json")));
//			if(true){//BaseInfo.isLoadConfig){
//				skillInfoVO.updateObj(JSON.parse(e.target.data));
////				info = XML(loader.data);
////				skillInfoVO.updateByXML(info);
////				BaseInfo.setSkillInfo(info);
//			}else{
////				info = WuxingEditorPanel.skillInfo = BaseInfo.skillInfo;
//			}
			wuxingKind = new DataProvider(skillInfoVO.infos.wuxing);
			dispatchEvent(new ObjectEvent(SKILL_INFO_UPDATE));
			//trace(info.skillKind.items);
//			cb_buffWuxing.dataProvider=cb_wuxing.dataProvider=wuxingKind;
			cb_buffWuxing.visible=cb_wuxing.visible=false;
			cb_icon.dataProvider = 									new DataProvider(skillInfoVO.infos.skillIcons);
			cb_buffIcon.dataProvider = 								new DataProvider(skillInfoVO.infos.buffIcons);
			cb_useKind.dataProvider =								new DataProvider(skillInfoVO.infos.useKind);
			cb_continueTurn.dataProvider=cb_effectTurn.dataProvider=new DataProvider(skillInfoVO.infos.turns);
			cb_layer.dataProvider =									new DataProvider(skillInfoVO.infos.layer);
			cb_isDebuff.dataProvider = 								new DataProvider(skillInfoVO.infos.isDebuff);
			cb_skillEquipKind.dataProvider = 						new DataProvider(skillInfoVO.infos.equipKind);
			cb_buffPosition.dataProvider = 							new DataProvider(skillInfoVO.infos.buffPosition);
			
			cb_replaceKind.dataProvider = 							new DataProvider(skillInfoVO.infos.replaceKind);
			cb_priority.dataProvider = 								new DataProvider(skillInfoVO.infos.priority);
			
			updateTotalInfo();
		}
		
		public function updateTotalInfo():void{
			skillEffectContainer.initInfo();
			buffEffectContainer.initInfo();
			
//			var skillp:DataProvider = new DataProvider(skillInfoVO.skills);//info.skills[0]);
//			for (var i:int=0; i<skillInfoVO.skills.length; i++) {
//				skillp.addItem({id:skillInfoVO.skills[i].id, label:info.skills.skill[i].@id+":"+info.skills.skill[i].@label});
//			}
			list_skill.dataProvider = new DataProvider(skillInfoVO.skills);
			showSkill(skillInfoVO.skills[0]);
			
//			var buffp:DataProvider=new DataProvider();//info.buffs[0]);
//			for (i=0; i<info.buffs.buff.length(); i++) {
//				buffp.addItem({id:info.buffs.buff[i].@id, label:info.buffs.buff[i].@id+":"+info.buffs.buff[i].@label});
//			}
			list_buff.dataProvider = new DataProvider(skillInfoVO.buffs);
			showBuff(skillInfoVO.buffs[0]);
		}
		
		
		/**
		 * 关闭当前面板
		 * @param e
		 */
		public function closePanel(e:*=null):void {
			saveSkill();
			saveBuff();
			this.visible = false;
		}
		
		/**
		 * 增加技能
		 * @param e
		 */
		public function addSkill(e:*=null):void {
//			if(info){
//				saveSkill();
//				skillInfoT.@id = parseInt(info.skills.skill[info.skills.skill.length()-1].@id)+1;
//				skillInfoT.@label = "skill_"+skillInfoT.@id;
//				info.skills.appendChild(new XML(skillInfoT));
//				
//				var skillp:DataProvider=new DataProvider(info.skills[0]);
//				list_skill.dataProvider=skillp;
//				showSkill(info.skills.skill[info.skills.skill.length()-1]);
//			}
				
			saveSkill();
			var skill:SkillConfigVO = skillInfoVO.addSkill();
//			list_skill.dataProvider.addItem({label:skill.label+"("+skill.id+")"});
			list_skill.dataProvider = new DataProvider(skillInfoVO.skills);
			list_skill.selectedIndex = list_skill.dataProvider.length-1;
			showSkill(skill);
		}
		
		/**
		 * 增加buff
		 * @param e
		 */
		public function addBuff(e:*=null):void {
//			if(info){
//				saveBuff();
//				buffInfoT.@id = parseInt(info.buffs.buff[info.buffs.buff.length()-1].@id)+1;
//				buffInfoT.@label = "buff_"+buffInfoT.@id;
//				info.buffs.appendChild(new XML(buffInfoT));
				
//				var buffp:DataProvider = new DataProvider(info.buffs[0]);
//				list_buff.dataProvider = buffp;
//				showBuff(info.buffs.buff[info.buffs.buff.length()-1]);
//				
//				skillEffectContainer.initInfo(info);
//			}
			
			saveBuff();
			var buff:BuffConfigVO = skillInfoVO.addBuff();
//			list_buff.dataProvider.addItem({label:buff.label+"("+buff.id+")"});
			list_buff.dataProvider = new DataProvider(skillInfoVO.buffs);
			list_buff.selectedIndex = list_buff.dataProvider.length-1;
			showBuff(buff);
		}
		
		/**
		 * 增加技能效果
		 * @param e
		 */
		public function addSkillEffect(e:*=null):void {
			if(cuSkill){
				saveSkill();
				cuSkill.addEffect();
				showSkill(cuSkill);
			}
		}
		
		/**
		 * 减少技能效果
		 * @param e
		 */
		public function reduceSkillEffect(e:*=null):void {
			if(cuSkill && cuSkill.effects.length>1){
				saveSkill();
				cuSkill.reduceEffect();
				showSkill(cuSkill);
			}
		}
		
		/**
		 * 增加buff效果
		 * @param e
		 */
		public function addBuffEffect(e:*=null):void {
			if(cuBuff){
				saveBuff();
				cuBuff.addEffect();
				showBuff(cuBuff);
			}
		}
		
		/**
		 * 减少buff效果
		 * @param e
		 */
		public function reduceBuffEffect(e:*=null):void {
			if(cuBuff && cuBuff.effects.length>1){
				saveBuff();
				cuBuff.reduceEffect();
				showBuff(cuBuff);
			}
		}
		
		/**
		 * 编辑精灵
		 * @param e
		 */
		public function goFairy(e:*=null):void {
			saveSkill();
			saveBuff();
			this.visible = false;
			WuxingWorldEditorPanel.getInstance().fairyEditorPanel.visible = true;
		}
		
		/**
		 * 保存技能
		 * @param e
		 */
		public function saveSkill(e:*=null):void {
			if(!cuSkill) return;
			cuSkill.id = parseInt(tf_ID.text);
			cuSkill.label = tf_name.text;
			cuSkill.cd = parseInt(tf_CD.text);
			cuSkill.power = parseInt(tf_power.text);
			cuSkill.hit = parseInt(tf_hit.text);
			cuSkill.describe = tf_skillInfo.text;
			for(var i:int=0; i<WuxingVO.wuxingArr.length; i++){
				cuSkill.cost[i] = parseInt(this["tf_cost_"+WuxingVO.wuxingArr[i]]["text"]);
			}
			
			cuSkill.icon = cb_icon.selectedLabel;//cb_icon.selectedIndex;
			cuSkill.useKind = cb_useKind.selectedIndex;
//			cuSkill.wuxing = cb_wuxing.selectedItem.id;
			cuSkill.equipKind = cb_skillEquipKind.selectedIndex;
			
			skillEffectContainer.saveInfo();
			dispatchEvent(new Event(SKILL_INFO_UPDATE));
		}
		
		/**
		 * 保存buff
		 * @param e
		 */
		public function saveBuff(e:*=null):void {
			if(!cuBuff) return;
			cuBuff.id 			= parseInt(tf_buffID.text);
			//list_buff.selectedItem.label = 
			cuBuff.label 		= tf_buffName.text;
			cuBuff.describe 	= tf_buffInfo.text;
			cuBuff.collect 		= parseInt(tf_buffCollect.text);
			cuBuff.icon 		= cb_buffIcon.selectedLabel;//cb_buffIcon.selectedIndex; 
//			cuBuff.wuxing = cb_buffWuxing.selectedItem.id;
			cuBuff.continuedTime= cb_continueTurn.selectedItem.value;
			cuBuff.effectTime 	= cb_effectTurn.selectedItem.value;
			cuBuff.maxLayer 		= cb_layer.selectedItem.value;
			cuBuff.isDebuff 	= cb_isDebuff.selectedIndex;
			cuBuff.buffPosition = cb_buffPosition.selectedIndex;
			cuBuff.replaceKind 	= cb_replaceKind.selectedIndex;
			cuBuff.priority 	= cb_priority.selectedIndex;
			
			buffEffectContainer.saveInfo();
		}
		
		/**
		 * 导出skillInfo.json
		 * @param e
		 */
		public function export(e:*=null):void {
			saveSkill();
			saveBuff();
			
			var vo:Object = skillInfoVO.getChangeVO();
			var outinfo:String = JSON.stringify(vo);
//			var outinfo:String = JSON.stringify(skillInfoVO);
			TextFactory.outputFile(outinfo, "skillInfo.json");
		}
		
		/**
		 * 展示一个选择的技能
		 * @param e
		 * 
		 */
		public function electSkill(e:Event):void {
			saveSkill();
//			showSkill(info.skills.skill[list_skill.selectedIndex]);
			showSkill(list_skill.selectedItem as SkillConfigVO);
		}
		
		/**
		 * 显示一个技能
		 * @param skillInfo
		 */		
		public function showSkill(skillInfo:SkillConfigVO):void{
			cuSkill = skillInfo;
			tf_name.text = cuSkill.label;
			tf_ID.text = String(cuSkill.id);
			tf_CD.text = String(cuSkill.cd);
			tf_power.text = String(cuSkill.power);
			tf_hit.text = String(cuSkill.hit);
			tf_skillInfo.text = cuSkill.describe;
			for(var i:int=0; i<WuxingVO.wuxingArr.length; i++){
				this["tf_cost_"+WuxingVO.wuxingArr[i]]["text"] = cuSkill.cost[i];
			}
			
			cb_icon.selectedIndex = ArrayFactory.getIndexObj(skillInfoVO.infos.skillIcons, "label", cuSkill.icon);//cuSkill.icon;
			cb_useKind.selectedIndex = cuSkill.useKind;
//			cb_wuxing.selectedIndex = cuSkill.wuxing;
			cb_skillEquipKind.selectedIndex = cuSkill.equipKind;
			
			skillEffectContainer.updateInfo(cuSkill.effects);
			sp_skillEffects.source = skillEffectContainer;
		}
		
		
		/**
		 * 展示一个选择的buff
		 * @param e
		 */
		public function electBuff(e:Event):void {
			saveBuff();
//			showBuff(info.buffs.buff[list_buff.selectedIndex]);
			showBuff(list_buff.selectedItem as BuffConfigVO);
		}
		
		/**
		 * 显示一个buff
		 * @param buffInfo
		 */
		public function showBuff(buffInfo:BuffConfigVO):void{
			cuBuff = buffInfo;
			//trace("________________________________1\n"+buffInfo);
			tf_buffName.text = cuBuff.label;
			tf_buffID.text = String(cuBuff.id);
			tf_buffInfo.text = cuBuff.describe;
			tf_buffCollect.text = String(cuBuff.collect);
			cb_buffIcon.selectedIndex = ArrayFactory.getIndexObj(skillInfoVO.infos.buffIcons, "label", cuBuff.icon);//cuBuff.icon;
//			cb_continueTurn.selectedIndex = skillInfoVO.infos.turns.time.(@value==cuBuff.@continuedTime)[0].@id;
			cb_continueTurn.selectedIndex = ArrayFactory.getIndexObj(skillInfoVO.infos.turns, "value", cuBuff.continuedTime);
//			cb_effectTurn.selectedIndex = info.skillKind.turns.time.(@value==cuBuff.@effectTime)[0].@id;
			cb_effectTurn.selectedIndex = ArrayFactory.getIndexObj(skillInfoVO.infos.turns, "value", cuBuff.effectTime);
			cb_buffWuxing.selectedIndex = cuBuff.wuxing;
//			cb_layer.selectedIndex = info.skillKind.layer.time.(@value==cuBuff.@layer)[0].@id;
			cb_layer.selectedIndex = cuBuff.maxLayer-1;
			cb_isDebuff.selectedIndex = cuBuff.isDebuff;
			cb_buffPosition.selectedIndex = cuBuff.buffPosition;
			
			cb_replaceKind.selectedIndex = cuBuff.replaceKind;
			cb_priority.selectedIndex = cuBuff.priority;
			
			buffEffectContainer.updateInfo(cuBuff.effects);
			sp_buffEffects.source = buffEffectContainer;
		}
	}
}
