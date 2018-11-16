package com.view.UI.tip {
	import com.model.ApplicationFacade;
	import com.greensock.TweenLite;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.logic.ChessBoardLogic;
	import com.model.logic.LevelGameLogic;
	import com.model.vo.config.guide.GuideConfig;
	import com.model.vo.config.guide.GuideConfigVO;
	import com.model.vo.level.LevelOverVO;
	import com.model.vo.user.UserVO;
	import com.utils.ShapeFactory;
	import com.view.BasePanel;
	import com.view.UI.fight.FightPanel;
	import com.view.UI.level.LevelFailurePanel;
	import com.view.UI.chessboard.PuzzlePanel;
	import com.view.UI.playerEditor.PlayerEditorPanel;
	import com.view.UI.user.WuxingInfoPanel;
	
	import flas.events.MouseEvent;
	import flas.geom.Point;
	import flas.geom.Rectangle;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * 引导点击/交换提示面板
	 * @author hunterxie
	 */
	public class GuidePanel extends BasePanel {
		public static const NAME:String = "GuidePanel";
		public static const SINGLETON_MSG:String="single_GuidePanel_only";
		protected static var instance:GuidePanel;
		public static function getInstance():GuidePanel{
			if ( instance == null ) instance=new GuidePanel();
			return instance as GuidePanel;
		}
		
		/**
		 * 新玩家通过最初引导(最少)判断
		 */
		public static const newUserPassNum:int = 5;
		
		
		/**
		 * 放提示动画的容器，居中，不可点击
		 */
		public var mc_touch:Sprite;
		
		/**
		 * 中空矩形覆盖层，遮挡用户点击
		 */
		public var mc_touch_cover:Sprite;
		
		public var mc_guider:GuideFairy;
		
		/**
		 * 点击提示按钮
		 */
		private var touchFocus:MovieClip;
		
		private var tipFocus:Array = [];
		
		private const bg_alpha:Number = 0.3;
		
		public var vo:GuideConfigVO;
		
		
		private var guideAskTip:GuideAskTip;
		
		public function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		
		
		/**
		 * 
		 * 
		 */
		public function GuidePanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			touchFocus = new GuideTouchFocus;
			
			this.mouseEnabled = false;
			this.mc_guider.mouseEnabled = this.mc_guider.mouseChildren = false;
			this.mc_touch.mouseChildren = this.mc_touch.mouseEnabled = false;
			
			guideAskTip = GuideAskTip.getInstance();
			guideAskTip.on(BasePanel.CLOSE_PANEL, this, onAskClose);
			
			EventCenter.on(ApplicationFacade.SHOW_PANEL_SUCCESS, this, onShowPanel);
			EventCenter.on(ApplicationFacade.GUIDE_GET_WUXING_BOX, this, onGetBox);
			EventCenter.on(ApplicationFacade.GUIDE_WUXING_PANEL_SHOW_OVER, this, wuxingShowOver);
		}
		
		
		private function wuxingShowOver(e:ObjectEvent):void{
			judgeGuidePremise(GuideConfigVO.GUIDE_PREMISE_KIND_6);
		}
		
		private function onGetBox(e:ObjectEvent):void{
			judgeGuidePremise(GuideConfigVO.GUIDE_PREMISE_KIND_4);
		}
		
		private function onShowPanel(e:ObjectEvent):void{
			switch(e.data){
				case PuzzlePanel.NAME:
				case FightPanel.NAME:
					var id:int = FightPanel.getInstance().fightInfo.levelVO.id;
					LevelFailurePanel.getInstance()
					if(LevelOverVO.nowFailueID==id){
						judgeGuidePremise(GuideConfigVO.GUIDE_PREMISE_KIND_8, id);
					}else{
						judgeGuidePremise(GuideConfigVO.GUIDE_PREMISE_KIND_1, id);
					}
					break;
				case LevelFailurePanel.NAME:
					judgeGuidePremise(GuideConfigVO.GUIDE_PREMISE_KIND_3, id);
					break;
				case WuxingInfoPanel.NAME:
					judgeGuidePremise(GuideConfigVO.GUIDE_PREMISE_KIND_6);
					break;
				case PlayerEditorPanel.NAME:
					judgeGuidePremise(GuideConfigVO.GUIDE_PREMISE_KIND_7);
					break;
			}
		}
		
		override public function close(e:*=null):void{
			EventCenter.event(ApplicationFacade.GUIDE_MISSION_CONFIRM, vo.id);
			userInfo.guideOver(this.vo.id);
			judgeGuidePremise(GuideConfigVO.GUIDE_PREMISE_KIND_0, vo.id);
		}
		
		protected function onAskClose(event:ObjectEvent):void{
			userInfo.guideOver(guideAskTip.vo.guideID);
			judgeGuidePremise(GuideConfigVO.GUIDE_PREMISE_KIND_5, guideAskTip.vo.id, guideAskTip.vo.choosed);
		}
		
		/**
		 * 判断满足条件的首个guide
		 * @param premise	前提ID
		 * @param id		对应的ID（如levelID）
		 * @return 			是否成功激活guide
		 */
		public function judgeGuidePremise(premise:int, id:int=0, choice:int=0):void{
			var vo:GuideConfigVO = GuideConfig.judgeGuidePremise(premise, id, choice);
			if(vo && vo.judgeIsShow(userInfo.guides[vo.id])){
				if(vo.kind==GuideConfigVO.GUIDE_KIND_ASK){//让提示选择面板来展示 
					TweenLite.to({},0.5,{onComplete:delayShowGuide, onCompleteParams:[GuideConfig.getGuideAsk(vo)]});
				}else{
					TweenLite.to({},0.3,{onComplete:delayShowGuide, onCompleteParams:[vo]}); 
				}
			}
		}
		
		private function delayShowGuide(vo:*):void{
			if(vo.kind==GuideConfigVO.GUIDE_KIND_FOCUS){
				vo.points = ChessBoardLogic.getInstance().getTarBuffBalls(LevelGameLogic.getInstance().levelVO.targetClearBuff);
			}
			EventCenter.event(ApplicationFacade.SHOW_PANEL, GuideAskTip.getShowName(vo));
		}
		
		/**
		 * <guide ID="3" kind1="0" premise="1">
				<point>442,473:2</point>
				<point>442,394:2</point>
				<info>这里需要快速移动这两颗棋子消除哦</info>
				<notes>第一个快消关卡提示玩家快速移动两颗棋子</notes>
			</guide>
		 * @param vo
		 */
		public function updateInfo(vo:GuideConfigVO):void{
			this.vo = vo; 
			while(mc_touch.numChildren){
				var mc:Sprite = mc_touch.getChildAt(0) as Sprite;
				if(mc is ExchangeTip){
					ExchangeTip.push(mc as ExchangeTip);
				}else if(mc is GuideFocusTip){
					GuideFocusTip.push(mc as GuideFocusTip);
				}
				mc_touch.removeChildAt(0); 
			}
			mc_guider.updateInfo(vo.info);
			var rects:Array = [];
			var point:Point = vo.points[0];
			switch(vo.kind){
				case GuideConfigVO.GUIDE_KIND_NULL:
					mc_guider.x = 271;
					mc_guider.y = 232;
					while(mc_touch_cover.numChildren) mc_touch_cover.removeChildAt(0);
					mc_touch_cover.addChild(ShapeFactory.newRect(0,0,stage.stageWidth, stage.stageHeight, 0, bg_alpha));
					mc_touch_cover.addEventListener(MouseEvent.CLICK, onNomalClick);
					return;
				case GuideConfigVO.GUIDE_KIND_CLICK:
					touchFocus.x = point.x;
					touchFocus.y = point.y;
					mc_touch.addChild(touchFocus);
					rects.push(touchFocus.getRect(stage));
					break;
				case GuideConfigVO.GUIDE_KIND_CHANGE:
				case GuideConfigVO.GUIDE_KIND_QUICK_CHANGE:
					for(var i:int=0; i<vo.points.length; i++){
//						vo.updateChangePoints();
						var change:MovieClip = vo.kind==GuideConfigVO.GUIDE_KIND_CHANGE ? ExchangeTip.getExchangeTip(vo.points[i]) : QuickChangeTip.getQuickChangeTip(vo.points[i]);
						mc_touch.addChild(change);
						rects.push(change.getRect(stage));
					}
					break;
				case GuideConfigVO.GUIDE_KIND_FOCUS:
					for(var i:int=0; i<vo.points.length; i++){
						var focu:MovieClip = GuideFocusTip.getGuideFocusTip(vo.points[i]);
						mc_touch.addChild(focu);
						rects.push(focu.getRect(stage));
					} 
					TweenLite.to(this, 2, {onComplete:close});
					break;
				case GuideConfigVO.GUIDE_KIND_ASK:
					
					break;
			}
			
			if(stage){
				var rect:Rectangle = Rectangle.changeRectangle(mc_touch.getRect(stage));
				mc_guider.x = rect.x-mc_guider.width/2-60;
				if(mc_guider.x<0){
					mc_guider.x = rect.x+rect.width;
				}else if(mc_guider.x+mc_guider.width>BaseInfo.fullScreenWidth){
					mc_guider.x = BaseInfo.fullScreenWidth-mc_guider.width;
				}
					
				mc_guider.y = rect.y+rect.height-50;
				if(mc_guider.y>(BaseInfo.fullScreenHeight-mc_guider.height)){
					mc_guider.y = rect.y-mc_guider.height;
				}
			
				while(mc_touch_cover.numChildren) mc_touch_cover.removeChildAt(0);
				mc_touch_cover.addChild(ShapeFactory.middleEmptyRect(rect,
					new Rectangle(0, 0, BaseInfo.fullScreenWidth, BaseInfo.fullScreenHeight),
					0, bg_alpha));
//				mc_touch_cover.addChild(ShapeFactory.shapeEraser(mc_touch,
//					new Rectangle(0, 0, BaseInfo.fullScreenWidth, BaseInfo.fullScreenHeight),
//					0, bg_alpha)); 
			}
		}
		
		/**
		 * 判断是否点中提示范围的内容
		 * @param event
		 */
		public function onc(event:*):void	{
//			trace(mc_touch.hitTestPoint(stage.mouseX, stage.mouseY));
			if(event.type==MouseEvent.MOUSE_DOWN && vo.kind==GuideConfigVO.GUIDE_KIND_CHANGE ||
				event.type==MouseEvent.MOUSE_DOWN && vo.kind==GuideConfigVO.GUIDE_KIND_QUICK_CHANGE ||
				event.type==MouseEvent.MOUSE_DOWN && vo.kind==GuideConfigVO.GUIDE_KIND_FOCUS ||
				event.type==MouseEvent.CLICK && vo.kind==GuideConfigVO.GUIDE_KIND_CLICK){
				if(mc_touch.hitTestPoint(stage.mouseX, stage.mouseY)){
					close();
				}
			}
		}
		
		private function onNomalClick(e:*):void{ 
			mc_touch_cover.removeEventListener(MouseEvent.CLICK, onNomalClick);
			close();
		}
		
		public static function getShowName(vo:GuideConfigVO):String{
			getInstance().updateInfo(vo);
			return NAME;
		}
	}
}
