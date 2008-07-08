package org.seasar.akabana.yui.framework.error
{
    public class ComponentDuplicatedRegistrationError extends Error
    {
        public function ComponentDuplicatedRegistrationError(message:String="", id:int=0)
        {
            super(message, id);
        }
        
    }
}