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
package org.seasar.akabana.yui.resources.embed{

	import flash.utils.ByteArray;
	
	public class EmbedXmlReader {
		
		public function read( embedClass:Class ):Object{
			return readXml( new embedClass() as ByteArray );
		}

		private final function readXml( byteArray:ByteArray ):XML{
			var xmlString:String = "";
			var char:String;
			for( var i:int = 0; i < byteArray.length; i++ ){
				if((byteArray[i] >> 7) == 0){
					char = byteArray.readUTFBytes(1);
					if( char.charCodeAt() > 31 ){
						xmlString += char; 
					}
				} else {
					if( (byteArray[i] >> 1) == 126){
						xmlString += byteArray.readUTFBytes(6);
						i+=5;
					} else if( (byteArray[i] >> 2) == 62){
						xmlString += byteArray.readUTFBytes(5);
						i+=4;
					} else if( (byteArray[i] >> 3) == 30){
						xmlString += byteArray.readUTFBytes(4);
						i+=3;
					} else if( (byteArray[i] >> 4) == 14){
						xmlString += byteArray.readUTFBytes(3);
						i+=2;
					} else if( (byteArray[i] >> 5) == 6 ){
						xmlString += byteArray.readUTFBytes(2);
						i+=1;
					}
				}
			}
			return new XML( xmlString );
		}
	}
}