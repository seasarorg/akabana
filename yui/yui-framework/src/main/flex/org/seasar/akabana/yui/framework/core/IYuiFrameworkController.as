/*
 * Copyright 2004-2011 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.framework.core
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;

    [ExcludeClass]
    public interface IYuiFrameworkController
    {
        function addRootDisplayObject(systemManager:DisplayObject):void;
        
        function removeRootDisplayObject(systemManager:DisplayObject):void;

        function customizeView( container:DisplayObjectContainer ):void;

        function uncustomizeView( container:DisplayObjectContainer ):void;

        function customizeComponent( container:DisplayObjectContainer, child:DisplayObject):void;
        
        function uncustomizeComponent( container:DisplayObjectContainer, child:DisplayObject):void;
    }
}