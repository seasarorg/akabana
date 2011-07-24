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
package org.seasar.akabana.yui.service.resonder
{
    import org.seasar.akabana.yui.core.error.NotFoundError;
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.core.reflection.ParameterRef;
    import org.seasar.akabana.yui.service.Operation;
    import org.seasar.akabana.yui.service.ns.rpc_fault;
    import org.seasar.akabana.yui.service.ns.rpc_result;
    import org.seasar.akabana.yui.util.StringUtil;

    [ExcludeClass]
    public class ResponderFactory {
        
        private static const EVENT_SEPARETOR:String = "_";

        private static const RESULT_HANDLER:String = "ResultHandler";

        private static const FAULT_HANDLER:String = "FaultHandler";

        protected var eventResoponderClassRef:ClassRef;

        protected var objectResponderClassRef:ClassRef;

        protected var noneResponderClassRef:ClassRef;

        public function ResponderFactory(){

        }

        public function createResponder( operation:Operation, responder:Object ):Responder{
            const classRef:ClassRef = getClassRef(responder);
            const resultFuncDef:FunctionRef = findResultFunctionRef( classRef, operation.serviceName, operation.name );
            const faultFuncDef:FunctionRef = findFaultFunctionRef( classRef, operation.serviceName, operation.name  );

            var rpcResponder:Responder = null;
            var responderClassRef:ClassRef;
            if( resultFuncDef.parameters.length <= 0 ){
                responderClassRef = noneResponderClassRef;
            } else {
                var parameter:ParameterRef = resultFuncDef.parameters[0] as ParameterRef;
                if( parameter.isEvent ){
                    responderClassRef = eventResoponderClassRef;
                } else {
                    responderClassRef = objectResponderClassRef;
                }
            }
            if( faultFuncDef == null){
                rpcResponder = responderClassRef.newInstance(resultFuncDef.getFunction(responder),null,true) as Responder;
            } else {
                rpcResponder = responderClassRef.newInstance(resultFuncDef.getFunction(responder),faultFuncDef.getFunction(responder),true) as Responder;
            }
            return rpcResponder as Responder;
        }

        public function findResultFunctionRef( classRef:ClassRef, serviceName:String, serviceMethodName:String ):FunctionRef{
            var serviceMethod:String = StringUtil.toLowerCamel( serviceName ) + StringUtil.toUpperCamel( serviceMethodName );
            var serviceResultMethod:String = serviceMethod + RESULT_HANDLER;
            var functionRef:FunctionRef = classRef.getFunctionRef( serviceResultMethod );
            do{
                var ns:Namespace = org.seasar.akabana.yui.service.ns.rpc_result;
                if( functionRef == null ){
                    serviceMethod = StringUtil.toLowerCamel( serviceName ) + EVENT_SEPARETOR + serviceMethodName;
                    functionRef = classRef.getFunctionRef(serviceMethod,ns);
                    break;
                }
                if( functionRef == null ){
                    functionRef = classRef.getFunctionRef(serviceMethod,ns);
                    break;
                }
            }while(false);
            if( functionRef == null ){
                throw new NotFoundError( classRef.name, "public function " + serviceMethod + RESULT_HANDLER + " or rpc_result function " + serviceMethod);
            }
            return functionRef;
        }

        public function findFaultFunctionRef( classRef:ClassRef, serviceName:String, serviceMethodName:String ):FunctionRef{
            var serviceMethod:String = StringUtil.toLowerCamel( serviceName ) + StringUtil.toUpperCamel( serviceMethodName );
            var serviceFaultMethod:String = serviceMethod + FAULT_HANDLER;
            var functionRef:FunctionRef = classRef.getFunctionRef( serviceFaultMethod );

            do{
                var ns:Namespace = org.seasar.akabana.yui.service.ns.rpc_fault;
                if( functionRef == null ){
                    serviceMethod = StringUtil.toLowerCamel( serviceName ) + EVENT_SEPARETOR + serviceMethodName;
                    functionRef = classRef.getFunctionRef(serviceMethod,ns);
                    break;
                }
                if( functionRef == null ){
                    functionRef = classRef.getFunctionRef(serviceMethod,ns);
                    break;
                }
            }while(false);

            return functionRef;
        }

    }
}