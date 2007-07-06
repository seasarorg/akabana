/*
 * Copyright 2004-2007 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.framework.metadata {
    
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    
    import org.seasar.akabana.yui.framework.core.ClassUtil;
    import org.seasar.akabana.yui.service.Operation;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceRepository;
    import org.seasar.akabana.yui.framework.customizer.ServiceEventCustomizer;
    
    internal class ServiceMetadataParser {
        
        private static var NAME:String = "name";
        
        public static function parse( owner:Object, target:Object, variableXML:XML, metadataXML:XML ):void{
            var variableName:String = variableXML.@name.toString();
            
            var serviceName:String = metadataXML.arg.(@key == NAME).@value.toString();
            if( serviceName == null || serviceName.length <= 0 ){
                serviceName = variableName;
            }
             
            var service:Service = ServiceRepository.getService( serviceName );
            if( service == null ){
                service = ClassUtil.newInstance(variableXML.@type.toString()) as Service;
                service.destination = serviceName;
                ServiceRepository.addService( service );
            }
            
            ServiceEventCustomizer.customizer( service, target );
            target[ variableName ] = service;
        }
    }
}