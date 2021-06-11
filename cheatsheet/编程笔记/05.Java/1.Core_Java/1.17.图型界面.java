
图型界面(不常用、难学)
1、Awt: 抽象窗口工具箱，它由三部分组成:
   ①组件: 界面元素；
   ②容器: 装载组件的容器(例如窗体)；
   ③布局管理器: 负责决定容器中组件的摆放位置。

2、图形界面的应用分四步:
   ① 选择一个容器:
     ⑴window:带标题的容器(如Frame)；
     ⑵Panel:面板通过add()向容器中添加组件。
       注: Panel不能作为顶层容器。
       Java 的图形界面依然是跨平台的。但是调用了窗体之后只生成窗体；必须有事件的处理，关闭按钮才工作。
   ②设置一个布局管理器: 用setLayout()；
   ③向容器中添加组件；
     jdk1.4用getContentPare()方法添加主件。
   ④ 添加组件的事务处理。
     Panel 也是一种容器: 但是不可见的，很容易忘记设置它们的可见性。
     Panel pan=new Panel;
     Fp.setLayout(null);//表示不要布局管理器。

3、五种布局管理器:
  (1)、Flow Layout(流式布局): 按照组件添加到容器中的顺序，顺序排放组件位置。
        默认为水平排列，如果越界那么会向下排列。排列的位置随着容器大小的改变而改变。
        FlowLayout layout = new FlowLayout(FlowLayout.LEFT);//流式布局，可设对齐方式
        Panel 默认的布局管理器为Flow Layout。
  (2)、BorderLayout: 会将容器分成五个区域: 东西南北中。
        语句: Button b1=new Botton(“north”);//botton 上的文字
        f.add(b1,”North”);//表示b1 这个botton 放在north 位置
        f.add(b1, BorderLayout.NORTH);//这句跟上句是一样的效果，不写方位默认放中间，并覆盖
        注: 一个区域只能放置一个组件，如果想在一个区域放置多个组件就需要使用Panel 来装载。
        Frame 和Dialog 的默认布局管理器是Border Layout。
  (3)、Grid Layout(网格布局管理器): 将容器生成等长等大的条列格，每个块中放置一个组件。
        f.setLayout GridLayout(5,2,10,10)//表示条列格为5 行2 列，后面为格间距
  (4)、CardLayout(卡片布局管理器):一个容器可以放置多个组件，但每次只有一个组件可见(组件重叠)。
        使用first()，last()，next()可以决定哪个组件可见。可以用于将一系列的面板有顺序地呈现给用户。
  (5)、GridBag Layout(复杂的网格布局管理器):
        在Grid中可指定一个组件占据多行多列，GridBag的设置非常烦琐。
   注: 添加滚动条: JScrollPane jsp = new JScrollPane(ll);

4、常用的组件:
        (1)、JTextArea: 用作多行文本域
        (2)、JTextField: 作单行文本
        (3)、JButton:按钮
        (4)、JComboBox: 从下拉框中选择记录
        (5)、JList: 在界面上显示多条记录并可多重选择的列表
        (6)、JMenuBar: 菜单栏
        (7)、JScrollPane: 滚动条

/***********************************************************/
//最简单的图形用户界面，学会其中的四大步骤
import java.awt.*;
import javax.swing.*;
class FirstFrame {
    public static void main(String[] args) {
        //1、选择容器
        JFrame f = new JFrame();//在JFrame()的括号里可以填写窗口标题
        //2、选择布局管理器
        LayoutManager lm = new BorderLayout();
        f.setLayout(lm);
        //3、添加组件
        JButton b = new JButton("确定");
        f.add(b);
        //4、添加事件，显示
        JOptionPane.showMessageDialog(null, "哈哈，你好！");//对话窗口
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);//用窗口的开关控制程序的结束
        f.setSize(400, 300);//窗口的大小
        f.setVisible(true); //让窗口可见，默认不可见的
    }
}
/***********************************************************/

/*****************例题 画出计算器的界面*****************************
 界面如下:
     1   2   3   +
     4   5   6   -
     7   8   9   *
     0   .   =   /
 *******************/
import java.awt.*;
import javax.swing.*;
class Calculator {
    public static void main(String[] args) {
        JTextField text = new JTextField();
        JFrame f = new JFrame("计算器");
        Font font = new Font("宋体", Font.BOLD, 25);//"宋体"想写成默认，则写“null”
        text.setFont(font); //定义字体
        text.setHorizontalAlignment(JTextField.RIGHT);//令text的文字从右边起
        text.setEditable(false);//设置文本不可修改，默认可修改(true)
        f.add(text, BorderLayout.NORTH);//Frame和Dialog的默认布局管理器是Border Layout
        JPanel buttonPanel = new JPanel();//设法把计算器键盘放到这个Jpanel按钮上
        String op = "123+456-789*0.=/";
        GridLayout gridlayout = new GridLayout(4,4,10,10);
        buttonPanel.setLayout(gridlayout);//把计算器键盘放到buttonPanel按钮上
        for(int i=0; i<op.length(); i++) {
            char c = op.charAt(i);
            JButton b = new JButton(c+"");
            buttonPanel.add(b);
        }//这个循环很值得学习
        f.add(buttonPanel/*, BorderLayout.CENTER*/);  //默认添加到CENTER位置
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);//关窗口时结束程序
        f.setSize(300, 250);
        f.setVisible(true);//这句要放到最后，等事件完成后再显示
    }
}
/******学过事件之后，可以实现计算器的具体功能*******************************/




/////////// 下面是事件的添加 ////////
观察者模式:
事件源一旦产生事件，监察者立即作出相应处理。
    事件源: 产生一个事件的对象
    事件对象: 由事件源产生的一个对象
    事件监听者(观察者): 处理这个事件对象的对象
    事件注册: 给一个事件源注册一个(或多个)事件监听者

