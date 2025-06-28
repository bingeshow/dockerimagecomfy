# ========= BASE IMAGE =========
FROM nvidia/cuda:12.8.1-devel-ubuntu24.04

# ========= SYSTEM SETUP =========
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    apt-get update && \
    apt-get install -y python3.12 python3.12-venv python3-pip git curl aria2 && \
    ln -s /usr/bin/python3.12 /usr/bin/python && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ========= PYTHON ENV =========
# RUN python3.12 -m venv /opt/venv
# ENV PATH="/opt/venv/bin:$PATH"
# RUN pip install --upgrade pip
RUN python -m pip install --upgrade pip --break-system-packages

# ========= TORCH NIGHTLY INSTALL =========
# RUN pip install --pre torch==2.8.0.dev20250531+cu128 torchvision --index-url https://download.pytorch.org/whl/nightly/cu128

# ========= OPTIONAL: validate =========
# RUN python -c "import torch; print(torch.__version__, torch.version.cuda, torch.cuda.is_available())"

# ========= DEFAULT CMD =========
# 留空，pod 启动命令在 template 中指定
CMD ["sleep", "infinity"]
