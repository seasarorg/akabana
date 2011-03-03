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
package org.seasar.akabana.yui.air
{
    import flash.events.Event;
    
    import mx.core.UIComponent;
    import mx.core.WindowedApplication;
    import mx.events.AIREvent;
    
    import org.seasar.akabana.yui.framework.YuiApplicationConsts;
    import org.seasar.akabana.yui.framework.core.YuiFrameworkSettings;
    import org.seasar.akabana.yui.framework.error.YuiFrameworkError;
    
    [Style(name="rootViewClass", type="Class")]
    public class YuiWindowedApplication extends WindowedApplication
    {
        private var _setting:YuiFrameworkSettings;
        
        public function get setting():YuiFrameworkSettings{
            return _setting;
        }
        
        private var _rootView:UIComponent;
        
        public function get rootView():UIComponent{
            return _rootView;
        }
        
        public function YuiWindowedApplication()
        {
            super();
            _setting = new YuiFrameworkSettings();
        }

        public override function dispatchEvent(event:Event):Boolean
        {
            var result:Boolean = super.dispatchEvent(event);
            if( !(event.type in YuiApplicationConsts.UNRECOMMEND_EVENT_MAP)){
                if( result ){
                    if( initialized && _rootView != null && _rootView.initialized ){
                        result = _rootView.dispatchEvent(event);
                    }
                }
            }
            return result;
        }

        protected override function createChildren():void{
            super.createChildren();
            
            createRootView();
        }

        protected function createRootView():void{
            var viewClass:Class = getStyle("rootViewClass") as Class;
            
            if( viewClass == null ){
                throw new YuiFrameworkError("rootViewClass style is needed.");
            } else {
                _rootView = new viewClass();
                _rootView.name = "rootView";
                _rootView.setVisible(false,true);
                addChild(_rootView);
            }
        }
    }
}