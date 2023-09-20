FROM saladtechnologies/sdnext:latest

ARG MODEL_ID=131579
ENV MODEL_ID=${MODEL_ID}
ENV REFINER_MODEL_ID=stabilityai/stable-diffusion-xl-refiner-1.0
ENV CKPT=${DATA_DIR}/models/Stable-diffusion/base/base.safetensors
ENV REFINER=${DATA_DIR}/models/Stable-diffusion/refiner/refiner.safetensors

# Get the base model
RUN mkdir -p ${DATA_DIR}/models/Stable-diffusion/base
RUN wget "https://civitai.com/api/download/models/${MODEL_ID}" \
    -O "${CKPT}"

# Get the refiner model
RUN mkdir -p ${DATA_DIR}/models/Stable-diffusion/refiner
RUN wget "https://huggingface.co/${REFINER_MODEL_ID}/resolve/main/sd_xl_refiner_1.0.safetensors" \
    -O "${REFINER}"

ENV HOST='0.0.0.0'
ENV PORT=7860

ENTRYPOINT [  ]
CMD ["/bin/bash", "-c", "${INSTALLDIR}/entrypoint.sh \
    --backend diffusers \
    --use-cuda \
    --no-download \
    --docs \
    --ckpt ${CKPT} \
    --quick \
    --server-name \"${HOST}\" \
    --port ${PORT}" ]