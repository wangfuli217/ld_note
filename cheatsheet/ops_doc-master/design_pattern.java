#	设计模式简介 https://github.com/xyy15926/proxy

设计默认（design pattern）

-	软件开发过程中面临的一般问题的解决方案
-	反复使用的、多数人知晓的、经过分类编目、代码设计经验的
	总结
-	利于重用代码、提高代码可读性、可靠性

##	设计模式原则

设计模式主要基于以下面向对象设计原则

-	对接口编程而不是对实现编程
-	优先使用对象组合而不是继承

六大原则

-	开闭原则（open close principle）
	-	对扩展开放、修改关闭。
	-	程序需要扩展时，不能修改原有代码以实现热拔插效果，
		易于扩展和升级

-	里氏代换原则（Liskov Substitution Principle）
	-	任何基类可以出现的地方，子类一定可以出现
	-	此为继承复用的基石，只有派生类了可以替换掉基类，且
		软件功能不受到影响，基类才能真正被复用
	-	对开闭原则的补充，实现开闭原则的关键步骤就是
		抽象化，基类与子类的继承关系就是抽象化的具体实现，
		LSP就是对实现抽象化的具体步骤的规范

-	依赖倒转原则（Dependence Inversion Principle）
	-	针对接口编程，以来抽象而不是具体
	-	开闭原则的基础

-	接口隔离原则（Interface Segregation Principle)
	-	使用多个隔离的接口优于单个接口
	-	降低类之间的耦合度

-	迪特米法则（最小知道原则，Demeter Principle）
	-	一个尸体应尽量少与其他实体发生相互作用
	-	使得系统功能模块相对独立

-	合成复用原则（Composite Reuse Principle）
	-	尽量使用合成、聚合方式，而不是继承

##	创建型模式

在创建对象的同时隐藏创建逻辑的方式，而不是直接使用`new`
运算符直接实例化对象，这使得程序在判断针对某个给定实例需要
创建哪些对象时更加灵活

###	工厂模式 Factory Pattern

创建对象时不会对客户端暴露创建逻辑，而是通过共同的接口指向
新创建的对象

-	意图：定义创建对象的接口，让其子类决定实例化何种工厂类，
	工厂模式使其创建过程延迟到子类进行
-	解决问题：接口选择问题
-	使用场景：明确地计划不同条件下创建不同实例时
-	解决方案：子类实现工厂接口，同时返回抽象产品
-	关键：创建过程在子类中进行
-	优点
	-	只需要名称就可以创建对象
	-	扩展性高，需要增加产品，只需要增加工厂类
	-	屏蔽产品具体实现，调用者只关心产品接口
-	缺点
	-	每次增加产品，都需要增加具体类和对象实现工厂，系统中
		类个数增长快，增加复杂度
	-	增加了系统具体类的依赖
-	注意
	-	在任何需要生成复杂对象的地方，都可以使用工厂模式
	-	但简单对象，使用工厂模式需要引入工厂类，增加系统
		复杂度

```java
// step1: create interface
public interface Shape{
	void draw();
}

// step2: create concrete class implementing interface
public class Rectangle implements Shape{
	@Override
	public void draw(){
		System.out.println('Inside Rectangle::draw() method.");
	}
}
public class Square implements Shape{
	@Override
	public void draw(){
		System.out.println("Inside Square::draw() method.");
	}
}
public class Circle implements Shape{
	@Override
	public void draw(){
		System.out.println("Inside Circle::draw() method.");
	}
}

// step3: create factory class generating concrete classes
// according to given info
public class ShapeFactory{
	public Shape getShape(String shapeType){
		if (shapeType == null){
			return null;
		}
		if (shapeType.equalsIgnoreCase("CIRCLE")){
			return new Circle();
		}
		if (shapeType.equalsIgnoreCase("RECTANGLE")){
			return new Rectangle();
		}
		if (shapeType.equalsIgnoreCase("SQUARE")){
			return new Square();
		}
		return null;
	}
}

// usage demo
public class FactoryPatternDemo{
	public static void main(String[] args){
		ShapeFactory shapeFactory = new ShapeFactory();

		Shape circle = shapeFactory.getShape("CIRCLE");
		circle.draw();
		Shape rectangle = shapeFactory.getShape("Rectangle");
		rectangle.draw();
		Shape square = shapeFactory.getShape("square");
		square.draw();
	}
}
```

###	抽象工厂模式 Abstract Factory Pattern

围绕一个超级工厂创建其他工厂，超级工厂又称为其他工厂的工厂，
其中接口是负责创建相关对象的工厂，不需要显式指定他们的类，
每个生成的工厂都能按照工厂模式提供对象

-	意图：提供创建一系列相关或相互依赖对象的接口，且无需指定
	其具体类型
-	解决问题：端口选择问题
-	使用场景：系统的产品有多个产品族，而系统只需要消费其中
	一族的产品
-	解决方案：在一个产品族中定义多个产品
-	优点：当一个产品族中多个对象被设计为一起工作时，能够保证
	客户端始终只使用同一个产品族中的对象
-	缺点：产品族扩展困难，需要同时修改具体类、抽象工厂类

```java
// step1: create interface
public interface Shape{
	void draw();
}
public interface Color{
	void fill();
}

// step2: create concrete class implementing interface

// shape classes
public class Rectangle implements Shape{
	@Override
	public void draw(){
		System.out.println("Inside Rectangle::draw() method.");
	}
}
public class Square implements Shape{
	@Override
	public void draw(){
		System.out.println("Inside Square::draw() method.");
	}
}
public class Circle implements Shape{
	@Override
	public void draw(){
		System.out.println("Inside Circle::draw() method.");
	}
}

// color classes
public Red implements Color{
	@Override
	public void fill(){
		System.out.println("Inside Red::fill() method.");
	}
}
public Green implements Color{
	@Override
	public void fill(){
		System.out.println("Inside Green::fill() method.");
	}
}
public Blue implements Color{
	@Override
	public void fill(){
		System.out.println("Inside Blue::fill() method.");
	}
}

// step3: create abstract class to get factory classes
public abstract class AbstractFactory{
	public abstract Color getColor(String color);
	public abstract Shape getShape(String shape);
}

// step4: create factory classes extending abstract factory
// class
public class ShapeFactory extends AbstractFactory{
	@Override
	public Shape getShape(String shapeType){
		if (shapeType == null){
			return null
		}
		if (shapeType.equalsIgnoreCase("CIRCLE"){
			return new Circle();
		}
		if (shapeType.equalsIgnoreCase("Rectangle"){
			return new Rectangle();
		}
		if (shapeType.equalsIgnoreCase("square"){
			return new Square();
		}
		return null;
	}

	@Override
	public Color getColor(String Color){
		return null;
	}
}

public class ColorFactory extends AbstractFactory{
	@Override
	public Shape getShape(String shapeType){
		return null;
	}

	@Override
	public getColor(String color){
		if (color == null){
			return null;
		}
		if (color.equalsIgnoreCase("RED"){
			return new Red();
		}
		if (color.equalsIgnoreCase("Green"){
			return new Green();
		}
		if (color.equalsIgnoreCase("blue"){
			return new Blue();
		}

		return null;
	}
}

// step5: create factory producer
public class FactoryProducer{
	public static AbstractFactory getFactory(String choice){
		if(choice.equalsIgnoreCase("SHAPE"){
			return new ShapeFactory();
		}else if(choice.equalsIgnoreCase("COLOR"){
			return new ColorFactory();
		}
		return null;
	}
}

// step6: demo
public class AbstractFactoryPatternDemo{
	public static void main(String[] args){
		
		// use shape cluster only
		AbstractFactory shapeFactory = FactoryProducer.getFactory("SHPAE");
		Shape circle = shapeFactory.getShape("CIRCLE");
		circle.draw();
		Shape rectangle = shapeFactory.getShape("RECTANGLE");
		rectangle.draw();
		Shape square = shapeFactory.getShape("SQUARE");
		square.draw();

		//use color cluster only
		AbstractFactory colorFactory = FactoryProducer.getFactory("color");
		Color red = colorFactory.getColor("RED");
		red.fill();
		Color green = colorFactory.getColor("green");
		green.fill();
		Color blue = colorFactory.getColor("blue");
		blue.fill();
	}
}
```

###	单例模式 Singleton Pattern

涉及到一个单一的类，该类负责创建自己的对象，同时确保只有单个
对象被创建，提供一种访问其唯一对象的方式，不需要实例化该类
的对象，可以直接访问

-	意图：保证类只有一个实例，并提供一个访问其的全局访问点
-	解决问题：一个全局使用的类频繁创建与销毁
-	使用场景：控制实例数据，节省系统资源
-	解决方法：判断系统是否已有实例，若有则返回，否则创建
-	优点
	-	内存仅有一个实例，减少内存开销
	-	避免对资源的多重占用（如文件读写）
-	缺点
	-	没有接口、无法继承，与单一职责冲突
	-	类应该只关心内部逻辑，而不设计外部如何实例化

```java
// step1: create singleton class
public class SingleObject{

	// create object as soon as class is loaded. It's okay
	// to move creating to `getInstance()`
	private static SingleObject instance = new SingleObject();

	// private construction method, so this class won't be
	// instantiated
	private SingleObject(){};

	public static SingleObject getInstance(){
		return instance;
	}

	public void showMessage(){
		System.out.println("hello world");
	}
}

// step2: test demo
public class SingletonPatternDemo{
	public static void main(String[] args){

		// private construction method, so `new SingleObject()`
		// is illegal
		SingleObject object = SingleObject.getInstance();
		object.showMessage();
	}
}
```

###	建造者模式 Builder Pattern

使用多个简单对象一步步构建成复杂对象

-	意图：将复杂的构建与其表示相分离，使得同样的构建过程可以
	创建不同的表示
-	解决问题：对于由负责多个子对象组成复杂对象，其各个组成
	部分可能随着需求而变化，而构建复杂对象的算法相对稳定
-	使用场景：基本部件不变，而其组合经常变化
-	解决方案：将变、不变分开考虑
-	优点
	-	建造者独立，容易扩展
	-	便于控制细节风险
缺点
	-	产品必须有共同点，范围有限制
	-	如果内部变化复杂，会有很多建造类

