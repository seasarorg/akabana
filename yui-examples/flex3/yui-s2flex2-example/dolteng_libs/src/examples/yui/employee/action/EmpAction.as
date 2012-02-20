package examples.yui.employee.action
{
    import examples.yui.employee.entity.Emp;
    import examples.yui.employee.helper.EmpHelper;
    
    import flash.events.MouseEvent;
    import flash.net.Responder;
    
    import org.seasar.akabana.yui.framework.event.FrameworkEvent;
    import org.seasar.akabana.yui.service.event.ResultEvent;
    import org.seasar.akabana.yui.service.rpc.remoting.RemotingService;
    
    public class EmpAction{
        
        public var helper:EmpHelper;
        
        public var empService:RemotingService;
        
        public function onApplicationStartHandler( event:FrameworkEvent ):void{
            doRefresh();    
        }

        public function searchClickHandler(event:MouseEvent):void{
            doClear();
            empService
                .searchByName(helper.searchWord)
                .addResponder( this );     
        }  
        
        public function addClickHandler(event:MouseEvent):void{
            helper.changeNewState();   
        }
        
        public function clearClickHandler(event:MouseEvent):void{
            doClear();
        }

        public function refreshClickHandler(event:MouseEvent):void{
            doRefresh();
        }        

        public function removeClickHandler(event:MouseEvent):void{
            if( helper.isNewState ){
                helper.changeDefaultState();
            } else {
                var emp:Emp = helper.currentEmp;
                empService
                    .remove(emp.id)
                    .addResponder( this );
            }
        }      
        
        public function registerClickHandler(event:MouseEvent):void{
            var emp:Emp = helper.formData;
            if( helper.isNewState ){  
                emp.id = 0;
                emp.versionNo = 0;  
                empService
                    .insert(emp)
                    .addResponder( this );
            } else {
                empService
                    .update(emp)
                    .addResponder( this );
            }
        }        
        
        public function empServiceSelectAllResultHandler(event:ResultEvent):void{
            helper.employeeList = event.result as Array;
        }

        public function empServiceUpdateResultHandler(event:ResultEvent):void{
            doRefresh();
        }

        public function empServiceInsertResultHandler(event:ResultEvent):void{
            doRefresh();
        }

        public function empServiceRemoveResultHandler(event:ResultEvent):void{
            doRefresh();
        }

        public function empServiceSearchByNameResultHandler(event:ResultEvent):void{
            helper.employeeList = event.result as Array;
        }

        protected function doRefresh():void{
            empService
                .selectAll()
                .addResponder( this );        
        }     

        protected function doClear():void{
            helper.employeeList = [];      
        }
    }
}