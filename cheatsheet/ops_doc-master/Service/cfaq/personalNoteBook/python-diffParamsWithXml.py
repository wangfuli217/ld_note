#this script is used for work: compare paramters value beteen two file,then compare with default value in xml.

from pprint import pprint
import re

def myprint(f):
    for s in f:
        print(s)

def convert(paraVals: set) ->dict:
    """ convert set{param = value} to dict{param: value}"""
    result = {}
    #print(paraVals, len(paraVals))
    for p in paraVals:
        if '=' in p:        
            k,v = p.strip().split('=')
            result[k] = v
    return result

def diffParams(file1, file2) -> set:
    """ return different content between file1 and file2"""
    f1 = open(file1)
    f2 = open(file2)
        
    f1content = f1.readlines()
    f2content = f2.readlines()
    
    f1content = set(f1content)
    f2content = set(f2content)
    
    diff = f1content.difference(f2content)
    
    f1.close()
    f2.close()
    #myprint(diff)
    return diff

def decodeLine(line: str) ->tuple:
    """ line content : <field name="actDldynTargetBler" size="32" default="10"/>  """
    if not line:
        return ('invalid', 0)
    #print(line)
    namePrefix = "name=\"" 
    valuePrefix = "default=\""
    paramName = ''.join(re.findall('(?<={})\w+'.format(namePrefix), line)) if namePrefix in line else 'invalid'            
    valueName = ''.join(re.findall('(?<={})\d+'.format(valuePrefix), line)) if valuePrefix in line else '0'            
    #print(paramName, valueName)
    return (paramName,valueName)
    

def parseXml(xmlfile) ->dict:
    """ return {params:value} """
    with open(xmlfile) as f:    
        paramValue = {}
        for line in f:
            k,v = decodeLine(line)
            paramValue[k] = v  
        
        return paramValue


def compare(src1:dict, src2:dict) ->dict:
    """ return diff k-v between src1 and src2 """
    result = {k:v for k,v in src1.items() if k in src2 and src2[k] != v}                       
    return result            

def write2File(data:dict, dstfile:str):
    """write dict{k:v} to text file: key = value """
    with open(dstfile,'w') as f:
        f.write(str(len(data)) + '\n')
        for k,v in sorted(data.items()):
            f.write(str(k) + ' = ' + str(v) +'\n')
            
def extractParaName(ifile:str) ->dict:
    """ extract para=>$value from file to dict """    
    with open(ifile) as f:
        result = dict( line.strip('\n, ').split('=>') for line in f if line.count('=>') == 1) #clean code !
        removespace = {k.strip():v.strip() for k,v in result.items()}
        return removespace
            
            
if __name__ == '__main__':
    """ find the  diff between ActiveCellSRS and ActiveCell,then compare with xml """
    diffValues = convert(diffParams('PS_CellSetupReq_modify.txt', 'PS_CellSetupReq_base.txt'))
    #write2File(diffValues, 'modify_base.txt')
    #pprint(diffValues)

    
    defaultValue = parseXml('PS_CellSetupReq.xml')
    #print()
    #pprint(defaultValue)
        
    #print()
    final = compare(diffValues,defaultValue)
    #write2File(final,'diff_withdefault.txt')
    #print(final)
    
    print('main ok')
