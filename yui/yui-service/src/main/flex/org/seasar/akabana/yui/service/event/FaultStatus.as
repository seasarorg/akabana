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
    import org.seasar.akabana.yui.util.StringUtil;
    
    public class FaultStatus {
        
        private var _code:String;
        
        private var _description:String;
        
        private var _details:String;
        
        public function FaultStatus(code:String, description:String, details:String = null){
            _code = code;
            _description = description;
            _details = details;
        }
        
        public function get code():String{
            return _code;
        }
        
        public function get description():String{
            return _description;
        }
        
        public function get details():String{
            return _details;
        }
        
        public function toString():String{
            return StringUtil.substitute("[{0}] {1}\n{2}",_code,_description,_details);
        }
    }
}