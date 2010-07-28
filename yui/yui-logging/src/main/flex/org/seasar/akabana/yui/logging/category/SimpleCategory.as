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
package org.seasar.akabana.yui.logging.category
{
    import org.seasar.akabana.yui.logging.Level;
    import org.seasar.akabana.yui.logging.LoggingData;

    [ExcludeClass]
    public class SimpleCategory extends CategoryBase{

        public function fatal( message:String, erorr:Error = null ):void{
            if( Level.FATAL.isGreaterOrEqual( _level )){
                doLog( Level.FATAL, message, erorr);
            }
        }

        public function error( message:String, erorr:Error = null ):void{
            if( Level.ERROR.isGreaterOrEqual( _level )){
                doLog( Level.ERROR, message, erorr);
            }
        }

        public function warn( message:String, erorr:Error = null ):void{
            if( Level.WARN.isGreaterOrEqual( _level )){
                doLog( Level.WARN, message, erorr);
            }
        }

        public function info( message:String, erorr:Error = null ):void{
            if( Level.INFO.isGreaterOrEqual( _level )){
                doLog( Level.INFO, message, erorr);
            }
        }

        public function debug( message:String, erorr:Error = null ):void{
            if( Level.DEBUG.isGreaterOrEqual( _level )){
                doLog( Level.DEBUG, message, erorr);
            }
        }

        protected function doLog( level:Level, message:String, erorr:Error=null):void{
            callAppenders(new LoggingData( message, _level, this, erorr));
        }

        protected function callAppenders( data:LoggingData ):void{
            _appender.append(data);
        }
    }
}