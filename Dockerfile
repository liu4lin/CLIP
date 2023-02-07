FROM nvidia/cuda:11.4.2-cudnn8-devel-ubuntu20.04

#Switch to Aliyun mirrors from Ubuntu official for acceleration
RUN sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list
RUN sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list

#Solve the GPG error "public key is not available"
RUN rm /etc/apt/sources.list.d/cuda.list
RUN apt update
RUN apt install -y wget

#Install the conda package
ADD https://repo.anaconda.com/miniconda/Miniconda3-py310_22.11.1-1-Linux-x86_64.sh .
RUN bash Miniconda3-py310_22.11.1-1-Linux-x86_64.sh -b
ENV PATH="/root/miniconda3/bin:${PATH}"

#Install the requirements of CLIP
RUN conda install pytorch torchvision -c pytorch -c nvidia
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install ftfy regex tqdm

#Install the CLIP package
RUN mkdir -p /usr/src/app
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN python setup.py install

#Docker commands note
#sudo docker build -t clip:1.0 -f Dockerfile .
#sudo docker run -it -p 8080:80 -v $PWD:/tmp -w /tmp --rm clip:1.0 bash
