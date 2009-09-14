package examples.yui.employee.entity
{
	
	[Bindable]
	[RemoteClass(alias="root.yui.example.entity.Emp")]
	public class Emp{
		public var id: Number;
		public var empNo: int;
		public var empName: String;
		public var mgrId: int;
		public var hiredate: Date;
		public var sal: String;
		public var deptId: int;
		public var versionNo: int;
		public var password:String;
	}
}