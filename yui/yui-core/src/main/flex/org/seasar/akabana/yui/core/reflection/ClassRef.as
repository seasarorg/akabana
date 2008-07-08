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
        public static function getQualifiedClassName( object:Object ):String{
            return flash.utils.getQualifiedClassName(object).replace(CLASS_NAME_SEPARATOR,DOT);
        }
        
        public static var classLoader:ClassLoader = new ClassLoader();
        
        public static function getReflector( target:Object ):ClassRef{

            var clazz:Class = null;
            try {
                switch( true ){
                    case ( target is Class ):{
                        clazz = target as Class;
                        break;
                    }
                    
                    case ( target is String ):{
                        clazz = classLoader.findClass(target as String);
                        break;
                    }
                    
                    default:{
                        clazz = classLoader.findClass(getQualifiedClassName(target));
                        break;
                    }
                }
            } catch( e:Error ){
                throw e;            
            }
            
            if( clazz != null ){
                var classRef:ClassRef = cache_[ clazz ];
                if( classRef == null ){
                    classRef = new ClassRef(clazz);                    
                    cache_[ clazz ] = classRef;
                }                
            }
            
            return classRef;
        }
        
        private static const cache_:Object = {};     
        
        private static const CLASS_NAME_SEPARATOR:String = "::";
        
        private static const DOT:String = ".";
        
        public var concreteClass:Class;

        public var isDynamic:Boolean;
        
        public var isFinal:Boolean;
        
        public var isStatic:Boolean;
        
        public var isInterface:Boolean;
        
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
            
            assembleMetadataRef(describeTypeXml.factory[0]);
            assembleConstructor(describeTypeXml.factory[0]);
            assemblePropertyRef(describeTypeXml.factory[0]);         
            assembleFunctionRef(describeTypeXml.factory[0]);
            assembleInterfaces(describeTypeXml.factory[0]);
            assemblePackage( describeTypeXml );            
            assembleThis( describeTypeXml );
        }
        
        public function getInstance():Object{
            return new concreteClass();
        }
        
        public function getFunctionRef( functionName:String ):FunctionRef{
            return _functionMap[ functionName ] as FunctionRef;
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
                    isAssignable_ = _interfaceMap[ ClassRef.getQualifiedClassName(interfaceType as Class) ] != null;
                    break;
                }
                if( interfaceType is String ){
                    isAssignable_ = _interfaceMap[ interfaceType ] != null;
                    break;
                }                
                
            }while(false);
            
            return isAssignable_;
        }
        
        private final function assembleConstructor( rootDescribeTypeXml:XML ):void{
            _constructor = new Constructor( rootDescribeTypeXml );
            _constructor.concreteClass = this.concreteClass;
        }

        private final function assemblePropertyRef( rootDescribeTypeXml:XML ):void{
            _properties = [];
            _propertyMap = {};
            _typeToPropertyMap = {};
            
            var propertyRef:PropertyRef = null;
            var propertysXMLList:XMLList = rootDescribeTypeXml.accessor;
            for each( var accessorXML:XML in propertysXMLList ){
                propertyRef = new PropertyRef(accessorXML);
                
                _properties.push( propertyRef );
                _propertyMap[ propertyRef.name ] = propertyRef;
                
                assembleTypeOfPropertyRef(propertyRef);
            }
            
            propertysXMLList = rootDescribeTypeXml.variable;
            for each( var variableXML:XML in propertysXMLList ){
                variableXML.@access = "readwrite";
                variableXML.@declaredBy = _name;
                propertyRef = new PropertyRef(variableXML);
                
                _properties.push( propertyRef );
                _propertyMap[ propertyRef.name ] = propertyRef;
                
                assembleTypeOfPropertyRef(propertyRef);
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
            
            var functionRef:FunctionRef = null;
            var functionsXMLList:XMLList = rootDescribeTypeXml.method;
            for each( var methodXML:XML in functionsXMLList ){
                functionRef = new FunctionRef(methodXML);
                
                _functions.push( functionRef );
                _functionMap[ functionRef.name ] = functionRef;

                var rfunctions_:Array = _returnTypeToFunctionMap[ functionRef.returnType ];
                if( rfunctions_ == null ){
                    rfunctions_ = _returnTypeToFunctionMap[ functionRef.returnType ] = [];
                }
                rfunctions_.push(functionRef);
            }
        }
        
        private final function assembleInterfaces( rootDescribeTypeXml:XML ):void{
            _interfaces = [];
            _interfaceMap = {};
            
            var interfaceRef:ClassRef = null;
            var interfacesXMLList:XMLList = rootDescribeTypeXml.implementsInterface;
            for each( var interfaceXML:XML in interfacesXMLList ){
                interfaceRef = getReflector(getTypeString(interfaceXML.@type));
                
                _interfaces.push( interfaceRef );
                _interfaceMap[ interfaceRef.name ] = interfaceRef;
            }
        }

        private final function assemblePackage( rootDescribeTypeXml:XML ):void{
            _package = _name.substring(0,_name.lastIndexOf("."));
        }        

        private final function assembleThis( rootDescribeTypeXml:XML ):void{
            
            isDynamic = rootDescribeTypeXml.@isDynamic.toString() == "true";
            isFinal = rootDescribeTypeXml.@isDynamic.toString() == "true";
            isStatic = rootDescribeTypeXml.@isDynamic.toString() == "true";

            try{
                new concreteClass();
                isInterface = false;
            } catch( e:Error ){
                isInterface = true;
            }
            
        }

        protected override function getName( rootDescribeTypeXml:XML ):String{
            return getTypeString(rootDescribeTypeXml.@name.toString());
        } 
    }
}