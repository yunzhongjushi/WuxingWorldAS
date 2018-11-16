package com.view.UI.fairy {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.conn.ServerVO_68;
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.fairy.FairyListVO;
	import com.model.vo.fairy.TipFairyVO;
	import com.view.BasePanel;
	
	import flash.events.Event;

	/**
	 * 新获得精灵提示面板
	 * @author hunterxie
	 *
	 */
	public class TipFairyPanel extends BasePanel {
		public static const NAME:String="TipFairyPanel";
		private static const SINGLETON_MSG:String="single_TipFairyPanel_only";
		private static var instance:TipFairyPanel;
		public static function getInstance():TipFairyPanel {
			if(instance==null) instance=new TipFairyPanel();
			return instance as TipFairyPanel;
		}

		public static const PANEL_END_SHOW:String="PANEL_END_SHOW";


		public var tipFairyShowPanel:TipFairyShowPanel;

		private var mShowList:Array=[];

		private var willShow:Boolean=false;
		private var isShowing:Boolean=false;
		
		private var tipFairyVO:TipFairyVO;

		public function TipFairyPanel() {
			if(instance!=null)
				throw Error(SINGLETON_MSG);
			instance=this;
			tipFairyShowPanel.addEventListener(PANEL_END_SHOW, onCloseShowPanel);

			this.addEventListener(Event.ADDED_TO_STAGE, onAdd);
			this.addEventListener(Event.ADDED_TO_STAGE, onClose);

			onClose();
			
			tipFairyVO = TipFairyVO.getInstance();
			tipFairyVO.on(TipFairyVO.UPDATE, this, showFairy);
			EventCenter.on(ApplicationFacade.SHOW_PANEL, this, onShow);
				
		}
		
		private function onShow(e:ObjectEvent):void{
			if(e.data==TipFairyPanel.NAME) {
				showFairy();
			}
		}

		protected function onClose(e:Event=null):void {
			willShow=false;
		}

		protected function onAdd(e:Event):void {
			if(willShow==false) {
				this.close();
			}
		}

		/**
		 * 显示精灵
		 * @param fairyVO
		 *
		 */
		public function showFairy(e:ObjectEvent=null):void {
			willShow=true;
			mShowList=mShowList.concat(tipFairyVO.totalFairyArr);
			if(isShowing==false)
				showNextFairy();
		}

		/**
		 * 关闭一个展示页面时，
		 * 如果列表中有其他精灵，显示之
		 * 没有则关闭整个面板
		 * @param e
		 *
		 */
		private function onCloseShowPanel(e:Event):void {
			mShowList.shift();
			showNextFairy();
			return;
			if(mShowList.length>=1) {
				showNextFairy();
			} else {
				isShowing=false;
				this.close();
			}
		}

		private function showNextFairy():void {
			if(mShowList[0]==null) {
				isShowing=false;
				this.close();
			} else {
				isShowing=true;
				tipFairyShowPanel.updateInfo(mShowList[0] as BaseFairyVO);
			}
		}
	}
}
