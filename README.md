# Train ml5 style transfer model with INTEL devCloud

This repository contains a slightly modified version of [ml5/training-styletransfer](https://github.com/ml5js/training-styletransfer). Since [INTEL devCloud](https://software.intel.com/en-us/ai/devcloud) is cpu based, there are some tweaks on the code as well as special environment setup. This approach is prepared for Interactive Machine Learning Class taught at NYU Shanghai, spring 2019. [Class website](https://wp.nyu.edu/shanghai-ima-interactivemachinelearning/) + [Code repo](https://github.com/imachines/IMA-Interactive-Machine-Learning).

* [INTEL DevCloud](https://software.intel.com/en-us/ai/devcloud) provides free access to everyone! So everyone can try your own neural style transfer with this repo! This training will take around 20 hours on the devCloud.

## Step-by-step Guide on DevCloud
### 1) Log in INTEL DevCloud

```bash
ssh colfax
```

### 2) Clone this Project

```bash
git clone https://github.com/aaaven/train_style_transfer_devCloud
```

### 3) Log in Compute Node and Setup Environment
- Log in Compute Node

```bash
qsub -l walltime=24:00:00 -I
```
- Set up environment with conda and environment.yml:

```bash
cd train_style_transfer_devCloud
conda env create -f environment.yml
```
- Check and Activate Environment

```bash
source activate styletransferml5
```
* conda env titled styletransferml5 should be activated if everything went right.

- Download Dataset
```bash
sh setup.sh
```
This could take a while (download 14 GB COCO dataset) based on the internet condition. Once the download is ready, you can terminate current terminal window.

### 4) Select, upload a style image and train.sh

- Put the image you want to train the style on, in the `/images` folder;
* open a new terminal window on your computer and use following command to transfer image.

```bash
cd YOURIMAGE_path
scp YOURIMAGE_name colfax:train_style_transfer_devCloud/images
```


* create **train.sh** with copy paste in following code and save, remember change the **YOURIMAGE.jpg**  to the image name you upload to colfax (pay attention to the file format) and change **u24235** to your intel ID.
```bash
source activate styletransferml5
cd /home/u24235/training_styletransfer_devCloud/

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

upload train.sh to colfax:

```bash
cd path_to_trainsh
scp train.sh colfax:
```

* You can learn more about how to use all the parameters for training in the on the original repository for this code [here](https://github.com/lengstrom/fast-style-transfer#documentation) and [here](https://github.com/lengstrom/fast-style-transfer/blob/master/docs.md).


### 5) Log in log-in-node and Start the training
- Log in log-in-node with a new termial window

```bash
ssh colfax
```

- Use qsub command to summit the training task

```bash
qsub -l walltime=24:00:00 -k oe train.sh
```

- If the training task is summited, you will find two files in your current home directory - **train.sh.e1234** and **train.sh.o1234** - use **view** or **tail** command to check. With command:

```bash
view train.sh.e1234
```

you should see nothing because this suppose to be the error log.  And with command:

```bash
tail train.sh.o1234
```

you should see something like this:

```
ml5.js Style Transfer Training!
Note: This traning will take a couple of hours.
Training is starting!...
Train set has been trimmed slightly..
(1, 451, 670, 3)
UID: 56
```

### 6) Use it!

Once the model is ready, your model will be in the `models/` folder. Use scp command to copy it to your local computer.(open a new terminal)

```bash
scp -r colfax:train_style_transfer_devCloud/models your_new_style_name
```

You will just need to point to it in your ml5 sketch:

```javascript
let style = new ml5.styleTransfer('./models/your_new_style_name');
```

You can also find a example here: [Inference style transfer model with ml5js](https://github.com/aaaven/inference_style_transfer_ml5)
