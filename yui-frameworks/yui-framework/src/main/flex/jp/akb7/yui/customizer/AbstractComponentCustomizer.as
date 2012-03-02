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
package jp.akb7.yui.customizer
{
    import __AS3__.vec.Vector;
    
    import flash.display.DisplayObjectContainer;
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;
    
    import mx.core.UIComponent;
    
    import jp.akb7.yui.core.YuiFrameworkController;
    import jp.akb7.yui.core.ns.yui_internal;
    import jp.akb7.yui.core.reflection.ClassRef;
    import jp.akb7.yui.core.reflection.PropertyRef;
    import jp.akb7.yui.logging.debug;
    import jp.akb7.yui.message.MessageManager;
    
    [ExcludeClass]
    public class AbstractComponentCustomizer implements IViewCustomizer {

        protected function setPropertiesValue(target:Object,varClassName:String,value:Object):void {
            const targetClassRef:ClassRef = getClassRef(target);
            const propertyRefs:Vector.<PropertyRef> = targetClassRef.getPropertyRefByType(varClassName);
            
            if(propertyRefs != null) {
                for each(var propertyRef:PropertyRef in propertyRefs) {
                    propertyRef.setValue(target,value);
                }
            }
        }

        public function customizeView( view:UIComponent ):void{
            throw new IllegalOperationError("can't call");
        }

        public function uncustomizeView( view:UIComponent ):void{
            throw new IllegalOperationError("can't call");
        }
        
        CONFIG::DEBUG {
            protected function _debug(resourceName:String,...parameters):void{
                debug( this, MessageManager.yui_internal::yuiframework.getMessage.apply(null,[resourceName].concat(parameters)));
            }
        }
    }
}