```java
// step1
public interface Item{
	public String name();
	public Packing packing();
	public float price();
}
public interface Packing{
	public String pack();
}

// step2
public class Wrapper implements Packing{
	@Override
	public String pack(){
		return "Wrapper";
	}
}
public class Bottle implements Packing{
	@Override
	public String pack(){
		return "Bottle";
	}
}

// step3
public abstract class Burger implements Item(){
	@Override
	public Packing packing(){
		return new Wrapper();
	}
	@Override
	public abstract float price();
}
public abstract class ColdDrink implements Item{
	@Override
	public Packing packing(){
		return new Bottle();
	}
	@Override
	public abstract float price();
}

// step4
public class VegBurger extends Buger{
	@Override
	public float price(){
		return 25.0f;
	}
	@Override
	public String name(){
		return "Veg Burger";
	}
}
public class ChickenBurger extends Burger{
	@Override
	public float price(){
		return 50.5f;
	}
	@Override
	public String name(){
		return "Chicken Burger";
	}
}
public class Coke extends ColdDrink{
	@Override
	public float price(){
		return 30.0f;
	}
	@Override
	public String name(){
		return "Coke";
	}
}
public class Pepsi extends ColdDrink{
	@Override
	public float price(){
		return 35.0f;
	}
	@Override
	public String name(){
		return "Pepsi";
	}
}

// step5
import java.util.ArrayList;
import java.util.List;
public class Meal{
	private List<Item> items = new ArrayList<Item>();
	public void addItem(Item item){
		items.add(item);
	}
	public float getCost(){
		float cost = 0.0f;
		for (Item item: items){
			cost += item.price();
		}
		return cost;
	}
	public void showItem(){
		for (Item item: items){
			System.out.print("Item: " + item.name());
			System.out.print(", Packing: " + item.packing().pack());
			System.out.println(", Price: " + item.price());
		}
	}
}

// step6
public class MealBuilder{
	public Meal prepareVegMeal(){
		Meal meal = new Meal();
		meal.addItem(new VegBurger());
		meal.addItem(new Coke());
		return meal;
	}
	public Meal parpareNonVegMeal(){
		Meal meal = new Meal();
		meal.addItem(new ChickenBuger());
		meal.addItem(new Pepsi());
		return meal;
	}
}

// step7
public class BuilderPatternDemo{
	public static void main(String[] args){
		MealBuilder mealBuilder = new MealBuilder();

		Meal vegMeal = mealBuilder.prepareVegMeal();
		System.out.println("Veg Meal");
		vegMeal.showItems();
		System.out.println("Total Cost: " + vegMeal.getCost());

		Meal.nonVegMeal = mealBuilder.prepareNonVegMeal();
		System.out.println("\n\nNon-Veg Meal");
		nonVegMeal.showItems();
		System.out.println("Total Cost: " + nonVegMeal.getCost());
	}
}
```

###	原型模式 Prototype Pattern

实现一个原型接口，用于创建重复对象，同时又能保证性能

-	意图：用原型实例指定创建对象的种类，并通过拷贝这些原型
	创建新的对象
-	解决问题：在运行时建立和删除原型
-	使用场景
	-	类的初始化代价大
	-	系统应该独立其产品的创建、构成、表示
	-	要实例化的类是在运行时指定
	-	避免创建与产品类层次平行的工厂类
	-	类的实例只能有几个不同的状态组合中的一种时，建立相应
		数目的原型并克隆可能比每次用合适的状态手工实例化更
		方便
	-	实际上原型模式很少单独出现，一般和工厂模式一起出现，
		通过clone方法创建对象返回给调用者
-	优点
	-	性能提高，尤其是直接创建对象代价比较大
		（如对象需要在高代价的数据库操作后被创建）
	-	逃避构造函数的约束
-	缺点
	-	配备克隆方法需要对类的功能全盘考虑，对已有类可能比较
		难，尤其是类引用不支持串行化的间接对象
-	注意：原型模式时通过拷贝现有对象生成新对象，要主要区分
	浅拷贝和深拷贝

```java
// step1: create an abstract class implementing Cloneable
// interface
public abstract class Shape implements Cloneable{
	// Java中已经同原型模式融为一体
	// 实现`Cloneable`接口实现浅拷贝，深拷贝则是通过实现
	// `Serializable`读取二进制流
	private String id;
	protected String type;

	abstract void draw();
	public String getType(){
		return type;
	}
	public String getId(){
		return id;
	}
	public void setId(String id){
		this.id = id;
	}
	public Object clone(){
		Object clone = null;
		try{
			clone = super.clone();
		}
		catch (CloneNotSupportedException e){
			e.printStackTrace();
		}
		return clone;
	}
}

// step2: create a concrete class extending the abstract
// class
public class Rectangle extends Shape{
	public Rectangle(){
		tpye = "Rectangle";
	}
	@Override
	public void draw(){
		System.out.println("Inside Rectangle::draw() method.");
	}
}
public class Square extends SHape{
	public Square(){
		type = "Sqaure";
	}
	@Override
	public void draw(){
		System.out.println("Inside Square::draw() method.");
	}
}
public class Circle extends Shape{
	public Circle(){
		type = "Circle";
	}
	@Override
	public void draw(){
		System.out.println("Inside Circle::draw() method.");
	}
}

// step3: creat a class to store the implements
import java.util.Hashtable;
public class ShapeCache{
	private static Hashtable<String, Shape> shapeMap
		= new Hashtable<String, Shape>();

	public static Shape getShape(String shapeId){
		Shape cachedShape = shapeMap.get(shapeId);
		return (Shape)cachedShape.clone();
	}
	public static void loadCache(){
		Circle circle = new Circle();
		circle.setId("1");
		shapeMap.put(circle.getId(), circle);

		Square square = new Square();
		square.setId("2");
		shapeMap.put(square.getId(), square);

		Rectangle rectangle = new Rectangle();
		rectangle.setId("3");
		shapeMap.put(rectangle.getId(), rectangle);
	}
}

// step4: test demo
public class PrototypePatternDemo{
	public static void main(String[] args){
		ShapeCache.loadCache();

		Shape clonedShape = (Shape)ShapeCache.getShape("1");
		System.out.println("shape: " + clonedShape.getType());
		Shape clonedShape2 = (Shape)ShapeCache.getShape("2");
		System.out.println("shape: " + clonedShape2.getType());
		Shape clonedShape3 = (Shape)ShapeCache.getShape("2");
		System.out.println("shape: " + clonedShape3.getType());
	}
}
```

##	结构型模式

关注类和对象的；组合，继承的概念被用来组合接口和定义组合对象
获得新功能的方式

###	适配器模式 Adaptor Pattern

不兼容的接口之间的桥梁，负责加入独立的或不兼容的接口功能

-	意图：将一个类的接口转换为客户希望的另一个接口，使得原本
	由于接口不兼容的类可以一起工作
-	解决问题：“现存对象”无法满足新环境要求
-	使用场景
	-	系统需要使用现有类，现有类不符合系统需要
	-	想要建立可以重复使用的类，用于与一次彼此之间没有太大
		关联的类（包括可能未来引进的类）
	-	通过接口转换将一个类插入另一个类
-	解决方法：继承或以来
-	优点
	-	可以让任何两个没有关联的类一起运行
	-	提高类类的复用
	-	增加了类的透明度
	-	灵活性好
-	缺点
	-	过多的使用适配器可能会导致系统凌乱，不易把握整体
	-	对于单继承语言，至多只能适配一个适配器类
-	注意事项：适配器模式用于解决正在服役的项目问题，而不是
	详细设计时

```java
// step1: create interfaces
public interface MediaPlayer{
	public void play(String audioType, String fileName);
}
public interface AdvancedMediaPlayer{
	public void playVlc(String fileName);
	public void playMp4(String fileName);
}

// step2:
public class VlcPlayer implements AdvancedMediaPlayer{
	@Override
	public void playVlc(String fileName){
		System.out.println("Playing vlc file. Name: " + fileName);
	}
	@Override
	public void playMp4(String fileName){
	}
}
public class Mp4Player implements AdvancedMediaPlayer{
	@Override
	public void playVlc(String fileName){
	}
	@Override
	public void playMp4(String fileName){
		System.out.println("Playing mp4 file. Name: " + fileName);
	}
}

// step3: create adapter class
public class MediaAdapter implements MediaPlayer{
	AdvancedMediaPlayer advancedMusicPlayer;

	// construction method
	public MediaAdapter(String audioType){
		if(audioType.equalsIgnoreCase("vlc")){
			advancedMusicPlayer = new VlcPlayer();
		}else if (audioType.equalsIgnoreCase("mp4")){
			advancedMusicPlayer = new Mp4Player();
		}
	}
	@Override
	public void play(String audioType, String fileName){
		if(audioType.equalsIgnoreCase("vlc")){
			advancedMusicPlayer.playVlc(fileName);
		}else if(audioType.equalsIgnoreCase("mp4")){
			advancedMusciPlayer.playMp4(fileName);
		}
	}
}

// step4:
public class AudioPlayer implements MediaPlayer{
	MediaPlayer mediaAdapter;

	@Override
	public void play(String audioType, String fileName){
		if(audioType.equalsIgnoreCase("mp3")){
			System.out.println("Playing mp3 file. Name: " + fileName);
		}else if(audioType.equalsIgnoreCase("vlc") ||
			audioType.equalsIgnoreCase("mp4")){
			mediaAdapter = new MediaAdatper(audioType);
			mediaAdapter.play(audioType, fileName);
		}else{
			System.out.println("Invalid media. " +
				audioType + " format not supported.");
		}
	}
}

// step5: test demo
public class AdapterPatternDemo{
	public static void main(String[] args){
		AudioPlayer audioPlayer = new AudioPlayer();
		audioPlayer.play("mp3", "beyond the horizon.mp3");
		audioPlayer.play("mp4", "alone.mp4");
		audioPlayer.play("vlc", "far far away.vlc");
		audioPlayer.play("avi", "mind me.avi");
	}
}
```

###	桥接模式 Bridge Pattern

把抽象化与现实化解耦，使得二者可以独立变化，涉及一个作为桥接
的接口，使得实体类的功能能独立与接口实现类

