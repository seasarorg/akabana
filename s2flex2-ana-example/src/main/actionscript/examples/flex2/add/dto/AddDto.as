package examples.flex2.add.dto {
    
    [RemoteClass(alias="examples.flex2.add.dto.AddDto")]
    public class AddDto {
        private var arg1_:int;
        private var arg2_:int;
        private var sum_:int;
        
        public function get arg1():int{
        	return arg1_;
        }
        public function set arg1(newValue:int):void{
        	this.arg1_=newValue;
        }
        public function get arg2():int{
        	return arg2_;
        }
        public function set arg2(newValue:int):void{
        	this.arg2_=newValue;
        }
        public function get sum():int{
        	return sum_;
        }
        public function set sum(newValue:int):void{
        	this.sum_=newValue;
        }
    }
}