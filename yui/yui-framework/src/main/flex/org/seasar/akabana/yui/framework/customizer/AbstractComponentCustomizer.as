/*
 * Copyright 2004-2008 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.framework.customizer
{
    CONFIG::FP10 {
        import __AS3__.vec.Vector;
    }

    import flash.errors.IllegalOperationError;

    import mx.core.UIComponent;

    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.core.yui_internal;
    import org.seasar.akabana.yui.framework.message.MessageManager;

    internal class AbstractComponentCustomizer implements IComponentCustomizer
    {
        protected static function setPropertiesValue(target:Object,varClassName:String,value:Object):void {
            const targetClassRef:ClassRef = getClassRef(target);
            CONFIG::FP9 {
                const propertyRefs:Array = targetClassRef.getPropertyRefByType(varClassName);
            }
            CONFIG::FP10 {
                const propertyRefs:Vector.<PropertyRef> = targetClassRef.getPropertyRefByType(varClassName);
            }

            if(propertyRefs != null) {
                for each(var propertyRef:PropertyRef in propertyRefs) {
                    propertyRef.setValue(target,value);
                }
            }
        }

        public function isTarget( view:UIComponent ):Boolean{
            return false;
        }

        public function customize( view:UIComponent, owner:UIComponent=null):void{
            throw new IllegalOperationError("can't call");
        }

        public function uncustomize( view:UIComponent, owner:UIComponent=null):void{
            throw new IllegalOperationError("can't call");
        }

        protected function getMessage(resourceName:String,...parameters):String{
            return MessageManager.yui_internal::yuiframework.getMessage.apply(null,[resourceName].concat(parameters));
        }

    }
}