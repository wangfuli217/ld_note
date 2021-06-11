# -*- coding: utf-8 -*-
"""
Created on Thu Mar 15 10:23:33 2018

@author: lianzeng
"""

#data from  https://github.com/caicloud/tensorflow-tutorial/tree/master/Deep_Learning_with_TensorFlow/datasets/MNIST_data


import struct
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
import random
tf.set_random_seed(777)  # for reproducibility
#data format refer to:  http://yann.lecun.com/exdb/mnist/
IMAGE_FILE_HEADER_SIZE = 16 
LABEL_FILE_HEADER_SIZE = 8
LABEL_NUM = 10



def imshow(img, size):
    img = img.reshape(size)    
    plt.imshow(img,cmap='Greys',interpolation='nearest')
    plt.show()

def readImag(filename): 
    ''' read binary struct file,return img[None, 784]        '''
    with open(filename, 'rb') as f:
        magic, num, rows, cols = struct.unpack(">IIII", f.read(IMAGE_FILE_HEADER_SIZE))
        img = np.fromfile(f, dtype=np.uint8).reshape(num, rows*cols)
        #imshow(img[0],[rows,cols])
        return img
        

def readLable(filename):
    ''' return matrix[None, LABEL_NUM]'''
    with open(filename, 'rb') as f:
        magic, num = struct.unpack(">II", f.read(LABEL_FILE_HEADER_SIZE))
        labels = np.fromfile(f, dtype=np.uint8) #labels[0] = 7   
    return tf.one_hot(labels, LABEL_NUM)    
   
        
      
def getBatch(data,label,batchIndex,batchSize):
    xs = data[batchIndex*batchSize : (batchIndex + 1)*batchSize]
    ys = label[batchIndex*batchSize : (batchIndex + 1)*batchSize]
    assert(xs.shape == (batchSize,784) )
    assert(ys.shape == (batchSize,LABEL_NUM) )
    #imshow(xs[0],[28,28])
    #print(ys[0])        
    return (xs,ys)


X = tf.placeholder(tf.float32, shape = [None,784]) #28*28 = 784, image size
Y = tf.placeholder(tf.float32, shape = [None,LABEL_NUM])
W = tf.Variable(tf.random_normal([784, LABEL_NUM]))
b = tf.Variable(tf.random_normal([LABEL_NUM]))
'''
H = tf.nn.softmax(tf.matmul(X,W) + b)
cost = tf.reduce_mean(-tf.reduce_sum(Y * tf.log(H), axis=1)) #no work,why??
optimizer = tf.train.GradientDescentOptimizer(learning_rate=0.1).minimize(cost)
'''
H = tf.matmul(X,W) + b
cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(logits = H, labels = Y))
optimizer = tf.train.AdamOptimizer(learning_rate = 0.01).minimize(cost)

correct_prediction = tf.equal(tf.argmax(H, 1), tf.argmax(Y, 1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

training_epochs = 15
batch_size = 100

if __name__ == '__main__':
    trainImg = readImag('./MNistData/train-images.idx3-ubyte') #shape=(10000,784)
    trainLabels = readLable('./MNistData/train-labels.idx1-ubyte')
    testImg = readImag('./MNistData/t10k-images.idx3-ubyte') #shape=(10000,784)
    testLabels = readLable('./MNistData/t10k-labels.idx1-ubyte')
    numExamples = trainImg.shape[0]
    assert(numExamples == 60000)
    
    
    with tf.Session() as sess:
        trainLabels = sess.run(trainLabels)#tensor --> numpy.ndarray
        testLabels = sess.run(testLabels)
        sess.run(tf.global_variables_initializer())
        for epoch in range(training_epochs):            
            batchNum = numExamples//batch_size
            assert(batchNum == 600)
            avg_cost = 0
            for i in range(batchNum):
                batch_xs, batch_ys = getBatch(trainImg,trainLabels,i,batch_size)
                c,_ = sess.run([cost,optimizer],feed_dict = {X:batch_xs, Y:batch_ys})
                avg_cost += c/batchNum
                
            print('Epoch:','%04d' %(epoch+1), 'cost = ','{:.9f}'.format(avg_cost))
            
        print('Learning Finished!')    
        print("Accuracy: ", sess.run(accuracy, feed_dict = {X:testImg, Y:testLabels}) )        
        
        #Get one and predict
        r = random.randint(0, testImg.shape[0]-1)
        predict = sess.run(tf.argmax(H,1), feed_dict={X:testImg[r:r+1]})
        print('predict: ', predict, ' Label: ',sess.run(tf.argmax(testLabels[r:r+1],1)))
        imshow(testImg[r:r+1],[28,28])
        
    
            
 ///////////////////////////////////output
'''
Epoch: 0001 cost =  362.105439916
Epoch: 0002 cost =  117.222675434
Epoch: 0003 cost =  91.428492891
Epoch: 0004 cost =  77.258645783
Epoch: 0005 cost =  68.427426186
Epoch: 0006 cost =  62.208863269
Epoch: 0007 cost =  56.648760489
Epoch: 0008 cost =  52.277398214
Epoch: 0009 cost =  49.499239092
Epoch: 0010 cost =  48.033059193
Epoch: 0011 cost =  45.726984806
Epoch: 0012 cost =  43.778515391
Epoch: 0013 cost =  42.320477688
Epoch: 0014 cost =  40.973845763
Epoch: 0015 cost =  40.108077409
Learning Finished!
Accuracy:  0.8794
predict:  [9]  Label:  [9]
''' 
