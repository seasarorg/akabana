/*
* Copyright 2004-2010 the Seasar Foundation and the Others.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
* either express or implied. See the License for the specific language
* governing permissions and limitations under the License.
*/
package org.seasar.akabana.yui.air.core
{
    import mx.managers.ISystemManager;
    
    import org.seasar.akabana.yui.framework.core.YuiFrameworkContainer;
    
    import spark.components.Window;

    public class Window extends spark.components.Window
    {
        public override function set systemManager(value:ISystemManager):void
        {
            if( super.systemManager != value ){
                super.systemManager = value;
                YuiFrameworkContainer.yuicontainer.addExternalSystemManager(value);
            }
        }
    }
}