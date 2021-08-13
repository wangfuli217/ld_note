收集的35个 jQuery 小技巧/代码片段，可以帮你快速开发.


--------------------------------
1. 禁止右键点击

$(document).ready(function(){
    $(document).bind("contextmenu",function(e){
        return false;
    });
});

--------------------------------
2. 隐藏搜索文本框文字
	Hide when clicked in the search field, the value.(example can be found below in the comment fields)

$(document).ready(function() {
$("input.text1").val("Enter your search text here");
   textFill($('input.text1'));
});

    function textFill(input){ //input focus text function
     var originalvalue = input.val();
     input.focus( function(){
          if( $.trim(input.val()) == originalvalue ){ input.val(''); }
     });
     input.blur( function(){
          if( $.trim(input.val()) == '' ){ input.val(originalvalue); }
     });
}

--------------------------------
3. 在新窗口中打开链接
	XHTML 1.0 Strict doesn’t allow this attribute in the code, so use this to keep the code valid.

$(document).ready(function() {
   //Example 1: Every link will open in a new window
   $('a[href^="http://"]').attr("target", "_blank");

   //Example 2: Links with the rel="external" attribute will only open in a new window
   $('a[@rel$='external']').click(function(){
      this.target = "_blank";
   });
});
// how to use
<a href="http://www.opensourcehunter.com" rel=external>open link</a>

--------------------------------
4. 检测浏览器
	注: 在版本jQuery 1.4中，$.support 替换掉了$.browser 变量

$(document).ready(function() {
// Target Firefox 2 and above
if ($.browser.mozilla && $.browser.version >= "1.8" ){
    // do something
}

// Target Safari
if( $.browser.safari ){
    // do something
}

// Target Chrome
if( $.browser.chrome){
    // do something
}

// Target Camino
if( $.browser.camino){
    // do something
}

// Target Opera
if( $.browser.opera){
    // do something
}

// Target IE6 and below
if ($.browser.msie && $.browser.version <= 6 ){
    // do something
}

// Target anything above IE6
if ($.browser.msie && $.browser.version > 6){
    // do something
}
});

--------------------------------
5. 预加载图片
	This piece of code will prevent the loading of all images, which can be useful if you have a site with lots of images.

$(document).ready(function() {
jQuery.preloadImages = function()
{
  for(var i = 0; i<ARGUMENTS.LENGTH; jQuery(?<img { i++)>").attr("src", arguments[i]);
  }
}
// how to use
$.preloadImages("image1.jpg");
});

--------------------------------
6. 页面样式切换

$(document).ready(function() {
    $("a.Styleswitcher").click(function() {
        //swicth the LINK REL attribute with the value in A REL attribute
        $('link[rel=stylesheet]').attr('href' , $(this).attr('rel'));
    });
// how to use
// place this in your header
<LINK rel=stylesheet type=text/css href="default.css">
// the links
<A class=Styleswitcher href="#" rel=default.css>Default Theme</A>
<A class=Styleswitcher href="#" rel=red.css>Red Theme</A>
<A class=Styleswitcher href="#" rel=blue.css>Blue Theme</A>
});

--------------------------------
7. 列高度相同
	如果使用了两个CSS列，使用此种方式可以是两列的高度相同。

$(document).ready(function() {
function equalHeight(group) {
    tallest = 0;
    group.each(function() {
        thisHeight = $(this).height();
        if(thisHeight > tallest) {
            tallest = thisHeight;
        }
    });
    group.height(tallest);
}
// how to use
$(document).ready(function() {
    equalHeight($(".left"));
    equalHeight($(".right"));
});
});

--------------------------------
8. 动态控制页面字体大小
	用户可以改变页面字体大小

$(document).ready(function() {
  // Reset the font size(back to default)
  var originalFontSize = $('html').css('font-size');
    $(".resetFont").click(function(){
    $('html').css('font-size', originalFontSize);
  });
  // Increase the font size(bigger font0
  $(".increaseFont").click(function(){
    var currentFontSize = $('html').css('font-size');
    var currentFontSizeNum = parseFloat(currentFontSize, 10);
    var newFontSize = currentFontSizeNum*1.2;
    $('html').css('font-size', newFontSize);
    return false;
  });
  // Decrease the font size(smaller font)
  $(".decreaseFont").click(function(){
    var currentFontSize = $('html').css('font-size');
    var currentFontSizeNum = parseFloat(currentFontSize, 10);
    var newFontSize = currentFontSizeNum*0.8;
    $('html').css('font-size', newFontSize);
    return false;
  });
});

--------------------------------
9. 返回页面顶部功能
	For a smooth(animated) ride back to the top(or any location).

$(document).ready(function() {
$('a[href*=#]').click(function() {
 if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'')
 && location.hostname == this.hostname) {
   var $target = $(this.hash);
   $target = $target.length && $target
   || $('[name=' + this.hash.slice(1) +']');
   if ($target.length) {
  var targetOffset = $target.offset().top;
  $('html,body')
  .animate({scrollTop: targetOffset}, 900);
    return false;
   }
  }
  });
// how to use
// place this where you want to scroll to
<A name=top></A>
// the link
<A href="#top">go to top</A>
});

