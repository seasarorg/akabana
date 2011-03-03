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
    CONFIG::FP10{
        import __AS3__.vec.Vector;
    }
    
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
    
    use namespace yui_internal;
    
    [ExcludeClass]
    internal class YuiFrameworkControllerCore implements IYuiFrameworkController
    {
        include "../Version.as";
        
        protected var _isApplicationStarted:Boolean = true;
        
        protected var _namingConvention:NamingConvention;
        
        protected var _rootDisplayObjectMap:Dictionary;
        
        CONFIG::FP9{
            protected var _customizers:Array;
        }
        CONFIG::FP10{
            protected var _customizers:Vector.<IElementCustomizer>;
        }
        
        CONFIG::FP9{
            protected var _rootDisplayObjects:Array;
            
            public function get rootDisplayObjects():Array{
                return _rootDisplayObjects;
            }
        }
        CONFIG::FP10{
            protected var _rootDisplayObjects:Vector.<DisplayObject>;
            
            public function get rootDisplayObjects():Vector.<DisplayObject>{
                return _rootDisplayObjects;
            }
        }
        
        public function YuiFrameworkControllerCore(){
            CONFIG::FP9{
                _rootDisplayObjects = [];
            }
            CONFIG::FP10{
                _rootDisplayObjects = new Vector.<DisplayObject>;
            }
            _rootDisplayObjectMap = new Dictionary(true);
        }
        
        public function addRootDisplayObject(root:DisplayObject ):void{
        }
        
        public function removeRootDisplayObject(root:DisplayObject ):void{
        }
        
        public function customizeView( container:DisplayObjectContainer ):void{
        }
        
        public function uncustomizeView( container:DisplayObjectContainer ):void{
        }
        
        public function customizeComponent( container:DisplayObjectContainer, child:DisplayObject):void{
        }
        
        public function uncustomizeComponent( container:DisplayObjectContainer, child:DisplayObject):void{
        }
        
        public function callLater(callBack:Function):void{
            new FunctionInvoker(callBack).invokeDelay();
        }
        
        CONFIG::DEBUG{
            protected function getMessage(resourceName:String,...parameters):String{
                return MessageManager.yui_internal::yuiframework.getMessage.apply(null,[resourceName].concat(parameters));
            }
        }
        
        protected function registerRootDisplayObject(root:DisplayObject):void{
            CONFIG::DEBUG{
                debug(YuiFrameworkControllerCore,"add rootDisplayObject"+root);
            }
            _rootDisplayObjects.push(root);
            _rootDisplayObjectMap[ root ] = _rootDisplayObjects.length-1;
        }
        
        protected function unregisterRootDisplayObject(root:DisplayObject):void{
            CONFIG::DEBUG{
                debug(YuiFrameworkControllerCore,"remove rootDisplayObject"+root);
            }
            if( root in _rootDisplayObjectMap ){
                var index:int = _rootDisplayObjectMap[ root ] as int;
                delete _rootDisplayObjectMap[ root ];
                _rootDisplayObjects.splice(index,1);
            }
        }
        
        protected function getDefaultCustomizerClasses():Array{
            return [];
        }
        
        yui_internal function isView( component:DisplayObject ):Boolean{
            return false;
        }
        
        yui_internal function isComponent( component:DisplayObject ):Boolean{
            return false;            
        }
    }
}