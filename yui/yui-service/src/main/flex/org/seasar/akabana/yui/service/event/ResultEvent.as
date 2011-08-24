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
package org.seasar.akabana.yui.service.event 
{
    public final class ResultEvent extends AbstractServiceEvent {
        
        public static const RESULT:String = "result";
        
        private var _result:Object;

        public function get result():Object{
            return _result;
        }

        public function set result(value:Object):void{
            _result = value;
        }

        public function ResultEvent( result:Object = null, bubbles:Boolean = false, cancelable:Boolean = false  ){
            super( RESULT, bubbles, cancelable );
            
            this.result = result;
        }
    }
}