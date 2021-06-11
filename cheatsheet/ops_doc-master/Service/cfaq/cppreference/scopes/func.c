void f()
{
   {   
       goto label; // label 在作用域中，尽管之后才声明
label:;
   }
   goto label; // 标号忽略块作用域
}
 
void g()
{
    goto label; // 错误： g() 中 label 不在作用域中
}

