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
package org.seasar.akabana.yui.service.error {

    public class IllegalOperationError extends Error {
        
        public function IllegalOperationError(name:String){
            var errorMessage:String;
            var errorCode:int;
            if( name == null ){
                errorMessage = "operation is none.";
                errorCode = ErrorCode.BASE + 3;
            } else {
                errorMessage = name + " is illegal operation name.";
                errorCode = ErrorCode.BASE + 4;
            }
            super(errorMessage,errorCode);
        }
        
    }
}