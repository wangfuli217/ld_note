
1.查考文档
    http://docs.jquery.com/UI/
    http://jqueryui.net/tutorial/

2.概述
  属性
    创建实例时设置属性值
    创建组件实例时，以 Object 型参数设置实例的属性。
    $(".class").组件名({属性名1:值1,属性名2:值2});
    如： $(".class").draggable({axis:"x",cursor:"crosshair"});

    获得属性值
    组件实例化后，可以通过 option 方法获得属性值。
    var a = $(".class").组件名("option",属性名);
    如： var axis = $(".class").draggable("option","axis");

    重设属性值
    组件实例化后，可以通过 option 方法重设属性值。
    $(".class").组件名("option",属性名,属性值);
    如： $(".class").draggable("option","axis","y");

  事件
    创建实例时设置事件
    创建组件实例时，以 Object 型参数设置实例的事件。
    $(".class").组件名({事件1:函数1,事件2:函数2});
    如： $(".class").draggable({ start:function(event,ui){...}, drag:function(event,ui){...} });

    实例化后时绑定事件
    组件实例化后，通过 bind 方法绑定事件。
    $(".class").bind("事件类型",函数);
    如： $(".class").bind("dragstart",function(event,ui){...});

    事件类型通常为“组件名+事件”或“动作名+事件”，当“动作名”与“事件”相同时，仅使用“动作名”。

  方法
    组件实例化后，可调用组件方法执行特定功能。每个组件均有四个通用方法：disable、enable、destroy、option，也有组件自己的特定方法。

    disable 禁止操作组件
    组件依然可见，但暂停响应用户操作。
    如使日期选择控件暂停响应用户操作： $("#id").datepicker("disable");

    enable 允许操作组件
    重新允许操作暂停响应用户操作的组件。
    如使日期选择控件暂停响应用户操作： $("#id").datepicker("enable");

    destroy 销毁组件实例
    销毁组件实例后，由 jQuery UI 添加的 HTML 标签、DOM 事件均被删除，恢复原始 HTML 代码。

    option 修改或获取属性值。详见上方“属性”说明。

  样式
    通过 ThemeRoller, 可为 jQuery UI 制定各种主题，可配置字体、字号、文字颜色、底纹样式、底纹颜色、圆角大小等。
    ThemeRoller 的网址:  http://jqueryui.com/themeroller/



================================================================

Jquery UI dialog 详解 (中文)

