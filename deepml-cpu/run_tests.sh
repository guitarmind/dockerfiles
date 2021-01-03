#!/bin/bash

ret=0

echo "Test loading OpenCV module ......"
python -c "import cv2; print(cv2.__version__)"
out=$?
if [ $out -ne 0 ]; then ret=$out; fi

echo "Test loading Tensorflow module ......"
python -c "import tensorflow as tf; print(tf.__version__)"
out=$?
if [ $out -ne 0 ]; then ret=$out; fi

echo "Test loading PyTorch module ......"
python -c "import torch; print(torch.__version__)"
out=$?
if [ $out -ne 0 ]; then ret=$out; fi

if [ $ret -ne 0 ]; then
  echo "Tests failed."
else
  echo "Tests passed."
fi

exit $ret;