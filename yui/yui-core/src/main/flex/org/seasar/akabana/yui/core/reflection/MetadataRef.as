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
package org.seasar.akabana.yui.core.reflection
{
    
    public class MetadataRef extends ObjectRef
    {

        private var _args:Array;

        public function get args():Array{
            return _args;
        }
        
        private var _argMap:Object;
        
        public function MetadataRef( describeTypeXml:XML )
        {
            super( describeTypeXml );
            assembleArgs( describeTypeXml );
        }
        
        public function hasArgs():Boolean{
            return _args.length() > 0;
        }
        
        public function getArgValue( key:String ):Object{
            return _argMap[ key ];
        }
        
        public function toString():String{
            var toString_:String = "[" + name + "]{";
            
            for( var key:String in _argMap ){
                toString_ += key + ":" + _argMap[ key ] + ",";
            }
            
            toString_ += "}";
                
            return toString_;
        }
        
        private function assembleArgs( rootDescribeTypeXml:XML ):void{
            _args = [];
            _argMap = {};
               
            var argsXMLList:XMLList = rootDescribeTypeXml.arg;
            for each( var argXML:XML in argsXMLList ){
                var name:String = argXML.@key.toString();
                if( name == "__go_to_definition_help"){
                    continue;
                }
                
                var value:Object = argXML.@value.toString();
                
                _args.push( name );
                _argMap[ name ] = value;
            }
        }
    }
}