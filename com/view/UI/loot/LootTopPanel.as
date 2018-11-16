package com.view.UI.loot
		{
			import com.model.event.ObjectEvent;
			import com.model.vo.loot.LootVO;
			import com.view.BasePanel;
			
			import flash.display.MovieClip;
			import flash.events.Event;
			import flas.events.MouseEvent;
			import flash.text.TextField;
			
			public class LootTopPanel extends BasePanel
			{
				public function LootTopPanel(){
					super();
					this.addEventListener(MouseEvent.CLICK,handle_click);
				}
				public function handle_click(e:*):void{
					switch(e.target){
						case btn_close:
							close();
							break;
					}
				}
				//****************   以上为模板，请勿随意改动。   *******************************
				//Function Names
				public static const E_CLICK_TOP:String = "E_CLICK_TOP";
				public static const SHOP_NAME:String = "商店";
				//Event Names 
				//场景含有组件
				public var tf_curLevelDesc:TextField;
				public var tf_curRewardDesc:TextField;
				public var tf_nextLevelDesc:TextField;
				public var tf_nextRewardDesc:TextField;
				public var tf_info:TextField;
				public var mc_cover:MovieClip;
				//
				
				public function updateInfo(lootVO:LootVO,topList:Array):void{
					tf_curLevelDesc.text = String(lootVO.configData.score);
					tf_curRewardDesc.text = lootVO.configData.description;
					tf_nextLevelDesc.text = String(lootVO.configData.next.score);
					tf_nextRewardDesc.text = lootVO.configData.next.description;
				}
				
			}
		}