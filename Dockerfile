################################################################################
#
# Use this to build the image:
# docker build -t whisper-groq-docker .
#
################################################################################

FROM python:3.14-slim-trixie AS builder

# Disabled bytecode writing to reduce size and improve startup, further optimizations
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install groq && \
    /venv/bin/pip check && \
    /venv/bin/pip uninstall --yes pip

WORKDIR /venv

COPY run.py /venv

################################################################################

FROM python:3.14-slim-trixie AS runner

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/* && \
    # Create a non-root user for security
    groupadd -g 10000 -r run && useradd -u 10000 -M -g run run

COPY --from=builder /venv /venv

USER run

# 'exec' shreds the unnecessary /bin/sh process
CMD exec /venv/bin/python /venv/run.py
