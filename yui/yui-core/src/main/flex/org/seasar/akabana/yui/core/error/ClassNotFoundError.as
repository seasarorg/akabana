package org.seasar.akabana.yui.core.error
{
    public class ClassNotFoundError extends Error
    {
        public var className:String;
        
        public function ClassNotFoundError(message:String="", id:int=0)
        {
            super(message, id);
        }

    }
}