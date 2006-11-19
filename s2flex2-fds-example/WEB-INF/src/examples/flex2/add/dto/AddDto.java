package examples.flex2.add.dto;

import java.util.Date;

public class AddDto {

    private int arg1;
    private int arg2;
    private int sum;
    private Date calclateDate;

    
    public Date getCalclateDate() {
		return calclateDate;
	}
    
	public void setCalclateDate(Date calclateDate) {
		this.calclateDate = calclateDate;
	}
	public int getArg1() {
        return arg1;
    }
    public void setArg1(int arg1) {
        this.arg1 = arg1;
    }
    public int getArg2() {
        return arg2;
    }
    public void setArg2(int arg2) {
        this.arg2 = arg2;
    }
    
    public int getSum() {
        return sum;
    }
    public void setSum(int sum) {
        this.sum = sum;
    }
}
