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
CONFIG::FP10{
    import __AS3__.vec.Vector;
}

    internal class AnnotatedObjectRef extends ObjectRef implements AnnotatedReflector{

        private static const HELP_METADATA:String = "__go_to_definition_help";

        private static function isTargetMetadata( metadataXML:XML ):Boolean{
            var isTarget:Boolean;
            do{
                if( metadataXML.@name.toString() == HELP_METADATA){
                    isTarget = false;
                    break;
                }
                //
                var list:XMLList = metadataXML.@declaredBy;
                if( list.length() > 0 ){
                    var declaredBy_:String = list[0].toString();
                    if( excludeDeclaredByFilterRegExp.test(declaredBy_)){
                        isTarget = false;
                    }
                }
                isTarget = true;
            }while(false);
            return isTarget;
        }

CONFIG::FP9{
        private var _metadatas:Array;

        public function get metadatas():Array{
            return _metadatas;
        }
}
CONFIG::FP10{
        private var _metadatas:Vector.<MetadataRef>;

        public function get metadatas():Vector.<MetadataRef>{
            return _metadatas;
        }
}

        private var _metadataMap:Object;

        public function AnnotatedObjectRef( describeTypeXml:XML ){
            super( describeTypeXml );
        }

        public function hasMetadata( metadataName:String ):Boolean{
            return _metadataMap[ metadataName ] != null;
        }

        public function getMetadata( metadataName:String ):MetadataRef{
            return _metadataMap[metadataName];
        }

        protected final function assembleMetadataRef( rootDescribeTypeXml:XML ):void{
CONFIG::FP9{
            _metadatas = [];
}
CONFIG::FP10{
            _metadatas = new Vector.<MetadataRef>();
}
            _metadataMap = {};

            var metadataRef:MetadataRef = null;
            var metadatasXMLList:XMLList = rootDescribeTypeXml.metadata;
            for each( var metadataXML:XML in metadatasXMLList ){
                if( isTargetMetadata(metadataXML)){
                    metadataRef = new MetadataRef(metadataXML);

                    _metadatas.push( metadataRef );
                    _metadataMap[ metadataRef.name ] = metadataRef;
                }
            }
        }
    }
}