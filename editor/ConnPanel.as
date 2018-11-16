package editor{
	import com.model.vo.user.UserVO;
	import com.view.BasePanel;
	import com.view.DebugPanel;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	import flas.net.Socket;
	import flas.utils.ByteArray;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.text.TextField;

	/**
	 * 测试连接后台面板，用于测试联网对战
	 * @author hunterxie
	 */
	public class ConnPanel extends BasePanel{
		public static const NAME:String = "ConnPanel";
		public static const SINGLETON_MSG:String = "single_ConnPanel_only";
		protected static var instance:ConnPanel;
		public static function getInstance():ConnPanel{
			if ( instance == null ) instance = new ConnPanel();
			return instance;
		}
		
		public var isConnSucc:Boolean=false;
		public var room:int=0;
		public var socket:Socket=new Socket();
		public var obj:Object=new Object();
		
		public var tf_ipInput:TextField;
		public var tf_userName:TextField;
		public var tf_show:TextField;
		public var tf_input:TextField;
		
		public var btn_multiple:CommonBtn;
		public var btn_prepare:CommonBtn;
		public var btn_send:CommonBtn;
		
		public function ConnPanel(){
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			btn_multiple.setNameTxt("联接");
			btn_multiple.addEventListener(MouseEvent.CLICK, testAMF);
			
			btn_send.setNameTxt("发送指令");
			btn_send.addEventListener(MouseEvent.CLICK, onSend);
			
			btn_prepare.visible = false;
			btn_prepare.setNameTxt("开始游戏");
			btn_prepare.addEventListener(MouseEvent.CLICK, onPrepare);
			
//			MainDispatcher.getInstance().addEventListener("game_start", game_start);
		}
		
		public function testAMF(e:*=null):void{
			socket.addEventListener(Event.CLOSE, closeHandler);
			socket.addEventListener(Event.CONNECT, connectHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler_AMF3);
			//socket.connect("192.168.1.198", 6999);
			socket.connect(tf_ipInput.text, 6999);
		}
		
		
		public function closeHandler(event:Event):void {
			trace("连接关闭");
			btn_multiple.visible=true;
			btn_prepare.visible=false;
			isConnSucc=false;
		}
		public function connectHandler(event:Event):void {
			trace("连接成功");
			isConnSucc=true;
			if(tf_userName.text.length>0){
				sendInfo({command:"login", userName:tf_userName.text});
			}
		}
		public function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler信息： "+event);
		}
		public function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler信息: "+event);
		}
		
		public function socketDataHandler_AMF3(event:ProgressEvent):void {
			log("接收到数据段,加载长度:"+event.bytesLoaded+"======有效长度: "+socket.bytesAvailable);
			var bta:ByteArray=new ByteArray  ;
			socket.readBytes(bta);
			//bta.position=35;
			
			//解压=====================================================
			//bta.uncompress();
			//var amfBta:ByteArray = new ByteArray;
			//var decoder:GZIPBytesEncoder = new GZIPBytesEncoder();
			//var amfBta:ByteArray=decoder.uncompressToByteArray(bta);
			
			onReceveData(bta.readObject());
		}
		
		public function onReceveData(obj:Object):void{
//			MyClass.traceInfo(obj, tf_show);
			switch(obj.command){
				case "loginSuccess":
					btn_multiple.visible=false;
					btn_prepare.visible=true;
					break;
				case "loginField":
					log("登录失败:"+obj.info);
					break;
				case "chat":
					break;
				case "game_ready":
					if(obj.success){
						this.room=obj.roomID;
						btn_prepare.visible=false;
						log("进入房间, ID:"+obj.roomID);
					}
					break;
				case "prepare":
					break;
				case "game_action":
					event("game_action", obj.actions);
					break;
				case "game_start":
					event("game_start", obj);
					break;
				case "game_end":
					
					break;
				case "game_error":
					
					break;
			}
		}
		
		public function onSend(e:*):void {
			//sendInfo({command:"chat", info:tf_input.text});
			sendInfo({command:"game_action", actionUserID:UserVO.getInstance().userID, tarUserID:0, info:tf_input.text});
		}
		public function onPrepare(e:*):void {
			UserVO.getInstance().userID = Math.floor(Math.random()*99999);
			sendInfo({command:"game_ready", 
				userID:UserVO.getInstance().userID,
				fight_kind:1,
				clear_kind:1,
				fairyInfo:{
					ID:1, userID:UserVO.getInstance().userID, LV:50, wuxing:0, HP:100, AP:5, DP:[0,0,0,0,0], skill:[101,102,103,104], res:[0,0,0,0,0], maxres:[100,100,100,100,100]
				}});
			
			//sendInfo({command:"game_ready"});
		}
		
		public function log(info:String):void {
			DebugPanel.traceInfo(info);
			//tf_show.appendText(info+"\n");
			//tf_show.scrollV=tf_show.maxScrollV;
			trace(info);
		}
		public function sendInfo(info:Object):void{
			if(!isConnSucc) return;
			//	var bta:ByteArray=new ByteArray  ;
			//	bta.writeInt(0);
			//	bta.writeObject(info);
			//	bta.position=0;
			//	bta.writeInt(bta.length);
			//	bta.position=0;
			//	socket.writeBytes(bta);
			socket.writeObject(info);
			log("发送数据，长度:"+socket.bytesPending);
			socket.flush();
		}
	}
}
