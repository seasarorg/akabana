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
    import flash.utils.getTimer;
    
    import net.akb7.yui.core.logging.ILogger;
    import net.akb7.yui.util.DateUtil;
    
    public final class SimpleLogger implements ILogger {
        
        public function error(message:String,...args):void{
            log.apply(null,["[ERROR]",message].concat(args));
        }
        
        public function debug(message:String,...args):void{
            log.apply(null,["[DBGUG]",message].concat(args));
        }
        
        public function info(message:String,...args):void{
            log.apply(null,["[INFO_]",message].concat(args));
        }
        
        public function fatal(message:String,...args):void{
            log.apply(null,["[FATAL]",message].concat(args));
        }
        
        public function warn(message:String,...args):void{
            log.apply(null,["[WARN_]",message].concat(args));
        }
        
        private function log(level:String,message:String,...args):void{
            var time:String = "[" + DateUtil.getCurrentDateString() + "]";
            if( args.length == 0 ){
                trace(time,level,message);
            } else {
                trace.apply(null,[time,level,message].concat(args));
            }
        }
    }
}