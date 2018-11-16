package com.view.UI.animation {
	import com.model.ApplicationFacade;
	import com.greensock.TweenLite;
	import com.model.event.ObjectEvent;
	import com.model.vo.WuxingVO;
	import com.model.vo.animation.AnimationShowVO;
	import com.model.vo.animation.InfoShowVO;
	import com.model.vo.animation.LightningShowVO;
	import com.model.vo.chessBoard.BoardSkillActiveVO;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.chessBoard.SingleClearVO;
	import com.model.vo.skill.BoardSkillVO;
	import com.utils.MoveFactory;
	import com.view.UI.chessboard.ChessboardPanel;
	
	import flas.geom.Point;
	import flas.media.Sound;
	import flas.utils.utils;
	
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.system.ApplicationDomain;
	
	/**
	 * 动画展示层
	 * @author hunterxie
	 */
	public class AnimationPanel extends MovieClip{
		private static const SINGLETON_MSG:String="single_AnimationPanel_only";
		private static var instance:AnimationPanel;
		public static function getInstance():AnimationPanel{
			if ( instance == null ) instance=new AnimationPanel();
			return instance;
		}
		
		public var mc_lvUp:MovieClip;
		
		private var animationShowVO:AnimationShowVO;
		
		
		public static var wuxingLightningGlow:Array = [
			new GlowFilter(0xffff00, 1, 15, 15, 1.5),
			new GlowFilter(0x00ff00, 1, 15, 15, 1.5),
			new GlowFilter(0x993300, 1, 15, 15, 1.5),
			new GlowFilter(0x0000ff, 1, 15, 15, 1.5),
			new GlowFilter(0xff0000, 1, 15, 15, 1.5),
			new GlowFilter(0x00ff00, 1, 15, 15, 1.5),//空=1
			new GlowFilter(0x00ff00, 1, 15, 15, 1.5),//灰=1
			new GlowFilter(0xffff00, 1, 15, 15, 1.5),//钻=0
			new GlowFilter(0xff00ff, 1, 15, 15, 1.5)];
		//		public static function getLightningGlow(wuxing:String):GlowFilter{
		//			var gf:GlowFilter = wuxingLightningGlow[wuxing];
		//			if(!gf){
		//				gf = wuxingLightningGlow[0];
		//			}
		//			return gf;
		//		}
		public static var wuxingClearingGlow:Array = [
			null,
			new GlowFilter(0x00ff00, 1, 5, 5, 1.5),
			null,
			null,
			new GlowFilter(0xff0000, 1, 8, 8, 1.5),
			new GlowFilter(0x996600, 1, 15, 15, 1.5)]
		
		public static function getWuxingClearingMatrix(kind:int):Array{
			if(wuxingClearingMatrix[kind]==null){
				return [];
			}
			return [wuxingClearingMatrix[kind]];
		}
		public static var wuxingClearingMatrix:Array = [
			new ColorMatrixFilter([
				0,0,0,0,255,
				0,1,0,0,0,
				0,0,0.5,0,0,
				0,0,0,1,0]),
			new ColorMatrixFilter([
				0.75,0,0,0,0,
				0,1,0,0,0,
				0,0,0.75,0,0,
				0,0,0,1,0]),
			new ColorMatrixFilter([
				0,0,0,0,255,
				0,1,0,0,0,
				0,0,0,0,255,
				0,0,0,1,0]),
			null,
			new ColorMatrixFilter([
				0,0,0,0,255,
				0,1,0,0,0,
				0,0,1,0,0,
				0,0,0,1,0]),
			new ColorMatrixFilter([
				0,0,0,0,255,
				0,0.9,0,0,0,
				0,0,0.75,0,0,
				0,0,0,1,0])]
		
		/**
		 * 存放各种特效动画，通过元件名对应数组，
		 * 所有动画元件都遵循：播放完自我从舞台移除并且发出"playOver"事件，收到事件后进行回收进对象池
		 */
		private var effectPool:Object = {BoomEffect:[], LightningEffect:[], LightningEffect2:[], QiuClearEffect:[]};
		
		
		/**
		 * 动画层
		 * 
		 */
		public function AnimationPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			this.mouseEnabled=this.mouseChildren=false;
			if(mc_lvUp){
				mc_lvUp.visible=false;
//				mc_lvUp.addEventListener("lvUpMoviePlayOver", removeMC);
			}
			
			animationShowVO = AnimationShowVO.getInstance();
			animationShowVO.on(ApplicationFacade.SHOW_ANIMIATION, this, onShow);
		}
		
		private function onShow(e:ObjectEvent):void{
			var vo:AnimationShowVO = e.data as AnimationShowVO
			switch(vo.kind){						
				case AnimationShowVO.TEXT_INFO_SHOW:
					showTextInfo(vo.info as InfoShowVO);
					break;
				case AnimationShowVO.FIGHT_LIGHTNING_SHOW:
					showLightningLine(vo.info as LightningShowVO);
					break;
				case AnimationShowVO.WUXING_FIRE_BALL:
					showFireBall(vo.info as LightningShowVO);
					break;
				case AnimationShowVO.FIGHT_SKILL_LIGHTNING_SHOW:
					showSkillLightningEffect(vo.info as BoardSkillActiveVO);
					break;
				case AnimationShowVO.FIGHT_SKILL_BOOM_SHOW:
					showBoomEffect(vo.info as BoardSkillActiveVO);
					break;
				case AnimationShowVO.FIGHT_LV_UP:
					showLvUp();
					break;
				case AnimationShowVO.SOUND_PLAY:
					soundPlay(vo.info as String);
					break;
			}
		}
		
		
		/**
		 * 展示五行动画（抵抗、选择、成功。。。。）
		 * @param wuxingID
		 */
		public function showWuxing(wuxingID:int):void{
			
		}
		
		public function showLvUp():void{
			mc_lvUp.gotoAndPlay(2);
		}
		
		/**
		 * 展示战斗中棋盘的积分、伤害
		 * @param value
		 * @return 
		 */
		public function showTextInfo(vo:InfoShowVO):void{ 
			var info:TextInfoShow = TextInfoShow.getTextInfo(vo);
			TweenLite.to({},vo.delay,{onComplete:function(t:TextInfoShow):void{addChild(t)}, onCompleteParams:[info]});
		}

		
		/**
		 * 连锁闪电效果
		 * @param point1
		 * @param point2
		 * @param delayTime
		 * @param kind
		 */
		public function showLightningChain(vo:LightningShowVO):void{
			var lightning:MovieClip = getEffect("LightningEffectChain");
			lightning.x = vo.point1.x;
			lightning.y = vo.point1.y;
			lightning.rotation = Math.atan2((vo.point2.y-vo.point1.y), (vo.point2.x-vo.point1.x))*180/Math.PI;
			lightning.scaleX = Point.distance(vo.point1,vo.point2)/436;
			lightning.filters = [wuxingLightningGlow[vo.kind]];
			addChild(lightning);
			lightning.gotoAndPlay(2);
		}
		
		private function onDelay(vo:LightningShowVO):void{
			var lightning:MovieClip = getEffect("LightningEffectChain");
			lightning.x = vo.point1.x;
			lightning.y = vo.point1.y;
			lightning.rotation = Math.atan2((vo.point2.y-vo.point1.y), (vo.point2.x-vo.point1.x))*180/Math.PI;
			lightning.scaleX = Point.distance(vo.point1,vo.point2)/436;
			lightning.filters = [wuxingLightningGlow[vo.kind]];
			addChild(lightning);
			lightning.gotoAndPlay(2);
		}
		
		/**
		 * 直线闪电
		 * @param point1
		 * @param point2
		 * @param delayTime
		 * @param kind
		 */
		public function showLightningLine(vo:LightningShowVO):void{
			var lightning:MovieClip = getEffect("LightningEffectLine");
			lightning.x = vo.point1.x;
			lightning.y = vo.point1.y;
			lightning.rotation = Math.atan2((vo.point2.y-vo.point1.y), (vo.point2.x-vo.point1.x))*180/Math.PI;
			lightning.scaleX = Point.distance(vo.point1,vo.point2)/415;
			lightning.filters = [wuxingLightningGlow[vo.kind]];
			addChild(lightning);
			lightning.gotoAndPlay(2);
		}
		/**
		 * 连锁闪电
		 * @param vo
		 */
		public function showSkillLightningEffect(vo:BoardSkillActiveVO):void{
			for(var i:int=0; i<vo.clearArr.length; i++){
				var single:SingleClearVO = vo.clearArr[i] as SingleClearVO;
				var delay:Number = 0;
				if(vo.id==BoardSkillVO.CHESS_SKILL_KIND_1){
					for(var j:int=0; j<single.clearArr.length; j++){
						var qiuPoint:QiuPoint = j==0 ? vo.originalPoint : (single.clearArr[j-1] as QiuPoint);
						var point1:Point = ChessboardPanel.getQiuGlobalPoint(qiuPoint);
						var point2:Point = ChessboardPanel.getQiuGlobalPoint(single.clearArr[j] as QiuPoint);
						TweenLite.to({}, delay, {onComplete:showLightningChain, onCompleteParams:[new LightningShowVO(point1, point2, delay, vo.originalPoint.showKind)]});
						TweenLite.to({}, delay, {onComplete:showTextInfo, onCompleteParams:[new InfoShowVO("1", point2, WuxingVO.getColor(qiuPoint.showKind), 2)]});
						delay+=vo.interval;
					}
				}else{
					if(single.clearNum>0 || single.tarPoint){
						MoveFactory.shake(this.parent, 2, 2, 10);
						TweenLite.to({}, delay, {onComplete:showLightningLine, onCompleteParams:[new LightningShowVO(ChessboardPanel.getQiuGlobalPoint(single.tarPoint), ChessboardPanel.getQiuGlobalPoint(single.lastPoint), delay, vo.originalPoint.showKind)]});
					}	
				}
			}
		}
		public function showBoomEffect(skill:BoardSkillActiveVO):void{
//			var num:int = 0;
//			vo.clearArr.forEach(function(item:Array, index:int, arr:Array):void{num+=item.length});
			var scale:Number = 0.5+0.5*skill.lv;
			var boom:MovieClip = getEffect("BoomEffect");
			if(boom){
				var tarPoint:Point = ChessboardPanel.getQiuGlobalPoint(skill.originalPoint);
				boom.x = tarPoint.x;
				boom.y = tarPoint.y;
				boom.scaleX = boom.scaleY = scale;
				boom.gotoAndPlay(2);
				addChild(boom);
			}
			for(var i:int=0; i<skill.clearArr.length; i++){
				var vo:SingleClearVO = skill.clearArr[i] as SingleClearVO;
				for(var j:int=0; j<vo.clearArr.length; j++){
					var point:QiuPoint = vo.clearArr[j] as QiuPoint;
					if(point.showKind!=QiuPoint.KIND_NULL && point.showKind!=QiuPoint.KIND_GRAY){
						switch(skill.id){
							case BoardSkillVO.CHESS_SKILL_KIND_0:
							case BoardSkillVO.CHESS_SKILL_KIND_1:
							case BoardSkillVO.CHESS_SKILL_KIND_2:
							case BoardSkillVO.CHESS_SKILL_KIND_3://技能消除
								showTextInfo(new InfoShowVO("1", ChessboardPanel.getQiuGlobalPoint(point), WuxingVO.getColor(point.showKind), 2));
								break;
						}
					}
				}
			}
		}
		private function getEffect(name:String):MovieClip{
			if(!effectPool[name]) effectPool[name]=[];
			var arr:Array = effectPool[name] as Array;
			if(arr.length>0){
				return arr.shift() as MovieClip;
			}
//			try{
				var obj:MovieClip = utils.getDefinitionByName(name) as MovieClip;
				obj.addEventListener("playOver", effectPlayOver)
				return obj;
//			}catch(e:Error) {
//				showMSG("getEffectError:"+name+"_"+e.toString());
//			}
//			return null;
		}
		private function effectPlayOver(e:*):void{
			var name:String = utils.getQualifiedClassName(e.target);
			var arr:Array = effectPool[name] as Array;
			arr.push(e.target);
		}
		
		public function soundPlay(info:String):void{
			return;//TODO
			var sound:Sound;
			sound = utils.getDefinitionByName(info) as Sound;
			if(sound) sound.play();
		}
		
		public function addBloomEffect(point:Point):void{
			
		}
		
		/**
		 * 五行法球动画
		 * @param param0
		 */
		public function showFireBall(vo:LightningShowVO):void{
			var fireBall:MovieClip = getEffect("QiuClearEffect");
			fireBall.x = vo.point1.x;
			fireBall.y = vo.point1.y;
			fireBall.scaleX = fireBall.scaleY = 0.8;
			fireBall.filters = getWuxingClearingMatrix(vo.kind);
			fireBall.gotoAndStop(2);
			addChild(fireBall);
			TweenLite.to(fireBall, vo.delayTime, {x:vo.point2.x, y:vo.point2.y, onComplete:function():void{fireBall.gotoAndPlay(2)}});
		}
	}
}