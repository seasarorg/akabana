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
package org.seasar.akabana.yui.mobile.skins
{
    import mx.core.ClassFactory;
    import mx.core.IFactory;
    
    import org.seasar.akabana.yui.mobile.components.YuiViewNavigator;
    
    import spark.components.ViewMenu;
    import spark.components.ViewNavigator;
    import spark.components.ViewNavigatorApplication;
    import spark.skins.mobile.supportClasses.MobileSkin;
    
    public class YuiViewNavigatorApplicationSkin extends MobileSkin{
        
        /**
         * The navigator for the application.
         */
        public var navigator:YuiViewNavigator;
        
        /**
         *  Creates an action menu from this factory when the menu button is pressed 
         */ 
        public var viewMenu:IFactory;
        
        /** 
         *  @copy spark.skins.spark.ApplicationSkin#hostComponent
         */
        public var hostComponent:ViewNavigatorApplication;
        
        /**
         *  @private 
         */ 
        public override function set initialized(value:Boolean):void{        
            super.initialized = value;
            
            navigator.canCustomize = true;
        }
        
        /**
         *  @private
         */
        public function YuiViewNavigatorApplicationSkin(){
            super();
            
            viewMenu = new ClassFactory(ViewMenu);
        }
        
        /**
         *  @private
         */
        protected override function createChildren():void{
            navigator = new YuiViewNavigator();
            navigator.id = "navigator";
            
            addChild(navigator);
        }
        
        /**
         *  @private 
         */ 
        protected override function measure():void{        
            super.measure();
            
            measuredWidth = navigator.getPreferredBoundsWidth();
            measuredHeight = navigator.getPreferredBoundsHeight();
        }
        
        /**
         *  @private
         */
        protected override function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
            super.layoutContents(unscaledWidth, unscaledHeight);
            
            navigator.setLayoutBoundsSize(unscaledWidth, unscaledHeight);
            navigator.setLayoutBoundsPosition(0, 0);
        }
    }
}