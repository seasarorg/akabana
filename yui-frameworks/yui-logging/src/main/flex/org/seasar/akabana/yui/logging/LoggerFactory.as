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
package org.seasar.akabana.yui.logging
{
    import flash.utils.getQualifiedClassName;
    import org.seasar.akabana.yui.core.logging.ILogger;
    import org.seasar.akabana.yui.core.logging.ILoggerFactory;

    public class LoggerFactory implements ILoggerFactory{
        
        public function getLogger( target:Object ):ILogger{
            var logger_:Logger = LogManager.getLogger(target);
            return logger_;
        }
    }
}