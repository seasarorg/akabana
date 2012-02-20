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
package org.seasar.akabana.yui.mobile.components
{
    import flash.display.DisplayObjectContainer;
    
    import mx.core.IVisualElement;
    import mx.events.FlexEvent;
    
    import org.seasar.akabana.yui.framework.core.YuiFrameworkController;
    
    import spark.components.View;
    import spark.components.ViewNavigator;
    
    public class YuiViewNavigator extends ViewNavigator{
        
        private var _canCustomize:Boolean = false;

        public function get canCustomize():Boolean{
            return _canCustomize;
        }

        public function set canCustomize(value:Boolean):void{
            _canCustomize = value;
        }
        
        public function YuiViewNavigator(){
            super();
        }
        
        public override function addElement(element:IVisualElement):IVisualElement{
            var view:View = super.addElement(element) as View;
            if( canCustomize ){
                if( view.initialized ){
                    customizeView(view);
                } else {
                    view.addEventListener(FlexEvent.CREATION_COMPLETE,view_creationCompleteHandler);
                }
            }
            return view;
        } 
        
        public override function removeElement(element:IVisualElement):IVisualElement{
            var view:IVisualElement = super.removeElement(element);
            if( canCustomize ){
                YuiFrameworkController.getInstance().uncustomizeView(view as DisplayObjectContainer);
            }
            return view;
        }
        
        private function view_creationCompleteHandler(event:FlexEvent):void{
            var view:View = event.target as View;
            view.removeEventListener(FlexEvent.CREATION_COMPLETE,view_creationCompleteHandler);
            customizeView(view as DisplayObjectContainer);
        }
        
        protected function customizeView(view:DisplayObjectContainer):void{
            YuiFrameworkController.getInstance().customizeView(view);
        }
    }
}