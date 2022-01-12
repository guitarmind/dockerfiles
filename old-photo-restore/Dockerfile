FROM nvidia/cuda:11.1-cudnn8-devel-ubuntu20.04

WORKDIR /workspace
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install \
  git bzip2 wget unzip python3-pip python3-dev cmake libgl1-mesa-dev python-is-python3 libgtk2.0-dev -yq && \

  git clone https://github.com/microsoft/Bringing-Old-Photos-Back-to-Life.git && \
  cd Bringing-Old-Photos-Back-to-Life && \

  cd Face_Enhancement/models/networks/ && \
  git clone https://github.com/vacancy/Synchronized-BatchNorm-PyTorch && \
  cp -rf Synchronized-BatchNorm-PyTorch/sync_batchnorm . && \
  cd ../../../ && \

  cd Global/detection_models && \
  git clone https://github.com/vacancy/Synchronized-BatchNorm-PyTorch && \
  cp -rf Synchronized-BatchNorm-PyTorch/sync_batchnorm . && \
  cd ../../ && \
 
  cd Face_Detection/ && \
  wget http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2 && \
  bzip2 -d shape_predictor_68_face_landmarks.dat.bz2 && \
  cd ../ && \

  cd Face_Enhancement/ && \
  wget https://facevc.blob.core.windows.net/zhanbo/old_photo/pretrain/Face_Enhancement/checkpoints.zip && \
  unzip checkpoints.zip && \
  cd ../ && \
  cd Global/ && \
  wget https://facevc.blob.core.windows.net/zhanbo/old_photo/pretrain/Global/checkpoints.zip && \
  unzip checkpoints.zip && \
  rm -f checkpoints.zip && \
  cd ../ && \

  pip3 install numpy dlib && \
  pip3 install -r requirements.txt && \
  git clone https://github.com/NVlabs/SPADE.git && \
  cd SPADE/ && pip3 install -r requirements.txt && \
  cd ..

CMD ["python3", "run.py"]