-	意图：将抽象部分与实现部分分离，使得其可以独立变化
-	解决问题：在有多种可能会变化的情况下，用继承会造成类爆炸
	问题，扩展起来不灵活
-	使用场景：实现系统可能有多个角度分类，每种角度都可能变化
-	解决方法：把多角度分类分离出来，让其独立变化，减少其间
	耦合
-	优点
	-	抽象和实现的分离
	-	优秀的扩展能力
	-	实现细节对客户透明
-	缺点：照成系统的理解与设计难度，由于聚合关联关系建立在
	抽象层，要求开发者针对抽象进行设计、编程

```java
// step1
public interface DrawAPI{
	public void drawCircle(int radius, int x, int y);
}

// step2
public class RecCircle implements DrawAPI{
	@Override
	public void drawCircle(int radius, int x, int y){
		System.out.println("Drawing Circle[color: red, radius: "
			+ radius + ", x: " + x +", y: " + y + "]");
	}
}
public class GreenCircle implements DrawAPI{
	@Override
	public void drawCircle(int radius, int x, int y){
		System.out.println("Drawing Circle[color: Green, radius: "
			+ radius + ", x: " + x +", y: " + y + "]");
	}
}

// step3
public abstract class Shape{
	protected DrawAPI drawAPI;
	protected Shape(DrawAPI drawAPI){
		this.drawAPI = drawAPI;
	}
	public abstract void draw();
}

// step4
public class Circle extends Shape{
	private int x, y, radius;
	public Circle(int x, int y, int radius, DrawAPI drawAPI){
		super(drawAPI);
		this.x = x;
		this.y = y;
		this.radius = radius;
	}
	public void draw(){
		drawAPI.drawCircle(radius, x, y);
	}
}

// step5: test demo
public class BridgePatternDemo{
	public static void main(String[] args){
		Shape redCircle = new Circle(100, 100, 10, new RedCircle());
		Shape greenCircle = new Circle(100, 100, 10, new GreenCircle());
		redCircle.draw();
		greenCircle.draw();
	}
}
```

###	过滤器（标准）模式 Filter、Criteria Pattern

使用多种不同的标准过滤一组对象，通过逻辑运算以解耦的方式将其
连接起来，结合多个标准或者单一标准

-	意图：
-	解决问题：
-	适用场景：
-	解决方法：
-	优点
-	缺点

```java
// step1: create a class which will be impose criteria on
public class Person{
	private String name;
	private String gender;
	pirvate String maritalStatus;

	public Person(String name, String gender, String maritalStatus){
		this.name = name;
		this.gender = gender;
		this.maritalStatus = maritalStatus;
	}
	public String getName(){
		return name;
	}
	public String getGender(){
		return gender;
	}
	public String getMaritalStatus(){
		return maritalStatus;
	}
}

// step2: create an interface for criteria
import java.util.List;
public interface Criteria{
	public List<Person> meetCriteria(List<Person> persons);
}

// step3: creat 
import java.util.ArrayList;
import java.util.List;
public class CriteriaMale implements Criteria{
	@Override
	public List<Person> meetCriteria(List<Person> persons){
		List<Person> malePersons = new ArrayList<Peron>();
		for(Person person : persons){
			if(person.getGender().equalsIgnoreCase("MALE"){
				malePersons.add(Person);
			}
		}
		return malePersons;
	}
}
public class CriteriaFemale implements Criteria{
	@Override
	public List<Person> meetCriteria(List<Person> persons){
		List<Person> femalePerson = new ArrayList<Person>();
		for(Person person: persons){
			if(person.getGender.equalsIgnoreCase("Female"){
				femalePersons.add(person);
			}
		}
		return femalePersons;
	}
}
public class CriteriaSingle implements Criteria{
	@Override
	public List<Person> meetCriteria(List<Person> persons){
		List<Person> singlePersons = new ArrayList<Person>();
		for(Person person: persons){
			if(person.getMaritalStatus().equalsIgnoreCase("Single")){
				singlePerson.add(person);
			}
		}
		return singlePersons;
	}
}
public class AndCriteria implements Criteria{
	pirvate Criteria criteria;
	private Criteria otherCriteria;
	public AndCriteria(Criteria criteria, Criteria otherCriteria){
		this.criteria = criteria;
		this.otherCriteria = otherCriteria;
	}

	@Override
	public List<Person> meetCriteria(List<Person> persons){
		List<Person> firstCriteriaPersons = criteria.meetCriteria(persons);
		return otherCriteria.meetCriteria(firstCriteriaPersons);
	}
}
public class OrCriteria implements Criteria{
	pirvate Criteria criteria;
	private Criteria otherCriteria;
	public Criteria(Criteria criteria, Criteria otherCriteria){
		this.criteria = criteria;
		this.otherCriteria = otherCriteria;
	}

	@Override
	public List<Person> meetCriteria(List<Person> persons){
		List<Person> firstCriteriaItems = criteria.meetCriteria(persons);
		List<Person> otherCriteriaItems = criteria.meetCriteria(persons);
		for(Person person: otherCriteriaItems){
			if(!firstCriteriaItems.contains(person)){
				firstCriteriaItems.add(person);
			}
		}
		return firstCriteriaItems;
	}
}

// step4: test demo
import java.util.ArrayList;
import java.util.List;
public class CriteriaPatternDemo{
	public static void main(String[] args) {
		List<Person> persons = new ArrayList<Person>();

		persons.add(new Person("Robert","Male", "Single"));
		persons.add(new Person("John","Male", "Married"));
		persons.add(new Person("Laura","Female", "Married"));
		persons.add(new Person("Diana","Female", "Single"));
		persons.add(new Person("Mike","Male", "Single"));
		persons.add(new Person("Bobby","Male", "Single"));

		Criteria male = new CriteriaMale();
		Criteria female = new CriteriaFemale();
		Criteria single = new CriteriaSingle();
		Criteria singleMale = new AndCriteria(single, male);
		Criteria singleOrFemale = new OrCriteria(single, female);

		System.out.println("Males: ");
		printPersons(male.meetCriteria(persons));

		System.out.println("\nFemales: ");
		printPersons(female.meetCriteria(persons));

		System.out.println("\nSingle Males: ");
		printPersons(singleMale.meetCriteria(persons));

		System.out.println("\nSingle Or Females: ");
		printPersons(singleOrFemale.meetCriteria(persons));
		}

	public static void printPersons(List<Person> persons){
		for (Person person : persons) {
			System.out.println("Person : [ Name : " + person.getName() 
				+", Gender : " + person.getGender() 
				+", Marital Status : " + person.getMaritalStatus()
				+" ]");
		}
	}
}
```

###	组合模式 Composite Pattern

把一组相似的对象当作一个单一的对象，依据树形结构来组合对象，
用来表示部分和整体层次，亦称部分整体模式

-	意图：将对象组合成树形结构以表示“部分-整体”层次结构，
	使得用户对单个对象和组合对象的使用具有一致性
-	解决问题：模糊树形结构问题中简单元素和复杂元素的概念，
	客户程序可以像处理简单元素一样处理复杂元素，使得客户程序
	与复杂元素的内部结构解耦
-	使用场景
	-	表示对象的“部分-整体”层次结构（树形结构）
	-	希望用户忽略组合对象与单个对象的不同，统一地使用组合
		结构中所有对象
-	解决方法：树枝和叶子实现统一接口，树枝内部组合该接口
-	优点
	-	高层模块调用简单
	-	节点自由度增加
-	缺点：叶子和树枝的声明都是实现类，而不是接口，违反了依赖
	倒置原则

```java
// step1: create a class containing a list of Self
import java.util.ArrayList;
import java.util.List;
public class Employee{
	pirvate String name;
	pirvate String dept;
	private int salary'
	private List<Employee> subordinates;

	public Employee(String name, String dept, int sal){
		this.name = name;
		this.dept = dept;
		this.salary = sal;
		subordinates = new ArrayList<Employee>();
	}
	public void add(Employee e){
		subordinates.add(e);
	}
	public void remove(Employee e){
		subordinates.remove(e);
	}
	public List<Employee> getSubordinates(){
		return subordinates;
	}
	public String toString(){
		return ("Employee: [Name: " + name + ", dept: "
			+  dept + ", salary: " + salary + "]");
	}
}

// step2: test demo
public class CompositePatternDemo{
	public static void main(String[] args){
		Employee CEO = new Employee("John", "CEO", 30000);
		Employee headSales = new Employee("Robert", "Head Sales", 20000);
		Employee headMarketing = new Employee("Michel", "Head Marketing", 20000);
		Employee clerk1 = new Employee("Laura", "Marketing", 10000);
		Employee clerk2 = new Employee("Bob", "Marketing", 10000);
		Employee saleExecutive1 = new Employee("Richard", "Sales", 10000);
		Employee saleExecutive2 = new Employee("Rob", "Sales", 10000);
		CEO.add(headSales);
		CEO.add(headMarketing);
		headSales.add(saleExecutive1)
		headSales.add(saleExecutive2);
		headMarketing.add(clerk1);
		headMarketing.add(clerk2);

		System.out.println(CEO);
		for(Employee  headEmployee: CEO.getSubordinates()){
			System.out.println(headEmployee);
			for(Employee employee: headEmployee.getSubordinates()){
				System.out.println(employee);
			}
		}
	}
}
```
组合模式：在对象中包含其他对象，就是树，类似于叶子节点等等

###	装饰器模式 Decorator Pattern

创建一个新类用于包装原始类，向其添加新功能，同时不改变其结构

-	意图：动态的给对象添加额外的职责，比生成子类更灵活
-	解决问题：为扩展类而使用继承的方式，会为类引入静态特征，
	随着扩展功能的增多，子类会膨胀
-	使用场景：不增加很多子类的情况下扩展类
-	解决方法：将具体功能职责划分，同时继承装饰者模式
-	优点：装饰类和被装饰类可以独立发展，不会相互耦合，替代
	继承从而动态的扩展实现类的功能
-	缺点：多层装饰复杂

