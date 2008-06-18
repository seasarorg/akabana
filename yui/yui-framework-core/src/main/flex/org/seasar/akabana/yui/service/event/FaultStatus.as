/*
 * Copyright 2004-2008 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.service.event {
    public class FaultStatus {
        
        private var code_:String;
        
        private var description_:String;
        
        private var details_:String;
        
        public function FaultStatus(code:String, description:String, details:String = null){
            code_ = code;
            description_ = description;
            details_ = details;
        }
        
        public function get code():String{
            return code_;
        }
        
        public function get description():String{
            return description_;
        }
        
        public function get details():String{
            return details_;
        }
    }
}