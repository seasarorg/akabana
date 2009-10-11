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
    import flash.errors.IllegalOperationError;
    
    import mx.core.Container;
    
    import org.seasar.akabana.yui.core.yui_internal;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    import org.seasar.akabana.yui.framework.message.MessageManager;
    
    internal class AbstractComponentCustomizer implements IComponentCustomizer
    {
        protected var _namingConvention:NamingConvention;
        
        public function AbstractComponentCustomizer(namingConvention:NamingConvention){
            _namingConvention = namingConvention;
        }
        
        public function get namingConvention():NamingConvention{
            return _namingConvention;
        }
                
        public function customize( view:Container, owner:Container=null):void{
            throw new IllegalOperationError("can't call");
        }

        public function uncustomize( view:Container, owner:Container=null):void{
            throw new IllegalOperationError("can't call");
        }
        
        public function getMessage(resourceName:String,...parameters):String{
            return MessageManager.yui_internal::yuiframework.getMessage.apply(null,[resourceName].concat(parameters)); 
        }

    }
}