package org.seasar.akabana.yui.framework.util
{
	import mx.managers.ISystemManager;
	
	public class SystemManagerUtil
	{
		public static function getRootSystemManager(systemManager:ISystemManager):ISystemManager
		{
			if( systemManager != null ){
				return systemManager.getSandboxRoot() as ISystemManager; 
			}
			return null;
		}

	}
}