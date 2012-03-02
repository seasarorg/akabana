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
package jp.akb7.yui.core.reflection
{
    import __AS3__.vec.Vector;

    [ExcludeClass]
    internal class AnnotatedObjectRef extends ObjectRef implements IAnnotatedReflector {

        private static const METADATA_HELP:String = "__go_to_definition_help";

        private static function isTargetMetadata( metadataXML:XML ):Boolean{
            var isTarget:Boolean;
            do{
                if( metadataXML.@name.toString() == METADATA_HELP){
                    isTarget = false;
                    break;
                }
                //
                var list:XMLList = metadataXML.@declaredBy;
                if( list.length() > 0 ){
                    var declaredBy_:String = list[0].toString();
                    if( EXCLUDE_DECLARED_BY_FILTER_REGEXP.test(declaredBy_)){
                        isTarget = false;
                    }
                }
                isTarget = true;
            }while(false);
            return isTarget;
        }
        
        private var _isInitialiedMetadata:Boolean;

        private var _metadatas:Vector.<MetadataRef>;

        public function get metadatas():Vector.<MetadataRef>{
            if( !_isInitialiedMetadata ){
                assembleMetadataRef(describeType);
            }
            return _metadatas;
        }

        private var _metadataMap:Object;

        public function AnnotatedObjectRef( describeTypeXml:XML ){
            super( describeTypeXml );
            _metadatas = new Vector.<MetadataRef>();
            _metadataMap = {};
        }

        public function hasMetadata( metadataName:String ):Boolean{
            return _metadataMap[ metadataName ] != null;
        }

        public function getMetadata( metadataName:String ):MetadataRef{
            return _metadataMap[metadataName];
        }

        protected final function assembleMetadataRef( rootDescribeTypeXml:XML ):void{
            var metadataRef:MetadataRef = null;
            var metadatasXMLList:XMLList = rootDescribeTypeXml.metadata;
            for each( var metadataXML:XML in metadatasXMLList ){
                if( isTargetMetadata(metadataXML)){
                    metadataRef = new MetadataRef(metadataXML);

                    _metadatas.push( metadataRef );
                    _metadataMap[ metadataRef.name ] = metadataRef;
                }
            }
            _isInitialiedMetadata = true;
        }
    }
}