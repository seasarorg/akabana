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
package org.seasar.akabana.yui.framework.core
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.utils.Dictionary;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.framework.core.rule.IVolatileObject;
    import org.seasar.akabana.yui.framework.logging.debug;
    
    [ExcludeClass]
    public final class InstanceCache {
        
        private static const INSTANCE_REF_CACHE:Dictionary = new Dictionary(true);
        
        public static function newInstance(classRef:ClassRef,...args):Object{
            var result:Object = null;
            var cache:Dictionary = getCurrentInstanceRefCache();
            if( classRef.name in cache ){
                result = cache[ classRef.name ];
            } else {
                result = classRef.newInstance.apply(null,args);
                if( result is IVolatileObject ){
                } else {
                    cache[ classRef.name ] = result;
                }
            }
            return result;
        }

        public static function addRoot(root:Object):void{
            if( root != null ){
                removeRoot(root);
                INSTANCE_REF_CACHE[root] = new Dictionary(true);
            }
        }
        
        public static function removeRoot(root:Object):void{
            if( root != null && root in INSTANCE_REF_CACHE ){
                INSTANCE_REF_CACHE[root] = null;
                delete INSTANCE_REF_CACHE[root];
            }
        }
        
        private static function getCurrentInstanceRefCache():Dictionary{
            const currentRoot:Object = YuiFrameworkController.getInstance().currentRoot;
            var result:Dictionary;
            if( currentRoot in INSTANCE_REF_CACHE ){
                result = INSTANCE_REF_CACHE[ currentRoot ];   
            } else {
                result = new Dictionary(true);
                INSTANCE_REF_CACHE[ currentRoot ] = result;
            }
            return result;
        }
    }
}