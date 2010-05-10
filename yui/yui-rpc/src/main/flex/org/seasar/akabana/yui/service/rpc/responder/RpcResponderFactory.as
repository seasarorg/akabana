package org.seasar.akabana.yui.service.rpc.responder
{
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.service.resonder.ResponderFactory;

    [ExcludeClass]
    public class RpcResponderFactory extends ResponderFactory
    {
        public function RpcResponderFactory()
        {
            super();
            eventResoponderClassRef = getClassRef(RpcEventResponder);
            objectResponderClassRef = getClassRef(RpcObjectResponder);
            noneResponderClassRef = getClassRef(RpcNoneResponder);
        }
    }
}