```java
// step1
public interface Shape{
	void draw();
}

// step2
public class Rectangle implements Shape{
	@Override
	public void draw(){
		System.out.println("Shape: Rectangle");
	}
}
public class Circle implements Shape{
	@Override
	public void draw(){
		System.out.println("Shape: Cirlce");
	}
}

// step3
public abstract class ShapeDecorator implements Shape{
	protected Shape decoratedShape;
	public ShapeDecorator(Shape decoratedShape){
		this.decoratedShape = decoratedShape;
	}
	public void draw(){
		decoratedShape.draw();
	}
}

// step4
public class RedShapeDecorator extends ShapeDecorator{
	public RedShapeDecorator(Shape decoratedShape){
		super(decoratedShape);
	}
	@Override
	public void draw(){
		decoratedShape.draw();
		setRedBorder(decoratedShape);
	}
	private void setRedBorder(Shape decoratedShape){
		System.out.println("Border Color: Red");
	}
}

// step5: demo
public class DecoratorPatternDemo{
	public static void main(String[] args){
		Shape circle = new Circle();
		Shape redCircle = new RedShapeDecorator(new Circle());
		Shape redRectangle = new RedShapeDecorator(new Rectangle());
		System.out.println("Circle with normal border");
		circle.draw();
		System.out.println("\nCircle of red border");
		redCircle.draw();
		System.out.println("\nRectangle of red border");
		redRectangle.draw();
	}
}
```

###	外观模式 Facade Pattern

隐藏系统的复杂性，想客户端提供访问系统的接口，简化客户端请求
方法和对象系统类方法的委托调用

-	意图：定义一个高级接口，使得子系统更加容易使用
-	解决问题：降低访问复杂系统内部子系统时的复杂度
-	使用场景
	-	客户端不需要知道复杂系统内部的复杂联系，系统只需要
		提供“接待员”
	-	定义系统的入口
-	解决方法：客户端不与系统耦合，外观类与系统耦合
-	优点
	-	减少系统相互依赖
	-	提高灵活性
	-	提高安全性
-	缺点：不符合开闭原则，修改时麻烦

```java
// step1
public interface Shape{
	void draw();
}
// step2
public class Rectangle implements Shape{
	@Override
	public void draw(){
		System.out.println("Rectangle::draw()");
	}
}
public class Square implements Shape{
	@Override
	public void draw(){
		System.out.println("Square::draw()");
	}
}
public class Circle implements Shape{
	@Override
	public void draw(){
		System.out.println("Circle::draw()");
	}
}
// step3
public class ShapeMaker{
	private Shape circle;
	private Shape rectangle;
	private Shape square;

	public ShapeMaker(){
		circle = new Circle();
		rectangle = new Rectangle();
		square = new Square();
	}
	public void drawCircle(){
		circle.draw();
	}
	public void drawRectangle(){
		rectangle.draw();
	}
	public void drawSquare(){
		square.draw();
	}
}
// step4
public class FacadePatternDemo{
	public static void main(String[] args){
		ShapeMaker shapeMaker = new ShapeMaker();
		shapeMaker.drawCircle();
		shapeMaker.drawRectangle();
		shapeMaker.drawSquare();
	}
}
```

###	享元模式 Flyweight Pattern

尝试重用现有的同类对象，仅在找不到匹配对象才创建新对象，
减少创建对象的数量、内存占用，提高性能

-	意图：运用共享技术有效地支持大量细粒度的对象
-	解决问题：大量对象时，抽象出其中共同部分，相同的业务请求
	时，直接返回内存中已有对象
-	使用场景
	-	系统中有大量对象，消耗大量内存
	-	对象的状态大部分可以外部化
	-	对象可以按照内蕴状态分组，将外蕴状态剔除后可以每组
		对象只使用一个对象代替
	-	系统不依赖这些对象的身份，对象是“不可分辨的”
-	解决方法：用唯一标识码判断，如果内存中存在，则返回唯一
	标识码所标识的对象
-	优点：减少对象创建、内存消耗
-	缺点：增加系统复杂度，需要分离内蕴、外蕴状态，而且外蕴
	状态具有固有化相知，不应该随着内部状态变化而变化，否则会
	照成系统混乱

```java
// step1
public interface Shape{
	void draw();
}

// step2
public class Circle implements Shape{
	private String color;
	private int x;
	private int y;
	private int radius;

	public Circle(String color){
		this.color = color;
	}
	public void setX(int x){
		this.x = x;
	}
	public vodi setY(int y){
		this.y = y;
	}
	public void setRadius(int radius){
		this.radius = radius;
	}
	@Override
	public void draw(){
		System.out.println("Circle: Draw() [Color: " + color
			+ ",x: " + x + ",y: " + y + ",radius: " + radius);
	}
}

// step3
import java.util.HashMap;
public class ShapeFactory{
	private static final HashMap<String, Shape> circleMap = new HashMap<>();

	public static Shape getCircle(String color){
		Circle circle = (Circle)circleMap.get(Color);
		if(circle == null){
			circle = new Circle(color);
			circleMap.put(color, circle);
			System.out.println("Creating circle of color: " + color);
		}
		return cirle;
	}
}

// step4
public class FlyweightPatternDemo{
	pirvate static final String colors[] = 
	{"Red", "Green", "Blue", "White", "Black"};

	public static void main(String[] args){
		for (int i = 0; i < 20; ++i){
			Circle circle = (Circle)ShapeFactory.getCircle(getRamdonColor());
			circle.setX(getRandomX());
			circle.setY(getRandomY());
			circle.setRadius(100);
			circle.draw();
		}
	}
	private static String getRandomColor(){
		return colors[(int)(Math.random()*colors.length))];
	}
	private static int getRandomX(){
		return (int)(Math.random()*100)
	}
	private static int getRandomY(){
		return (int)(Math.random()*100);
	}
}
```

###	代理模式 Proxy Pattern

创建具有现有对象的对象，向外界提供功能接口，一个类代表另
一个类的功能，

-	意图：为其他对象提供一种代理以控制对这个对象的访问
-	解决问题：直接访问对象会给使用者、系统结构代理问题
-	使用场景：在访问类时做一些控制
-	解决方法：增加中间层
-	优点
	-	职责清晰
	-	高扩展性
	-	智能化
-	缺点
	-	在客户端和真实端之间增加了代理对象，可能降低效率
	-	代理模式需要额外工作，实现可能非常复杂

```java
// step1
public interface Image{
	void dispaly();
}

// step2
publi class RealImage implements Image{
	private String fileName;

	public RealImage(String fileName){
		this.filName = fileName;
		loadFromDisk(fileName);
	}
	@Ovrride
	public void display(){
		System.out.println("Displaying " + fileName);
	}
	private void loadFromDisk(String fileName){
		System.out.println("Loading " + fileName);
	}
}

// step3
public class ProxyImage implements Image{
	private RealImage realImage;
	private String fileName;

	public ProxyImage(String fileName){
		this.fileName = fileName;
		// it won't load image until display-method is
		// called
	}
	@Override
	public void display(){
		if(realImage = Null){
			realImage = new RealImage(fileName);
		}
		realImage.display();
	}
}

// step4
public class ProxyPatternDemo{
	public static void main(String[] args){
		Image image = new ProxyImage("test_10mb.jpg");
		image.display();
	}
}
```

##	行为型模式

特别关注对象之间的通信

###	责任链模式 Chain of Responsibility Pattern

为请求创建接收者对象的链，对请求的发送者和接收者进行解耦，
通常每个接着者都包含对另一个接收者的引用

-	意图：避免请求发送者与接收者耦合，让多个对象都有可能接受
	请求，将这些对象连接成职责链，并且沿着这条链传递请求，
	直到有对象处理
-	解决问题：职责链上处理者负责处理请求，客户只要将请求发送
	到职责链上即可，无需关心请求的处理细节和请求的传递，所以
	职责链将请求的发送者和请求的处理者解耦
-	使用场景：在处理时已过滤多次
-	解决方法：拦截的类都实现统一接口
-	优点
	-	降低耦合度
	-	简化对象，发送者不需要知道链的结构
	-	增强接收者的灵活性，通过改变、排序职责链内成员，允许
		动态的增删责任
	-	增加新的请求处理类方便
-	缺点
	-	不能保证请求一定被接收
	-	系统性能将受到影响，调试代码时不方便，可能造成循环
		调用
	-	不容易观察运行时特征，有碍于除错

```java
// step1
public abstract class AbstractLogger{
	public static int INFO = 1;
	public static int DEBUG = 2;
	public static int ERROR = 3'
	protected int level;
	protected AbstractLogger nextLogger;

	public void setNextLogger(AbstractLogger nextLogger){
		this.nextLogger = nextLogger;
	}
	public void logMessage(int level, String Message){
		if(this.level <= level){
			write(message);
		}
		if(nextLogger != null){
			nextLogger.logMessage(level, message);
		}
	}
	abstract protected void write(String message);
}

// step2
public class ConsoleLogger extends AbstractLogger{
	public consoleLogger(int level){
		this.level = level;
	}
	@Override
	protected void write(String message){
		System.out.println("Standard Console::Logger: " + message);
	}
}
public class ErrorLogger extends AbstractLogger{
	public ErrorLogger(int level){
		this.level = level;
	}
	@Override
	protected void write(String message){
		System.out.println("Error Console::Logger: " + message);
	}
}
public class FileLogger extends AbstractLogger{
	public FileLogger(int level){
		this.level = level;
	}
	@Override
	protected void write(String message){
		System.out.println("File::Logger: " + message);
	}
}

// step3
public class ChainPatternDemo{
	private static AbstractLogger getChainOfLogger(){
		AbstractLogger errorLogger = new ErrorLogger(AbstractLogger.ERROR);
		AbstractLogger fileLogger = new FileLogger(AbstractLogger.DEBUG):
		AbstractLogger console.Logger = new ConsoleLogger(AbstractLogger.INFO0;
		errorLogger.setNextLogger(fileLogger);
		fileLogger.setNextLogger(consoleLogger);
		return errorLogger;
	}
	public static void main(String[] args){
		AbstractLogger loggerChain = getChainLoggers();
		loggerChain.logMessage(AbstractLogger.INFO,
			"this is an information");
		loggerChain.logMessage(AbstractLogger.DEBUG,
			"this is a debug level infomation");
		loggerChain.logMessage(AbstractLogger.ERROR,
			"this is an error infomation");
	}
}
```

