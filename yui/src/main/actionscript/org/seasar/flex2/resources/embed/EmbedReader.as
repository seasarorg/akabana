package org.seasar.flex2.resources.embed {
	import flash.utils.ByteArray;
	
	public interface EmbedReader {
		function read( embedClass:Class ):Object;
	}
}