--------------------------------
10. 获得鼠标指针ＸＹ值
	Want to know where your mouse cursor is?

$(document).ready(function() {
   $().mousemove(function(e){
     //display the x and y axis values inside the div with the id XY
    $('#XY').html("X Axis : " + e.pageX + " | Y Axis " + e.pageY);
  });
// how to use
<DIV id=XY></DIV>

});

--------------------------------
11.返回顶部按钮
	你可以利用 animate 和 scrollTop 来实现返回顶部的动画，而不需要使用其他插件。

// Back to top
$('a.top').click(function () {
  $(document.body).animate({scrollTop: 0}, 800);
  return false;
});
<!-- Create an anchor tag -->
<a class="top" href="#">Back to top</a>

改变 scrollTop 的值可以调整返回距离顶部的距离，而 animate 的第二个参数是执行返回动作需要的时间(单位：毫秒)。


--------------------------------
12.预加载图片
	如果你的页面中使用了很多不可见的图片（如：hover 显示），你可能需要预加载它们：

$.preloadImages = function () {
  for (var i = 0; i < arguments.length; i++) {
    $('<img>').attr('src', arguments[i]);
  }
};

$.preloadImages('img/hover1.png', 'img/hover2.png');

--------------------------------
13.检查图片是否加载完成
	有时候你需要确保图片完成加载完成以便执行后面的操作：

$('img').load(function () {
  console.log('image load successful');
});

你可以把 img 替换为其他的 ID 或者 class 来检查指定图片是否加载完成。


--------------------------------
14.自动修改破损图像
	如果你碰巧在你的网站上发现了破碎的图像链接，你可以用一个不易被替换的图像来代替它们。添加这个简单的代码可以节省很多麻烦：

$('img').on('error', function () {
  $(this).prop('src', 'img/broken.png');
});

即使你的网站没有破碎的图像链接，添加这段代码也没有任何害处。


--------------------------------
15.鼠标悬停(hover)切换 class 属性
	假如当用户鼠标悬停在一个可点击的元素上时，你希望改变其效果，下面这段代码可以在其悬停在元素上时添加 class 属性，当用户鼠标离开时，则自动取消该 class 属性：

$('.btn').hover(function () {
  $(this).addClass('hover');
  }, function () {
    $(this).removeClass('hover');
  });

你只需要添加必要的CSS代码即可。如果你想要更简洁的代码，可以使用 toggleClass 方法：

$('.btn').hover(function () {
  $(this).toggleClass('hover');
});

注：直接使用CSS实现该效果可能是更好的解决方案，但你仍然有必要知道该方法。


--------------------------------
16.禁用 input 字段
	有时你可能需要禁用表单的 submit 按钮或者某个 input 字段，直到用户执行了某些操作（例如，检查“已阅读条款”复选框）。可以添加 disabled 属性，直到你想启用它时：

$('input[type="submit"]').prop('disabled', true);

你要做的就是执行 removeAttr 方法，并把要移除的属性作为参数传入：

$('input[type="submit"]').removeAttr('disabled');

--------------------------------
17.阻止链接加载
	有时你不希望链接到某个页面或者重新加载它，你可能希望它来做一些其他事情或者触发一些其他脚本，你可以这么做：

$('a.no-link').click(function (e) {
  e.preventDefault();
});

--------------------------------
18.切换 fade/slide
	fade 和 slide 是我们在 jQuery 中经常使用的动画效果，它们可以使元素显示效果更好。但是如果你希望元素显示时使用第一种效果，而消失时使用第二种效果，则可以这么做：

// Fade
$('.btn').click(function () {
  $('.element').fadeToggle('slow');
});
// Toggle
$('.btn').click(function () {
  $('.element').slideToggle('slow');
});

--------------------------------
19.简单的手风琴效果
	这是一个实现手风琴效果快速简单的方法：

