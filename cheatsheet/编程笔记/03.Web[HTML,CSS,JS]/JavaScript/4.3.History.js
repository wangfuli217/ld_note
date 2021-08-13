
History对象                        // 窗口的访问历史信息(属于window的子对象,常用于返回到已经访问过的页面)
    history.length                历史记录数
    history.foward()              向下一页
    history.back()                返回上一页
    history.go(0)                 刷新。括号里填"-1"就是返回上一页，填"1"就是下一页；其它数字类推


History对象
  属性
    length	历史列表的长度。用于判断列表中的入口数目
    current	当前文档的URL
    next	历史列表的下一个URL
    previous	历史列表的上一个URL
  方法
    back()	返回到前一个URL
    forward()	访问下一个URL
    go()	转移到以前已经访问过的URL


H5 新特性
	1.无刷新修改浏览器地址
	  可以在不刷新页面的情况下修改浏览器URL;也可以将浏览历史储存起来，当你在浏览器点击后退按钮的时候，你可以从浏览历史上获得回退的信息。

		var stateObject = {};
		var title = "Wow Title";
		var newUrl = "/my/awesome/url";
		history.pushState(stateObject,title,newUrl);

	  /* History 对象 pushState() 这个方法有3个参数。
	  第一个参数，是一个Json对象 , 在你储存有关当前URl的任意历史信息.
	  第二个参数,title 就相当于传递一个文档的标题。
	  第三个参数是用来传递新的URL. 你将看到浏览器的地址栏发生变化而当前页面并没刷新。
	  */

