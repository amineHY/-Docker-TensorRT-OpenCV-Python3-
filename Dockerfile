FROM nvcr.io/nvidia/tensorrt:19.05-py3

LABEL maintainer "Amine Hadj-Youcef  <hadjyoucef.amine@gmail.com>"


# install python samples for tensorrt
# RUN /opt/tensorrt/python/python_setup.sh


# install prerequisites
RUN apt-get update && apt-get install -y --no-install-recommends \
	protobuf-compiler \
	geany \
	libprotoc-dev \
	python3-tk \
	eog \
	gedit \
	build-essential \
	cmake \
	git \
	wget \
	unzip \
	yasm \
	pkg-config \
	libswscale-dev \
	libtbb2 \
	libtbb-dev \
	libjpeg-dev \
	libpng-dev \
	libtiff-dev \
	libavformat-dev \
	libpq-dev \
	&& rm -rf /var/lib/apt/lists/*



# install necessary python packages
RUN pip3 install numpy==1.16.4 \
	onnx==1.1.1 \
	pycuda==2018.1.1 \
	Pillow==6.0.0 \
	wget==3.2 \
	matplotlib==3.0.3


# Install opencv
WORKDIR /
ENV OPENCV_VERSION="3.4.6"
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
	&& unzip ${OPENCV_VERSION}.zip \
	&& mkdir /opencv-${OPENCV_VERSION}/cmake_binary \
	&& cd /opencv-${OPENCV_VERSION}/cmake_binary \
	&& cmake -DBUILD_TIFF=ON \
	-DBUILD_opencv_java=OFF \
	-DWITH_CUDA=OFF \
	-DWITH_OPENGL=ON \
	-DWITH_OPENCL=ON \
	-DWITH_IPP=ON \
	-DWITH_TBB=ON \
	-DWITH_EIGEN=ON \
	-DWITH_V4L=ON \
	-DBUILD_TESTS=OFF \
	-DBUILD_PERF_TESTS=OFF \
	-DCMAKE_BUILD_TYPE=RELEASE \
	-DCMAKE_INSTALL_PREFIX=$(python3.5 -c "import sys; print(sys.prefix)") \
	-DPYTHON_EXECUTABLE=$(which python3.5) \
	-DPYTHON_INCLUDE_DIR=$(python3.5 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
	-DPYTHON_PACKAGES_PATH=$(python3.5 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
	.. \
	&& make install \
	&& rm /${OPENCV_VERSION}.zip \
	&& rm -r /opencv-${OPENCV_VERSION}


RUN  ln -s \
    /usr/lib/python3.5/dist-packages/cv2/python-3.5/cv2.cpython-35m-x86_64-linux-gnu.so \
	/usr/local/lib/python3.5/dist-packages/cv2.so

# set the working directory
#WORKDIR /workspace



