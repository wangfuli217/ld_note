
### install pip on windows

1.[download pip:pip-9.0.1.tar.gz](https://pypi.python.org/pypi/pip#downloads)  

2.unpack to a folder: C:\pip-9.0.1

3.run Cmd as Administrator, enter C:\pip-9.0.1

4.run command to install pip:   py -3 setup.py install

  the pip will be installed into : C:\Program Files\Python36\Scripts
  
5.Add this dir to Enviroment Variable (system variable---Path)

6.now it's ok to run on Cmd: pip list ,    will display the installed package , like "pip 9.0.1 ,setuptools 28.8.0"


7.[refer to blog](https://www.cnblogs.com/yuanzm/p/4089856.html)

8.Two ways to use a package from Pypi:  
  a) "pip install package" ;    
  
  use proxy:  pip --proxy https://xx.xx.xx.xx:port  install package 
  
  b) download source code, unpack and "python setup.py install" it.
  
9.install many packages : put those package name with version in file  requirement.txt,then:

   pip install -r requirement.txt
