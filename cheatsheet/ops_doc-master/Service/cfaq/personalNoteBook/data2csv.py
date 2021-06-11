#python 2.7 script:  write data to csv , each list map to a column
#solution1:  lists may have diff length, each keep the origin length

import csv
from itertools import izip_longest
list1 = ['a', 'b', 'c', 'd', 'e']
list2 = ['f', 'g', 'i', 'j']
combinelist = [list1, list2]
export_data = izip_longest(*combinelist, fillvalue = '') #make both length = max(list1,list2)

#note:python2: open('output.csv', 'wb') equal to python3:open('output.csv', 'w',newline='')
with open('output.csv', 'wb') as myfile:
      wr = csv.writer(myfile)
      wr.writerow(['List1', 'List2'])#first row
      wr.writerows(export_data)




#solution2: if all lists have same length, or want to truncate to  the min length:

rows = zip(list1,list2,list3,list4,list5)
import csv
with open('output.csv', 'wb') as f:
    writer = csv.writer(f)
    writer.writerow(['col1','col2','col3','col4','col5'])
    for row in rows:
        writer.writerow(row)

            
            
#read data from csv, need import csv
with open('input.csv') as f:
      for line in csv.reader(f): # csv.DictReader(f)
            print(line) #each line form a list(reader), dict(DictReader)
            
      
with open('input.csv') as f:
      firstline = f.readline()
      data={}
      for line in f:
            k,v = line.strip().split(',') #strip() to remove \n , suppose two columns each line.
            data[k] = v
      pprint.pprint(data) #import pprint     
