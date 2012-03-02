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
package jp.akb7.yui.bridge
{
    import __AS3__.vec.Vector;

    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;

    [ExcludeClass]
    public interface IFrameworkBridgePlugin {
        function get application():DisplayObjectContainer;

        function set application(value:DisplayObjectContainer):void;

        function get parameters():Object;

        function get systemManager():DisplayObject;
        
        function get rootView():DisplayObjectContainer;

        function isApplication(application:DisplayObject):Boolean;

        function isContainer(component:DisplayObject):Boolean;

        function isComponent(component:DisplayObject):Boolean;

        function getDocumentOf(component:DisplayObject):DisplayObject;
        
        function getChildren(component:DisplayObjectContainer):Vector.<DisplayObject>;
    }
}