事件模型(重点)
    1. 定义:  事件模型指的是对象之间进行通信的设计模式。
        事件模型是在观察者模式基础上发展来的。
    2. 对象1 给对象2 发送一个信息相当于对象1 引用对象2 的方法。
    3. 事件对象分为三种:
       (1)事件源: 发出事件者；
       (2)事件对象: 发出的事件本身(事件对象中会包含事件源对象)
           事件对象继承:java.util.EventObjct类.
       (3)事件监听器: 提供处理事件指定的方法。
           标记接口: 没有任何方法的接口；如EventListene接口
           监听器接口必须继承java.util.EventListener接口。
           监听接口中每一个方法都会以相应的事件对象作为参数。
    4. 授权: Java AWT 事件模型也称为授权事件模型，指事件源可以和监听器之间事先建立一种授权关系:
        约定那些事件如何处理，由谁去进行处理。这种约定称为授权。
        当事件条件满足时事件源会给事件监听器发送一个事件对象，由事件监听器去处理。
        事件源和事件监听器是完全弱偶合的。
        一个事件源可以授权多个监听者(授权也称为监听者的注册)；事件源也可以是多个事件的事件源。
        监听器可以注册在多个事件源当中。监听者对于事件源的发出的事件作出响应。
        在java.util 中有EventListener 接口: 所有事件监听者都要实现这个接口。
        java.util 中有EventObject 类: 所有的事件都为其子类。
        注意: 接口因对不同的事件监听器对其处理可能不同，所以只能建立监听的功能，而无法实现处理。

//监听器接口要定义监听器所具备的功能，定义方法
/************下面程序建立监听功能***************************/
import java.awt.*;
import javax.swing.*;
public class TestEvent {
    public static void main(String[] args) {
        JFrame f = new JFrame("测试事件");
        JButton b = new JButton("点击");//事件源: 鼠标点击
        JTextArea textArea = new JTextArea();
        textArea.setFont(new Font(null, Font.BOLD+Font.ITALIC, 26));
        JScrollPane scrollPane = new JScrollPane(textArea);
        f.add(scrollPane, "Center");
        ButtonActionListener listener = new ButtonActionListener(textArea);
        b.addActionListener(listener);
        f.add(b, BorderLayout.SOUTH);
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.setSize(400, 300);
        f.setLocation(250, 250);
        f.setVisible(true);
    }
}
//事件对象，可以直接调用系统写好的
/*class ActionEvent extends EventObject{
    public ActionEvent(Object source) {
        super(source);
    }
}*/

//监听接口，同样可以调用系统写好的
/*interface ActionListener extends EventListener{
    public void actionPerformed(ActionEvent event);
}*/

//监听者
class ButtonActionListener implements ActionListener{
    private JTextArea textArea;
    public ButtonActionListener(JTextArea textArea) {
        this.textArea = textArea;
    }
    public void actionPerformed(ActionEvent e) {//必须覆盖它的actionPerformed()
        //JOptionPane.showMessageDialog(null, "按钮被按了一下");
        textArea.append("哈哈，放了几个字\n");
        textArea.append("哈哈，又放了几个字\n");
    }
}
/*********************************************************/

    注意查看参考书: 事件的设置模式，如何实现授权模型。
    事件模式的实现步骤: 开发事件对象(事件发送者)——接口——接口实现类——设置监听对象
    重点: 学会处理对一个事件源有多个事件的监听器(在发送消息时监听器收到消息的排名不分先后)。
        事件监听的响应顺序是不分先后的，不是谁先注册谁就先响应。
        事件监听由两个部分组成(接口和接口的实现类)。

        一定要理解透彻Gril.java 程序。
        事件源    事件对象        事件监听者
        gril     EmotinEvent   EmotionListener(接口)、Boy(接口的实现类)
        鼠标事件: MouseEvent，接口: MouseListener。
    注意在写程序的时候: import java.awt.*;以及import java.awt.event.*注意两者的不同。

    在生成一个窗体的时候，点击窗体的右上角关闭按钮激发窗体事件的方法:
    窗体Frame 为事件源，用WindowsListener 接口调用Windowsclosing()。
    为了配合后面的实现，必须实现WindowsListener所有的方法；除了Windowsclosing方法，其余的方法均为空实现。这样的程序中实现了许多不必要的实现类，虽然是空实现。为了避免那些无用的实现，可以利用WindowEvent 的一个WindowEvent 类，还是利用windowsListener。WindowAdapter类,实现于WindowsListener。它给出的全是空实现，那就可以只覆盖其中想实现的方法，不必再写空实现。

/******练习: 写一个带button 窗体，点关闭按钮退出。*************/
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import javax.swing.JFrame;
public class TestAdapter {
    public static void main(String[] args) {
        JFrame f = new JFrame("测试适配器");
        MyWindowListener listener = new MyWindowListener();
        //f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        //现在有上面这一句话，就可以不必再创建一个类了
        f.addWindowListener(listener);
        f.setSize(400, 300);
        f.setVisible(true);
    }
    private static class MyWindowListener extends WindowAdapter{
        public void windowClosing(WindowEvent e) {
            System.exit(0);
        }
    }
}
/*********************************************************/
注意: 监听过多，会抛tooManyListener 例外。
缺省试配设计模式: 如果一个接口有太多的方法，我们可以为这个接口配上一个对应的抽象类。



awt:
    java.applet.Applet 的 getParameter方法, 可以取得HTML里的参数。
    HTML文件必须用<param>标签, 如: <param name=htmlpra value="abc">
    (Graphics g;) g.drawString(getParameter("htmlpram"),70,80); //drawString 是显示文字的方法。

