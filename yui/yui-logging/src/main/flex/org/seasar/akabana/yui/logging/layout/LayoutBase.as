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
package org.seasar.akabana.yui.logging.layout
{
    import org.seasar.akabana.yui.logging.Layout;
    import org.seasar.akabana.yui.logging.LoggingData;

    [ExcludeClass]
    public class LayoutBase implements Layout {

        private static const EMPTY_STRING:String = "";

        protected var _header:String;

        public function get header():String{
            return _header;
        }

        public function set header( value:String ):void{
            _header = value;
        }

        protected var _footer:String;

        public function get footer():String{
            return _footer;
        }

        public function set footer( value:String ):void{
            _footer = value;
        }

        public function format( data:LoggingData ):String{
            return EMPTY_STRING;
        }
    }
}