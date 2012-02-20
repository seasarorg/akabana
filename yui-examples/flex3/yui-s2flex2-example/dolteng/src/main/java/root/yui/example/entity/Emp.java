package root.yui.example.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Version;

import java.math.BigDecimal;
import java.util.Date;


@Entity
public class Emp {

    @Id
    @GeneratedValue
    public Long id;

    @Column(name="PASSWORD")
    public String password;
    
    @Column(name="EMP_NO")
    public Integer empNo;

    @Column(name="EMP_NAME")
    public String empName;

    @Column(name="MGR_ID")
    public Integer mgrId;

    @Temporal(TemporalType.DATE)
    public Date hiredate;

    public BigDecimal sal;

    @Column(name="DEPT_ID")
    public Integer deptId;

    @Version
    @Column(name="VERSION_NO")
    public Integer versionNo;

}