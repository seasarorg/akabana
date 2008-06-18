package org.seasar.akabana.yui.core.reflection
{
    
    public interface AnnotatedReflector extends Reflector
    {
        function hasMetadata( metadata:String ):Boolean;
        
        function getMetadata( metadata:String ):MetadataRef;
        
        [ArrayElementType("my.core.metadata.MetadataRef")]
        function getMetadatas():Array;
        
        [ArrayElementType("my.core.metadata.MetadataRef")]
        function getDeclaredMetadatas():Array;
        
    }
}