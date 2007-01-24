package examples.chura.entity;

import java.math.BigDecimal;
import java.util.Date;


public class Emp {

	private Integer empno;

	private String ename;

	private Integer mgrid;

	private Date hiredate;

	private BigDecimal sal;

	private Integer deptid;

	private Integer versionno;

	public Emp() {
	}

	public Integer getEmpno() {
		return this.empno;
	}

	public void setEmpno(Integer empno) {
		this.empno = empno;
	}
	public String getEname() {
		return this.ename;
	}

	public void setEname(String ename) {
		this.ename = ename;
	}
	public Integer getMgrid() {
		return this.mgrid;
	}

	public void setMgrid(Integer mgrid) {
		this.mgrid = mgrid;
	}
	public Date getHiredate() {
		return this.hiredate;
	}

	public void setHiredate(Date hiredate) {
		this.hiredate = hiredate;
	}
	public BigDecimal getSal() {
		return this.sal;
	}

	public void setSal(BigDecimal sal) {
		this.sal = sal;
	}
	public Integer getDeptid() {
		return this.deptid;
	}

	public void setDeptid(Integer deptid) {
		this.deptid = deptid;
	}
	public Integer getVersionno() {
		return this.versionno;
	}

	public void setVersionno(Integer versionno) {
		this.versionno = versionno;
	}
}