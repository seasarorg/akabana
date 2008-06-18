package org.seasar.akabana.yui.core.reflection
{    
    public class PropertyRef extends AnnotatedObjectRef
    {
        
        private var _isReadable:Boolean;

        public function get isReadable():Boolean{
            return _isReadable;
        }
        
        private var _isWriteable:Boolean;

        public function get isWriteable():Boolean{
            return _isWriteable;
        }
        
        private var _type:String;

        public function get type():String{
            return _type;
        }
        
        public function get typeClassRef():ClassRef{
            return Reflectors.getClassReflector(type);
        }
        
        private var _declaredBy:String;

        public function get declaredBy():String{
            return _declaredBy;
        }
        
        public function PropertyRef( describeTypeXml:XML )
        {
            super( describeTypeXml );
            assembleMetadataRef( describeTypeXml );
            assembleThis( describeTypeXml );
        }
        
        public function toString():String{
            return name + "{type=" + _type + ", declaredBy=" + _declaredBy + ", isReadable=" + _isReadable + ", isWriteable=" + _isWriteable + "}";
        }
        
        private function assembleThis( rootDescribeTypeXml:XML ):void{
            var access:String = rootDescribeTypeXml.@access.toString();
            _isReadable = ( access == "readonly" || access == "readwrite" );
            _isWriteable = ( access == "writeonly" || access == "readwrite" );
            _type = getTypeString(rootDescribeTypeXml.@type.toString());
            _declaredBy = getTypeString(rootDescribeTypeXml.@declaredBy.toString());
        }
    }
}