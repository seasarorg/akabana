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
package org.seasar.akabana.yui.core.reflection
{
CONFIG::FP10{
    import __AS3__.vec.Vector;
}

    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;
    import flash.utils.Dictionary;

    import org.seasar.akabana.yui.core.ClassLoader;
    import org.seasar.akabana.yui.core.error.ClassNotFoundError;

    public final class ClassRef extends AnnotatedObjectRef {
        
        public static const ARRAY_CLASS:String = "Array";
        
        public static const VECTOR_CLASS:String = "__AS3__.vec.Vector.<";

        public static var classLoader:ClassLoader = new ClassLoader();
        
        private static const _UNDER_:String = _UNDER_;

        private static const CLASS_REF_CACHE:Dictionary = new Dictionary();
        
        private static const PRIMITIVE_CLASS_MAP:Object = {String:1,Boolean:1,int:1,Number:1,Object:1,String:1,uint:1};
        
        private static const TOPLEVEL_CLASS_MAP:Object = {Date:1,XML:1,Object:1};
        
        public static function getInstance( target:Object ):ClassRef{
            if( target == null ){
                return null;
            }
            var clazz:Class = null;
            try {
                switch( true ){
                    case ( target is Class ):
                        clazz = target as Class;
                        break;

                    case ( target is String ):
                        clazz = classLoader.findClass(target as String);
                        break;

                    default:
                        clazz = classLoader.findClass(getQualifiedClassName(target));
                }
            } catch( e:Error ){
                throw e;
            }

            var classRef:ClassRef = null;
            if( clazz != null ){
                if( clazz in CLASS_REF_CACHE ){
                    classRef = CLASS_REF_CACHE[ clazz ];
                } else {
                    classRef = new ClassRef(clazz);
                    CLASS_REF_CACHE[ clazz ] = classRef;
                }
            }

            return classRef;
        }

        public static function getCanonicalName( object:Object ):String{
            return getTypeString(flash.utils.getQualifiedClassName(object));
        }

        private static function isTargetAccessor( rootDescribeTypeXml:XML ):Boolean{
            const name_:String = rootDescribeTypeXml.@name.toString();
            const declaredBy_:String = rootDescribeTypeXml.@declaredBy.toString();
            const uri_:String = rootDescribeTypeXml.@uri.toString();

            return (name_.indexOf(_UNDER_) != 0) && 
                (!(
                    excludeDeclaredByFilterRegExp.test(declaredBy_) ||
                    excludeUriFilterRegExp.test(uri_)
                ));
        }

        private static function isTargetVariable( rootDescribeTypeXml:XML ):Boolean{
            const name_:String = rootDescribeTypeXml.@name.toString();
            const declaredBy_:String = rootDescribeTypeXml.@declaredBy.toString();
            const uri_:String = rootDescribeTypeXml.@uri.toString();

            return (name_.indexOf(_UNDER_) != 0) &&
                (!(
                    excludeDeclaredByFilterRegExp.test(declaredBy_) ||
                    excludeUriFilterRegExp.test(uri_)
                ));
        }

        private static function isTargetFunction( rootDescribeTypeXml:XML ):Boolean{
            const name_:String = rootDescribeTypeXml.@name.toString();
            const declaredBy_:String = rootDescribeTypeXml.@declaredBy.toString();
            const uri_:String = rootDescribeTypeXml.@uri.toString();

            return (name_.indexOf(_UNDER_) != 0) &&
                (!(
                    excludeDeclaredByFilterRegExp.test(declaredBy_) ||
                    excludeUriFilterRegExp.test(uri_)
                ));
        }

        private var _concreteClass:Class;

        public function get concreteClass():Class
        {
            return _concreteClass;
        }

        private var _isInterface:Boolean;

        public function get isInterface():Boolean
        {
            return _isInterface;
        }

        private var _isEvent:Boolean;

        public function get isEvent():Boolean
        {
            return _isEvent;
        }

        private var _isDisplayObject:Boolean;

        public function get isDisplayObject():Boolean
        {
            return _isDisplayObject;
        }

        private var _isEventDispatcher:Boolean;

        public function get isEventDispatcher():Boolean
        {
            return _isEventDispatcher;
        }

        private var _className:String;

        public function get className():String{
            return _className;
        }

        private var _isInitialiedProperties:Boolean;
CONFIG::FP9{
        private var _properties:Array;

        public function get properties():Array{
            if( !_isInitialiedProperties){ 
                assemblePropertyRef(_describeTypeXml.factory[0]);
            }
            return _properties;
        }
}
CONFIG::FP10{
        private var _properties:Vector.<PropertyRef>;

        public function get properties():Vector.<PropertyRef>{
            if( !_isInitialiedProperties){ 
                assemblePropertyRef(_describeTypeXml.factory[0]);
            }
            return _properties;
        }
}

        private var _propertyMap:Object;

        private var _typeToPropertyMap:Object;

        private var _isInitialiedFunctions:Boolean;
CONFIG::FP9{
        private var _functions:Array;

        public function get functions():Array{
            if( !_isInitialiedFunctions ){ 
                assembleFunctionRef(_describeTypeXml.factory[0]);
            }
            return _functions;
        }
}
CONFIG::FP10{
        private var _functions:Vector.<FunctionRef>;

        public function get functions():Vector.<FunctionRef>{
            if( !_isInitialiedFunctions ){ 
                assembleFunctionRef(_describeTypeXml.factory[0]);
            }
            return _functions;
        }
}

        private var _functionMap:Object;

        private var _returnTypeToFunctionMap:Object;
        
        private var _isInitialiedSuperClasses:Boolean;
CONFIG::FP9{
        private var _superClasses:Array;
        
        public function get superClasses():Array{
            if( !_isInitialiedSuperClasses ){ 
                assembleSuperClasses(_describeTypeXml.factory[0]);
            }
            return _superClasses;
        }
}
CONFIG::FP10{
        private var _superClasses:Vector.<String>;
        
        public function get superClasses():Vector.<String>{
            if( !_isInitialiedSuperClasses ){ 
                assembleSuperClasses(_describeTypeXml.factory[0]);
            }
            return _superClasses;
        }
}
        
        private var _superClassMap:Object;
        
        private var _isInitialiedInterfaces:Boolean;
CONFIG::FP9{
        private var _interfaces:Array;
        
        public function get interfaces():Array{
            if( !_isInitialiedInterfaces ){
                assembleInterfaces(_describeTypeXml.factory[0]);
            }
            return _interfaces;
        }
}
CONFIG::FP10{
        private var _interfaces:Vector.<String>;
        
        public function get interfaces():Vector.<String>{
            if( !_isInitialiedInterfaces ){
                assembleInterfaces(_describeTypeXml.factory[0]);
            }
            return _interfaces;
        }
}

        private var _interfaceMap:Object;

        private var _package:String;

        public function getPackage():String{
            return _package;
        }
        
        private var _isPrimitive:Boolean = true;
        
        public function get isPrimitive():Boolean{
            return _isPrimitive;
        }
        
        private var _isTopLevel:Boolean = true;
        
        public function get isTopLevel():Boolean{
            return _isTopLevel;
        }
        
        private var _isArray:Boolean = true;
        
        public function get isArray():Boolean{
            return _isArray;
        }
        
        private var _isVector:Boolean = true;
        
        public function get isVector():Boolean{
            return _isVector;
        }
        
        public function ClassRef( clazz:Class ){
            const describeTypeXml:XML = flash.utils.describeType(clazz);
            
            _functionMap = {};
            _interfaceMap = {};
            _propertyMap = {};
            _superClassMap = {};
            _typeToPropertyMap = {};

            _concreteClass = clazz;
            
            super( describeTypeXml );
            _className = getTypeName(_name);

            assemblePackage( describeTypeXml );
            assembleThis( describeTypeXml );
        }

        public function newInstance(... args):Object{
            var instance_:Object;

            switch( args.length ){
                case 1:
                    instance_ = new concreteClass( args[0] );
                    break;
                case 2:
                    instance_ = new concreteClass( args[0], args[1] );
                    break;
                case 3:
                    instance_ = new concreteClass( args[0], args[1], args[2] );
                    break;
                case 4:
                    instance_ = new concreteClass( args[0], args[1], args[2], args[3] );
                    break;
                case 5:
                    instance_ = new concreteClass( args[0], args[1], args[2], args[3], args[4] );
                    break;

                default:
                    instance_ = new concreteClass();

            }

            return instance_;
        }

        public function getFunctionRef( functionName:String, ns:Namespace = null):FunctionRef{
            if( !_functionMap.hasOwnProperty( functionName )){
                return null;
            }
            var targetNs:Namespace = ns;
            if( targetNs == null ){
                targetNs = new Namespace();
            }

            const functions:Array = _functionMap[ functionName ] as Array;
            var result:FunctionRef;
            if( functions.length > 0 ){
                for each( var func_:FunctionRef in functions ){
                    if(func_.uri == targetNs.uri){
                        result = func_;
                        break;
                    }
                }
            }
            return result;
        }

        public function getFunctionRefsByReturnType( returnType:String ):Array{
            return _returnTypeToFunctionMap[ returnType ] as Array;
        }

        public function hasFunctionByReturnType( returnType:String ):Boolean{
            return _returnTypeToFunctionMap[ returnType ] != null;
        }

        public function getPropertyRef( propertyName:String ):PropertyRef{
            return _propertyMap[ propertyName ] as PropertyRef;
        }

CONFIG::FP9{
        public function getPropertyRefByType( propertyType:String ):Array{
            if( !_isInitialiedProperties){ 
                assemblePropertyRef(_describeTypeXml.factory[0]);
                _isInitialiedProperties = true;
            }
            return _typeToPropertyMap[ propertyType ];
        }
}
CONFIG::FP10{
        public function getPropertyRefByType( propertyType:String ):Vector.<PropertyRef>{
            if( !_isInitialiedProperties){ 
                assemblePropertyRef(_describeTypeXml.factory[0]);
                _isInitialiedProperties = true;
            }
            return _typeToPropertyMap[ propertyType ];
        }
}

        private final function assemblePropertyRef( rootDescribeTypeXml:XML ):void{
CONFIG::FP9{
            _properties = [];
}
CONFIG::FP10{
            _properties = new Vector.<PropertyRef>();
}
            const typeName:String = describeType.@type.toString();

            var propertysXMLList:XMLList = rootDescribeTypeXml.accessor;
            var propertyRef:PropertyRef = null;
            for each( var accessorXML:XML in propertysXMLList ){
                if( isTargetAccessor(accessorXML) ){
                    propertyRef = new PropertyRef(accessorXML);

                    _properties.push( propertyRef );
                    _propertyMap[ propertyRef.name ] = propertyRef;

                    assembleTypeOfPropertyRef(propertyRef);
                }
            }

            propertysXMLList = rootDescribeTypeXml.variable;
            for each( var variableXML:XML in propertysXMLList ){
                if( isTargetVariable(variableXML) ){
                    variableXML.@access = "readwrite";
                    variableXML.@declaredBy = _name;
                    propertyRef = new PropertyRef(variableXML);

                    _properties.push( propertyRef );
                    _propertyMap[ propertyRef.name ] = propertyRef;

                    assembleTypeOfPropertyRef(propertyRef);
                }
            }
            _isInitialiedProperties = true;
        }

        private final function assembleTypeOfPropertyRef( propertyRef:PropertyRef ):void{
CONFIG::FP9{
            var rproperties_:Array = _typeToPropertyMap[ propertyRef.type ];
            if( rproperties_ == null ){
                rproperties_ = _typeToPropertyMap[ propertyRef.type ] = [];
            }
}
CONFIG::FP10{
            var rproperties_:Vector.<PropertyRef> = _typeToPropertyMap[ propertyRef.type ];
            if( rproperties_ == null ){
                rproperties_ = _typeToPropertyMap[ propertyRef.type ] = new Vector.<PropertyRef>();
            }
}
            rproperties_.push(propertyRef);
        }

        private final function assembleFunctionRef( rootDescribeTypeXml:XML ):void{
CONFIG::FP9{
            _functions = [];
}
CONFIG::FP10{
            _functions = new Vector.<FunctionRef>();
}
            _functionMap = {};
            _returnTypeToFunctionMap = {};

            const functionsXMLList:XMLList = rootDescribeTypeXml.method;

            var functionRef:FunctionRef = null;
            var rfunctions_:Array;
            for each( var methodXML:XML in functionsXMLList ){
                if( isTargetFunction(methodXML)){
                    functionRef = new FunctionRef(methodXML);
                    _functions.push( functionRef );

                    {
                        if( !_functionMap.hasOwnProperty( functionRef.name )){
                            _functionMap[ functionRef.name ] = [];
                        }
                        rfunctions_ = _functionMap[ functionRef.name ];
                        rfunctions_.push( functionRef );
                    }
                    {
                        rfunctions_ = _returnTypeToFunctionMap[ functionRef.returnType ];
                        if( rfunctions_ == null ){
                            rfunctions_ = _returnTypeToFunctionMap[ functionRef.returnType ] = [];
                        }
                        rfunctions_.push(functionRef);
                    }
                }
            }
            _isInitialiedFunctions = true;
        }

        private final function assembleInterfaces( rootDescribeTypeXml:XML ):void{
CONFIG::FP9{
            _interfaces = [];
}
CONFIG::FP10{
            _interfaces = new Vector.<String>();
}
            _interfaceMap = {};

            const interfacesXMLList:XMLList = rootDescribeTypeXml.implementsInterface;

            var interfaceName:String = null;
            for each( var interfaceXML:XML in interfacesXMLList ){
                interfaceName = getTypeString(interfaceXML.@type);

                _interfaces.push( interfaceName );
                _interfaceMap[ interfaceName ] = 1;
            }
            _isInitialiedInterfaces = true;
        }

        private final function assembleSuperClasses( rootDescribeTypeXml:XML ):void{
CONFIG::FP9{
            _superClasses = [];
}
CONFIG::FP10{
            _superClasses = new Vector.<String>();
}
            _superClassMap = {};

            var extendsClassXMLList:XMLList = rootDescribeTypeXml.extendsClass;
            var className:String;
            for each( var extendsClassXML:XML in extendsClassXMLList ){
                className = getTypeString(extendsClassXML.@type);
                _superClasses.push(className);
                _superClassMap[ className ] = 1;
                switch( className ){
                    case "flash.events.Event":
                        _isEvent = true;
                        break;
                    case "flash.events.EventDispatcher":
                        _isEventDispatcher = true;
                        break;
                    case "flash.display.DisplayObject":
                        _isDisplayObject = true;
                        break;
                    default:
                        break;
                }
            }
            _isInitialiedSuperClasses = true;
        }

        private final function assemblePackage( rootDescribeTypeXml:XML ):void{
            _package = _name.substring(0,_name.lastIndexOf("."));
        }

//        private final function assembleExtends( rootDescribeTypeXml:XML ):void{
//            const interfacesXMLList:XMLList = rootDescribeTypeXml.implementsInterface;
//
//            var interfaceRef:ClassRef = null;
//            for each( var interfaceXML:XML in interfacesXMLList ){
//                interfaceRef = ClassRef.getInstance(getTypeString(interfaceXML.@type));
//
//                _interfaces.push( interfaceRef );
//                _interfaceMap[ interfaceRef.name ] = interfaceRef;
//            }
//        }

        private final function assembleThis( rootDescribeTypeXml:XML ):void{
//            isDynamic = rootDescribeTypeXml.@isDynamic.toString() == "true";
//            isFinal = rootDescribeTypeXml.@isFinal.toString() == "true";
//            isStatic = rootDescribeTypeXml.@isStatic.toString() == "true";
            
            _isPrimitive = ( name in PRIMITIVE_CLASS_MAP );
            _isTopLevel = ( name in TOPLEVEL_CLASS_MAP );
            
            _isArray = ( name == ARRAY_CLASS );
            _isVector = ( name.indexOf(VECTOR_CLASS) == 0 );
            
            _isInterface = (rootDescribeTypeXml.factory.extendsClass as XMLList).length() == 0;
        }

        protected override function getName( rootDescribeTypeXml:XML ):String{
            return getTypeString(rootDescribeTypeXml.@name.toString());
        }
    }
}