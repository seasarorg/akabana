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
package org.seasar.akabana.yui.service.error {

    public final class IllegalDestinationError extends Error {
        
        public function IllegalDestinationError(name:String){
            var errorMessage:String;
            var errorCode:int;
            if( name == null ){
                errorMessage = "operation is none.";
                errorCode = ErrorCode.BASE + 5;
            } else {
                errorMessage = name + " is illegal destination name.";
                errorCode = ErrorCode.BASE + 6;
            }
            super(errorMessage,errorCode);
        }
        
    }
}