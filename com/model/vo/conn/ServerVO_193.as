package com.model.vo.conn {
			import com.conn.MainNC;
			import com.model.vo.altar.FairyTemplateVO;
			
			/**
			 * 掠夺匹配-发送 接收 ServerVO_32
			 */
			public class ServerVO_193{
				public static var ID:int = 0xc1;
				public var isSuccess:Boolean;
				private var itemArr:Array=[];
				private var running_code:int=-1;
				
				public function ServerVO_193(obj:Object) {
				}
				public function getIsSuccess():Boolean{
					return isSuccess;
				}
				public function getItemArr():Array{
					return itemArr;
				}
				public function getCode():int{
					return running_code
				}
				/**
				 * 发送给server
				 * @return 
				 */
				
				/**
				 * 获取匹配对手信息
				 */		
				public static var GET_MATCH_INFO:int = 0x01;
				public static function  getSendGetMatchInfo():Boolean{
					return MainNC.getInstance().sendInfo(ID,{
						code:GET_MATCH_INFO
					});
				}
				/**
				 * 开始掠夺
				 */		
				public static var START_LOOT:int = 0x02;
				public static function  getSendStartLoot(OppoID:int):Boolean{
					return MainNC.getInstance().sendInfo(ID,{code:START_LOOT,matchPlayer:OppoID});
				}
				
				/**
				 * 获取玩家掠夺信息,OppoID:int
				 */		
				public static var GET_LOOT_INFO:int = 0x03;
				public static function  getSendGetLootInfo():Boolean{
					return MainNC.getInstance().sendInfo(ID,{
						code:GET_LOOT_INFO
					});
				}
				/**
				 * 获取守护兽列表信息
				 */		
				public static var GET_GUARD_LIST:int = 0x04;
				public static function  getSendGetGuardList():Boolean{
					return MainNC.getInstance().sendInfo(ID,{
						code:GET_GUARD_LIST
					});
				}
				/**
				 * 设置守护兽或精灵信息
				 */		
				public static var SET_GUARD:int = 0x05;
				public static function  getSendSetGuard(guard:FairyTemplateVO, fairy1:FairyTemplateVO=null, fairy2:FairyTemplateVO=null):Boolean{
					var type:String,petID:String;
					if(guard!=null){
						type="0";
						petID = String(guard.templateID);
					}
					if(fairy1!=null && fairy2!=null){
						type="1";
						petID = String(fairy1.fairyID)+","+String(fairy2.fairyID);
					}
					if(type==null){
						return true;
					}
					return MainNC.getInstance().sendInfo(ID,{
						code:SET_GUARD,
						type:type,
						petId:petID
					});
				}
			}
		}
