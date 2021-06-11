

day06 练习
某公司的雇员分为以下若干类：
Employee：这是所有员工总的父类，属性：员工的姓名和生日月份。
方法：getSalary(int month) 根据参数月份来确定工资，如果该月员工过生日，
则公司会额外奖励100元。
SalariedEmployee：Employee的子类，拿固定工资的员工。属性：月薪
HourlyEmployee：Employee的子类，按小时拿工资的员工，每月工作超出160
小时的部分按照1.5倍工资发放
属性：每小时的工资、每月工作的小时数
SalesEmployee：Employee的子类，销售人员，工资由月销售额和提成率决定
属性：月销售额、提成率
BasePlusSalesEmployee：SalesEmployee的子类，有固定底薪的销售人员，
工资由底薪加上销售提成部分     属性：底薪。

public class TestEmployee{
    public static void main(String[]args){
        Employee[] es = new Employee[5];
        es[0] = new Employee("赵君",2);
        es[1] = new SalariedEmployee("宋婕", 1, 8000);
        es[2] = new HourlyEmployee("王超", 5, 10, 300);
        es[3] = new SalesEmployee("秋娥", 2, 200000, 0.05);
        es[4] = new BaseSalarySalesEmployee("郭镫鸿", 1, 1000000, 0.1, 10000);
        int month = 2;//本月为2月
        System.out.println("宇宙集团"+month+"月工资表：");
        for(int i=0; i<es.length; i++){
            System.out.println(es[i].getName()+":"+es[i].getSalary(month));
        }
    }
}

class Employee{
    private String name;
    private int birth;
    public String getName(){
        return name;
    }
    public Employee(String name, int birth){
        this.name = name;
        this.birth = birth;
    }
    public double getSalary(int month){
        if(month==birth){
            return 100;
        }
        return 0;
    }
}

class SalariedEmployee extends Employee{
    private double salary;
    public SalariedEmployee(String name, int birth, double salary){
        super(name, birth);
        this.salary = salary;
    }
    public double getSalary(int month){
        return salary + super.getSalary(month);
    }
}

class HourlyEmployee extends Employee{
    private double hourSalary;
    private int hour;
    public HourlyEmployee(String name, int birth, double hourSalary, int hour){
        super(name, birth);
        this.hourSalary = hourSalary;
        this.hour = hour;
    }
    public double getSalary(int month){
        if(hour<=160){
            return hourSalary*hour+super.getSalary(month);
        }else{
            return 160*hourSalary+(hour-160)*hourSalary*1.5+super.getSalary(month);
        }
    }
}

class SalesEmployee extends Employee{
    private double sales;
    private double pre;
    public SalesEmployee(String name, int birth, double sales, double pre){
        super(name, birth);
        this.sales = sales;
        this.pre = pre;
    }
    public double getSalary(int month){
        return sales*pre+super.getSalary(month);
    }
}

class BaseSalarySalesEmployee extends SalesEmployee{
    private double baseSalary;
    public BaseSalarySalesEmployee(String name, int birth, double sales, double pre, double baseSalary){
        super(name, birth, sales, pre);
        this.baseSalary = baseSalary;
    }
    public double getSalary(int month){
        return baseSalary+super.getSalary(month);
    }
}



/**
 * 在原有的雇员练习上修改代码
 * 公司会给SalaryEmployee每月另外发放2000元加班费,给
 * BasePlusSalesEmployee发放1000元加班费
 * 改写原有代码,加入以上的逻辑
 * 并写一个方法,打印出本月公司总共发放了多少加班费
 * @author Administrator
 *
 */
public class EmployeeTest {

    /**
     * @param args
     */
    public static void main(String[] args) {
        Employee e[] = new Employee[4];
        e[0] = new SalariedEmployee("魏威",10,5000);
        e[1] = new HourlyEmployee("段利峰",8,80,242);
        e[2] = new SalesEmployee("林龙",11,300000,0.1);
        e[3] = new BasedPlusSalesEmployee("华溪",1,100000,0.15,1500);
        for(int i=0;i<e.length;i++){
            System.out.println(e[i].getName()+": "+e[i].getSalary(11));
        }

        //统计加班费
        int result = 0;
//        for(int i=0;i<e.length;i++){
//            if(e[i] instanceof SalariedEmployee){
//                SalariedEmployee s = (SalariedEmployee)e[i];
//                result += s.getAddtionalSalary();
//            }
//            if(e[i] instanceof BasedPlusSalesEmployee){
//                BasedPlusSalesEmployee b = (BasedPlusSalesEmployee)e[i];
//                result += b.getAddtionalSalary();
//            }
//        }

        for(int i=0;i<e.length;i++){
            result += e[i].getAddtionalSalary();
        }
        System.out.println("加班费: "+result);
    }
}

interface AddtionalSalary{
    int getAddtionalSalary();
}

class Employee implements AddtionalSalary{
    private String name;//员工姓名
    private int birth;//员工生日月份
    public Employee(String name,int birth){
        this.name = name;
        this.birth = birth;
    }
    public int getSalary(int month){
        int result = 0;
        if(month==birth)
            result = 100;
        return result;
    }
    public String getName(){
        return name;
    }

    public int getAddtionalSalary(){
        return 0;
    }
}

class SalariedEmployee extends Employee{
    private int salaryPerMonth;
    public SalariedEmployee(String name,int birth,int salaryPerMonth){
        super(name,birth);
        this.salaryPerMonth = salaryPerMonth;
    }
    public int getSalary(int month){
        return this.salaryPerMonth + super.getSalary(month)+
            this.getAddtionalSalary();
    }
    public int getAddtionalSalary(){
        return 2000;
    }
}

class HourlyEmployee extends Employee{
    private int salaryPerHour;
    private int hoursPerMonth;
    public HourlyEmployee(String name,int birth,int salaryPerHour,int hoursPerMonth){
        super(name,birth);
        this.salaryPerHour = salaryPerHour;
        this.hoursPerMonth = hoursPerMonth;
    }
    public int getSalary(int month){
        int result = 0;
        if(this.hoursPerMonth<=160){
            result = hoursPerMonth*salaryPerHour;
        }else{
            result = 160*salaryPerHour +
            (int)((hoursPerMonth-160)*1.5*salaryPerHour);
        }
        return result+super.getSalary(month);
    }
}

class SalesEmployee extends Employee{
    private int sales;
    private double rate;
    public SalesEmployee(String name,int birth,int sales,double rate){
        super(name,birth);
        this.sales = sales;
        this.rate = rate;
    }
    public int getSalary(int month){
        return (int)(sales*rate)+super.getSalary(month);
    }
}

class BasedPlusSalesEmployee extends SalesEmployee{
    private int basedSalary;
    public BasedPlusSalesEmployee(String name,int birth,int sales,double rate,int basedSalary){
        super(name,birth,sales,rate);
        this.basedSalary = basedSalary;
    }
    public int getSalary(int month){
        return this.basedSalary+super.getSalary(month) +
        this.getAddtionalSalary();
    }
    public int getAddtionalSalary(){
        return 1000;
    }
}


