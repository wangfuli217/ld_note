

day17 图形界面
1. 计算器
/*****************例题 画出计算器的界面*****************************
界面如下：
     1   2   3   +
     4   5   6   -
     7   8   9   *
     0   .   =   /
 *******************/
import java.awt.*;
import javax.swing.*;

class Calculator {
   public static void main(String[] args){
      JTextField text = new JTextField();
      JFrame f = new JFrame("计算器");
      Font font = new Font("宋体", Font.BOLD, 25);//"宋体"想写成默认，则写“null”
      text.setFont(font); //定义字体
      text.setHorizontalAlignment(JTextField.RIGHT);//令text的文字从右边起
      text.setEditable(false);//设置文本不可修改，默认可修改(true)
      f.add(text, BorderLayout.NORTH);//Frame和Dialog的默认布局管理器是Border Layout
      ButtonActionListener listener = new ButtonActionListener(text);//事件反应在text中
      JPanel buttonPanel = new JPanel();//设法把计算器键盘放到这个Jpanel按钮上
      String op = "123+456-789*0.=/";
      GridLayout gridlayout = new GridLayout(4,4,10,10);
      buttonPanel.setLayout(gridlayout);//把计算器键盘放到buttonPanel按钮上
      for(int i=0; i<op.length(); i++){
          char c = op.charAt(i); //拿到字符串的第i个字符
          JButton b = new JButton(c+"");//把字符放到按钮上
          b.addActionListener(listener);//在按钮上放置监听器，每次按都会有反应
          buttonPanel.add(b);//把按钮放到buttonPanel上
      }//这个循环很值得学习，很常用
      f.add(buttonPanel/*, BorderLayout.CENTER*/);  //默认添加到CENTER位置
      f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      f.setSize(300, 250);
      f.setVisible(true);//这句要放到最后，等事件完成后再显示
}}

//监听者
class ButtonActionListener implements ActionListener{
    private JTextField textField;
    public ButtonActionListener(JTextField textField) {
        this.textField = textField;
    }
    public void actionPerformed(ActionEvent e) {//必须覆盖它的actionPerformed()

        textField.append("哈哈，放了几个字\n");
}}
/*********************未实现计算器的具体功能*******************************/



2. 扫雷游戏



3. 俄罗斯方块




