
select 标签

    HTML 内容如下:
        <select name='sele' id='sect' onchange='alert(this.options[this.selectedIndex].text)'>
            <option value='1'>第一名</option>
            <option value='2'>第二名</option>
            <option value='3'>第三名</option>
            <option value='4'>第四名</option>
        </select>

    js 使用如下:
        var select_elemet = window.document.getElementById("sect");
        var value = select_elemet.value // 这是获得选中的值
        var select_options = select_elemet.options //这是获得select中所有的值，是个数组, 里面是各 option 标签对象

        // 要获得option中间的文本
        var selectIndex = select_elemet.selectedIndex;//获得是第几个被选中了
        var selectText = select_elemet.options[selectIndex].text; //获得被选中的项目的文本
