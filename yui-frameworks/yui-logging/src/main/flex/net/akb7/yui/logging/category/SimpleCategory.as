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
package net.akb7.yui.logging.category
{
    import net.akb7.yui.logging.Level;
    import net.akb7.yui.logging.LoggingData;

    [ExcludeClass]
    public class SimpleCategory extends CategoryBase{

        public function fatal( message:String,...args ):void{
            if( Level.FATAL.isGreaterOrEqual( _level )){
                doLog( Level.FATAL, message, args);
            }
        }

        public function error( message:String,...args ):void{
            if( Level.ERROR.isGreaterOrEqual( _level )){
                doLog( Level.ERROR, message, args);
            }
        }

        public function warn( message:String,...args ):void{
            if( Level.WARN.isGreaterOrEqual( _level )){
                doLog( Level.WARN, message, args);
            }
        }

        public function info( message:String,...args ):void{
            if( Level.INFO.isGreaterOrEqual( _level )){
                doLog( Level.INFO, message, args);
            }
        }

        public function debug( message:String,...args ):void{
            if( Level.DEBUG.isGreaterOrEqual( _level )){
                doLog( Level.DEBUG, message, args);
            }
        }

        protected function doLog( level:Level, message:String, args:Array=null):void{
            if( args.length == 0 ){
                callAppenders(new LoggingData( message, level, this));
            } else {
                var e:Error = args[0] as Error;
                if( e == null ){
                    callAppenders(new LoggingData( message, level, this, null, args));
                } else {
                    callAppenders(new LoggingData( message, level, this, e, args.splice(0,1)));
                }
            }
        }

        protected function callAppenders( data:LoggingData ):void{
            _appender.append(data);
        }
    }
}