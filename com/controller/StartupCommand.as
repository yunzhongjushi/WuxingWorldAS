package com.controller {
	import com.model.ApplicationFacade;
	import com.conn.MainNC;
	
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	/**
	 * Proxy处理，界面处理，弹出窗处理
	 * @author
	 */
	public class StartupCommand extends MacroCommand {
		
		override protected function initializeMacroCommand():void {
//			addSubCommand( ModelPrepCommand );
			addSubCommand( ViewPrepCommand );
//			addSubCommand(ConnCommand);
			
//			FightCommand.getInstance();//facade.registerCommand(ApplicationFacade.LEVEL_GAME_START, FightCommand);
//			facade.registerCommand(MainNC.SERVER_INFO, MainNCCommand);
		}
	}
}