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
package org.seasar.akabana.yui.core
{
    import flash.net.getClassByAlias;
    import flash.utils.getDefinitionByName;

    import org.seasar.akabana.yui.core.error.ClassNotFoundError;

    public class ClassLoader
    {
        public function findClass( name:String ):Class {
            var clazz:Class = null;
            try{
                clazz = getDefinitionByName( name ) as Class;
            } catch( e:Error ){
            }
            if ( clazz == null ){
                try{
                    clazz = getClassByAlias( name );
                } catch( e:Error ){
                }
            }
            if( clazz == null){
                var e:ClassNotFoundError = ClassNotFoundError.createError(name);
                throw e;
            }

            return clazz;
        }
    }
}