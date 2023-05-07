# build stage
FROM ubuntu:22.04 AS builder

# Install the package
RUN apt-get update && apt-get install -y libopenblas-dev ninja-build build-essential python3 python3-pip
RUN python3 -m pip install --upgrade pip pytest cmake scikit-build setuptools fastapi uvicorn sse-starlette

# Install
RUN LLAMA_OPENBLAS=1 pip install llama-cpp-python[server]

# final stage
FROM builder

# We need to set the host to 0.0.0.0 to allow outside access
ENV HOST 0.0.0.0

# Run the server
CMD python3 -m llama_cpp.server