1 属性
    1.1 autoOpen 默认为:true; 这个属性为 true 的时候dialog被调用的时候自动打开dialog窗口。
        当属性为 false 的时候, 一开始隐藏窗口, 直到.dialog("open")的时候才弹出dialog窗口。
    1.2 bgiframe 默认为 false
        When true, the bgiframe plugin will be used, to fix the issue in IE6 where select boxes show on top of other elements, regardless of zIndex. Requires including the bgiframe plugin. Future versions may not require a separate plugin.
        在IE6下, 让后面那个灰屏盖住select。
    1.3 buttons 显示按钮, 并写上按钮的文本, 设置按钮点击函数。默认为{}, 没有按钮。例：
        $('.selector').dialog({
         buttons: {
            "确定":function(){
                alert('执行确定代码...');
                $(this).dialog('close');
             },
            "取消":function(){
                $(this).dialog('close');
             }
         });
    1.4 closeOnEscape 为 true 的时候, 点击键盘ESC键关闭dialog, 默认为 true
    1.5 dialogClass 类型将被添加到dialog, 默认为空
    1.6 draggable、resizable : draggable是否可以使用标题头进行拖动, 默认为 true,可以拖动; resizable是否可以改变dialog的大小, 默认为 true, 可以改变大小。
    1.7 width、height, dialog的宽和高, 默认为auto, 自动。
    1.8 maxWidth、maxHeight、minWidth、minHeight , dialog可改变的最大宽度、最大高度、最小宽度、最小高度。maxWidth、maxHeight的默认为 false, 为不限。
         minWidth、minHeight的默认为150。要使用这些属性需要ui.resizable.js 的支持。
    1.9 hide、show , 当dialog关闭和打开时候的效果。默认为 null, 无效果
    1.10 modal,是否使用模式窗口, 模式窗口打开后, 页面其他元素将不能点击, 直到关闭模式窗口。默认为 false 不是模式窗口。
    1.11 title, dialog的标题文字, 默认为空。
    1.12 position , dialog的显示位置：可以是'center', 'left', 'right', 'top', 'bottom',也可以是top和left的偏移量也可以是一个字符串数组例如['right','top']。
    1.13 zIndex, dialog的zindex值, 默认值为1000.
    1.14 stack 默认值为true, 当dialog获得焦点是, dialog将在最上面。


  属性的初始化：
    请注意, $('.selector')是dialog 的类名, 在本例中.selector=#dialoag,以后不再说明。
    把各属性的值预设出来,没写上的用默认值
        $('.selector').dialog({
            autoOpen: false,
            bgiframe: false,
            modal:true,
            width:"600px",
            height:"550",
            title:'title'
        });


  得到和设置某属性：
        var autoOpen = $('.selector').dialog('option', 'autoOpen'); // 获取 autoOpen 的值
        $('.selector').dialog('option', 'autoOpen', false); // 设置 autoOpen 的值



2 事件
    2.1  beforeclose 类型dialogbeforeclose ,  当dialog尝试关闭的时候此事件将被触发, 如果返回false, 那么关闭将被阻止。
         初始化例：$('.selector').dialog({
            beforeclose: function(event, ui) { ... }
         });
         使用类型绑定此事件例：$('.selector').bind('dialogbeforeclose', function(event, ui) {
            ...
         });

    2.2  close 类型：dialogclose , 当dialog被关闭后触发此事件。
         初始化例：$('.selector').dialog({
            close: function(event, ui) { ... }
         });
         使用类型绑定此事件例：$('.selector').bind('dialogclose', function(event, ui) {
            ...
         });

    2.3 open 类型：dialogopen , 当dialog打开时触发。（篇幅有限, 该省略的就省略了啊, 初始化例和使用类型绑定事件可以向上参考。）
    2.4 focus 类型：dialogfocus , 当dialog获得焦点时触发。
    2.5 dragStart 类型：dragStart, 当dialog拖动开始时触发。
    2.6 drag 类型：drag , 当dialog被拖动时触发。
    2.7 dragStop 类型：dragStop , 当dialog拖动完成时触发。
    2.8 resizeStart 类型：resizeStart , 当dialog开始改变窗体大小时触发。
    2.9 resize 类型：resize, 当dialog被改变大小时触发。
    2.10 resizeStop 类型：resizeStop, 当改变完大小时触发。


3 方法
    3.1 destroy , 我喜欢这个哦, 摧毁地球。。。 例：.dialog( 'destroy' )
    3.2 disable, dialog不可用, 例：.dialog('disable');
    3.3 enable,dialog可用, 例, 如3.2
    3.4 close, open, 关闭、打开dialog
    3.5 option , 设置和获取dialog属性, 例如：.dialog( 'option' , optionName , [value] ) , 如果没有value, 将是获取。
    3.6 isOpen , 如果dialog打开则返回 true, 例如：.dialog('isOpen')
    3.7 moveToTop ,将dialog移到最上层, 例如：.dialog( 'moveToTop' )

================================================================
jquery ui中文说明(使用方法)
中文文档网站：  http://jqueryui.net/
    jquery ui是jquery官方推出的配合jquery使用的用户界面组件集合！包含了许多的界面操作功能，如我们常用的表格排序，拖拽，TAB选项卡，滚动条，相册浏览，日历控件，对话框等JS插件~~可以很方便的开发用户界面上的功能，使得您的开发工作事半功倍~~不用写繁琐的JS代码~
下载地址：http://ui.jquery.com/download
下载后会发现里面有很多的JS文件，也有DOME，您可以一一演示，现在，我介绍一些常用的UI库的使用
基本的鼠标互动：
    拖拽(drag and dropping)、排序(sorting)、选择(selecting)、缩放(resizing)
    各种互动效果：
    手风琴式的折叠菜单(accordions)、日历(date pickers)、对话框(dialogs)、滑动条
    (sliders)、表格排序(table sorters)、页签(tabs)
    放大镜效果(magnifier)、阴影效果(shadow)

第一部分：鼠标交互


1.1 Draggables:拖拽
    所需文件：
    ui.mouse.js
    ui.draggable.js
    ui.draggable.ext.js
    用法：文件载入后，可以拖拽class = “block”的层
    $(document).ready(function(){
            $(".block").draggable();
    });
    draggable(options)可以跟很多选项
    选项说明：http://docs.jquery.com/UI/Draggables/draggable#options
    选项实例：http://dev.jquery.com/view/trunk/plugins/ui/tests/draggable.html


1.2 Droppables
    所需要文件，drag drop
    ui.mouse.js
    ui.draggable.js
    ui.draggable.ext.js
    ui.droppable.js
    ui.droppable.ext.js
    用法：
    $(document).ready(function() {
         $(".block").draggable({ helper: 'clone' });
         $(".drop").droppable({
            accept: ".block",
             activeClass: 'droppable-active',
             hoverClass: 'droppable-hover',
             drop: function(ev, ui) {
                 $(this).append("Dropped!");
             }
         });
    });
    选项说明：http://docs.jquery.com/UI/Droppables/droppable#options
    选项实例：http://dev.jquery.com/view/trunk/plugins/ui/tests/droppable.html


1.3　Sortables　排序
    所需要的文件
    jquery.dimensions.js
    ui.mouse.js
    ui.draggable.js
    ui.droppable.js
    ui.sortable.js
    用法：
    $(document).ready(function(){
         $("#myList").sortable({});
    });
    dimensions文档http://jquery.com/plugins/project/dimensions
    选项说明：http://docs.jquery.com/UI/Sortables/sortable#options
    选项实例：http://dev.jquery.com/view/trunk/plugins/ui/demos/ui.sortable.html


1.4 Selectables 选择
    所需要的文件
    jquery.dimensions.js
    ui.mouse.js
    ui.draggable.js
    ui.droppable.js
    ui.selectable.js
    用法：
    $(document).ready(function(){
         $(”#myList”).selectable();
    });
    选项说明：http://docs.jquery.com/UI/Selectables/selectable#options
    选项实例：http://dev.jquery.com/view/trunk/plugins/ui/tests/selectable.html


1.5　Resizables改变大小
    所需要的文件　，此例子需要几个css文件
    jquery.dimensions.js
    ui.mouse.js
    ui.resizable.js
    用法：
    $(document).ready(function(){
              $(”#example”).resizable();
    });
    CSS文件：http://dev.jquery.com/view/trunk/themes/flora/flora.all.css
    选项说明：http://docs.jquery.com/UI/Resizables/resizable#options
    选项实例：http://dev.jquery.com/view/trunk/plugins/ui/demos/ui.resizable.html


第二部分：互动效果
2.1 Accordion 折叠菜单
    所需要的文件:
    ui.accordion.js
    jquery.dimensions.js
    用法：
    $(document).ready(function(){
           $(”#example”).accordion();
    });
    CSS文件：http://dev.jquery.com/view/trunk/themes/flora/flora.all.css
    选项说明：http://docs.jquery.com/UI/Accordion/accordion#options
    选项实例：http://dev.jquery.com/view/trunk/plugins/accordion/?p=1.1.1


2.2 dialogs 对话框
    所需要的文件：
    jquery.dimensions.js
    ui.dialog.js
    ui.resizable.js
    ui.mouse.js
    ui.draggable.js
    用法：
    JavaScript代码
    $(document).ready(function(){
             $("#example").dialog();
    });
    CSS文件：http://dev.jquery.com/view/trunk/themes/flora/flora.all.css
    选项说明：http://docs.jquery.com/UI/Dialog/dialog#options
    选项实例：http://dev.jquery.com/view/trunk/plugins/ui/tests/dialog.html


2.3 sliders 滑动条
    所需要的文件
    jquery.dimensions.js
    ui.mouse.js
    ui.slider.js
    用法：
    $(document).ready(function(){
          $("#example").slider();
    });
    CSS文件：http://dev.jquery.com/view/trunk/themes/flora/flora.all.css
    选项说明：http://docs.jquery.com/UI/Slider/slider#options
    选项实例：http://dev.jquery.com/view/trunk/plugins/ui/demos/ui.slider.html


2.4 Tablesorter表格排序
    所需要的文件
    ui.tablesorter.js
    用法：
    JavaScript代码
    $(document).ready(function(){
           $("#example").tablesorter({sortList:[[0,0],[2,1]], widgets: ['zebra']});
    });
    CSS文件：http://dev.jquery.com/view/trunk/themes/flora/flora.all.css
    选项说明：http://docs.jquery.com/Plugins/Tablesorter/tablesorter#options
    选项实例：http://tablesorter.com/docs/#Demo


2.5 tabs页签(对IE支持不是很好)
    所需要的文件
    ui.tabs.js
    用法：
    $(document).ready(function(){
         $("#example > ul").tabs();
    });
    CSS文件：http://dev.jquery.com/view/trunk/themes/flora/flora.all.css
    选项说明：http://docs.jquery.com/UI/Tabs/tabs#initialoptions
    选项实例：http://dev.jquery.com/view/trunk/plugins/ui/tests/tabs.html
    tabs ext http://stilbuero.de/jquery/tabs_3/rotate.html


第三部分：效果
3.1 Shadow 阴影
    实例http://dev.jquery.com/view/trunk/plugins/ui/demos/ui.shadow.html

3.2 Magnifier 放大
    实例http://dev.jquery.com/view/trunk/plugins/ui/demos/ui.magnifier.html





