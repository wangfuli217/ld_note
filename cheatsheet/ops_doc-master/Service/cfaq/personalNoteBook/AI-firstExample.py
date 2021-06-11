# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import tensorflow as tf

X_Data = [[1,2],[2,3],[3,1],[4,3],[5,3],[6,2]]
Y_Data = [[0],[0],[0],[1],[1],[1]]

X = tf.placeholder(tf.float32,shape = [None, 2])
Y = tf.placeholder(tf.float32,shape = [None, 1])

W = tf.Variable(tf.random_normal([2,1]), name = 'weight')
b = tf.Variable(tf.random_normal([1,1]), name = 'bias')

H =   tf.sigmoid(tf.matmul(X, W) + b)

cost = -tf.reduce_mean(Y*tf.log(H) + (1-Y)*tf.log(1-H))

optimizer = tf.train.GradientDescentOptimizer(learning_rate = 0.01)

train = optimizer.minimize(cost)

predict = tf.cast(H > 0.5, dtype = tf.float32 )
accuracy = tf.reduce_mean(tf.cast(tf.equal(predict, Y),dtype = tf.float32))

with tf.Session() as sess:
    sess.run(tf.global_variables_initializer())
    for step in range(2001):
        cost_value, _= sess.run([cost, train], feed_dict = {X: X_Data, Y: Y_Data} )
        if step%20 == 0:
            print(step, cost_value)
    
    h,p,a = sess.run([H,predict,accuracy], feed_dict={X: X_Data,Y:Y_Data})
    print('outputvalue: ',h)
    print('predict with threashold:',p)
    print('accuracy:',a)
    



