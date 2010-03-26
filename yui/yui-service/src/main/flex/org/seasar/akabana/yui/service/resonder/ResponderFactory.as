package org.seasar.akabana.yui.service.resonder
{
    import org.seasar.akabana.yui.core.error.NotFoundError;
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.core.reflection.ParameterRef;
    import org.seasar.akabana.yui.service.Operation;
    import org.seasar.akabana.yui.service.ns.fault;
    import org.seasar.akabana.yui.service.ns.result;
    import org.seasar.akabana.yui.util.StringUtil;

    public class ResponderFactory
    {

        private static const RESULT_HANDLER:String = "ResultHandler";

        private static const FAULT_HANDLER:String = "FaultHandler";

        protected var eventResoponderClassRef:ClassRef;

        protected var objectResponderClassRef:ClassRef;

        protected var noneResponderClassRef:ClassRef;

        public function ResponderFactory(){

        }

        public function createResponder( operation:Operation, responder:Object ):Responder{
            const classRef:ClassRef = ClassRef.getReflector(responder);
            const serviceMethod:String = StringUtil.toLowerCamel( operation.serviceName ) + StringUtil.toUpperCamel( operation.name );
            const resultFuncDef:FunctionRef = findResultFunctionRef( classRef, serviceMethod );
            if( resultFuncDef == null ){
                throw new NotFoundError( responder, "public function " + serviceMethod + RESULT_HANDLER + " or result function " + serviceMethod);
            }
            const faultFuncDef:FunctionRef = findFaultFunctionRef( classRef, serviceMethod );

            var rpcResponder:Responder = null;
            var responderClassRef:ClassRef;
            if( resultFuncDef.parameters.length <= 0 ){
                responderClassRef = noneResponderClassRef;
            } else {
                var parameter:ParameterRef = resultFuncDef.parameters[0];
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

        protected function findResultFunctionRef( classRef:ClassRef, serviceMethod:String ):FunctionRef{
            const serviceResultMethod:String = serviceMethod + RESULT_HANDLER;
            var functionRef:FunctionRef = classRef.getFunctionRef( serviceResultMethod );
            if( functionRef == null ){
                var ns:Namespace = org.seasar.akabana.yui.service.ns.result;
                functionRef = classRef.getFunctionRef(serviceMethod,ns);
            }
            return functionRef;
        }

        protected function findFaultFunctionRef( classRef:ClassRef, serviceMethod:String ):FunctionRef{
            const serviceFaultMethod:String = serviceMethod + FAULT_HANDLER;
            var functionRef:FunctionRef = classRef.getFunctionRef( serviceFaultMethod );
            if( functionRef == null ){
                var ns:Namespace = org.seasar.akabana.yui.service.ns.fault;
                functionRef = classRef.getFunctionRef(serviceMethod,ns);
            }
            return functionRef;
        }

    }
}