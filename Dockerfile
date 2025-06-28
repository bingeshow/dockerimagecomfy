# ========= BASE IMAGE =========
FROM nvidia/cuda:12.8.1-runtime-ubuntu24.04

# ========= SYSTEM SETUP =========
# 安装 Python 3.12.3 及基础工具
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    apt-get update && \
    apt-get install -y python3.12 python3.12-venv python3-pip git curl aria2 && \
    ln -s /usr/bin/python3.12 /usr/bin/python

# ========= 验证 Python 版本 =========
RUN python --version

# ========= PYTHON ENV =========
RUN python3.12 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --upgrade pip

# ========= TORCH NIGHTLY INSTALL =========
RUN pip install --pre torch==2.8.0.dev20250531+cu128 torchvision --index-url https://download.pytorch.org/whl/nightly/cu128

# ========= 验证 PyTorch CUDA =========
RUN python -c "import torch; print(torch.__version__, torch.version.cuda, torch.cuda.is_available())"

# ========= CLONE COMFYUI =========
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /ComfyUI && \
    cd /ComfyUI && \
    git checkout 97f23b81f3421255ec4b425d2d8f4841207e0cd8

# ========= INSTALL COMFYUI DEPENDENCIES =========
WORKDIR /ComfyUI
RUN pip install -r requirements.txt

# ========= OPTIONAL: INSTALL EXTRA PACKAGES =========
RUN pip install numpy opencv-python onnxruntime-gpu

# ========= EXPOSE PORT =========
EXPOSE 8188

# ========= DEFAULT CMD =========
CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
