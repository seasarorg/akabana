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
package org.seasar.akabana.yui.core.event
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;

    public function notify(d:IEventDispatcher,type:String,...args):void{  
        var n:Notification;
        
        if( args.length > 1 ){
            n = new Notification(type,args);
        } else if( args.length == 1 ){
            n = new Notification(type,args[0]);
        } else {
            n = new Notification(type,null);
        }
        
        dispatchEvent(d,n);
    }
}