// Close all panels
$('#accordion').find('.content').hide();
// Accordion
$('#accordion').find('.accordion-header').click(function () {
  var next = $(this).next();
  next.slideToggle('fast');
  $('.content').not(next).slideUp('fast');
  return false;
});

--------------------------------
20.让两个 DIV 高度相同
	有时你需要让两个 div 高度相同，而不管它们里面的内容多少。可以使用下面的代码片段：

var $columns = $('.column');
var height = 0;
$columns.each(function () {
  if ($(this).height() > height) {
    height = $(this).height();
  }
});
$columns.height(height);

这段代码会循环一组元素，并设置它们的高度为元素中的最大高。


--------------------------------
21. 验证元素是否为空
	This will allow you to check if an element is empty.

$(document).ready(function() {
  if ($('#id').html()) {
   // do something
   }
});

--------------------------------
22. 替换元素
	Want to replace a div, or something else?

$(document).ready(function() {
   $('#id').replaceWith('
<DIV>I have been replaced</DIV>

');
});

--------------------------------
23. jQuery延时加载功能
	Want to delay something?

$(document).ready(function() {
   window.setTimeout(function() {
     // do something
   }, 1000);
});

--------------------------------
24. 移除单词功能
	Want to remove a certain word(s)?

$(document).ready(function() {
   var el = $('#id');
   el.html(el.html().replace(/word/ig, ""));
});

--------------------------------
25. 验证元素是否存在于jquery对象集合中
	Simply test with the .length property if the element exists.

$(document).ready(function() {
   if ($('#id').length) {
  // do something
  }
});

--------------------------------
26. 使整个DIV可点击
	Want to make the complete div clickable?

$(document).ready(function() {
    $("div").click(function(){
      //get the url from href attribute and launch the url
      window.location=$(this).find("a").attr("href"); return false;
    });
// how to use
<DIV><A href="index.html">home</A></DIV>

});

--------------------------------
27. ID与Class之间转换
	当改变Window大小时，在ID与Class之间切换

$(document).ready(function() {
   function checkWindowSize() {
    if ( $(window).width() > 1200 ) {
        $('body').addClass('large');
    }
    else {
        $('body').removeClass('large');
    }
   }
$(window).resize(checkWindowSize);
});

--------------------------------
28. 克隆对象
	Clone a div or an other element.

$(document).ready(function() {
   var cloned = $('#id').clone();
// how to use
<DIV id=id></DIV>

});

--------------------------------
29. 使元素居屏幕中间位置
	Center an element in the center of your screen.

$(document).ready(function() {
  jQuery.fn.center = function () {
      this.css("position","absolute");
      this.css("top", ( $(window).height() - this.height() ) / 2+$(window).scrollTop() + "px");
      this.css("left", ( $(window).width() - this.width() ) / 2+$(window).scrollLeft() + "px");
      return this;
  }
  $("#id").center();
});

--------------------------------
30. 写自己的选择器
	Write your own selectors.

$(document).ready(function() {
   $.extend($.expr[':'], {
       moreThen1000px: function(a) {
           return $(a).width() > 1000;
      }
   });
  $('.box:moreThen1000px').click(function() {
      // creating a simple js alert box
      alert('The element that you have clicked is over 1000 pixels wide');
  });
});

--------------------------------
31. 统计元素个数
	Count an element.

$(document).ready(function() {
   $("p").size();
});

--------------------------------
32. 使用自己的 Bullets
	Want to use your own bullets instead of using the standard or images bullets?

$(document).ready(function() {
   $("ul").addClass("Replaced");
   $("ul > li").prepend("‒ ");
 // how to use
 ul.Replaced { list-style : none; }
});

--------------------------------
33. 引用Google主机上的Jquery类库
	Let Google host the jQuery script for you. This can be done in 2 ways.

//Example 1
<SCRIPT src="http://www.google.com/jsapi"></SCRIPT>
<SCRIPT type=text/javascript>
google.load("jquery", "1.2.6");
google.setOnLoadCallback(function() {
    // do something
});
</SCRIPT><SCRIPT type=text/javascript src="http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.min.js"></SCRIPT>

 // Example 2:(the best and fastest way)
<SCRIPT type=text/javascript src="http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.min.js"></SCRIPT>

--------------------------------
34. 禁用Jquery（动画）效果
	Disable all jQuery effects

$(document).ready(function() {
    jQuery.fx.off = true;
});

--------------------------------
35. 与其他Javascript类库冲突解决方案
	To avoid conflict other libraries on your website, you can use this jQuery Method, and assign a different variable name instead of the dollar sign.

$(document).ready(function() {
   var $jq = jQuery.noConflict();
   $jq('#id').show();
});
