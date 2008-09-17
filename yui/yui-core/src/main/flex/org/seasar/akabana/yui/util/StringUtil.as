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
package org.seasar.akabana.yui.util
{

	public class StringUtil
	{
	    public static function trim(str:String):String
	    {
	        if (str == null) return '';
	        
	        var startIndex:int = 0;
	        while (isWhitespace(str.charAt(startIndex)))
	            ++startIndex;
	
	        var endIndex:int = str.length - 1;
	        while (isWhitespace(str.charAt(endIndex)))
	            --endIndex;
	
	        if (endIndex >= startIndex)
	            return str.slice(startIndex, endIndex + 1);
	        else
	            return "";
	    }
	    
	    public static function isWhitespace(character:String):Boolean
	    {
	        switch (character)
	        {
	            case " ":
	            case "\t":
	            case "\r":
	            case "\n":
	            case "\f":
	                return true;
	
	            default:
	                return false;
	        }
	    }
	
	    public static function substitute(str:String, ... rest):String
	    {
	        if (str == null) return '';
	        
	        // Replace all of the parameters in the msg string.
	        var len:uint = rest.length;
	        var args:Array;
	        if (len == 1 && rest[0] is Array)
	        {
	            args = rest[0] as Array;
	            len = args.length;
	        }
	        else
	        {
	            args = rest;
	        }
	        
	        for (var i:int = 0; i < len; i++)
	        {
	            str = str.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
	        }
	
	        return str;
	    }
	}
}