###	命令模式 Command Pattern

请求以命令的形式包裹对象中，并传给调用对象，调用对象寻找可以
处理该命令的合适的对象，是一种数据驱动的设计模式

-	意图：将请求封装成一个对象，用不同的请求对客户进行参数化
-	解决问题：行为请求者、实现者通常是紧耦合关系，
-	使用场景：需要对行为进行记录、撤销、重做、事务等处理时，
	紧耦合关系无法抵御变化
-	解决方法：通过调用者调用接收者执行命令
-	优点
	-	降低系统耦合度
	-	容易添加新命令至系统
-	缺点：使用命令模式可能会导致系统有过多具体命令类

```java
// step1
public interface Order{
	void execute();
}

// step2
public class Stock{
	private String name = "ABC";
	private int quantity = 10;
	public void buy(){
		System.out.println("Stock [Name: " + name
			+ ", Quantity: " + quantity + "] bought");
	}
	public void seel(){
		System.out.println("Stock [Name: " + name
			+ ", Quantity: " + quantity + "] sold");
	}
}

// step2
public class BuyStock implements Order{
	private Stock abcStock;
	public BuyStock(Stock abcStock){
		this.abcStock = abcStock;
	}
	public void execute（）{
		abcStock.but();
	}
}
public class SellStock implements Order{
	private Stock abcStock;
	public SellStock(Stock abcStock){
		this.abcStock = abcStock;
	}
	pubic void execute(){
		abcStock.sell();
	}
}

// step3
import java.util.ArrayList;
import java.util.List;
public class Broker{
	private List<Order> orderList = new ArrayList<Order>();
	public void takeOrder(Order order){
		orderList.add(order);
	}
	public void placeOrders(){
		for(Order order: orderList){
			order.execute();
		}
		orderList.clear();
	}
}

// step4
public class CommandPatternDemo{
	public static void main(String[] args){
		Stock abcStock = new Stock();
		BuyStock buyStockOrder = new BuyStock(abcStock);
		SellStock sellStockOrder = new SellStock(abcStock);
		Broker broker = new Broker();
		broker.takeOrder(buyStockOrder);
		broker.takeOrder(sellStockOrder);
		broker.placeOrders();
	}
}
```

###	解释器模式 Interpreter Pattern

实现一个表达式接口用于解释特定上下文，提供了评估语言的语法
或表达式的方式

-	意图：定义给定语言的文法表示、解释器
-	解决问题：为固定文法构建解释句子的解释器
-	使用场景：若特定类型问题发生频率足够高，可能值得将其各
	实例表述为监督语言的句子，便可构建解释器解释这些句子来
	解决问题
-	解决方法；构建语法树，定义终结符、非终结符
-	优点
	-	扩展性好，灵活
	-	增加了新的解释表达式的方式
	-	容易实现简单文法
-	缺点
	-	适用场景少
	-	对于复杂文法维护难度大
	-	解释器模式会引起类膨胀
	-	解释器模式采用递归调用方法

```java
// step1
public interface Expression{
	public boolean interpret(String context);
}

// step2
public class TerminalExpression implements Expression{
	private String data;
	public TerminalExpression(String data){
		this.data = data;
	}
	@Overide
	public boolean interpret(String context){
		if(context.contain(data)){
			return true;
		}
		return false;
	}
}
public class OrExpression implements Expression{
	private Expression expr1 = null;
	private Expression expr2 = null;
	public OrExpression(Expression expr1, Expression expr2){
		this.expr1 = expr1;
		this.expr2 = expr2;
	}
	@Override
	public boolean interpret(String context){
		return expr1.interpret((context) || expr2.interpret(context);
	}
}
public class AndExpression implements Expression{
	private Expression expr1 = null;
	private Expression expr2 = null;
	public AndExpression(Expression expr1, Expression expr2){
		this.expr1 = expr1;
		this.expr2 = expr2;
	}
	@Override
	public boolean interpret(String context){
		return expr1.interpret(context) && expr2.interpret(context);
	}
}

// step3
public class InterpreterPatternDemo{
	public static Expression getMaleExpression(){
		Expression robert = new TerminalExpression("Robert");
		Expression john = new TerminalExpression("John");
		return new OrExpression(robert, john);
	}
	public static Expression getMarriedWomanExpression(){
		Expression julie = new TerminalExpression("Julie");
		Expression married = new TerminalExpression("Married");
		return new AndExpression(julie, married);
	}
	public static void main(String[] args){
		Expression isMale = getMaleExpression();
		Expression isMarriedWoman = getMarriedWomanExpression();
		System.out.println("John is male?" + isMale.interpret("John");
		System.out.println("Julie is a married women?"
			+ is MarriedWoman.interpret("Married Julie"));
	}
}
```

###	迭代器模式 Iterator Pattern

用于访问顺序访问剂盒对象的元素，不需要知道集合对象的底层表示

-	意图：提供方法用于顺序访问聚合对象中的各个元素，又无须
	暴露该对象的内部表示
-	解决问题：不同方式遍历整个整合对象
-	使用场景：遍历聚合对象
-	解决方法：把在元素中游走的责任交给迭代器
-	优点
	-	支持以不同的方式遍历对象
	-	迭代器简化了聚合类
	-	增加新的聚合类、迭代器类方便
-	缺点：会将存储数据和遍历数据的职责分离，增加新的聚合类
	需要增加新的迭代器类，类数目成对增加，增加系统复杂性

```java
// step1
public interface Iterator{
	public boolean hasNext();
	public Object next();
}
public interface Container{
	public Iterator getIterator();
}

// step2
public class NameRepository implements Container{
	public String names[] = {"Robert", "John", "Julie", "Lora"};
	@Override
	public Iterator getIterator(){
		return new NameIterator();
	}
	private class NameIterator implements Iterator{
		int index;
		@Override
		public boolean hasNext(){
			if(index < names.length){
				return true;
			}
			return false;
		}
		@Override
		public Object Next(){
			if(this.hasNext()){
				return names[index++];
			}
			return null;
		}
	}
}

// step3
public class IteratorPatternDemo{
	public static void main(String[] args){
		NameReppository namesRepository = new NameRepository();
		for(Iterator iter = namesRepository.getIterator(); iter.hasNext;){
			String name = (String)iter.next();
			System.out.println("Name: " + name);
		}
	}
}
```

###	中介者模式 Mediator Pattern

提供一个中介类处理不同类之间的通信，降低多个对象、类之间的
通信复杂性，支持松耦合，使代码便于维护

-	意图：用一个中介对象封装一系列对象交互，中介使得个对象
	不需要显式的相互引用，从而使其耦合松散，且可以独立地改变
	它们之间地交互
-	解决问题：对象之间存在大量的关联关系，会导致系统结构很
	复杂，且若一个对象发生改变，需要跟踪与之关联的对象并作出
	相应处理
-	使用场景：多个类相互耦合形成网状结构
-	解决方法：将网状结构分离为星形结构
-	优点
	-	降低类的复杂度，多对多转为一对一
	-	各个类之间解耦
	-	符合迪米特原则
-	缺点：中介者可能会很庞大、难以维护

```java
// step1
import java.util.Date;
public class ChatRoom{
	public static void showMessage(User user, String message){
		System.out.println(new Date().toString()
			+ "[" + use.getName() + "]" + message);
	}
}

// step2
public class User{
	private String name;
	public String getName(){
		return name;
	}
	public void setName(String name){
		this.name = name;
	}
	public User(String name){
		this.name = name;
	}
	public void sendMessage(String message){
		ChatRoom.showMessage(this, message);
	}
}

// step3
public class MediatorPatternDemo{
	public static void main(String[] args){
		User robert = new User("Robert");
		User john = new User("John");
		robert.sendMessage("Hi! John");
		john.SendMessage("Hello! Robert.");
	}
}
```

###	备忘录模式 Memento Pattern

保存对象地某个状态以便在适当的时候恢复对象

-	意图：在不破坏封装性地前提下，捕获对象的内部状态并保存
	于对象外
-	解决问题：同意图
-	使用场景：需要记录对象的内部状态，允许用户取消不确定或
	错误的操作
-	解决方法：通过备忘录类专门存储对象状态
-	优点
	-	给用户提供了可以恢复状态的机制
	-	实现信息的封装，用户无需关心状态保存细节
-	缺点：消耗资源，如果类成员变量过多会占用比较大的资源

```java
// step2
public class Memento{
	private String state;
	public Memento(String state){
		this.state = state;
	}
	public String getState(){
		return state;
	}
}

// step2
public class Originator{
	private String state;
	public void setState(String state){
		this.state = state;
	}
	public String getState(){
		reutrn state;
	}
	public Memento saveStateToMemento(){
		return new Memento(state);
	}
	public vodi getStateFromMemento(Memento memento){
		state = memento.getState();
	}
}

// step3
import java.util.ArrayList;
import java.util.List;
public class CareTaker{
	private List<Memento> mementoList = new ArrayList<Memento>();
	public void add(Memento state){
		mementoList.add(state);
	}
	public Memento get(int index){
		return mementoList.get(index);
	}
}

// step4
public class MementoPatternDemo{
	public static void main(String[] args){
		Originator originator = new Originator();
		CareTaker careTaker = new CareTaker();
		originator.setState("State #1");
		originator.setState("State #2");
		careTaker.add(originator.saveStateToMemento());
		originator.setState("State #3");
		careTaker.add(Originator.saveStateToMemento());

		System.out.println("Current State: " + originator.getState());
		origiator.getStateFromMemento(careTaker.get(0));
		System.out.println("First saved State: " + originator.getState());
		originator.getStateFromMemento(CareTaker.get(1));
		System.out.println("Second saved State: " + originator.getState());
	}
}
```

###	观察者模式 Observer Pattern

-	意图：定义对象间的一种一对多的依赖关系，档一个对象状态
	发生改变时，所以依赖他的对象都得到通知并被自动更新
-	解决问题：一个对象状态改变给其他对象通知的问题，需要考虑
	易用性和低耦合，同时保证高度协作
