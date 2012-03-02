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
package jp.akb7.yui.util
{

    import mx.core.UIComponent;
    import mx.core.UIComponentDescriptor;
    import mx.core.mx_internal;

    [ExcludeClass]
    public final class UIComponentUtil {

        public static function getDescriptor( component:UIComponent ):UIComponentDescriptor{
            var result:UIComponentDescriptor = component.descriptor;
            if( result == null ){
                result = component.descriptor = new UIComponentDescriptor({});
            }
            if( result.events == null ){
                result.events = {};
            }
            return result;
        }

        public static function getDocumentDescriptor( component:UIComponent ):UIComponentDescriptor{
            var result:UIComponentDescriptor = component.mx_internal::documentDescriptor;
            if( result == null ){
                result = component.mx_internal::documentDescriptor = new UIComponentDescriptor({});
            }
            if( result.events == null ){
                result.events = {};
            }
            return result;
        }

        public static function getProperties( component:UIComponent ):Object{
            return getDescriptor(component).properties;
        }
    }
}