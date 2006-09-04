package org.seasar.flex2.resources.embed {
	import flash.utils.ByteArray;
	
	public interface EmbedBinaryDataReader {
		function read( byteArray:ByteArray ):Object;
	}
}