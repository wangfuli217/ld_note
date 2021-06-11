#this script is to extract cnp data from log, and save to csv file
import re
import csv
from itertools import izip_longest

#define global begin
covTicks      = []
decompseTicks = []
evdTicks      = []
g_inputFile   = 'input.log'
g_outputFile  = 'output.csv'
#define global end

def extractDigit(line):
    prefix = 'cost='
    nums = re.findall('(?<={})\d+'.format(prefix),line)
    #print nums
    if len(nums) > 0 :
        return int(nums[0])
    else:
        return ''

def readTicks(line):
    if 'HandleAllPoolSrsLongTermHMeasResp' in line:
        covTicks.append( extractDigit(line))
    elif 'HandleMgmtBfMatrixDecomposeReq' in line:
        decompseTicks.append( extractDigit(line))
    elif 'PowerMethod_Arm' in line :
        evdTicks.append( extractDigit(line))


def printTicks():
    print covTicks
    print decompseTicks
    print evdTicks

def writeDataToCsv(data, oFile):
    with open(oFile, 'wb') as myfile:
        wr = csv.writer(myfile)
        wr.writerow(['Covar', 'Decompose', 'EVD'])#first row title
        wr.writerows(data)
    

def readTickFromFile(iFile):
    with open(iFile) as f:
        for line in f:
            readTicks(line)

if __name__ == '__main__':    
    readTickFromFile(g_inputFile)
    #printTicks()
    combineLists = [covTicks, decompseTicks, evdTicks]
    export_data = izip_longest(*combineLists, fillvalue = '')
    writeDataToCsv(export_data, g_outputFile)
    
    
    
    
        
    
