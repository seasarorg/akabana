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
package net.akb7.yui.core
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;

    [ExcludeClass]
    /**
     * 
     */
    public interface IYuiFrameworkController
    {
        /**
         * 
         * @return 
         * 
         */
        function get currentRoot():DisplayObject;
        
        /**
         * 
         * @param systemManager
         * 
         */
        function addRootDisplayObject(systemManager:DisplayObject):void;
        
        /**
         * 
         * @param systemManager
         * 
         */
        function removeRootDisplayObject(systemManager:DisplayObject):void;

        /**
         * 
         * @param container
         * 
         */
        function customizeView( container:DisplayObjectContainer ):void;

        /**
         * 
         * @param container
         * 
         */
        function uncustomizeView( container:DisplayObjectContainer ):void;

        /**
         * 
         * @param container
         * @param child
         * 
         */
        function customizeComponent( container:DisplayObjectContainer, child:DisplayObject):void;
        
        /**
         * 
         * @param container
         * @param child
         * 
         */
        function uncustomizeComponent( container:DisplayObjectContainer, child:DisplayObject):void;
    }
}