-	使用场景：同问题
-	解决方法：使用面向对象技术将依赖关系弱化
-	优点
	-	观察者和被观察者是抽象耦合的
	-	建立一套触发机制
-	缺点
	-	如果被观察者有很多观察者，通过所有观察者耗费时间长
	-	观察者和被观察之间如果有循环依赖，观察目标可能会触发
		循环调用，导致系统崩溃
	-	没有机制让观察者知道所观察的目标是如何发生变化成，
		仅仅是知道观察目标发生了变化

```java
// step1
import java.util.ArryaList;
import java.util.List;
public class Subject{
	private List<Observer> observers
		= new ArrayList<Observer>();
	private int state;
	public int getState(){
		return state;
	}
	public void setState(){
		this.state = state;
		notifyAllObservers();
	}
	public void attach(Observer observer){
		observers.add(observer);
	}
	public void notifyAllObservers(){
		for(Observer observer: observers){
			observer.update();
		}
	}
}

// step2
public abstract class Observer{
	protected Subject subject;
	public abstract void update();
}

// step3
public class BinaryObserver extends Observer{
	public BinaryObserver(Subject subject){
		this.subject = subject;
		this.subject.attach(this);
	}
	@Override
	public void update(){
		System.out.println("Binary String: "
			+ Interger.toBinaryString(subject.getState()));
	}
}

public class OctalObserver extends Observer{
	public OctalObserver(Subject subject){
		this.subject = subject;
		this.subject.attach(this);
	}
	@Override
	public void update(){
		System.out.println("Octal String: "
			+ Integer.toOctalString(subject.getState()));
	}
}

public class HexaObserver extends Observer{
	public HexaObserver(Subject subject){
		this.subject = subject;
		this.subject.attach(this);
	}
	@Override
	public void update(){
		System.out.println("Hex String: "
			+ Integer.toHexString(subject.getState()).toUpperCase());
	}
}

// step4
public class ObserverPatternDemo{
	public static void main(String[] args){
		Subject subject = new Subject();
		new HexaObserver(subject);
		new OctalObserver(subject);
		new BinaryObserver(subject);
		System.out.println("First state change: 15");
		subject.setState(15);
		System.out.println("Second state change: 10");
		subject.setState(16);
	}
}
```

###	状态模式 State Pattern

创建表示各种状态的对象和一个行为随着状态改变而改变的context
对象

-	意图：允许在对象的内部状态改变时改变它的行为，看起来好像
	修改了其所属的类
-	解决问题：对象的行为依赖其状态（属性），并且可以根据其
	状态改变而改变其相关行为
-	使用场景：代码中包含大量与对象状态相关的条件语句
-	解决方法：将各种具体状态类抽象出来
-	优点
	-	封装了转换规则
	-	枚举了可能状态，在枚举之前需要确定状态种类
	-	将所有与某个状态有关的行为放在一个类中，只需要改变
		对象状态就可以改变对象行为，可以方便地增加新状态
	-	允许状态转换逻辑与状态对象合成一体
	-	可以让多个环境对象共享一个状态对象，减少系统中对象
		数量
-	缺点
	-	增加系统类和对象地个数
	-	结构与实现都较为复杂，使用不当将导致结构和代码的混乱
	-	对“开闭原则”支持不太好，增加新的状态类需要修改复杂
		状态转换的源代码，修改某状态类的行为也需要修改对应类
		的源代码

```java
// step1
public interface State{
	public void doAction(Context context);
}

// step2
public class StartState implements State{
	public void doAction(Context context){
		System.out.println("Player is in start state");
		context.setState();
	}
	public String toString(){
		return "Start State";
	}
}
public class StopState implements State{
	public void doAction(Context context){
		System.out.println("Player is in the stop state");
		context.setState(this);
	}
	public String toString(){
		return "Stop State");
	}
}

// step3
public class Context{
	private State state;
	public Context(){
		state = null;
	}
	public void setState(State state){
		this.state = state;
	}
	public State getState(){
		return state;
	}
}

// step4
public class StatePatternDemo{
	public static void main(String[] args){
		Context context = new Context();
		StartState startState = new StartState();
		startState.doAction(context);
		System.out.println(context.getState().toString());
		StopState stopState = new StopState();
		stopState.doAction(context);
		System.out.println(context.getState().toString());
	}
}
```
### 空对象模式 Null Object Pattern

创建一个指定各种要执行的操作的抽象类和扩展该类的实体类、一个
未做人实现的空对象类，空对象类将用于需要检查空值的地方取代
NULL对象实例的检查，也可以在数据不可用时提供默认的行为

```java
// step1
public abstract class AbstractCustomer{
	protected String name;
	public abstract boolean isNil();
	public abstract String getName();
}


// step2
public class RealCustomer extends AbstractCustomer{
	public RealCustomer(String name){
		this.name = name;
	}
	@Override
	public String getName(){
		return name;
	}
	@Override
	public boolean isNil(){
		return false;
	}
}
public class NullCustomer extends AbstractCustomer{
	@Override
	public String getName(){
		return "Not Available in Customer Database";
	}
	@Override
	public boolean isNil(){
		return true;
	}
}

// step3
public class CustomerFactory(){
	public static final String[] names = {"Rob", "Joe", "Julie"};
	public static AbstractCustomer getCustomer(String name){
		for(int i = 0; i < names.length; i++){
			if(names[i].equalsIgnoreCase(name)){
				return new RealCustomer(name);
			}
		}
		return NullCustomer();
	}
}

// step4
public class NullPatternDemo{
	public static void main(String[] args){
		AbstractCustomer customer1 = CustomerFactory.getCustomer("Rob");
		AbstractCustomer customer2 = CustomerFactory.getCustomer("Bob");
		AbstractCustomer customer3 = CustomerFactory.getCustomer("Julie");
		AbstractCustomer customer4 = CustomerFactory.getCustomer("Laura");
		System.out.println("Customers");
		System.out.println(customer1.getName());
		System.out.println(customer2.getName());
		System.out.println(customer3.getName());
		System.out.println(customer4.getName());
	}
}
```

###	策略模式 Strategy Pattern

创建表示各种策略的对象和一个随着策略对象改变的context对象，
类的行为、算法可以在运行时更改

-	意图：定义一系列算法并封装，使其可以相互替换
-	解决问题：有多种相似算法的情况下，使用`if...else`难以
	维护
-	使用场景：系统中有许多类，只能通过其直接行为区分
-	解决方法：将算法封装成多个类，任意替换
-	优点
	-	算法可以自由切换
	-	避免使用多重条件判断
	-	扩展性良好
-	缺点
	-	策略类增多
	-	所有策略类都需要对外暴露

```java
// step1
public interface Strategy{
	public int doOperation(int num1, int num2);
}

// step2
public class OperationAdd implements Strategy{
	@Override
	public int doOperation(int num1, int num2){
		return num1 + num2;
	}
}
public class OperationSubstract implements Strategy{
	@Override
	public int doOperation(int num1, int num2){
		return num1 - num2;
	}
}
public class OperationMultiply impliments Strategy{
	@Override
	public int doOperation(int num1, int num2){
		return num1 * num2;
	}
}

// step3
public class Context{
	private Strategy strategy;
	public Context(Strategy strategy){
		this.strategy = strategy;
	}
	public int executeStrategy(int num1, int num2){
		return strategy.doOperation(num1, num2);
	}
}

// step4
public class StrategyPatternDemo{
	public static void main(String[] args){
		Context context = new Context(new OperationAdd());
		System.out.println("10 + 5 = " + context.executeStrategy(10, 5));
		context = new Context(new OperationSubstract());
		System.out.println("10 - 5 = " + context.executeStrategy(10, 5));
		context = new Context(new OperationMultiply());
		System.out.println("10 * 5 = " + context.executeStrategy(10, 5));
	}
}
```

###	模板模式 Template Pattern

一个抽象类公开定义执行它的方式（模板），其子类可以按需要重写
的方法实现，但将以抽象类中定义的方式调用

-	意图：定义一个操作中算法的骨架，将一些步骤延迟到子类中，
	使得子类可以不改变算法的接口即可重定义算法的某些步骤
-	解决问题：一些方法通用，却在每个子类中重写该方法
-	使用场景：有通用的方法
-	解决方法：将通用算法抽象出来
-	优点
	-	封装不变部分，扩展可变部分
	-	提取公共代码，便于维护
	-	行为由父类控制，子类实现
-	缺点：每个不同的实现都需要子类实现，类的个数增加

```java
// step1
public abstract class Game{
	abstract void initializa();
	abstract void startPlay();
	abstract void endPlay();
	public final void play(){
		initialize();
		startPlay();
		endPlay();
	}
}

// step2
public class Cricket extends Game{
	@Override
	void endPlay(){
		Syste.out.println("Cricket Game Finished");
	}
	@Override
	void initialize(){
		System.out.println("Cricket Game Initialized! Start playing.");
	}
	@Override
	void startPlay(){
		System.out.println("Cricket Game Stared. Enjoy the game!");
	}
}
public class Football extends Game{
	@Override
	void endPlay(){
		Syste.out.println("Football Game Finished");
	}
	@Override
	void initialize(){
		System.out.println("Football Game Initialized! Start playing.");
	}
	@Override
	void startPlay(){
		System.out.println("Football Game Stared. Enjoy the game!");
	}
}

// step3
public class TemplatePatternDemo{
	public static void main(String[] args){
		Game game = new Cricket();
		game.play();
		System.out.println();
		game = new Football();
		game.play();
	}
}
```

###	访问者模式 Visitor Pattern

使用一个访问者类，其改变元素类的执行算法

-	意图：将数据结构与数据操作分离
-	解决问题：稳定的数据结构和易变的操作耦合问题
-	使用场景：需要对数据结构进行很多不同且不相关的操作，且要
	避免让这些操作“污染”数据结构类
-	解决方法：在数据结构类中增加对外提供接待访问者的接口
-	优点
	-	符合单一职责原则
	-	优秀的扩展性、灵活性
-	缺点
	-	具体元素对访问者公布细节，违反迪米特原则
	-	具体元素变更困难
	-	违反依赖倒置原则，依赖具体类而不是抽象类
	-	依赖递归，如果数据结构嵌套层次太深可能有问题

