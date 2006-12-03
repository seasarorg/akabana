package examples.flex2.check.dto {
	import mx.collections.ArrayCollection;
	
	[RemoteClass(alias="examples.flex2.check.dto.CheckDto")]
	public dynamic class CheckDto {
		[Bindable]
		public var id:int;
		[Bindable]
		public var name:String;
		[Bindable]
		public var createTime:Date;
		[Bindable]
		public var minus:int;
		[Bindable]
		public var b:Boolean;
		[Bindable]
		public var stringArray:Array;
		[Bindable]
		public var doubleValue:Number;
		[Bindable]
		public var address:String;
		[Bindable]
		public var list:ArrayCollection;
	}
}