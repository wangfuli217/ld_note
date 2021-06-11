需求：只将"|"前边的空白符去掉，数字前的空白不动



分析：相当于1.txt中就是最后一列和倒数第二列之间的空白符去掉

[root@~]# cat 1.txt
180.99.0.100|10.4.50.59|2016-04-28 11:45:53|65|2|2|2|509.496    	|8264F011451264F0110456FC04
180.99.0.102|10.4.51.35|2016-04-28 11:12:00|124|0|15|15|2020.999        |8264F011408564F011040D7533
180.99.0.102|10.4.51.35|2016-04-28 11:12:00|63|0|1|1|534.729    |8264F011408564F011040D7533
180.99.0.10|10.4.5.104|2016-04-28 11:12:47|54|2|1|1|620.355     |8264F011491864F01104909E31
180.99.0.10|10.4.5.104|2016-04-28 11:12:47|62|0|0|0|458.776     |8264F011491864F01104909E31
180.99.0.144|10.4.72.8|2016-04-28 	11:12:24|105|8|27|27|1007.499 |8264F011405F64F01103F6D332
180.99.0.144|10.4.72.8|2016-04-28 	11:12:24|47|0|0|0|856.9191    |8264F011405F64F01103F6D332
180.99.0.185|10.4.92.239|2016-04-28	11:51:11|48|0|2|2|1160.023  |8264F011479064F01104790331
180.99.0.193|10.4.96.188|2016-04-28 	11:13:37|65|0|0|0|914.9741  |8264F0116A5364F01106A4E038
180.99.0.193|10.4.96.188|2016-04-28	11:13:37|66|2|1|1|871.2271	|8264F0116A5364F01106A4E038




[root@ ~]# sed 's/\s\+|/|/g' 1.txt
180.99.0.100|10.4.50.59|2016-04-28 11:45:53|65|2|2|2|509.496|8264F011451264F0110456FC04
180.99.0.102|10.4.51.35|2016-04-28 11:12:00|124|0|15|15|2020.999|8264F011408564F011040D7533
180.99.0.102|10.4.51.35|2016-04-28 11:12:00|63|0|1|1|534.729|8264F011408564F011040D7533
180.99.0.10|10.4.5.104|2016-04-28 11:12:47|54|2|1|1|620.355|8264F011491864F01104909E31
180.99.0.10|10.4.5.104|2016-04-28 11:12:47|62|0|0|0|458.776|8264F011491864F01104909E31
180.99.0.144|10.4.72.8|2016-04-28 	11:12:24|105|8|27|27|1007.499|8264F011405F64F01103F6D332
180.99.0.144|10.4.72.8|2016-04-28 	11:12:24|47|0|0|0|856.9191|8264F011405F64F01103F6D332
180.99.0.185|10.4.92.239|2016-04-28	11:51:11|48|0|2|2|1160.023|8264F011479064F01104790331
180.99.0.193|10.4.96.188|2016-04-28 	11:13:37|65|0|0|0|914.9741|8264F0116A5364F01106A4E038
180.99.0.193|10.4.96.188|2016-04-28	11:13:37|66|2|1|1|871.2271|8264F0116A5364F01106A4E038





[root@ ~]# awk -F '[\t ]+\\|' '$1=$1' OFS="|" 1.txt
180.99.0.100|10.4.50.59|2016-04-28 11:45:53|65|2|2|2|509.496|8264F011451264F0110456FC04
180.99.0.102|10.4.51.35|2016-04-28 11:12:00|124|0|15|15|2020.999|8264F011408564F011040D7533
180.99.0.102|10.4.51.35|2016-04-28 11:12:00|63|0|1|1|534.729|8264F011408564F011040D7533
180.99.0.10|10.4.5.104|2016-04-28 11:12:47|54|2|1|1|620.355|8264F011491864F01104909E31
180.99.0.10|10.4.5.104|2016-04-28 11:12:47|62|0|0|0|458.776|8264F011491864F01104909E31
180.99.0.144|10.4.72.8|2016-04-28 	11:12:24|105|8|27|27|1007.499|8264F011405F64F01103F6D332
180.99.0.144|10.4.72.8|2016-04-28 	11:12:24|47|0|0|0|856.9191|8264F011405F64F01103F6D332
180.99.0.185|10.4.92.239|2016-04-28	11:51:11|48|0|2|2|1160.023|8264F011479064F01104790331
180.99.0.193|10.4.96.188|2016-04-28 	11:13:37|65|0|0|0|914.9741|8264F0116A5364F01106A4E038
180.99.0.193|10.4.96.188|2016-04-28	11:13:37|66|2|1|1|871.2271|8264F0116A5364F01106A4E038




总结：这里awk使用的分隔符号是 已空白符和"|"作为分隔符   空白符包含tab和空格等，分割之后，就剩两列了，最后将两列用"|" 再拼接起来，这就是这个awk的思路。