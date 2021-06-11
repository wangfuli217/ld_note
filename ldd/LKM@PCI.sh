pci(){
Agent：可以操作总线的设备（device）或实体（entity）。
Master：可以发起一次总线事务（transaction）的agent。
Transaction：在PCI上下文中，一次transaction包含一次address phase和一次或多次data phase。也被称为burst transfer。
Initiator：获得总线控制权的master，也就是发起transaction的agent。
Target：在address phase认识到自己address的agent。Target会响应transaction。
Central Resource：主机系统上提供总线支持（如产生CLK信号等等），总线仲裁等等功能的元素。
Latency：在一次transaction中，两次状态转换之间消耗的时钟周期。Latency用来度量一个agent响应另外一个agent请求所花的时间，因此是性能的一个度量指标。
}
