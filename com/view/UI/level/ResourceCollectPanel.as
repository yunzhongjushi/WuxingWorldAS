package com.view.UI.level{
	import com.model.logic.BaseGameLogic;
	import com.model.logic.LevelGameLogic;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.view.UI.chessboard.ResourceCollect;

	/**
	 * 资源/棋子收集展示面板
	 * @author hunterxie
	 */
	public class ResourceCollectPanel extends Sprite{
		public static const NAME:String = "ResourceCollectPanel";
		public static const SINGLETON_MSG:String="single_ResourceCollectPanel_only";
		protected static var instance:ResourceCollectPanel;
		public static function getInstance():ResourceCollectPanel{
			if ( instance == null ) instance=new ResourceCollectPanel();
			return instance;
		}
		
		
		/**
		 * 收集元素
		 */
		public var mc_resource0:MovieClip;
		public var mc_resource1:MovieClip;
		public var mc_resource2:MovieClip;
		
		/**
		 * 收集棋子
		 */
		public var mc_base:ResourceCollect;
		public var mcArr:Array;
		public var vo:LevelGameLogic;
		
		public function ResourceCollectPanel(){ 
			mc_base.mouseChildren=mc_base.mouseEnabled=false;
			mcArr = [mc_base];
			
			mc_resource0.visible = mc_resource1.visible = mc_resource2.visible = false;
		}
		
		private function reset():void{
			if(this.vo){
				this.vo.removeEventListener(BaseGameLogic.UPDATE_COLLECT_INFO, updateInfo);
				this.vo.removeEventListener(BaseGameLogic.UPDATE_GAME_INFO, updateInfo);
				this.vo = null;
			}
		}
		
		public function init(vo:LevelGameLogic):void{
			reset();
			this.vo = vo;
			this.vo.addEventListener(BaseGameLogic.UPDATE_GAME_INFO, updateInfo);
//			var n:int = Math.max(mcArr.length, vo.tarResource.length);
			for(var n:int=0; n<mcArr.length; n++){
				mcArr[n].visible=false;
			}
			var i:int = 0;
			for(var na:* in vo.tarResource){
				var mc:ResourceCollect;
				if(i>=mcArr.length){
					mc = new ResourceCollect;
					mc.y = mc_base.height*i;
					mcArr.push(mc);
					addChild(mc);
				}else{
					mc = mcArr[i] as ResourceCollect;
				}
				mc.mouseChildren=mc.mouseEnabled=false;
				mcArr[na] = mc;
				mc.visible = true;
				mc.kind = na;
				mc.tf_num.text = 0+"/"+vo.tarResource[na];
				i++;
			}
			vo.addEventListener(BaseGameLogic.UPDATE_COLLECT_INFO, updateInfo);
		}
		
		/**
		 * 展示收集到的资源
		 * @param e
		 */
		public function updateInfo(e:Event):void{
			for(var name:String in vo.tarResource){
				var mc:ResourceCollect = mcArr[name] as ResourceCollect;
				if(vo.boardUserInfo.resourceCollect[name]>0){
					if(vo.boardUserInfo.resourceCollect[name]>vo.tarResource[name]){
						vo.boardUserInfo.resourceCollect[name] = vo.tarResource[name];
					}
					mc.tf_num.text = vo.boardUserInfo.resourceCollect[name]+"/"+vo.tarResource[name];
				}
			}
		}
	}
}