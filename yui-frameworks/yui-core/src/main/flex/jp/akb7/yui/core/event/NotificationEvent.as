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
package jp.akb7.yui.core.event
{
    import flash.events.Event;

    /**
     * 通知イベントクラス
     * 
     * 子コンポーネントから親コンテナにメッセージを通知するためのイベントクラスです。
     * 
     */
    public final class NotificationEvent extends Event {
        
        private var _data:Object;
        
        public function get data():Object {
            return _data;
        }
        
        public function NotificationEvent(type:String,data:Object) {
            super(type, true, true);
            _data = data;
        }
        
        public override function clone():Event{
            return new NotificationEvent(type, _data);
        }
        
        public override function toString():String{
            return formatToString("NotificationEvent", "type", "bubbles", "cancelable","eventPhase","data");
        }
    }
}