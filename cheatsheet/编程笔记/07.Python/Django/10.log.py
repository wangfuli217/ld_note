
django.utils.log 文件里面，定义了默认的日志 DEFAULT_LOGGING

配置日志系统
  LOGGING = {
    'version': 1,#指明dictConnfig的版本，目前就只有一个版本，哈哈
    'disable_existing_loggers': True,#禁用所有的已经存在的日志配置
    'formatters': {#格式器
        'verbose': {#详细
            'format': '%(levelname)s %(asctime)s %(module)s %(process)d %(thread)d %(message)s'
        },
        'simple': {#简单
            'format': '%(levelname)s %(message)s'
        },
    },
    'filters': {#过滤器
        'special': {#使用project.logging.SpecialFilter，别名special，可以接受其他的参数
            '()': 'project.logging.SpecialFilter',
            'foo': 'bar',#参数，名为foo，值为bar
        }
    },
    'handlers': {#处理器，在这里定义了三个处理器
        'null': {#Null处理器，所有高于（包括）debug的消息会被传到/dev/null
            'level':'DEBUG',
            'class':'django.utils.log.NullHandler',
        },
        'console':{#流处理器，所有的高于（包括）debug的消息会被传到stderr，使用的是simple格式器
            'level':'DEBUG',
            'class':'logging.StreamHandler',
            'formatter': 'simple'
        },
        'mail_admins': {#AdminEmail处理器，所有高于（包括）而error的消息会被发送给站点管理员，使用的是special格式器
            'level': 'ERROR',
            'class': 'django.utils.log.AdminEmailHandler',
            'filters': ['special']
        }
    },
    'loggers': {#定义了三个记录器
        'django': {#使用null处理器，所有高于（包括）info的消息会被发往null处理器，向父层次传递信息
            'handlers':['null'],
            'propagate': True,
            'level':'INFO',
        },
        'django.request': {#所有高于（包括）error的消息会被发往mail_admins处理器，消息不向父层次发送
            'handlers': ['mail_admins'],
            'level': 'ERROR',
            'propagate': False,
        },
        'myproject.custom': {#所有高于（包括）info的消息同时会被发往console和mail_admins处理器，使用special过滤器
            'handlers': ['console', 'mail_admins'],
            'level': 'INFO',
            'filters': ['special']
        }
    }
  }



自定义日志配置和禁用日志配置
    使用 LOGGING_CONFIG 属性自定义和禁用日志配置， LOGGING_CONFIG=None 禁用

django日志拓展
  django提供三个自带的记录器：

  django
    django记录器是捕捉所有消息的记录器，没有消息是直接发往django记录器的

  django.request
    5XX会引发一个error消息，4XX会引发一个warning消息，这个记录器还附带有额外的上下文：
    status_code：HTTP响应码
    request：生成这个消息的request对象

  django.db.backens
    所有的由请求运行的sql语句都会记录一条debug的消息，每个记录器还附带有额外的上下文：
    duration：sql语句运行的时间
    sql：运行的sql语句
    params：sql语句调用的参数

    出于网站运行的表现原因，仅当 settings.DEBUG=True 的时候，这个处理器才生效，否则即使配置了也无效


class AdminEmailHandler(include_html=False)
    除了python模块自带的，django自定义了这个处理器
    这个处理器每收到一条消息就会发往站点管理员，如果日志信息包含request属性，那么整个request的详细信息也会被包包含在Email中发往站点管理员；
    如果日志信息包含堆栈跟踪信息，堆栈跟踪信息也会被发送。
    include_html 属性控制当 DEBUG 为真的时候是否发送那些回溯信息，因为这些都是很敏感的系统系统，如果被人截获，可能会发生危险，所以要谨慎。
    配置这个属性示例如下：

    'handlers': {
        'mail_admins': {
            'level': 'ERROR',
            'class': 'django.utils.log.AdminEmailHandler',
            'include_html': True,
        }
    },



class CallBackFilter(callback)
    除了python自带的，django提供了两个自带的过滤器： CallBackFilter 和 RequireDebugFalse
    这个过滤器接受一个回调函数（这个函数接受一个参数，被记录的信息），每个记录通过过滤器的时候都会调用这个回调函数，当回调函数返回False的时候，不处理这个记录。
    下面是一个示例：

    from django.http import UnreadablePostError

    def skip_unreadable_post(record):
        if record.exc_info:
            exc_type, exc_value = record.exc_info[:2]
            if isinstance(exc_value, UnreadablePostError):
                return False
        return True

    'filters': {
        'skip_unreadable_posts': {
            '()': 'django.utils.log.CallbackFilter',
            'callback': skip_unreadable_post,
        }
    },
    'handlers': {
        'mail_admins': {
            'level': 'ERROR',
            'filters': ['skip_unreadable_posts'],
            'class': 'django.utils.log.AdminEmailHandler'
        }
    },

class RequireDebugFalse
    这个过滤器仅当 settings.DEBUG 为 False 的时候会生效，默认是启用的，仅当 settings.DEBUG=False 的时候，AdminEmailHandler 才生效
    'filters': {
         'require_debug_false': {
             '()': 'django.utils.log.RequireDebugFalse',
         }
     },
     'handlers': {
         'mail_admins': {
             'level': 'ERROR',
             'filters': ['require_debug_false'],
             'class': 'django.utils.log.AdminEmailHandler'
         }
     },

