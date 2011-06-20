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
package 
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import org.seasar.akabana.yui.core.event.NotificationEvent;

    /**
     * 指定されたターゲットに対して通知を送ります。
     */
    public function sendNotification(target:IEventDispatcher,type:String,...args):void {
        var n:NotificationEvent;
        
        if( args.length > 1 ){
            n = new NotificationEvent(type,args);
        } else if( args.length == 1 ){
            n = new NotificationEvent(type,args[0]);
        } else {
            n = new NotificationEvent(type,null);
        }
        
        dispatchEvent(target,n);
    }
}