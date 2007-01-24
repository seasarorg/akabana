package examples.chura.entity {
	
	[Bindable]
	[RemoteClass(alias="examples.chura.entity.Emp")]
	public class Emp {
		
		public var empno: int;
		public var ename: String;
		public var mgrid: int;
		public var hiredate: Date;
		public var sal: int;
		public var deptid: int;
		public var versionno: int;
	}
}