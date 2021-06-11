
四、 自定义对象
    1. 基本语法：
       使用 function 指令定义。其属性用“this.属性名”定义。
       如： function ObjectName(yName, yAge) {
                 this.name = yName;
                 this.age = yAge;
            }
       调用时：
            var myObject  = new ObjectName("kk",80); // ObjectName 里面的函数会被执行
            alert("name = " +  myObject.name +  "\n age = " + myObject.age);

    2. 使用简略语句快速创建对象
      1) 类
       正常写法：
           var car = new Object();
           car.color = "red";
           car.wheels = 4;
           car.hubcaps = "spinning";
       简略写法：
           var car = {
               color: "red",
               wheels:4,
               hubcaps:"spinning"
           }
           对象 car 就此创建，不过需要特别注意，结束花括号前一定不要加 ";" 否则在 IE 会遇到很大麻烦。

      2) 数组
        正常数组是这样写的： var movies = new Array('Transformers','Transformers2','Avatar','Indiana Jones 4');
        更简洁的写法是： var movies = ['Transformers', 'Transformers2', 'Avatar', 'Indiana Jones 4'];

      3)关联数组
        这样一个特别的东西。 你会发现很多代码是这样定义对象的：
        var car = new Array();
        car['colour'] = 'red';
        car['wheels'] = 4;
        car['hubcaps'] = 'spinning';
        //遍历的时候
        for ( var key in car ) { alert(key + " : " + car[key]); }

    3.匿名函数
      var myFun = function(args1, args2){ alert('haha'); }
      变量 myFun 指向一个匿名函数,这相当于创建函数 function myFun(args1, args2){ alert('haha'); }
      由于 javascript 没有类型,所以变量可以指向任意类型,也可以指向一个函数,对它来说都只是一片内存空间而已
      匿名函数一般用在只有一次使用的情况下,也是可以传递参数的
      如: element.onclick = function(){ alert(0); }

    4.JavaScript原生函数
      //要找一组数字中的最大数,如下，可以用一个循环
      var numbers = [3,342,23,22,124];
      var max = 0;
      for(var i=0;i<numbers.length;i++) { if(numbers[i] > max){max = numbers[i];} }
      alert(max);
      //也可以用排序实现同样的功能：
      var numbers = [3,342,23,22,124];
      numbers.sort(function(a,b){return b - a});
      alert(numbers[0]);
      //而最简洁的写法是：
      Math.max(12,123,3,2,433,4); // returns 433
      //你甚至可以使用Math.max来检测浏览器支持哪个属性：
      var scrollTop = Math.max( document.documentElement.scrollTop, document.body.scrollTop );

    5.如果你想给一个元素增加class样式，可能原始的写法是这样的：
      function addclass(elm,newclass) {
          var c = elm.className;
          elm.className = (c === '') ? newclass : c+' '+newclass;
      }
      //而更优雅的写法是：
      function addclass(elm,newclass){
          var classes = elm.className.split(' ');
          classes.push(newclass);
          elm.className = classes.join(' ');
      }

    6.对象的继承
      一般的做法是复制所有属性，但还有种方法，就是: Function.apply
      函数的 apply 方法能劫持另外一个对象的方法，继承另外一个对象的属性
      Function.apply(obj,args) 方法接收两个参数
        obj：这个对象将代替Function类里this对象
        args：这个是数组，它将作为参数传给Function（args-->arguments）

      示范如：
        function Person(name,age){   // 定义一个类，人类
            this.name=name;     //名字
            this.age=age;       //年龄
            this.sayhello=function(){alert("hello " + this.name);};
        }
        function Print(){            // 显示类的属性
            this.show=function(){
                var msg=[];
                for(var key in this){
                    if(typeof(this[key])!="function"){
                        msg.push([key,":",this[key]].join(""));
                    }
                }
                alert(msg.join(" "));
            };
        }
        function Student(name,age,grade,school){    //学生类
            Person.apply(this,arguments); // this 继承 Person,具备了它的所有方法和属性
            Print.apply(this,arguments);  // this 继承 Print,具备了它的所有方法和属性
            this.grade=grade;             //年级
            this.school=school;           //学校
        }
        var p1=new Person("jake",10);
        p1.sayhello();
        var s1=new Student("tom",13,6,"清华小学");
        s1.show();
        s1.sayhello();


    7.面向对象
      prototype: 当实例对象的时候，对象会自动生成一个prototype属性，它是一个指针指向对象公共的属性和函数集合。
        我们可以直接理解为 Person.prtotype = Person原型 = Person类所有实例都共享的属性和函数的一个指针。
      constructor: 它是一个指针指向对象原型,或者说指向对象的构造器。
      hasOwnProperty: 判断对象是否有自己独有的属性，不包括公共的。
      in 关键字:对象是否有这属性,不管是独有的还是公共的。
      独有属性与公共属性的优先级: 独有属性优先(遵守范围越小,优先级越高原则)。

      示范1 (定义面向对象的类,以及它们的属性、函数)：
        function Person(name) {
            this.name = name;
            this.sayName = function() {
                alert(this.name);
            }
        }

        var people1 = new Person('fanlizhi');
        var people2 = new Person('小明');

        people1.sayName();//fanlizhi
        people2.sayName();//小明

        // 每个实例不仅有自己独有的name同时，也将有自己独有的sayName函数（不是同一个函数的引用）
        // 因此浪费了资源，我们只需要调用同一个函数就行了而不像现在调用的是两个 sayName 函数。
        alert(people1.sayName == people2.sayName); //false


      示范2 (定义面向对象的类,以及它们公用的属性、函数)：
        function Person(name) {
            this.name = name;
        }

        var people1 = new Person('fanlizhi');
        var people2 = new Person('小明');

        /* 下面这写法,避免了上面 “示范1”的 sayName 函数的重复定义,各实例公用一个函数 */
        // prototype: 指向对象公共的属性和函数集合的指针
        Person.prototype.printName = function() {
             alert(this.name);
        };

        // 现在它们公用一个 printName 函数了(虽然这函数在它们实例化之后再加入,但这并不影响它的使用)
        people1.printName();//fanlizhi
        people2.printName();//小明

        alert(people1.printName === people2.printName);//true


      示范3 (思考 prototype 和 constructor)：
        function Person(name) {
            this.name = name;
        }
        Person.prototype.printName = function() {
             alert(this.name);
        };
        // 下面这写法跟上面有着本质不同,你可以认为下面的是对象的一个静态函数(各实例都不会有的)
        Person.sayHello = function() {
             alert('sayHello');
        };

        var people1 = new Person('fanlizhi');
        var people2 = new Person('小明');

        //constructor:标识对象类型的
        alert(people1.constructor === Person); alert(people2.constructor === Person);//true
        //instanceof:检测对象类型是否属于XXX
        alert(people1 instanceof Object); alert(people1 instanceof Person);//true

        alert(people1.sayHello); // undefined
        alert(Person.printName); // undefined

        alert(people1.constructor.sayHello);  // function
        alert(Person.prototype.printName); // function

        alert(people1.constructor.sayHello === Person.sayHello); //true (因为 people1.constructor == Person)
        alert(Person.prototype.printName === people1.printName); //true

        /*
         * constructor 其实就是对象实例化的时候 people1 与 Person 的关系,
         * people1.constructor 指向 Person，其实这个 constructor 是来自于 People.prototype.constructor,
         * 这是实例化时候内部解释器自动加上的默认属性。
         */
        alert(people1.constructor === Person); //true
        alert(Person.prototype.constructor === Person); //true
        alert(people1.constructor === Person.prototype.constructor); //true


      示范4 (关于实例独有的函数或者属性, hasOwnProperty() 和 in)：
        function Person(name) {
            this.name = name;
        }
        Person.prototype.printName = function() {
             alert(this.name);
        };

        var people1 = new Person('fanlizhi');
        var people2 = new Person('小明');

        /* 实例独有的函数或者属性, 得用 hasOwnProperty() 和 in 来判断 */
        alert(people2.hasOwnProperty("printName")); //false (hasOwnProperty 只检查自己独有的属性, 公用的不管)
        alert("printName" in people2);//true (in 是判断有没有这样的引用,先查找独有的,找不到再去找公用的)
        alert(people2.hasOwnProperty("name")); //true (在构造函数里面定义的,各个实例的都不一样,所以 name 是各个实例独有的)

        people2.printName = '小明 printName'; // 这里定义了一个独有属性
        alert(people2.hasOwnProperty("printName"));//true
        alert("printName" in people2);//true


      示范5 (关于优先级,实例的独有函数或者属性 与 公用函数或者属性 的优先级)：
        function Person(name) {
            this.name = name;
        }
        // 公用的函数
        Person.prototype.printName = function() {
             alert(this.name);
        };

        var people1 = new Person('fanlizhi');
        var people2 = new Person('小明');

        // 独有的函数
        people1.printName = function(){
            alert('hello ' + this.name);
        };

        people1.printName(); // hello fanlizhi (此时调用了自己独有的 printName 函数,而不是公用的)
        alert(people1.printName === people2.printName); //false (people2 用的是公用的)

        delete people1.printName; // 删掉它独有的函数(公用不能这样删)
        people1.printName();// fanlizhi (此时调用了公用的 printName 函数)
        alert(people1.printName === people2.printName); // true (又都是掉用公用的)

        // 删除公用的函数或属性得这样写(下面两种都可以):
        delete people1.constructor.prototype.printName;
        delete Person.prototype.printName;


      示范6 (一次用 prototype 定义多个属性或者函数)：
        function Person(){
        }

        var people1 = new Person();
        alert(people1.constructor); //Person()

        // 这样 Person.prototype 被重写了(而且它的 constructor 指向了 Object, 类型被改变了)
        Person.prototype = {
            name:'fanlizhi',
            sayName:function(){
                alert(this.name);
            }
        }

        var people2 = new Person();
        alert(people2.constructor);//Object()

        alert(people1.sayName); //undefined
        people2.sayName(); //fanlizhi

        alert(people2.constructor === Object); // true
        alert(people1.constructor === Person); // true
        alert(people1.constructor === people2.constructor); // false


      示范7 (一次用 prototype 定义多个属性或者函数, 避免“示范6”的 constructor 被重写)：
        function Person(){
        }

        var people1 = new Person();
        alert(people1.constructor); // Person()

        // 这样 Person.prototype 依然被重写了,但它的 constructor 被指向 Person, 保持了原类型不变
        Person.prototype = {
            constructor:Person,
            name:'fanlizhi',
            sayName:function(){
                alert(this.name);
            }
        }

        var people2 = new Person();
        alert(people2.constructor);// Person()

        alert(people1.sayName); // undefined (people1 用的是没有公用属性的那个 Person.prototype, 重写前的)
        people2.sayName(); //fanlizhi (people2 用的是重写后的那个 Person.prototype, 有公用函数及属性)
        alert(people1.sayName === people2.sayName); // false (people1 的找不到)

        alert(people2.constructor === Object); // false
        alert(people1.constructor === Person); // true
        alert(people2.constructor === Person); // true
        alert(people1.constructor === people2.constructor); // true

        alert(people1.constructor.prototype === people2.constructor.prototype); // true (people1 真实引用的那个 Person.prototype,想不到怎么找它出来了)


      示范8：(把 Person 当成 function 用, 区别于当成 类 来用, 它们里面的 this 不同)
        function Person(name) {
            this.name = name;
            alert(this === window);
        }

        Person('fanlizhi'); // 当 function 用时, 里面的 this 指的是 window, alert(true)
        alert(window.name); // fanlizhi

        var people1 = new Person('小明'); // 当类来用时, 里面的 this 指的是这个类的实例, alert(false)
        alert(window.name); // fanlizhi
        alert(people1.name); // 小明

