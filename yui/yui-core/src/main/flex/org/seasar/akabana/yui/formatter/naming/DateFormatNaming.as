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
package org.seasar.akabana.yui.formatter.naming
{
    public class DateFormatNaming {

        public static var MONTH_SHORT:Array = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
        
        public static var MONTH_LONG:Array = ["January","February","March","April","May","June","July","August","September","October","November","December"];
        
        public static var DAY_SHORT:Array = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
        
        public static var DAY_LONG:Array = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
        
        public static var TIME_SCTION:Array = ["AM","PM"];
        
        public function getMonthShort(month:int):String{
            return MONTH_SHORT[month];
        }

        public function getMonthLong(month:int):String{
            return MONTH_LONG[month];
        }

        public function getDayShort(day:int):String{
            return DAY_SHORT[day];
        }

        public function getDayLong(day:int):String{
            return DAY_LONG[day];
        }
        
        public function getTimeSection(time:int):String{
            return TIME_SCTION[time];
        }

    }
}