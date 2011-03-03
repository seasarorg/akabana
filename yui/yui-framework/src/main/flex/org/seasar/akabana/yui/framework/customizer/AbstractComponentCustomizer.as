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
package org.seasar.akabana.yui.framework.customizer
{
    CONFIG::FP10 {
        import __AS3__.vec.Vector;
    }

    import flash.errors.IllegalOperationError;

    import mx.core.UIComponent;

    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.core.ns.yui_internal;
    import org.seasar.akabana.yui.framework.message.MessageManager;
    import org.seasar.akabana.yui.framework.rule.IStateless;
	import org.seasar.akabana.yui.framework.logging.debug;
    import org.seasar.akabana.yui.framework.core.YuiFrameworkController;
    import flash.utils.Dictionary;
    import flash.display.DisplayObjectContainer;

    internal class AbstractComponentCustomizer implements IViewCustomizer {
        
        private static const INSTANCE_REF_CACHE:Dictionary = new Dictionary();
        
        private static function get currentInstanceRefCache():Dictionary{
            const currentRoot:DisplayObjectContainer = YuiFrameworkController.currentRoot;
            
            var result:Dictionary;
            if( currentRoot in INSTANCE_REF_CACHE ){
                result = INSTANCE_REF_CACHE[ currentRoot ];   
            } else {
                result = new Dictionary(true);
                INSTANCE_REF_CACHE[ currentRoot ] = result;
            }
            return result;
        }
        
        protected function newInstance(classRef:ClassRef,...args):Object{
            var result:Object = null;
            if( classRef.isAssignableFrom(IStateless)){
                result = classRef.newInstance.apply(null,args);
                CONFIG::DEBUG {
                    debug(this,"instance created:" + classRef.name);
                }
            } else {
                if( classRef.name in currentInstanceRefCache ){
                    result = INSTANCE_REF_CACHE[ classRef.name ];
                    
                    CONFIG::DEBUG {
                        debug(this,"instance reused:" + classRef.name);
                    }                    
                } else {
                    result = classRef.newInstance.apply(null,args);
                    currentInstanceRefCache[ classRef.name ] = result;
                    CONFIG::DEBUG {
                        debug(this,"instance created and cached:" + classRef.name);
                    }
                }
            }
            return result;
        }
        
        protected function setPropertiesValue(target:Object,varClassName:String,value:Object):void {
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

        public function customizeView( view:UIComponent ):void{
            throw new IllegalOperationError("can't call");
        }

        public function uncustomizeView( view:UIComponent ):void{
            throw new IllegalOperationError("can't call");
        }
        
        protected function getMessage(resourceName:String,...parameters):String{
            return MessageManager.yui_internal::yuiframework.getMessage.apply(null,[resourceName].concat(parameters));
        }

    }
}