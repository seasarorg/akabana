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
package org.seasar.akabana.yui.service.local
{
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    import org.seasar.akabana.yui.service.IService;
    import org.seasar.akabana.yui.util.StringUtil;

    [ExcludeClass]
    public final class LocalServiceInvoker {
        
        private static const SERVICE_REF_CACHE:Dictionary = new Dictionary();
        
        public function invoke(servicePackageName:String,serviceName:String,methodName:String,...args):Object{
            const lservice:String = StringUtil.toUpperCamel(serviceName);
            const serviceClassName:String = 
                servicePackageName+
                StringUtil.DOT+
                lservice;
            
            const service:Object = getServiceInstance(serviceClassName);
            const result:Object = doInvokeServiceMethod(service,methodName,args);
            return result;
        }
        
        private function getServiceInstance(serviceClassName:String):Object{
            var result:Object = null;
            if( serviceClassName in SERVICE_REF_CACHE ){
                result = SERVICE_REF_CACHE[serviceClassName];
            } else {
                var serviceClassRef:ClassRef = getClassRef(serviceClassName);
                result = serviceClassRef.newInstance();
            }
            return result;
        }
        
        private function doInvokeServiceMethod(service:Object, methodName:String, args:Array ):Object{
            const method:Function = service[methodName] as Function;
            const result:Object = method.apply(null,args);
            return result;
        }
    }
}