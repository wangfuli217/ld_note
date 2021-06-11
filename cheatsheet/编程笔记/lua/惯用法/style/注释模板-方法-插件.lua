--[[--
绑定插件
### Useage:
    M.bindPlugin(事件源, 参数集合)
### Refer:
    M.unbindPlugin
### See:
    http://coder.babybus.com
### Deprecate:
    废弃方法。性能上存在问题。
### Aliases:
    M.bindPlg
### Notice:
    参数集合说明:
    [必填项]
        无
    [选填项]
        CCNode      **node**            结点
        CCSize      **contentSize**     内容尺寸
        CCPoint     **anchor**          锚点位置
        ccColor3b   **color**           颜色
        CCNode      **parent**          父结点
        number      **grid9**           在父结点中的9宫排列方式
        CCPoint     **offset**          在父结点中的排列偏移量
        bool        **ignoreAnchor**    是否忽略锚点(默认false)
        CCPoint     **position**        坐标(与x, y值任选其一)
        number      **x**               坐标x
        number      **y**               坐标y
        number      **z**               层深度
        number      **tag**             标签
        bool        **isScreenSpace**   是否使用屏幕作为参考系
    [其他项]
        无
### Example:
    ----------------------
    -- 示例1: 通用操作
    ----------------------
    M.bindPlugin():to(something)
    ----------------------
    -- 示例2: 全API操作
    ----------------------
    M.bindPlugin({
        x           = 0,
        y           = 0,
        canWork     = true,
        bitData     = { 0, 1, 0, 1, 0 },
        ...
    })
### Parameters:
-   object **sender**       事件源
-   table **params**        参数集合
### Returns: 
-   BabybusPlugin           宝宝巴士定制插件
--]]--
function M.bindPlugin(sender, params)

end