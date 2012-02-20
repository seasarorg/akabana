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
package org.seasar.akabana.yui.logging.appender
{
    import org.seasar.akabana.yui.logging.IAppender;
    import org.seasar.akabana.yui.logging.ILayout;
    import org.seasar.akabana.yui.logging.LoggingData;

    [ExcludeClass]
    public class AppenderBase implements IAppender
    {

        protected var _name:String;

        public function get name():String
        {
            return _name;
        }

        public function set name(value:String):void
        {
            _name = value;
        }

        protected var _layout:ILayout;

        public function get layout():ILayout
        {
            return _layout;
        }

        public function set layout(value:ILayout):void
        {
            _layout = value;
        }

        public function AppenderBase()
        {
            super();
        }

        public function close():void
        {

        }

        public function append( data:LoggingData ):void
        {
        }
    }
}