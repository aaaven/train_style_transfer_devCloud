#! /bin/bash

mkdir data
cd data
test -f imagenet-vgg-verydeep-19.mat && rm imagenet-vgg-verydeep-19.mat
wget http://www.vlfeat.org/matconvnet/models/beta16/imagenet-vgg-verydeep-19.mat
mkdir bin
test -f train2014.zip && rm train2014.zip
wget http://msvocds.blob.core.windows.net/coco2014/train2014.zip
unzip train2014.zip
