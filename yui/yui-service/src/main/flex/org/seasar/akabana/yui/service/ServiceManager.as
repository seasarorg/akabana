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
package org.seasar.akabana.yui.service {

    import flash.utils.Dictionary;
    
    import org.seasar.akabana.yui.util.StringUtil;

    [ExcludeClass]
    public final class ServiceManager {

        private static var serviceMap:Dictionary = new Dictionary(true);

        public static function createService( serviceClass:Class, name:String = null ):Service{
            var result:Service = getService( name );
            if( result == null ){
                result = new serviceClass();
				result.name = name;
                if( StringUtil.isEmpty(result.destination) ){
                    result.destination = name;
                }
                addService( result );
            }
            return result;
        }

        public static function addService( service:Service ):void{
            serviceMap[ service.name ] = service;
        }

        public static function removeService( service:Service ):void{
            serviceMap[ service.name ] = null;
            delete serviceMap[ service.name ];
        }

        public static function getService( name:String ):Service{
            return serviceMap[ name ] as Service;
        }

        public static function hasService( name:String ):Boolean{
            return serviceMap.hasOwnProperty(name);
        }
    }
}