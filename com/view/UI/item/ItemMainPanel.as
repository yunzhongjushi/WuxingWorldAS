package com.view.UI.item {
	import com.view.BasePanel;
	import com.view.UI.button.LeafButton;
	
	import flas.events.MouseEvent;

	/**
	 * 物品分类标签面板
	 * @author hunterxie
	 */
	public class ItemMainPanel extends BasePanel {
		/**
		 * 玩家选择了一个标签
		 */
		public static const E_ON_TAG:String="E_ON_TAG";
		
		/**
		 * 基础按钮，至少存在一个
		 */
		public var btn_0:LeafButton;
		
		/**
		 * 所有标签列表
		 */
		private var btnArr:Array;
		
		/**
		 * 
		 * 
		 */
		public function ItemMainPanel() {
			btnArr = [btn_0];
			
			reset();
		}
		
		/**
		 * 更新按钮数据
		 * @param arr
		 * @return 
		 */
		public function updateInfo(arr:Array):void{
			var len:int = Math.max(arr.length, btnArr.length);
			for(var i:int=0; i<len; i++){
				var btn:LeafButton;
				if(i<btnArr.length){
					btn = btnArr[i];
					if(i>=arr.length){
						btn.removeEventListener(MouseEvent.CLICK, handle_click);
						btn.visible = false;
						continue;
					}
				}else{
					btn = new LeafButton;
					btn.x = btn_0.x;
					btn.y = btn_0.y+65*i;
					btnArr.push(btn);
					addChild(btn);
				}
				btn.setTf(arr[i]);
				btn.addEventListener(MouseEvent.CLICK, handle_click);
			}
			btn_0.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		public function handle_click(e:*):void {
			var btn:LeafButton = e.target as LeafButton;
			reset(btn);
			event(E_ON_TAG, btn.kind);
		}

		public function reset(btn:LeafButton=null):void {
			for(var i:int=0; i<btnArr.length; i++){
				var btn1:LeafButton = btnArr[i] as LeafButton;
				if(btn1.visible){
					btn1.turnOff();
				}
			}
			if(btn){
				btn.turnOn();
			}
		}
	}
}
