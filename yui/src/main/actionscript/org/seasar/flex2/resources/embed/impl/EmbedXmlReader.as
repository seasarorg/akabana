package org.seasar.flex2.resources.embed.impl{
	import flash.utils.ByteArray;
	
	import org.seasar.flex2.resources.embed.EmbedReader;
	
	public class EmbedXmlReader implements EmbedReader {
		
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