package examples.yui.employee.helper
{
    import examples.yui.employee.entity.Emp;
    import examples.yui.employee.view.EmpView;
    
    import mx.collections.ArrayCollection;
    
    public class EmpHelper{
        
        public var view:EmpView;

        public function set employeeList( dataSource:Array ):void{
            view.empList.dataProvider = new ArrayCollection( dataSource );
        }
        
        public function get currentEmp():Emp{
            return view.empList.selectedItem as Emp;
        }
        
        public function get formData():Emp{
            var result:Emp = new Emp();
            result.id = parseInt(view.empId.text);
            result.empNo = parseInt(view.empNo.text);
            result.empName = view.empName.text;
            result.password = view.password.text;
            result.mgrId = parseInt(view.mgrId.text);
            result.hiredate = view.hiredate.selectedDate;
            result.sal = view.sal.text;
            result.deptId = parseInt(view.deptId.text);
            result.versionNo = parseInt(view.versionNo.text);
            
            return result;
        }
        
        public function get searchWord():String{
            return view.searchWord.text;
        }
        
        public function get isNewState():Boolean{
            return view.currentState == "newState";
        }
        
        public function changeNewState():void{
            view.currentState = "newState";
        }
        
        public function changeDefaultState():void{
            view.currentState = null;
        }
    }
}