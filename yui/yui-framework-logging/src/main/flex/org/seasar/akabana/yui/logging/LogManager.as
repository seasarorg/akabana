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
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;
    
    import org.seasar.akabana.yui.logging.appender.SimpleAppender;
    import org.seasar.akabana.yui.logging.layout.PatternLayout;
    
    public class LogManager
    {
        private static const CACHE:Object= {};
        
        public static function getLogger( targetClass:Class ):Logger{
            var fullClassName:String = describeType( targetClass ).@name.toString();
            var logger_:Logger = CACHE[ fullClassName ];
            
            if( logger_ == null ){
                
                var layout_:PatternLayout = new PatternLayout();
                layout_.pattern ="%d [%c] %l - %m%t";
                
                var appender_:Appender = new SimpleAppender();
                appender_.layout = layout_;
                
                logger_ = new Logger();
                logger_.name = getQualifiedClassName(targetClass);
                logger_.addAppender( appender_ );
            }
                        
            return logger_;
        }
    }
}