```java
// step1
public interface ComputerPart{
	public void accept(ComputerPartVisitor computerPartVsistor);
}

// step2
public class Keyboard implements ComputerPart{
	@Override
	public void accept(ComputerPartVisitor computerPartVisiter){
		computerPartVisitor.visit(this);
	}
}
public class Monitor implements ComputerPart{
	@Override
	public void accept(ComputerPartVisitor computerPartVisitor){
		computerPartVisitor.visit(this);
	}
}
public class Mouse implements ComputerPart{
	@Override
	public void accept(ComputerPartVisitor computerPartVisitor){
		computerPartVisitor.visit(this);
	}
}
public class Computer implements ComputerPart{
	ComputerPart[] parts;
	public Computer(){
		parts = new ComputerPart[]{new Mouse(), new Keyboard(), new Monitor()};
	}
	@Override
	public void accept(ComputerPartVisitor computerPartVisitor){
		for(ComputerPart part: parts){
			part.accept(computerPartVisitor);
		}
		computerPartVisitor.visit(this);
	}
}

// step3
public interface ComputerPartVisitor(){
	public void visit(Computer computer);
	public void visit(Mouse mouse);
	public void visit(Keyboard keyboard);
	public void visit(Monitor monitor);
}

// step4
public class ComputerDisplayVisitor implements ComputerPartVisitor{
	@Override
	public void visit(Computer computer){
		System.out.println("Display Computer");
	}
	@Override
	public void visit(Mouse mouse) {
		System.out.println("Displaying Mouse.");
	}

	@Override
	public void visit(Keyboard keyboard) {
		System.out.println("Displaying Keyboard.");
	}

	@Override
	public void visit(Monitor monitor) {
		System.out.println("Displaying Monitor.");
	}
}

// step5
public class VisitorPatternDemo{
	public static void main(String[] args){
		Computer computer = new Computer();
		computer.accept(new ComputerPartDisplayVisitor());
	}
}
```

##	J2EE模式

特别关注表示层，由Sun Java Center鉴定

###	MVC模式 MVC Pattern

Model-View-Controller模式，用于应用程序的分层开发
-	Model（模型）：存取数据的对象，可以带有逻辑，在数据变化
	时更新控制器
-	View（视图）：模型包含的数据可视化
-	Controller（控制器）：作用与模型、视图上，控制数据流向
	模型对象，并在数据变化时更新视图，使视图与模型分离

```java
// step1
public class Student{
	private String rollNo;
	private String name;
	public String getRollNo(){
		return rollNo;
	}
	public void setRollNo(String rollNo){
		this.rollNo = rollNo;
	}
	public String getName(){
		return name;
	}
	public void setName(String name){
		this.name = name;
	}
}

// step2
public class StudentView{
	public void printStudentDetails(String studentName, String studentRollNo){
		System.out.println("Student: ");
		System.out.println("Name: " + studentName);
		System.out.println("Roll No: " + studentRollNo);
	}
}

// step3
public class StudentController{
	private Student model;
	private StudentView view;
	public StudentController(Student model, StudentView view){
		this.model = model;
		this.view = view;
	}
	public void setStudentName(String name){
		model.setName(name);
	}
	public String getStudentName(){
		return model.getName();
	}
	public void setStudentRollNo(String rollNo){
		model.setRollNo(rollNo);
	}
	public String getStudentRollNo(){
		return model.getRollNo();
	}
	public void updateView(){
		view.printStudentDetails(model.getName(), model.getRollNo());
	}
}

// step4
public class MVCPatternDemo{
	public static void main(String[] args){
		Student model = retriveStudentFromDatabase();
		StudentView view = new StudentView();
		StudentController controller = new StudentController(model, view);
		controller.updateView();
		controller.setStudentName("John");
		controller.updateView();
	}
	private static Student retriveStudentFromDataBase(){
		Student student = new Student();
		student.setName("Robert");
		student.setRollNo("10");
		return student;
	}
}
```

###	业务代表模式 Business Delegate Pattern

用于对表示层和业务层解耦，基本上是用来减少通信或对表示层代码
中的业务层代码的远程查询功能，业务层包括以下实体

-	Client（客户端）
-	Business Delegate（业务代表）：为客户端提实体提供的入口
	类，提供了对业务服务方法的访问
-	LookUp Service（查询服务）：获取相关的业务实现，提供业务
	对象对业务代表对象的访问
-	Business Service（业务服务）：业务服务接口，实现其的具体
	类提供了实际的业务实现逻辑

```java
// step1
public interface BusinessService{
	public void doProcessing();
}

// step2
public class EJBService implements BusinessService{
	@Override
	public void doProcessing(){
		System.out.println("Processing task by invoking EJB Service");
	}
}
public class JMSService implements BusinessService{
	@Override
	public void doProcessing(){
		System.out.println("Processing task by invoking JMS Service");
	}
}

// step3
public class BusinessLookUp{
	public BusinessService getBusinessService(String serviceType){
		if(serviceType.equalsIgnoreCase("EJB"){
			return new EJBService();
		}else{
			returen new JMSService();
		}
	}
}

// step4
public class BusinessDelegate{
	private BusinessLookUp lookupService = new BusinessLookUp();
	private BusinessService businessService;
	private String serviceType;
	public void setServiceType(String serviceType){
		this.serviceType = serviceType;
	}
	public void doTask(){
		businessService = lookupService.getBusinessService(serviceTpye);
		businessService.doProcessing();
	}
}

// step5
public class Client{
	BusinessDelegate businessService;
	public Client(BusinessDelegate businessService){
		this.businessServie = businessService;
	}
	public void doTask(){
		businessService.doTask();
	}
}

// step6
public class BusinessDelegatePatternDemo{
	public static void main(String[] args){
		BusinessDelegate businessDelegate = new BusinessDelegate();
		businessDelegate.setServiceType("EJB");
		Client client = new Client(businessDelegate);
		cliend.doTask();
		businessDelegate.setServiceType("JMS");
		client.doTask();
	}
}

```

###	组合实体模式 Composite Entity Pattern

一个组合实体是一个EJB实体bean，代表对象的图解，更新一个组合
实体时，内部依赖对象beans会自动更新，因为其是由EJB实体bean
管理的，组合实体bean参与者包括

-	Composite Entity（组合实体）：主要的实体bean，可以是
	粗粒的，或者包含一个粗粒度对象，用于持续生命周期
-	Coarse-Grained Object（粗粒度对象）：包含依赖对象，有
	自己的生命周期，也能管理依赖对象的生命周期
-	Dependent Object（依赖对象）：持续生命周期依赖于粗粒度
	对象的对象
-	Strategies（策略）：如何实现组合实体

```java
// step1
public class DependentObject1{
	private String data;
	public void setData(String data){
		this.data = data;
	}
	public String getData(){
		return data;
	}
}
public class DependentObject2{
	private String data;
	public void setData(String data){
		this.data = data;
	}
	public String getData(){
		return data;
	}
}

// step2
public class CoarseGrainedObject{
	DependentObject1 do1 = new DependentObject1();
	DependentObject2 do2 = new DependentObject2();
	public void setData(String data1, String data2){
		do1.setData(data1);
		do2.setData(data2);
	}
	public String[] getData(){
		return new String[] {do1.getData(), do2.getData()};
	}
}

// step3
public class CompositeEntity{
	private CoarseGrainedObject cgo = new CaorseGraiendObject();
	public void setData(String data1, String data2){
		cgo.setData(data1, data2);
	}
	public String[] getData(){
		return cgo.getData();
	}
}

// step4
public class Client{
	private CompositeEntity compositeEntity = new CompositeEntity();
	public void printData(){
		for(String str: compositeEntity.getData()){
			System.out.println("Data: " + str);
		}
	}
	public void setData(String data1, data2){
		compositeEntity.setData(data1, data2);
	}
}

// step5
public class CompositeEntityPatternDemo{
	public static void main(String[] args){
		Client client = new Client();
		client.setData("test", "data");
		client.printData();
		client.setData(second test", "data2");
		client.printData();
	}
}
```

###	数据访问对象模式 Data Access Object Pattern

用于把低级的数据访问API、操作从高级的业务服务中分离出来

-	Data Access Object Interface（数据访问对象接口）：定义
	在模型对象上要执行的标准操作
-	Data Access Object concrete class（数据访问对象实体类）
	：实现上述接口，负责从数据源（数据库、xml等）获取数据
-	Model/Value Object（模型/数值对象）：简单的POJO，包含
	`get/set`方法存储使用DAO类检索到的数据

```java
// step1
public class Student{
	private String name;
	private int rollNo;
	Student(String name, int rollNo){
		this.name = name;
		this.rollNo = rollNo;
	}
	public String getName(){
		return name;
	}
	public void setName(String name){
		this.name = name;
	}
	public int getRollNo(){
		return rollNo;
	}
	public void setRollNo(int rollNo){
		this.rollNo = rollNo;
	}
}

// step2
import java.util.List;
public interface StudentDao{
	public List<Student> getAllStudents();
	public Student getStudent(int rollNo);
	public void updateStudent(Student student);
	public void deleteStudent(Student student);
}

// step3
import java.util.ArrayList;
import java.util.List;
public class StudentDaoImpl implements StudentDao{
	List<Student> students;
	public StudentDaoImpl(){
		students = new ArrayList<Student>();
		Student student1 = new Student("Roberts", 0);
		Student student2 = new Student("John", 1);
		students.add(student1);
		students.add(student2);
	}
	@Override
	public void deleteStudent(Student student){
		students.remove(student.getRollNo());
		System.out.println("Student: Roll No "
			+ student.getRollNo()
			+ ", deleted from database"
		);
	}
	@Override
	public List<Student> getAllStudents(){
		return students;
	}
	@Override
	public Student getStudent(int rollNo){
		return students.get(rollNo);
	}
	@Override
	public void updateStudent(Student student){
		students.get(student.getRollNo()).setName(student.getName());
		System.out.println("Student: Roll No "
			+ student.getRollNo()
			+ ", updated in the database"
		);
	}
}

// step4
public class DaoPatternDemo{
	public static void main(String[] args){
		StudentDao studentDao = new StudentDaoImpl();

		for(Student student: studentDao:getAllStudents()){
			System.out.println("Student: [RollNo: "
				+ student.getRollNo()
				+ ", Name: "
				+ student.getName()
				+ " ]"
			);
		}
		Student student = studentDao.getAllStudents().get(0);
		student.setName("Micheal");
		studentDao.updateStudent(student);
		studentDao.getStudent(0);
		System.out.println("Student: [RollNo: "
			+ student.getRollNo()
			+ ", Name: "
			+ student.getName()
			+ "]"
		);
	}
}
```

