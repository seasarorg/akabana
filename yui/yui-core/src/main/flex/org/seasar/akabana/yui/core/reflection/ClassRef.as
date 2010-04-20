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
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;

    import org.seasar.akabana.yui.core.ClassLoader;


    public class ClassRef extends AnnotatedObjectRef
    {

        public static const CLASS_REF_CACHE:Object = {};

		public static const CLASS_NAME_SEPARATOR:String = "::";

		public static const DOT:String = ".";

        public static var classLoader:ClassLoader = new ClassLoader();

		public static function getClassName( object:Object ):String{
			return flash.utils.getQualifiedClassName(object).replace(CLASS_NAME_SEPARATOR,DOT);
		}

        public static function getReflector( target:Object ):ClassRef{

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

            if( clazz != null ){
                var classRef:ClassRef = CLASS_REF_CACHE[ clazz ];
                if( classRef == null ){
                    classRef = new ClassRef(clazz);
                    CLASS_REF_CACHE[ clazz ] = classRef;
                }
            }

            return classRef;
        }

        private static function isTargetAccessor( rootDescribeTypeXml:XML ):Boolean{
            const name_:String = rootDescribeTypeXml.@name.toString();
            const declaredBy_:String = rootDescribeTypeXml.@declaredBy.toString();
            const uri_:String = rootDescribeTypeXml.@uri.toString();

            return (!(
                excludeDeclaredByFilterRegExp.test(declaredBy_) ||
                excludeUriFilterRegExp.test(uri_)
            )) && (name_.indexOf("_") != 0);
        }

        private static function isTargetVariable( rootDescribeTypeXml:XML ):Boolean{
            const name_:String = rootDescribeTypeXml.@name.toString();
            const declaredBy_:String = rootDescribeTypeXml.@declaredBy.toString();
            const uri_:String = rootDescribeTypeXml.@uri.toString();

            return (!(
                excludeDeclaredByFilterRegExp.test(declaredBy_) ||
                excludeUriFilterRegExp.test(uri_)
            )) && (name_.indexOf("_") != 0);
        }

        private static function isTargetFunction( rootDescribeTypeXml:XML ):Boolean{
            const name_:String = rootDescribeTypeXml.@declaredBy.toString();
            const uri_:String = rootDescribeTypeXml.@uri.toString();

            return !(
                excludeDeclaredByFilterRegExp.test(name_) ||
                excludeUriFilterRegExp.test(uri_)
            );
        }

        public var concreteClass:Class;

        public var isDynamic:Boolean;

        public var isFinal:Boolean;

        public var isStatic:Boolean;

        public var isInterface:Boolean;

        public var isEvent:Boolean;

        public var isDisplayObject:Boolean;

        public var isEventDispatcher:Boolean;

        private var _className:String;

        public function get className():String{
            return _className;
        }

        private var _constructor:Constructor;

        public function get constructor():Constructor{
            return _constructor;
        }

        private var _properties:Array;

        public function get properties():Array{
            return _properties;
        }

        private var _propertyMap:Object;

        private var _typeToPropertyMap:Object;

        private var _functions:Array;

        public function get functions():Array{
            return _functions;
        }

        private var _functionMap:Object;

        private var _returnTypeToFunctionMap:Object;

        private var _interfaces:Array;

        public function get interfaces():Array{
            return _interfaces;
        }

        private var _interfaceMap:Object;

        private var _package:String;

        public function getPackage():String{
            return _package;
        }

        public function ClassRef( clazz:Class ){
            var describeTypeXml:XML = flash.utils.describeType(clazz);
            concreteClass = clazz;
            super( describeTypeXml );
            _className = getClassName();

            assembleMetadataRef(describeTypeXml.factory[0]);
            assembleConstructor(describeTypeXml.factory[0]);
            assemblePropertyRef(describeTypeXml.factory[0]);
            assembleFunctionRef(describeTypeXml.factory[0]);
            assembleInterfaces(describeTypeXml.factory[0]);
            assembleInstance(describeTypeXml.factory[0]);
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

        public function getPropertyRefByType( propertyType:String ):Array{
            return _typeToPropertyMap[ propertyType ];
        }

        public function isAssignableFrom(interfaceType:Object):Boolean{
            var isAssignable_:Boolean = false;

            do{
                if( interfaceType is Class ){
                    var className:String = ClassRef.getClassName(interfaceType as Class);
                    isAssignable_ = _interfaceMap.hasOwnProperty( className );
                    break;
                }
                if( interfaceType is String ){
                    isAssignable_ = _interfaceMap.hasOwnProperty( interfaceType );
                    break;
                }

            }while(false);

            return isAssignable_;
        }

        private final function getClassName():String{
            var result:String;
            var dotIndex:int = _name.lastIndexOf(DOT);
            if( dotIndex > 0 ) {
                result = _name.substring(dotIndex+1);
            } else {
                result = _name;
            }
            return result;
        }

        private final function assembleConstructor( rootDescribeTypeXml:XML ):void{
            _constructor = new Constructor( rootDescribeTypeXml, this.concreteClass);
        }

        private final function assemblePropertyRef( rootDescribeTypeXml:XML ):void{
            _properties = [];
            _propertyMap = {};
            _typeToPropertyMap = {};

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
        }

        private final function assembleTypeOfPropertyRef( propertyRef:PropertyRef ):void{
            var rproperties_:Array = _typeToPropertyMap[ propertyRef.type ];
            if( rproperties_ == null ){
                rproperties_ = _typeToPropertyMap[ propertyRef.type ] = [];
            }
            rproperties_.push(propertyRef);
        }

        private final function assembleFunctionRef( rootDescribeTypeXml:XML ):void{
            _functions = [];
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
        }

        private final function assembleInterfaces( rootDescribeTypeXml:XML ):void{
            _interfaces = [];
            _interfaceMap = {};

            const interfacesXMLList:XMLList = rootDescribeTypeXml.implementsInterface;

            var interfaceName:String = null;
            for each( var interfaceXML:XML in interfacesXMLList ){
                interfaceName = getTypeString(interfaceXML.@type);

                _interfaces.push( interfaceName );
                _interfaceMap[ interfaceName ] = null;
            }
        }

        private final function assembleInstance( rootDescribeTypeXml:XML ):void{
            var extendsClassXMLList:XMLList = rootDescribeTypeXml.extendsClass;
            for each( var extendsClassXML:XML in extendsClassXMLList ){
                switch( getTypeString(extendsClassXML.@type)){
                    case "flash.events.Event":
                        isEvent = true;
                        break;
                    case "flash.events.EventDispatcher":
                        isEventDispatcher = true;
                        break;
                    case "flash.display.DisplayObject":
                        isDisplayObject = true;
                        break;
                    default:
                        break;
                }
            }
        }

        private final function assemblePackage( rootDescribeTypeXml:XML ):void{
            _package = _name.substring(0,_name.lastIndexOf("."));
        }

        private final function assembleExtends( rootDescribeTypeXml:XML ):void{
            const interfacesXMLList:XMLList = rootDescribeTypeXml.implementsInterface;

            var interfaceRef:ClassRef = null;
            for each( var interfaceXML:XML in interfacesXMLList ){
                interfaceRef = getReflector(getTypeString(interfaceXML.@type));

                _interfaces.push( interfaceRef );
                _interfaceMap[ interfaceRef.name ] = interfaceRef;
            }
        }

        private final function assembleThis( rootDescribeTypeXml:XML ):void{
            isDynamic = rootDescribeTypeXml.@isDynamic.toString() == "true";
            isFinal = rootDescribeTypeXml.@isFinal.toString() == "true";
            isStatic = rootDescribeTypeXml.@isStatic.toString() == "true";
        }

        protected override function getName( rootDescribeTypeXml:XML ):String{
            return getTypeString(rootDescribeTypeXml.@name.toString());
        }
    }
}