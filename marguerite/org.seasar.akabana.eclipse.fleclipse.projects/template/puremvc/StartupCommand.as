/*
   Simple Command - PureMVC
*/
package ${packageName}.controller {
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
   	import org.puremvc.as3.patterns.observer.Notification;
   	
	/**
	* StartupCommand
	*/
 	public class StartupCommand extends SimpleCommand {
 		
		override public function execute(note:INotification):void {
			trace("Hello world!");
 		}
 		
	}
}  