###	前端控制器模式 Front Controller Pattern

用于提供一个集中请求处理机制，所有的请求都将由单一的处理程序
处理，该处理程序可以做认证、授权、记录日志、跟踪请求，然后把
请求传给相应的处理程序，包含以下部分

-	Front Controller（前端控制器）：处理应用程序所有类型请求
	的单个处理程序
-	Dispatcher（调度器）：前端控制器调用，用于调度请求到相应
	的具体处理程序
-	View（视图）：为请求而创建的对象

```java
// step1
public class Homeview(){
	public void show(){
		System.out.println("Displaying Home Page");
	}
}
public class StudentView{
	public void show(){
		System.out.println("Displaying Student Page");
	}
}

// step2
public class Dispatcher{
	private StudentView studentView;
	private HomeView homeView;
	public Dispatcher(){
		studentView = new StudentView();
		homeView = new HomeView();
	}
	public void dispatch(String request){
		if(request.equalsIgnoreCase("StudENT")){
			studentView.show();
		}else{
			homeView.show();
		}
	}
}

// step3
public class FrontController{
	private Dispatcher dispatcher;
	public FrontController(){
		dispatcher = new Dispatcher();
	}
	private boolean isAuthenticUser(){
		System.out.println("User is authenticated successfully.");
		return true;
	}
	private void trackRequest(String request){
		System.out.println("Page requested: " + request);
	}
	public void dispatchRequest(String request){
		trackReqeust(reqeust);
		if(isAuthenticUser()){
			dispatcher.dispatch(request);
		}
	}
}

// step4
public class FrontControllerPatternDemo{
	public static void main(String[] args){
		FrontController frontController = new FrontController();
		frontController.dispatchRequest("HOMe");
		frontController.dispatchRequest("STUDENT");
	}
}

```

###	拦截过滤器模式 Intercepting Filter Pattern

用于应用程序的请求或相应做一些预处理、后处理，定义过滤器，
并将其应用在请求上后再传递给实际目标应用程序，过滤器可以做
认证、授权、记录日志、跟踪请求

-	Filter（过滤器）：在处理程序执行请求之前或之后执行某些
	任务
-	Filter Chain（过滤器链）：带有多个过滤器，并按定义的顺序
	执行这些过滤器
-	Target：请求处理程序
-	Filter Manager（过滤管理器）：管理过滤器和过滤器链
-	Client（客户端）：向Target对象发送请求的对象

```java
// step1
public interface Filter{
	public void execute(String request);
}

// step2
public class AuthenticationFilter implements Filter{
	public void execute(String request){
		System.out.println("Authenticating request: " + request);
	}
}
public class DebugFilter implements Filter{
	public void execute(String request){
		System.out.println("request log: " + request);
	}
}

// step3
public class Target{
	public void execute(String request）{
		System.out.println("Executing request: " + request);
	}
}

// step4
import java.util.ArrayList;
import java.util.List;
public class FilterChain{
	private List<Filter> filters = new ArrayList<Filter>();
	private Target target;
	public void addFilter(Filter filter){
		filters.add(filter);
	}
	public void execute(String request){
		for(Filter filter: filters){
			filter.execute(reqeust);
		}
		target.execute(request);
	}
	public vodi setTarget(Target target){
		this.target = target;
	}
}

// step5
public class FilterManager{
	FilterChain filterChain;
	public FilterManager(Target target){
		filterChain = new FilterChain();
		filterChain.setTarget(target);
	}
	public void setFilter(Filter filter){
		filterChain.addFilter(filter);
	}
	public void filterRequest(String request){
		filterChain.execute(request);
	}
}

// step6
public class Client{
	FilterManager filterManager;
	public void setFilterManager(FilterManager filterManager){
		this.filterManager = filterManager;
	}
	public void sendRequests(String request){
		filterManager.filterRequest(request);
	}
}

// step7
public class InterceptingFilterDemo{
	public static void main(String[] args){
		FilterManager filterManager = new FilterManager(new Target());
		filterManager.setFilter(new AuthenticationFilter());
		filterManager.setFilter(new DebugFilter());
		Client client = new Client();
		client.setFilterManager(filterManager);
		client.sendRequest("HOME");
	}
}
```

### 服务定位器模式 Service Locator Pattern

用于使用JNDI查询定位各种服务时，充分利用缓存技术减小为服务
查询JNDI的代价，首次请求服务时，服务定位器在JNDI中查找服务，
并缓存供之后查询相同服务的请求使用

-	Service（服务）：实际处理请求的服务，其引用可以在JNDI
	服务器中查到
-	Context：JNDI带有要查找的服务的引用
-	Service Locator（服务定位器）：通过JNDI查找和缓存服务来
	获取服务的单点接触
-	Cache（缓存）：缓存服务引用以便复用
-	Client（客户端）：通过ServiceLocator调用服务对象

```java
// step1
public interface Serivce{
	public String getName();
	public void execute();
}

// step2
public class Service1 implements Service{
	public void execute(){
		System.out.println("Executing Service1");
	}
	@Override
	public String getName(){
		return "Service1";
	}
}
public class Service2 implements Service{
	public void execute(){
		System.out.println("Executing Service2"):
	}
	@Override
	public String getName(){
		return "Service2";
	}
}

// step3
public class InitialContext{
	public Object lookup(String jndiName){
		if(jndiName.equalsIgnoreCase("SERVICE1"){
			System.out.println("Looking up and creating a new Service1 object");
			return new Service1();
		}else if(jndiName.equalsIgnoreCase("service2"){
			System.out.println("Looking up and creating a new Service2 object.");
			return new Service2();
		}
		return null;
	}
}

// step4
import java.util.ArrayList;
import java.uitl.List;
public class Cache{
	private List<Service> services;
	public Cache(){
		services = new ArrayList<Service>();
	}
	public Service getService(String serviceName){
		for(Service service: services){
			if(service.getName().equalsIgnoreCase(serviceName)){
				System.out.println("Returning cached "
					+ serviceName
					+ " object"
				);
			}
		}
		return null;
	}
	public void addService(Service newService){
		boolean exists = false;
		for(Service service: services){
			if(service.getName().equalsIgnoreCase(newService.getName())){
				exists = true;
			}
		}
		if(!exist){
			services.add(newService);
		}
	}
}

// step5
public class ServiceLocator{
	private static Cache cache;
	static{
		cache = new Cache();
	}
	public static Service getService(String jndiName){
		Service service = cache.getService(jndiName);
		if(service != null){
			return service;
		}
		InitialContext context = new InitialContext();
		Service service1 = (Service)context.lookup(jndiName);
		cache.addService(service1);
		return service1;
	}
}

// step6
public class ServiceLocatorPatternDemo{
	public static void main(String[] args){
		Service service = ServiceLocator.getService("Service1");
		service.execute();
		service = ServiceLocator.getService("Service2");
		service.execute();
		service = ServiceLocator.getService("Service1");
		service.execute();
		service = ServiceLocator.getService("Service1");
		service.execute();
	}
}
```

### 传输对象模式 Tranfer Object Pattern

用于从客户端向服务器一次性传递带有多个属性的数据。传输对象
（数值对象）是具有`getter/setter`方法的简单POJO类，可
序列化，因此可以通过网络传输，没有任何行为。服务器端业务类
通常从数据库读取数据填充POJO，并发送到客户端或按值传递；
客户端可以自行创建传输对象并传送给服务器，以便一次性更新
数据库中的数值

-	Business Object（业务对象）：为传输对象填充数据的业务
	服务
-	Transfer Object（传输对象）：简单的POJO，只有设置/获取
	属性的方法
-	Client（客户端）：可以发送请求或发送传输对象到业务对象

```java
// step1
public class StudentVO{
	private String name;
	private int rollNo;
	StudentVo(String name, int rollNo){
		this.name = name;
		this.rollNo = rollNo;
	}
	public String getName(){
		return name;
	}
	public void setName(String name){
		thi.name = name;
	}
	public int getRollNo(){
		return rollNo;
	}
	public void setRollNo(int rollNo){
		this.rollNo = rollNo;
	}
}

// step2
import java.util.ArrayList;
import java.util.List;
public class StudentBO{
	List<StudentVO> students;
	public StudentBO(){
		students = new ArrayList<StudentVO>();
		studentVO student1 = new StudentVO("Robert", 0);
		studentVO student2 = new StudentVO("John", 1);
		student1.add(student1);
		student2.add(student2);
	}
	public void deleteStudent(StudentVO student){
		students.remove(student.getRollNo());
		System.out.println("Student: Roll No "
			+ student.getRollNo()
			+ ", deleted from database."
		);
	}
	public List<StudentVO> getAllStudents(){
		return students;
	}
	public StudentVO getStudent(int rollNo){
		return students.get(rollNo);
	}
	public void updateStudent(StudentVO student){
		students.get(studentNo()).setName(student.getName());
		System.out.println("Student: Roll No "
			+ student.getRollNo()
			+ ", updated in the database."
		);
	}
}

// public class TransferObjectPatternDemo{
	public static void main(String[] args){
		StudentBO studentBusinessObject = new StudentBO();
		for(StudentVO student: studentBusinessObject.getAllStudent()){
			System.out.println("Student: [Roll No: "
				+ student.getRollNo()
				+ ", Name: "
				+ student.getName()
				+ "]"
			);
		}
		studentVO student = studentBusinessObject.getAllStudents().get(0);
		student.setName("Micheal");
		studentBusinessObject.updateStudent(student);
		student = studentBusinessObject.getStudent(0);
		System.out.println("Student: [Roll No: "
			+ student.getRollNo()
			+ ", Name: "
			+ student.getName()
			+ "]"
		);
	}
}
```

