#coding=utf-8
from django.core.paginator import Paginator
from django.template.loader import get_template
from django.template import Context
from django.http import HttpResponse
from django.views.static import serve
from django.shortcuts import render_to_response
from django.db.models import Q
from django.db import connection

from xyt.settings import PROJECT_DIR # 项目配置信息(项目路径)

import codecs, os, os.path, datetime
import csv



# 默认每页显示多少笔资料
PAGE_DEFAULT_LIMIT = 10

# 静态页面存放的路径(要求目录必须先存在)
STARIC_PATH = '%s/demo' % PROJECT_DIR


# 添加返回值
#  总页数 total
#  上页  pre_page
#  下页  next_page
def get_page(objs, page_info={}, to_values=True):
    # 分页信息。 如果传入此参数，取传入的；没传入则预设值
    page_info = page_info or {
         'start': 0,  # 开始行
         'index': 1,  # 第几页
         'limit': PAGE_DEFAULT_LIMIT  # 每页多少笔资料
    }
    # 每页显示多少笔资料
    limit = int(page_info.get('limit', PAGE_DEFAULT_LIMIT))
    # 从第几笔资料开始
    start = int(page_info.get('start', 0))
    # 显示第几页
    index = int(page_info.get('index', (start // limit) + 1))
    if index < 1:
        index = 1

    # 若objs是CSV文件路径,则如此分页
    if isinstance(objs, basestring):
        data = []
        total_count = 0

        if os.path.isfile(objs):
            csv_file = file(objs, 'rU')
            import chardet
            enc = chardet.detect(csv_file.read())['encoding']
            if enc.upper() == 'GB2312' or enc.upper() == 'BIG5':
                enc = 'GB18030'
            #csv_file.close()
            #import codecs
            #csv_file = codecs.open(objs, 'r', enc)
            csv_file.seek(0L)

            first_line_number = limit*(index-1) + 1
            last_line_number = first_line_number + limit
            if first_line_number >= 1:
                #暂时顺序读取,随机读取慢慢改
                #{'line_count': 100, 'line_offset': [0L, 50L, 88L]}
                #line_offset = []
                #while True:
                #    line_offset.append(f.tell())
                #    if not f.readline():
                #        break

                current_line_number = 1

                for line in csv.reader(csv_file):
                    if current_line_number >= first_line_number and current_line_number < last_line_number:
                        line_decode = []
                        for d in line:
                            line_decode.append(d.decode(enc))
                        data.append(line_decode)
                    current_line_number += 1
                total_count = current_line_number-1
            csv_file.close()

        tatal_page = total_count/limit if (total_count/limit)*limit == total_count else total_count/limit+1

        return {
            'start': start,
            'index': index,
            'limit': limit,
            'count': total_count,
            'data': data,
            'total': tatal_page,
            'pre_page':  index-1 if index>1 else 1,
            'next_page': index+1 if index<tatal_page else tatal_page
        }
    else:
        pmake = Paginator(objs, limit, allow_empty_first_page=True)

        # 防止超出最大页码
        if index > pmake.num_pages:
            index = pmake.num_pages

        p = pmake.page(index)

        return {
            'start': start,
            'index': index,
            'limit': limit,
            'count': pmake.count,
            'data': list(p.object_list.values() if to_values else p.object_list),
            'total': pmake.num_pages,
            'pre_page':  index-1 if index>1 else 1,
            'next_page': index+1 if index<pmake.num_pages else pmake.num_pages
        }

def page_sql(sql, page_info={}, to_values=True):
    if not page_info:
         page_info = {
             'start': 0,
             'index': 1,
             'limit': PAGE_DEFAULT_LIMIT
         }

    limit = int(page_info.get('limit', PAGE_DEFAULT_LIMIT))
    index = page_info.get('index', None)
    start = int(page_info.get('start', 0))
    if index == None:
        index = int(start / limit) + 1
    else:
        index = int(index)
        if index < 1:
            index = 1

    count_sql = "SELECT COUNT(1) FROM (" + sql + ")"
    cursor = connection.cursor()
    rows = cursor.execute(count_sql)
    count = int(rows.fetchone()[0])
    total = count/limit
    if total*limit < count:
        total += 1

    if index > total:
        index = total

    # oracle 的数据库语句分页
    page_sql = "SELECT * FROM (SELECT  AA.*, ROWNUM RN  FROM (" + sql + ") AA WHERE ROWNUM <= %(lastrow)d) WHERE RN > %(firstrow)d" % {
                'firstrow': (index-1)*limit,
                'lastrow': index*limit
             }

    rows = cursor.execute(page_sql)

    return {
        'start': start,
        'index': index,
        'limit': limit,
        'count': count,
        'data': list(rows) if to_values else rows,
        'total': total,
        'pre_page':  index-1 if index>1 else 1,
        'next_page': index+1 if index<total else total
    }

def next_q(q, filter_ds, qname, qtype='exact', field_name=None, reverse=False, is_or=False, val_deal=None, val_deal_args=[]):
    if qname not in filter_ds:
        #return q
        return Q() if q is None else q
    v = filter_ds.get(qname, None)
    if v is None:
        #return q
        return Q() if q is None else q
    if v is '' and qtype in ['icontains', 'startswith']:
        return Q() if q is None else q
    if callable(val_deal):
        v = val_deal(v, qname, val_deal_args)
    if not field_name:
        field_name = qname
    qn = apply(Q, [], {'%s__%s' % (field_name, qtype) : v})
    if reverse:
        qn = ~qn
    if q is None:
        return qn
    else:
        if is_or:
            return q | qn
        else:
            return q & qn

#获取组合状态可能值的列表
def masked_list(length, mask):
    vl_dict = {}
    for v in range(1 << length):
        if v & mask == mask:
            vl_dict[v] = True
    return vl_dict.keys()

#字典参数的key转为str
def key2str(src_dict):
    dct_dict = {}
    for k,v in src_dict.items():
        if isinstance(k,str):
            dct_dict[k] = v
        else:
            dct_dict[str(k)] = v
    return dct_dict



# 获取分页导航条html及分页数据
# 使用时，页面输出需要加“|safe”过滤器让他不转码显示，如：{{ page.html|safe }}
def get_html(objs, request, page_size=PAGE_DEFAULT_LIMIT, to_values=True, path="", script=""):
    '''
    分页导航条
    @param objs 需查询的数据
    @param request 页面请求
    @param page_size 每页显示多少条记录
    @param to_values 是否以列表返回
    @param path 提交请求的路径
    @param script 按钮的 javascript 事件(有此属性则 path 无效；且此导航条需放到提交的form里面)
    @return 获取分页导航条html 及 分页数据
    '''
    # 显示第几页
    page_index = request.POST.get('page') or request.GET.get('page', 1)
    # 防止客户端的错误输入
    try:
        page_index = int(page_index)
    except:
        page_index = 1
    if page_index < 1:
        page_index = 1

    # 分页导航条信息
    paginator = Paginator(objs, page_size, allow_empty_first_page=True)

    # 防止超出最大页码
    if page_index > paginator.num_pages:
        page_index = paginator.num_pages

    # 获取分页信息
    p = paginator.page(page_index)

    # 总页数
    page_total = paginator.num_pages

    # 按钮的 javascript 事件
    if script:
        href = "javascript:document.getElementById('page').value=%d;" + script
        doSubmit = "document.getElementById('page').value=value;" + script
    # 页面跳转的路径
    else:
        path += "&" if '?' in path else "?"
        href = path + "page=%d"
        doSubmit = "location.href='%spage='+value" % path

    # html 输出
    html = '<div class="Flip"><input type="hidden" name="page" id="page" />'

    # 首页
    if page_index == 1:
        html += u'<a href="javascript:void(0);">首 页</a> |'
    else:
        html += u'<a href="%s">首 页</a> |' % (href % 1)

    # 上一页
    if p.has_previous():
        html += u'<a href="%s">上一页</a> |' % (href % (page_index - 1))
    else:
        html += u'<a href="javascript:void(0);">上一页</a> |'

    # 下一页
    if p.has_next():
        html += u'<a href="%s">下一页</a> |' % (href % (page_index + 1))
    else:
        html += u'<a href="javascript:void(0);">下一页</a> |'

    # 最后一页
    if page_index == page_total:
        html += u'<a href="javascript:void(0);">末 页</a> |'
    else:
        html += u'<a href="%s">末 页</a> |' % (href % page_total)

    # 共几页
    html += u'共 %d 页' % page_total

    # 跳转页面输入框
    html += '''<input id="go_page" type="text" value="%d" size="3" onkeydown="var value=parseInt(this.value,10); if(13==event.keyCode && %d != value){%s;return false;}"/>''' % (page_index, page_index, doSubmit)

    # go按钮
    html += '''<input type="button" name="button" id="button" value="GO>>" style="font-size:10px;" onclick="var value=parseInt(document.getElementById('go_page').value,10); if(%d != value){%s;}"/></div>''' % (page_index, doSubmit)

    return {
            'data': list(p.object_list.values() if to_values else p.object_list),
            'html': html
    }


# 静态页面字典，保存每个静态页面的生成时间
STATIC_dict = {}

def is_need_update(path, request=None):
    '''
    判断这个路径的静态文件是否需要更新
    @param path 模板文件的路径和文件名
    @param request 页面请求(为了可以强制更新,如：http://localhost/index.html?update=1)
    @return 需要更新返回 True, 不需要更新返回 False
    '''
    # 是否强制更新静态文件
    if ( request and request.GET.get('update') == "1" ):
        return True;

    # 上一次更新时间(这里设定每天更新一次)
    last_update = STATIC_dict.get(path)
    if ( (not last_update) or (last_update < datetime.date.today()) ):
        return True;

    # 不需要更新
    return False;


def update_static(path, param={}, request=None):
    '''
    生成静态页面
    @param path 模板文件的路径和文件名
    @param param 需要传给模板的参数字典
    @param request 页面请求(为了可以强制更新,如：http://localhost/index.html?update=1)
    @return 静态页面的内容
    '''
    # 是否强制更新静态文件
    if ( request and request.GET.get('update') == "1" ):
        param['page_update'] = '?update=1'
    # 生成静态文件
    news_file = codecs.open('%s/%s' % (os.path.abspath(STARIC_PATH), path), 'wb', 'utf-8')
    try:
        t = get_template(path)
        html = t.render(Context(param))
        news_file.write(html) # 写文件
        STATIC_dict[path] = datetime.date.today() # 保存此页面的更新时间
        return HttpResponse(html) # 传回页面内容
    except IOError, ioe:
        raise RpcError(ioe.message)
    finally:
        news_file.close()


def statistics(request, path):
    '''
    访问缓存的静态文件
    @param request 页面请求
    @param path 模板文件的路径和文件名
    '''
    # 访问缓存的静态文件
    return serve(request, document_root=STARIC_PATH, path=path)



