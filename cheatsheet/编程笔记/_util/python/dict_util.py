# -*- coding:utf-8 -*-

"""
    分类数量统计

    Author      : Holemar
    E-mail      : daillow@gmail.com
    Create_Date : 2011-06-27
    Modif_Date  : 2011-07-07
"""

__version__ = "1.0"

import datetime
import time
import json



def time2string(table_list):
    '''
        将时间类型转成字符串类型，以便格式化成json时不会出错

        参数 ：table_list  数据内容列表
        返回 ：返回处理数据之后的资料
    '''
    # 数据处理: 由于 time, datetime 类型，不能直接json序列化，需在此转换
    for table in table_list:
        for key, value in table.items():
            if isinstance(value, datetime.datetime):
                record[key] = value.strftime('%Y-%m-%d %H:%M:%S')
            elif isinstance(value, (list, set)):
                time2string(value)

    return table_list


def string2time(info, fields):
    """
        递归遍历转换字符串为时间类型

        参数 ：字典类型
        返回 ：将时间类型转成字符类型
    """
    for key, value in info.iteritems():
        if key in fields and isinstance(value, str):
            info[key] = time.strptime(value, '%Y-%m-%d %H:%M:%S')
        elif key in fields and isinstance(value, dict):
            for time_key, time_value in value.items():
                value[time_key] = datetime.datetime.strptime(time_value, '%Y-%m-%d %H:%M:%S')
        elif isinstance(value, (list, set, dict)):
            string2time(value, fields)


def group_by(table_list, group_col, action_col, action='SUM'):
    """
        将 table 的内容(字典dict形式的) group by 分组

        参数 ：table_list  数据内容列表
              group_col  要进行分组的字段
              action_col  分组时，要操作的字段
              action  分组时，要操作的动作(仅支持: AVG, SUM, COUNT, MAX, MIN)
        返回 ：返回分组之后的table资料
    """
    action = action.strip().upper()

    # 用于储存 分组后的资料
    result_return = []
    # 数据处理: 将数据按 group_col 分组合并,累加文章数
    for table in table_list:
        group_col_value = table.get(group_col)
        action_col_value = table.get(action_col)

        # 标志是否已经有此 group_col 的资料
        flag = True
        if group_col_value and action_col_value != None:
            for return_table in result_return:
                if group_col_value == return_table.get(group_col):
                    if 'SUM' == action:
                        return_table[action_col] += action_col_value
                    # 求平均时，是先相加，后再除;这里先把相加结果和数量都记录起来，后面再除
                    elif 'AVG' == action:
                        return_table[action_col] = (return_table.get(action_col)[0] + action_col_value, return_table.get(action_col)[1] + 1,)
                    elif 'COUNT' == action:
                        return_table[action_col] += 1
                    elif 'MAX' == action:
                        return_table[action_col] = max(return_table.get(action_col), action_col_value)
                    elif 'MIN' == action:
                        return_table[action_col] = min(return_table.get(action_col), action_col_value)
                    flag = False

        # 如果此 group_col 的资料还未存在，则添加
        if flag and action_col_value != None:
            return_table = table.copy()
            result_return.append(return_table)
            if 'COUNT' == action:
                return_table[action_col] = 1
            elif 'AVG' == action:
                return_table[action_col] = (return_table.get(action_col), 1,)

    # 如果是求平均的，需要后续再处理一下(即计算平均)
    if 'AVG' == action:
        for table in result_return:
            try:
                table[action_col] = table.get(action_col)[0] / table.get(action_col)[1]
            # 此值不能相除时
            except:
                table[action_col] = table.get(action_col)[0]

    return result_return




if __name__ == '__main__':
    """
        统计某个时间段内与分类相关的报道数量,以报道数（相关篇数）由多到少排序

        参数 ：查询条件
        返回 ：如果存在该资料，将返回详细信息，反之为假(False)
    """
    result = common.find_table(TABLE, {})
    if (not result.get('info')):
        return result

    # 分组,按站点分
    result_info = group_by(table=result.get('info'), group_col='siteid', action_col='archivecount', action='SUM')

    post_data = eval(args.get('post_data'))
    # 如果有排序
    if post_data and post_data.get("order"):
        result_info.sort(key=lambda d:d.get(post_data.get("order")))
    # 默认按文章数排序
    else:
        result_info.sort(key=lambda d:-d.get('archivecount'))

    # 数据处理: 由于 addon 是 datetime 类型，不能直接json序列化，需在此转换
    result_info = time2string(result_info)

    result['info'] = result_info
    return result





