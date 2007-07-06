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
package org.seasar.akabana.yui.framework.core.metadata {
    
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    
    import org.seasar.akabana.yui.framework.core.ClassUtil;
    import org.seasar.akabana.yui.service.Operation;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceRepository;
    
    internal class ServiceMetadataParser {
        
        private static var NAME:String = "name";
        
        private static var RESULT_HANDLER:String = "ResultHandler";
        
        private static var FAULT_HANDLER:String = "FaultHandler";
        
        private static var EVENT_HANDLER:String = "EventHandler";
        
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
            
            parseServiceEvent( service, target, metadataXML);
            
            target[ variableName ] = service;
        }


        private static function parseServiceEvent( service:Service, target:Object, metadataXML:XML ):void{
            var serviceName:String = service.destination;
            var resultFunctions:Dictionary = new Dictionary();
            var faultFunctions:Dictionary = new Dictionary();
            var operations:Dictionary = new Dictionary();
            var operationEvents:Dictionary = new Dictionary();
            
            var describeTypeXml:XML = describeType(Object(target).constructor);
            var methods:XMLList = describeTypeXml.factory.method.(@name.toString().indexOf(serviceName) == 0 );
			
			var operationName:String;
			var methodName:String;
			var eventName:String;
			var handlerIndex:int;
			for each( var method:XML in methods ){
				methodName = method.@name.toString();
				//Resultイベント
				{
    				handlerIndex = methodName.lastIndexOf(RESULT_HANDLER);
    				if( handlerIndex > -1 ){
        				operationName = methodName.substr(serviceName.length,1).toLocaleLowerCase() + methodName.substring(serviceName.length+1,handlerIndex);
                        resultFunctions[ operationName ] = methodName;
                        if( operations[ operationName ] == null ){
                            operations[ operationName ] = 1;
                        }
                        continue;
                    }
                }
                //Faultイベント
                {
                    handlerIndex = methodName.lastIndexOf(FAULT_HANDLER);
    				if( handlerIndex > -1 ){
        				operationName = methodName.substr(serviceName.length,1).toLocaleLowerCase() + methodName.substring(serviceName.length+1,handlerIndex);
                        faultFunctions[ operationName ] = methodName;
                        if( operations[ operationName ] == null ){
                            operations[ operationName ] = 1;
                        }
                        continue;
                    }
                }
                //その他のイベント
                {
                    handlerIndex = methodName.lastIndexOf(EVENT_HANDLER);
    				if( handlerIndex > -1 ){
    				    eventName = methodName.substr(serviceName.length,1).toLocaleLowerCase() + methodName.substring(serviceName.length+1,handlerIndex);
   						operationEvents[ eventName ] = target[ methodName ];
                        continue;
                    }
                }
			}
			
			var resultFunction:Function;
			var faultFunction:Function;
            for ( operationName in operations ){
                
                if( resultFunctions[ operationName ] != null ){
                    resultFunction = target[resultFunctions[ operationName ]];
                } else {
                    resultFunction = null;
                }
                if( faultFunctions[ operationName ] != null ){
                    faultFunction = target[faultFunctions[ operationName ]];
                } else {
                    faultFunction = null;
                }
                
                service.addOperation( operationName, null, resultFunction, faultFunction );
                
                
                addOperationEventListeners( service.getOperation( operationName ), operationEvents ); 
            }
        }
        
        private static function addOperationEventListeners( operation:Operation, operationEvents:Dictionary):void{
            for ( var eventName:String in operationEvents ){
                operation.addEventListener( eventName, operationEvents[ eventName ] );
            }
        }
       
    }
}