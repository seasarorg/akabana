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
package org.seasar.akabana.yui.logging.category
{
    import mx.resources.ResourceManager;
    
    import org.seasar.akabana.yui.logging.Appender;
    import org.seasar.akabana.yui.logging.Level;
    import org.seasar.akabana.yui.logging.LoggingEvent;
    
    public class SimpleCategory extends CategoryBase
    {
        
        public function fatal( message:String, erorr:Error = null ):void{
            if( Level.FATAL.isGreaterOrEqual( _level )){
                doLog( Level.FATAL, message, erorr);
            }
        }
        
        public function fatalMessage(bundleName:String, resourceName:String,...parameters):void{
            fatal(
                substitute(
                    ResourceManager.getInstance().getString(bundleName,resourceName),
                    parameters
                )
            );
        }
        
        public function error( message:String, erorr:Error = null ):void{
            if( Level.ERROR.isGreaterOrEqual( _level )){
                doLog( Level.ERROR, message, erorr);
            }
        }
        
        public function errorMessage(bundleName:String, resourceName:String,...parameters):void{
            error(
                substitute(
                    ResourceManager.getInstance().getString(bundleName,resourceName),
                    parameters
                )
            );
        }
        
        public function warn( message:String, erorr:Error = null ):void{
            if( Level.WARN.isGreaterOrEqual( _level )){
                doLog( Level.WARN, message, erorr);
            }
        }
        
        public function warnMessage(bundleName:String, resourceName:String,...parameters):void{
            warn(
                substitute(
                    ResourceManager.getInstance().getString(bundleName,resourceName),
                    parameters
                )
            );
        }
        
        public function info( message:String, erorr:Error = null ):void{
            if( Level.INFO.isGreaterOrEqual( _level )){
                doLog( Level.INFO, message, erorr);
            }
        }
        
        public function infoMessage(bundleName:String, resourceName:String,...parameters):void{
            info(
                substitute(
                    ResourceManager.getInstance().getString(bundleName,resourceName),
                    parameters
                )
            );
        }
                                
        public function debug( message:String, erorr:Error = null ):void{
            if( Level.DEBUG.isGreaterOrEqual( _level )){
                doLog( Level.DEBUG, message, erorr);
            }
        } 
        
        public function debugMessage(bundleName:String, resourceName:String,...parameters):void{
            debug(
                substitute(
                    ResourceManager.getInstance().getString(bundleName,resourceName),
                    parameters
                )
            );
        }
        
        protected function doLog( level:Level, message:String, erorr:Error=null):void{
            callAppenders(new LoggingEvent( message, _level, this, erorr));
        }
        
        protected function callAppenders( event:LoggingEvent ):void{
            for each( var appender_:Appender in _appenders ){
                appender_.append(event);
            }
        }
    }
}