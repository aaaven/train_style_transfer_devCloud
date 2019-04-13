# 使用 INTEL devCloud 训练ml5风格转移模型 [English Version](README.md)

此代码仓是[ml5/training-styletransfer](https://github.com/ml5js/training-styletransfer)的微调版本。由于[英特尔devCloud](https://software.intel.com/en-us/ai/devcloud) 是基于CPU的，因此在代码和特殊环境设置上有一些调整。此方法是为2019年春季上海纽约大学的交互式机器学习课程准备的。
 [Class website](https://wp.nyu.edu/shanghai-ima-interactivemachinelearning/) + [Code repo](https://github.com/imachines/IMA-Interactive-Machine-Learning).

* [英特尔DevCloud](https://software.intel.com/en-us/ai/devcloud)是免费开放注册并无偿使用！所以每个人都可以尝试使用这个项目训练自己的神经风格转移模型！这个项目的训练在DevCloud上大约需要20个小时。

## Step-by-step Guide on DevCloud 分步指南

### 1) 登录英特尔DevCloud

```bash
ssh colfax
```

### 2) 克隆此项目

```bash
git clone https://github.com/aaaven/train_style_transfer_devCloud
```

### 3) 登录计算节点和设置环境
- 登录计算节点

```bash
qsub -l walltime=24:00:00 -I
```
- 使用Conda和environment.yml设置环境：

```bash
cd train_style_transfer_devCloud
conda env create -f environment.yml
```
- 检查并激活环境

```bash
source activate styletransferml5
```
* 如果一切正常，则应激活名为StyleTransferML5的Conda env。

- 下载数据集

```bash
sh setup.sh
```
根据网络状况，这可能需要一段时间下载（14 GB COCO数据集）。一旦下载准备就绪，你就可以关闭当前终端窗口。

### 4) 选择，上传目标风格图像和train.sh
- 将要训练样式的图像放在/images文件夹中；
* 在计算机上打开一个新的终端窗口，并使用以下命令传输图像。

```bash
cd YOURIMAGE_path
scp YOURIMAGE_name colfax:train_style_transfer_devCloud/images
```


* 创建train.sh，复制粘贴以下代码并保存，记住将your-image.jpg更改为上传到colfax的图像名（注意文件格式），并将u24235更改为你的intel id。

```bash
source activate styletransferml5
cd /home/u24235/train_style_transfer_devCloud/

export PYTHONUNBUFFERED=0
python style.py --style images/YOURIMAGE.jpg \
  --checkpoint-dir checkpoints/ \
  --model-dir models/ \
  --test images/violetaparra.jpg \
  --test-dir tests/ \
  --content-weight 1.5e1 \
  --checkpoint-iterations 1000 \
  --batch-size 32
```

* 将train.sh上传到colfax：

```bash
cd path_to_trainsh
scp train.sh colfax:
```

* 更多训练参数细节可以在[这里](https://github.com/lengstrom/fast-style-transfer#documentation) and [here](https://github.com/lengstrom/fast-style-transfer/blob/master/docs.md)被找到。


### 5) 登陆“登陆节点”并开始训练
- 使用新的termial窗口登录log-in-node

```bash
ssh colfax
```

- 使用qsub命令提交训练任务

```bash
qsub -l walltime=24:00:00 -k oe train.sh
```
- 如果训练任务已结束，您将在当前主目录中找到两个文件 -  train.sh.e1234和train.sh.o1234  

- 使用view或tail命令进行检查。用命令：

```bash
view train.sh.e1234
```

- 你应该什么也看不见，因为这假设是错误日志。用命令：

```bash
tail train.sh.o1234
```

- 你应该看到这样的东西：

```
ml5.js Style Transfer Training!
Note: This traning will take a couple of hours.
Training is starting!...
Train set has been trimmed slightly..
(1, 451, 670, 3)
UID: 56
```

### 6) 使用它！
模型准备好后，您的模型将位于模型/文件夹中。使用scp命令将其复制到本地计算机（打开一个新终端）。

```bash
scp -r colfax:train_style_transfer_devCloud/models your_new_style_name
```

您只需要在ml5中加载这个模型：

```javascript
let style = new ml5.styleTransfer('./models/your_new_style_name');
```

您还可以在此处找到示例：[使用ml5js的风格转换模型](https://github.com/aaaven/inference_style_transfer_ml5)
