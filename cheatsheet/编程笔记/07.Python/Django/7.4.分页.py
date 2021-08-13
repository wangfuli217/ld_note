
分页
    可使用 django 内置的分页

    # 导入分页工具
    from django.core.paginator import Paginator

    objects = ['john', 'paul', 'george', 'ringo', 'vincent', 'jecheck', 'dennis', 'lynn', 'lili', 'andy'] # 模拟数据库查询出的数据

    # 参数: 第一个就是数据的集合, 第二个表示每页放几笔数据。 allow_empty_first_page 查询时是否允许为空,(默认值 False,为空时报错)
    # 第一个参数可以是list, tuple, QuerySet 或者任意对象——只要它有 count() 或者 __len__() 函数。 Django会先尝试调用 count()。如果 不可行, 再调用 len() 。
    p = Paginator(objects, 3, allow_empty_first_page=True)
    print(p.count)  # 共多少笔资料, 打印: 10
    print(p.num_pages) # 共多少页,打印:  4
    print(p.page_range) # 分页条的列表,打印:  [1,2,3,4]

    page1 = p.page(1) # 取第一页, 里面的数字是第几页
    print(page1) # 对象, 打印:  <Page 1 of 4>
    print(page1.object_list) # 所取页面的集合,打印: ['john', 'paul', 'george']

    page2 = p.page(2) # 取第二页
    print(page2.has_next()) # 是否有下一页,结果是bool类型,打印: True
    print(page2.has_previous()) # 是否有上一页,结果是bool类型,打印: True
    print(page2.has_other_pages()) # 是否有其他页面,结果是bool类型,打印: True
    print(page2.next_page_number()) # 下一页的页码,打印: 3。 最后一页时,调用会报异常
    print(page2.previous_page_number()) # 上一页的页码,打印: 1。 第一页时,调用会报异常
    print(page1.previous_page_number()) # 上一页的页码,第一页时,报异常

    print(page1.start_index()) # 这页面的开始行数(从1开始),打印: 1
    print(page2.start_index()) # 这页面的开始行数(从1开始),打印: 4
    print(page2.end_index()) # 这页面的结束行数,打印: 6

    p.page(0) # 报错:  EmptyPage: That page number is less than 1
    p.page(5) # 报错:  EmptyPage: That page contains no results

