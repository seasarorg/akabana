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
package org.seasar.akabana.yui.framework.auto {

    import flash.utils.Dictionary;
    import flash.utils.describeType;
    
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.Operation;
    
    public class AutoServiceEventRegister {

        private static var RESULT_HANDLER:String = "ResultHandler";
        
        private static var FAULT_HANDLER:String = "FaultHandler";
        
        private static var EVENT_HANDLER:String = "EventHandler";
        
        public static function register( service:Service, logic:Object ):void {
            var serviceName:String = service.destination;
            var resultFunctions:Dictionary = new Dictionary();
            var faultFunctions:Dictionary = new Dictionary();
            var operations:Dictionary = new Dictionary();
            var operationEvents:Dictionary = new Dictionary();
            
            var describeTypeXml:XML = describeType(Object(logic).constructor);
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
   						operationEvents[ eventName ] = logic[ methodName ];
                        continue;
                    }
                }
			}
			
			var resultFunction:Function;
			var faultFunction:Function;
            for ( operationName in operations ){
                
                if( resultFunctions[ operationName ] != null ){
                    resultFunction = logic[resultFunctions[ operationName ]];
                } else {
                    resultFunction = null;
                }
                if( faultFunctions[ operationName ] != null ){
                    faultFunction = logic[faultFunctions[ operationName ]];
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