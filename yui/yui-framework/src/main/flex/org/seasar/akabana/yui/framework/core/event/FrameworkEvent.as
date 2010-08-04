/*
 * Copyright 2004-2010 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.framework.core.event
{
    import flash.events.Event;
    

    public class FrameworkEvent extends Event
    {
        public static const APPLICATION_MONITOR_START:String = "applicationMonitorStart";
		
		public static const APPLICATION_MONITOR_STOP:String = "applicationMonitorStop";
        
        public static const ASSEMBLE_COMPELETE:String = "assembleComplete";
        
        public static const APPLICATION_START:String = "applicationStart";
        
        public function FrameworkEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}