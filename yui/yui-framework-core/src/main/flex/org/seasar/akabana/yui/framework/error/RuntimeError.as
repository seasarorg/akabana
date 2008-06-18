package org.seasar.akabana.yui.framework.error
{
    public class RuntimeError extends Error
    {
        public function RuntimeError(message:String="", id:int=0)
        {
            super("Runtime Error:" + message, id);
        }
        
    }
}