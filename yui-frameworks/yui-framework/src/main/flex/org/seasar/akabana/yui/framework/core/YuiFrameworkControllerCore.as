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
    import __AS3__.vec.Vector;
    
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.utils.Dictionary;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    
    import org.seasar.akabana.yui.core.ns.yui_internal;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    import org.seasar.akabana.yui.framework.customizer.IElementCustomizer;
    import org.seasar.akabana.yui.framework.message.MessageManager;
    import org.seasar.akabana.yui.framework.util.StyleManagerUtil;
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionInvoker;
    import org.seasar.akabana.yui.framework.logging.debug;
    import org.seasar.akabana.yui.framework.logging.info;
    
    use namespace yui_internal;
    
    [ExcludeClass]
    /**
     * 
     * @author arikawa.eiichi
     * 
     */
    internal class YuiFrameworkControllerCore implements IYuiFrameworkController
    {
        include "../Version.as";
        
        /**
         * 
         */
        protected var _isApplicationStarted:Boolean = true;
        
        /**
         * 
         */
        protected var _namingConvention:NamingConvention;
        
        /**
         * 
         */
        protected var _rootDisplayObjectMap:Dictionary;
        
        /**
         * 
         */
        protected var _customizers:Vector.<IElementCustomizer>;
        
        /**
         * 
         */
        protected var _rootDisplayObjects:Vector.<DisplayObject>;
        
        /**
         * 
         * @return 
         * 
         */
        public function get rootDisplayObjects():Vector.<DisplayObject>{
            return _rootDisplayObjects;
        }
        
        /**
         * 
         * @return 
         * 
         */
        public function get currentRoot():DisplayObject{
            return null;
        }
        
        /**
         * 
         * 
         */
        public function YuiFrameworkControllerCore(){
            _rootDisplayObjects = new Vector.<DisplayObject>;
            _rootDisplayObjectMap = new Dictionary(true);
        }
        
        /**
         * 
         * @param root
         * 
         */
        public function addRootDisplayObject(root:DisplayObject ):void{
        }
        
        /**
         * 
         * @param root
         * 
         */
        public function removeRootDisplayObject(root:DisplayObject ):void{
        }
        
        /**
         * 
         * @param container
         * 
         */
        public function customizeView( container:DisplayObjectContainer ):void{
        }
        
        /**
         * 
         * @param container
         * 
         */
        public function uncustomizeView( container:DisplayObjectContainer ):void{
        }
        
        /**
         * 
         * @param container
         * @param child
         * 
         */
        public function customizeComponent( container:DisplayObjectContainer, child:DisplayObject):void{
        }
        
        /**
         * 
         * @param container
         * @param child
         * 
         */
        public function uncustomizeComponent( container:DisplayObjectContainer, child:DisplayObject):void{
        }
        
        /**
         * 
         * @param callBack
         * 
         */
        public function callLater(callBack:Function):void{
            new FunctionInvoker(callBack).invokeDelay();
        }
        
        CONFIG::DEBUG{
            /**
             * 
             * @param resourceName
             * @param parameters
             * 
             */
            protected function _debug(resourceName:String,...parameters):void{
                debug(this,MessageManager.yui_internal::yuiframework.getMessage.apply(null,[resourceName].concat(parameters)));
            }
        }
        CONFIG::DEBUG{
            /**
             * 
             * @param resourceName
             * @param parameters
             * 
             */
            protected function _info(resourceName:String,...parameters):void{
                info(this,MessageManager.yui_internal::yuiframework.getMessage.apply(null,[resourceName].concat(parameters)));
            }
        }
        
        protected function registerRootDisplayObject(root:DisplayObject):void{
            CONFIG::DEBUG{
                _debug("RootAdd",root);
            }
            _rootDisplayObjects.push(root);
            _rootDisplayObjectMap[ root ] = _rootDisplayObjects.length-1;
        }
        
        protected function unregisterRootDisplayObject(root:DisplayObject):void{
            CONFIG::DEBUG{
                _debug("RootRemove",root);
            }
            if( root in _rootDisplayObjectMap ){
                var index:int = _rootDisplayObjectMap[ root ] as int;
                delete _rootDisplayObjectMap[ root ];
                _rootDisplayObjects.splice(index,1);
            }
        }
        
        protected function getDefaultCustomizers():Vector.<IElementCustomizer>{
            var classes:Array = getDefaultCustomizerClasses();
            var result:Vector.<IElementCustomizer> = new Vector.<IElementCustomizer>();
            for each( var customizerClass:Class in classes ){
                result.push(new customizerClass());
            }
            return result;
        }

        protected function getDefaultCustomizerClasses():Array{
            return [];
        }
    }
}