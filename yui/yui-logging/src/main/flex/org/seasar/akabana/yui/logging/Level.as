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
package org.seasar.akabana.yui.logging
{
    public class Level {

        public static const OFF_INT:int   = int.MAX_VALUE;
        public static const FATAL_INT:int = 50000;
        public static const ERROR_INT:int = 40000;
        public static const WARN_INT:int  = 30000;
        public static const INFO_INT:int  = 20000;
        public static const DEBUG_INT:int = 10000;
        public static const ALL_INT:int   = int.MIN_VALUE;

        public static const OFF:Level   = new Level( OFF_INT,   "OFF");
        public static const FATAL:Level = new Level( FATAL_INT, "FATAL");
        public static const ERROR:Level = new Level( ERROR_INT, "ERROR");
        public static const WARN:Level  = new Level( WARN_INT,  "WARN");
        public static const INFO:Level  = new Level( INFO_INT,  "INFO");
        public static const DEBUG:Level = new Level( DEBUG_INT, "DEBUG");
        public static const ALL:Level   = new Level( ALL_INT,   "ALL");
        
        public static function getLevel( name:String ):Level{
            var levelName_:String = name.toUpperCase();
            
            switch( true ){
                case levelName_ == OFF.name:{
                    return OFF;
                }
                case levelName_ == FATAL.name:{
                    return FATAL;
                }
                case levelName_ == ERROR.name:{
                    return ERROR;
                }
                case levelName_ == WARN.name:{
                    return WARN;
                }
                case levelName_ == INFO.name:{
                    return INFO;
                }
                case levelName_ == DEBUG.name:{
                    return DEBUG;
                }
                default:
            }            
            return ALL;
        }
        
        public var value:int = ALL_INT;
        
        public var name:String;
        
        public function Level( value:int, name:String ){
            this.value = value;
            this.name = name;
        }

        public function isGreaterOrEqual(level:Level):Boolean{
          return value >= level.value;
        }
    }
}