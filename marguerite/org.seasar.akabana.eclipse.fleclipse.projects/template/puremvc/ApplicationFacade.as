package ${packageName} {
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	import ${packageName}.model.*;
	import ${packageName}.view.*;
	import ${packageName}.controller.*;
	
	/**
	*/
	public class ApplicationFacade extends Facade implements IFacade {
		// Notification name constants
		public static const STARTUP:String = "startup";
		
		public static function getInstance():ApplicationFacade {
			if (instance == null) instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		// Register commands with the controller
		override protected function initializeController():void {
			super.initializeController();
			
			registerCommand(STARTUP, StartupCommand);
		}
		
	}
	
}