#! /bin/bash

export PYTHONUNBUFFERED=0
python style.py --style images/zaha_hadid.jpg \
  --checkpoint-dir checkpoints/ \
  --model-dir models/ \
  --test images/violetaparra.jpg \
  --test-dir tests/ \
  --content-weight 1.5e1 \
  --checkpoint-iterations 100 \
  --batch-size 32
