package com.model.vo.conn {
			import com.model.proxy.BaseConnProxy;
			import com.model.vo.altar.FairyTemplateVO;
			import com.model.vo.fairy.FairyListVO;
			import com.model.vo.fairy.FairyVO;
			import com.model.vo.loot.LootOpponentVO;
			import com.model.vo.loot.LootVO;
			
			/**
			 * 掠夺匹配-接收 发送：ServerVO_193
			 */
			public class ServerVO_32 extends BaseConnProxy{
				protected static var instance:ServerVO_32;
				public static function getInstance():ServerVO_32{
					if ( instance == null ) instance=new ServerVO_32();
					return instance;
				}
				
				
				public static var ID:int = 0x20;
				private var running_code:int=-1;
				private var lootVO:LootVO;
				private var oppoVO:LootOpponentVO;
				private var guardList:Array;
				
				public function ServerVO_32(obj:Object=null) {
					//			if(obj["rs"]){
					//				isSuccess=true;
					//			}else{
					//				isSuccess=false;
					//			}
					running_code=obj["code"];
					switch(running_code){
						case ServerVO_32.GET_LOOT_INFO:
							//fairy id
							var f1:int = parseInt(obj["GuardPetId"]);
							var f2:int,f3:int;
							var fairyStr:String = obj["FightPetId"];
							var idArr:Array = fairyStr.split(",",2);
							if(idArr[0]){
								f2 = parseInt(idArr[0]);
							}else{
								f2 = LootVO.FAIRY_ID_NULL
							}
							if(idArr[1]){
								f3 = parseInt(idArr[1]);
							}else{
								f3 = LootVO.FAIRY_ID_NULL
							}
							//lootVO
							lootVO = new LootVO(obj["RankScore"],obj["LootTimes"],obj["LootDate"],obj["ProtectionDate"],new Date(),f1,f2,f3);
							lootVO = buildLootVO(lootVO);
							break;
						case ServerVO_32.GET_MATCH_INFO:
							//res
							var resStr:String = obj["addRes"];
							var resStrArr:Array =resStr.split(",",5);
							var resArr:Array=[];
							for(var i:int=0;i<resStrArr.length;i++){
								var res:int = parseInt(resStrArr[i]);
								resArr.push(res);
							}
							//fairy id
							var f1:int = parseInt(obj["GuardPetId"]);
							var f2:int,f3:int;
							var fairyStr:String = obj["FightPetId"];
							var idArr:Array = fairyStr.split(",",2);
							if(idArr[0]){
								f2 = parseInt(idArr[0]);
							}else{
								f2 = LootVO.FAIRY_ID_NULL
							}
							if(idArr[1]){
								f3 = parseInt(idArr[1]);
							}else{
								f3 = LootVO.FAIRY_ID_NULL
							}
							oppoVO = new LootOpponentVO(parseInt(obj["PlayerId"]),obj["NickName"],resArr,obj["RankScore"],f1,f2,f3);
							oppoVO = buildOppoVO(oppoVO);
							break;
						case ServerVO_32.GET_LOOT_END_INFO:
							
							break;
						case ServerVO_32.GET_GUARD_LIST:
							var list:Array=[];
							for(var index:String in obj){
								if(index=="code") continue;
								if(index=="serverCMD") continue;
								var fairyVO:FairyTemplateVO = FairyTemplateVO.genProtectorFairyVO(parseInt(obj[index]),1);
								list.push(fairyVO);
							}
							guardList=list;
							break;
						case ServerVO_32.SET_GUARD:
							break;
					}
				}
				public function getLootVO():LootVO{
					return lootVO;
				}
				public function getOppoVO():LootOpponentVO{
					return oppoVO;
				}
				public function getCode():int{
					return running_code
				}
				public function getGuardList():Array{
					return guardList;
				}
				private function buildLootVO(lootVO:LootVO):LootVO{
					for (var i:int = 1; i <= 3; i++) 
					{
						var fairyID:int = lootVO.getFairyID(LootVO.getPOSByIndex(i));
						if(fairyID==LootVO.FAIRY_ID_NULL) continue;
						var fairyVO:FairyVO = FairyListVO.fairyList.filter(filterByFairyID,fairyID)[0] as FairyVO;
						if(fairyVO==null) continue;
						var fairyTVO:FairyTemplateVO = new FairyTemplateVO(fairyVO.originID,fairyVO.LV,fairyID);
						lootVO.setFairyVO(fairyTVO,LootVO.getPOSByIndex(i));
					}
					return lootVO;
					function filterByFairyID(ele:FairyVO,index:int,arr:Array):Boolean{
						if(ele.ID==this){
							return true;
						}
						return false;
					}
				}
				private function buildOppoVO(oppoVO:LootOpponentVO):LootOpponentVO{
					for (var i:int = 1; i <= 3; i++) 
					{
						var fairyID:int = oppoVO.getFairyID(LootVO.getPOSByIndex(i));
						if(fairyID==LootVO.FAIRY_ID_NULL) continue;
						var fairyVO:FairyVO = FairyListVO.fairyList.filter(filterByFairyID,fairyID)[0] as FairyVO;
						if(fairyVO==null) continue;
						var fairyTVO:FairyTemplateVO = new FairyTemplateVO(fairyVO.originID,fairyVO.LV,fairyID);
						oppoVO.setFairyVO(fairyTVO,LootVO.getPOSByIndex(i));
					}
					return oppoVO;
					function filterByFairyID(ele:FairyVO,index:int,arr:Array):Boolean{
						if(ele.ID==this){
							return true;
						}
						return false;
					}
				}
				/**
				 * 发送给server
				 * @return 
				 */
				
				/**
				 * 获取匹配对手信息
				 */		
				public static var GET_MATCH_INFO:int = 0x01;
				public static var GET_LOOT_END_INFO:int = 0x02;
				public static var GET_LOOT_INFO:int = 0x03;
				public static var GET_GUARD_LIST:int = 0x04;
				public static var SET_GUARD:int = 0x05;
			}
		}
