package org.seasar.akabana.yui.core.reflection
{
    import flash.utils.describeType;
    
    internal class AnnotatedObjectRef extends ObjectRef implements AnnotatedReflector
    {
        
        [ArrayElementType("my.core.metadata.MetadataRef")]
        private var _metadatas:Array;
        
        public function get metadatas():Array{
            return _metadatas;
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
        
        public function getMetadatas():Array{
            return _metadatas;
        }
        
        public function getDeclaredMetadatas():Array{
            return _metadatas;
        }
        
        protected final function assembleMetadataRef( rootDescribeTypeXml:XML ):void{
            _metadatas = [];
            _metadataMap = {};
            
            var metadataRef:MetadataRef = null;
            var metadatasXMLList:XMLList = rootDescribeTypeXml.metadata;
            for each( var metadataXML:XML in metadatasXMLList ){
                metadataRef = new MetadataRef(metadataXML);
                
                _metadatas.push( metadataRef );
                _metadataMap[ metadataRef.name ] = metadataRef;
            }
        }
        
    }
}