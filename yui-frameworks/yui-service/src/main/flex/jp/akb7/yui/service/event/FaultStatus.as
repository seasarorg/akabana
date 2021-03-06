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
package jp.akb7.yui.service.event {
    import jp.akb7.yui.util.StringUtil;
    
    public final class FaultStatus {
        
        public var code:String;
        
        public var description:String;
        
        public var details:String;
        
        public function FaultStatus(code:String=null, description:String=null, details:String = null){
            this.code = code;
            this.description = description;
            this.details = details;
        }
        
        public function toString():String{
            return StringUtil.substitute("[{0}] {1}\n{2}",code,description,details);
        }
    }
}