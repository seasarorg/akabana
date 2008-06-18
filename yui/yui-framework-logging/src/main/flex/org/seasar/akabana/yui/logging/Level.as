package org.seasar.akabana.yui.logging
{
    public class Level {

        public static const OFF_INT:int   = int.MAX_VALUE;
        public static const FATAL_INT:int = 50000;
        public static const ERROR_INT:int = 40000;
        public static const WARN_INT:int  = 30000;
        public static const INFO_INT:int  = 20000;
        public static const DEBUG_INT:int = 10000;
        public static const TRACE_INT:int = 5000;
        public static const ALL_INT:int   = int.MIN_VALUE;

        public static const OFF:Level   = new Level( OFF_INT,   "OFF");
        public static const FATAL:Level = new Level( FATAL_INT, "FATAL");
        public static const ERROR:Level = new Level( ERROR_INT, "ERROR");
        public static const WARN:Level  = new Level( WARN_INT,  "WARN");
        public static const INFO:Level  = new Level( INFO_INT,  "INFO");
        public static const DEBUG:Level = new Level( DEBUG_INT, "DEBUG");
        public static const TRACE:Level = new Level( TRACE_INT, "TRACE");
        public static const ALL:Level   = new Level( ALL_INT,   "ALL");
        
        public var value:int = ALL_INT;
        
        public var name:String;
        
        public function Level( value:int, name:String ){
            this.value = value;
            this.name = name;
        }

        public function isGreaterOrEqual(level:Level):Boolean{
          return value >= level.value;
        }
    }
}