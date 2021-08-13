#python
# -*- coding:utf-8 -*-
'''
本模块是 django model 所需的枚举专用
Created on 2015/12/11
Updated on 2016/4/20
@author: Holemar


使用说明：
    1.定义枚举类， 直接继承此文件的 Const 类即可， 如：

        class Platform(Const):
            ios = (1, 'IOS')
            android = (2, 'ANDROID')
            wp = (3, 'WP')

        class LocationType(Const):
            asia = ('Asia', u'亚洲')
            europe = ('Europe', u'欧洲')
            america = ('America', u'美洲')
            australia = ('Australia', u'澳洲')

        class LocationType2(Const):
            asia = {'value':'Asia', 'label':'亚洲'}
            europe = {'value':'Europe', 'label':'欧洲'}
            america = {'value':'America', 'label':'美洲'}
            australia = {'value':'Australia', 'label':'澳洲'}


    2.在 model 中定义字段时， 可直接 new 枚举类， 如：

        from django.db import models
        class TestModel(models.Model):
            platform = models.PositiveSmallIntegerField('平台', choices=Platform(), db_index=True, default=Platform.android)
            location = models.CharField('用户所属地区', choices=LocationType(), max_length=20, blank=True, null=True)


    3.用来判断时， 直接点出枚举类对应的值即可：

        mo = TestModel()
        if mo.platform == Platform.android: print '这是安卓用户'


    4.获取对应的说明时， 用类的“get_FEILD_display”即可：

        mo = TestModel()
        plat_name = mo.get_platform_display()

        页面展示时：
        {{ object.get_platform_display }}


    5.获取对应的说明， 也可以由枚举类直接获取(用 _attrs, _values, _labels, _labels_to_values 四个属性)：

        print( Platform.ios == 1 and Platform.android == 2 ) # 打印: True

        print( Platform._attrs[2] == 'ANDROID' ) # 打印: True
        print( Platform._attrs ) # 打印: {1: 'IOS', 2: 'ANDROID', 3: 'WP'}

        print( Platform._labels_to_values['ANDROID'] == 2 ) # 打印: True
        print( Platform._labels_to_values ) # 打印: {'ANDROID': 2, 'IOS': 1, 'WP': 3}

        print( Platform._values['ios'] == 1 ) # 打印: True
        print( Platform._values ) # 打印: {'android': 2, 'ios': 1, 'wp': 3}

        print( Platform._labels['ios'] == 'IOS' ) # 打印: True
        print( Platform._labels ) # 打印: {'android': 'ANDROID', 'ios': 'IOS', 'wp': 'WP'}

        print( Platform() ) # 打印: [(1, 'IOS'), (2, 'ANDROID'), (3, 'WP')]
        print( Platform._items ) # 打印: [(1, 'IOS'), (2, 'ANDROID'), (3, 'WP')]

'''

class ConstType(type):
    def __new__(cls, name, bases, attrs):
        attrs_value = {}
        attrs_label = {}
        new_attrs = {}
        labels_to_values = {}

        for k, v in attrs.items():
            if k.startswith('__'):
                continue
            if isinstance(v, (tuple, list)) and len(v) == 2:
                attrs_value[k] = v[0]
                attrs_label[k] = v[1]
                new_attrs[v[0]] = v[1]
                labels_to_values[v[1]] = v[0]
            elif isinstance(v, dict) and 'label' in v and 'value' in v:
                attrs_value[k] = v['value']
                attrs_label[k] = v['label']
                new_attrs[v['value']] = v['label']
                labels_to_values[v['label']] = v['value']
            else:
                attrs_value[k] = v
                attrs_label[k] = v

        obj = type.__new__(cls, name, bases, attrs_value)
        obj._values = attrs_value
        obj._labels = attrs_label
        obj._labels_to_values = labels_to_values
        obj._attrs = new_attrs
        obj._items = sorted(new_attrs.iteritems(), key=lambda (k,v): k)
        return obj

    def __call__(cls, *args, **kw):
        return cls._items

class Const(object):
    __metaclass__ = ConstType

# 布尔值是最常用的枚举，所以这里先写一个
class Boolean(Const):
    no = (0, '否')
    yes = (1, '是')
