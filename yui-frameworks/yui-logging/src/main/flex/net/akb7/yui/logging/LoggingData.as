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
package net.akb7.yui.logging
{
    [ExcludeClass]
    public class LoggingData{

        public static const START_TIME:Number = new Date().time;

        public var categoryName:String;

        public var level:Level;

        public var message:String;

        public var timeStamp:Number;

        public var error:Error;
        
        public var args:Array;

        public function LoggingData( message:String, level:Level=null, logger:ICategory=null, error:Error=null, args:Array=null){
            this.timeStamp = new Date().time;
            this.categoryName = logger.name;
            this.message = message;
            this.level = level;
            this.error = error;
            this.args = args;
        }
    }
}