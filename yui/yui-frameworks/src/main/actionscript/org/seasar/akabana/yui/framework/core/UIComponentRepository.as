/*
 * Copyright 2004-2007 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.framework.core {
    
    import flash.display.DisplayObjectContainer;
    import flash.utils.Dictionary;
    
    import mx.core.Container;
    import mx.core.UIComponent;
    
    public class UIComponentRepository {
        
        private static var componentMap:Dictionary = new Dictionary(true);
        
        private static var componentChildrenMap:Dictionary = new Dictionary(true);
        
        public static function addComponent( component:UIComponent ):void{
            const componentName:String = UIComponentUtil.getComponentName(component);
            if( componentMap[ componentName ] == null ){
                componentMap[ componentName ] = component;
            } else {
                throw new Error("UIコンポーネント登録重複エラー");
            }
            
            addParentRelation( component );
            if( component.parent !== component.parentDocument ){
            	addParentDocumentRelation( component );
            }

        }
        
        public static function removeComponent( component:UIComponent ):void{
        	if( component != null ){
	            const componentName:String = UIComponentUtil.getComponentName(component);
	        	componentMap[ componentName ] = null;
	        	delete componentMap[ componentName ];
	        	
	        	componentChildrenMap[ component ] = null;
	        	delete componentChildrenMap[ component ];
	        	
	        	removeRelation( component.parent, component );
	        	removeRelation( component.parentDocument as DisplayObjectContainer, component );
	        	
				if( component is Container && component.numChildren > 0 ){
					for( var i:int = 0; i < component.numChildren; i++ ){
						removeComponent( component.getChildAt( i ) as UIComponent);
					}
				}
        	}
        }
        
        public static function getComponent( name:String ):UIComponent{
            return componentMap[ name ] as UIComponent;
        }
        
        public static function hasComponent( name:String ):Boolean{
            return componentMap.hasOwnProperty( name );
        }

        public static function getComponentChildren( object:Object ):Array{
            var childrenArray:Array = [];
            do {
                if( object is String ){
                    childrenArray = componentChildrenMap[ object as String ];
                    break;
                }
                if( object is UIComponent ){
                    childrenArray = componentChildrenMap[ UIComponentUtil.getComponentName( object as UIComponent )];
                    break;
                }
            } while( false );
            
            return childrenArray;
        }
        
        private static function addParentRelation( component:UIComponent ):void{
            addRelation( component.parent, component);
        }

        private static function addParentDocumentRelation( component:UIComponent ):void{            
            addRelation( component.parentDocument as DisplayObjectContainer, component);
        }
        
        private static function addRelation( parent:DisplayObjectContainer, child:UIComponent ):void{            
            var parentName:String = UIComponentUtil.getComponentName( parent as UIComponent );
            var componentChildrenArray:Array = componentChildrenMap[ parentName ];
            if( componentChildrenArray == null ){
                componentChildrenArray = componentChildrenMap[ parentName ] = [];
            }
            componentChildrenArray.push(child);
        }
        
        private static function removeRelation( parent:DisplayObjectContainer, child:UIComponent ):void{            
            var parentName:String = UIComponentUtil.getComponentName( parent as UIComponent );
            var componentChildrenArray:Array = componentChildrenMap[ parentName ];
            if( componentChildrenArray != null ){
            	var component:UIComponent;
            	for( var i:int = 0; i < componentChildrenArray.length; i++ ){
            		component = componentChildrenArray[ i ];
            		if( component === child ){
            			componentChildrenArray.splice( i, 1 );
            			break;
            		}
            	}
            }
        }   
    }
}