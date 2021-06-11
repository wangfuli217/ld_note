#coding: utf-8
import Image
import ImageDraw
import ImageFilter
import ImageFont
import random
import string
from tempfile import TemporaryFile as TF

def init_chars():
    """
    允许的字符集合，初始集合为数字、大小写字母
    usage: initChars()
    param: None
    return: list
    返回允许的字符集和
    for: picChecker类初始字符集合
    todo: Nothing
    """
    nums = [str(i) for i in range(10)]
    return nums
#    letterCase = [
#        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k',
#        'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
#        'w', 'x', 'y', 'z'
#    ]
#    upperCase = [
#        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K',
#        'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
#        'W', 'X', 'Y', 'Z',
#    ]
#    return nums + letterCase + upperCase
    
class PicChecker(object):
    """
    图片验证代码：
    1) 用户注册需填写图片验证码，以阻止机器人注册
    2) 图片验证码字符数为 4 位(大小写字母与数字，不区分大小写)。
    用户如果没有填写验证码或没有填写正确的验证码，
    页面友好性提示用户填写(同时程序方面也做相应限制)
    usage: pc = picChecker().createChecker()
    param: 很多，如下
    chars 允许的字符集合，
    类型 list
    默认值 initChars()
    例子 ['1','2','3']
    length 字符串长度
    类型 integer
    默认值 4
    size 图片大小
    类型 tutle
    默认值 (80, 24)
    例子 (80, 24)
    fontsize 字体大小
    类型 integer
    默认值 18
    begin 字符其实位置，即左上角位置
    类型 tutle
    默认值 (5,-2)
    outputType 输出类型
    类型 string
    默认值 GIF
    可选值 GIF JPEG TIFF PNG
    mode 图片模式
    类型 string
    可选值 RGB L (还有其他模式，但只推荐这2种)
    默认值 RGB
    backgroundColor 背景色
    foregroundColor 前景色
    当mode=RGB时，backgroundColor,foregroundColor为tutle类型
    取值为(integer,integer,integer)
    表示RGB颜色值
    当mode=L时，backgroundColor,foregroundColor为数字，表示黑白模式
    取值为0-255
    表示灰度
    fonttype 字体路径
    类型 string
    默认值 "wqy-zenhei.ttc"
    jamNum 干扰线条数
    类型 (int1,int1)
    int1 干扰线条数下限，包含
    int2 干扰线条数上线，包含
    pointBorder 散点噪音
    构造方法：对每个像素点使用随机函数确定是否在该像素上画散点噪音
    类型 (int1,int2)
    int1越大 散点越多
    int2越大 散点越少
    return: [picCheckerStr,pic]
    picCheckerStr: 表示返回图片中对应的字符串,可用于session验证以及其他用途
    pic : 返回的图片，类型为Image
    for :
    todo : Nothing
    """
    def __init__(self, chars=init_chars(), size=(80, 24), fontsize=18,
                begin=(5, -2), outputType='JPEG', mode='RGB',
                backgroundColor=(255, 255, 255), foregroundColor=(0, 0, 255),
                fonttype="wqy-zenhei.ttc", length=4, jamNum=(1, 5),
                pointBorder=(40, 39), is_save_file=False, save_path=''):
        """
        初始化配置
        """
        super(PicChecker, self).__init__()

        #验证码配置
        #允许的字符串
        self.chars = chars
        #图片大小
        self.size = size
        #字符起始插入点
        self.begin = begin
        #字符串长度
        self.length = length
        #输出类型
        self.outputType = outputType
        #字符大小
        self.fontsize = fontsize
        #图片模式
        self.mode = mode
        #背景色
        self.background_color = backgroundColor
        #前景色
        self.foreground_color = foregroundColor
        #干扰线条数
        self.jam_num = jamNum
        #散点噪音界限
        self.pointBorder = pointBorder
        #字体库路径
        self.fonttype = fonttype
        #设置字体,大小默认为18
        self.font = ImageFont.truetype(self.fonttype, self.fontsize)
        #设置是否保存为文件
        self.is_save_file = is_save_file
        #保存为文件时的路径
        self.save_path = save_path
            
    def get_pic_string(self):
        """
        usage: getPicString()
        return: string
        for : 生成给定长度的随机字符串
        todo: Nothing
        """
        #初始化字符串长度
        length = self.length
        #初始化字符集合
        chars = self.chars
        #获得字符集合
        selectedChars = random.sample(chars, length)
        charsToStr = string.join(selectedChars, '')
        return charsToStr
        
    def create_checker(self):
        """
        usage: createChecker()
        return: [str,pic]
        str:对应的字符串
        pic:对应的图片
        for:
        todo:
        """
        #获得验证码字符串
        randStr = self.get_pic_string()
        #将字符串加入空格
        randStr1 = string.join([i + " " for i in randStr], "")
        #创建图形
        im = Image.new(self.mode, self.size, self.background_color)
        #创建画笔
        draw = ImageDraw.Draw(im)
        #输出随机文本
        draw.text(self.begin, randStr1, font=self.font, fill=self.foreground_color)
        #im = self.drawText(draw,randStr,im)
        #干扰线
        self.create_jam(draw)
        #散点噪音
        self.create_points(draw)
        #图形扭曲
        para = [1-float(random.randint(1, 2)) / 100,
            0,
            0,
            0,
            1-float(random.randint(1, 10)) / 100,
            float(random.randint(1, 2)) / 500,
            0.001,
            float(random.randint(1, 2)) / 500
        ]
        #print randStr,para
        im = im.transform(im.size, Image.PERSPECTIVE, para)
        #图像滤镜
        im = im.filter(ImageFilter.EDGE_ENHANCE_MORE)
        if self.is_save_file:
            im.save(self.save_path, self.outputType)
            return (randStr, im)
        else:
            tf = TF()
            im.save(tf, self.outputType)
            tf.seek(0)
            data = tf.read()
            tf.close()
            return (randStr, data)
        
    def create_jam(self, draw):
        """
        usage: 创建干扰线
        para: draw 表示画笔
        return: None
        for:
        todo:
        """
        #干扰线条数
        lineNum = random.randint(self.jam_num[0], self.jam_num[1])
        for i in range(lineNum):
            begin = (random.randint(0, self.size[0]), random.randint(0, self.size[1]))
            end = (random.randint(0, self.size[0]), random.randint(0, self.size[1]))
            draw.line([begin, end], fill=(0, 0, 0))
        
    def create_points(self, draw):
        """
        usage: 创建散点噪音
        para: draw 表示画笔
        return: None
        for:
        todo:
        """
        #散点噪音
        for x in range(self.size[0]):
            for y in range(self.size[1]):
                flag = random.randint(0, self.pointBorder[0])
                if flag > self.pointBorder[1]:
                    draw.point((x, y), fill=(0, 0, 0))
                del flag
    
if __name__ == '__main__':
    PicChecker().create_checker()
