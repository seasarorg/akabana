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
package jp.akb7.yui.event
{
    import flash.events.Event;
    
    [ExcludeClass]
    public final class YuiFrameworkEvent extends Event {
        
        public static const APPLICATION_MONITOR_START:String = "applicationMonitorStart";
        
        public static const APPLICATION_MONITOR_STOP:String = "applicationMonitorStop";
        
        public static const APPLICATION_START:String = "applicationStart";

        public static const VIEW_INITIALIZED:String = "viewInitialized";
        
        public function YuiFrameworkEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
            super(type, bubbles, cancelable);
        }
        
        public override function clone():Event{
            return new YuiFrameworkEvent(type, bubbles, cancelable);
        }
        
        public override function toString():String{
            return formatToString("YuiFrameworkEvent", "type", "bubbles", "cancelable","eventPhase");
        }
    }
}