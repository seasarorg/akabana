/*
 * Copyright 2004-2007 the Seasar Foundation and the Others.
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
    import org.seasar.akabana.yui.logging.Appender;
    import org.seasar.akabana.yui.logging.Category;
    import org.seasar.akabana.yui.logging.Level;
    
    public class CategoryBase implements Category
    {
        protected var _name:String;
        
        public function get name():String{
            return _name;
        }
        
        public function set name( value:String ):void{
            this._name = value;
        }        
        
        protected var _level:Level;
        
        public function get level():Level{
            return _level;
        }
        
        public function set level( value:Level ):void{
            _level = value;
        }
        
        protected var _appenders:Array;
        
        public function get appenderCount():int{
            return _appenders.length;
        }
        
        public function CategoryBase(){
            _appenders = [];
            _level = Level.ALL;
        }
        
        public function addAppender( appender:Appender ):void{
            if( appender != null ){
                _appenders.push( appender );
            }
        }

        public function removeAppender( appender:Appender ):void{
            var appenderIndex_:int = _appenders.indexOf(appender);
            _appenders.splice(appenderIndex_,1);
        }
    }
}