# RunDiffusion XL
This uses the [sdnext api container](https://github.com/SaladTechnologies/sdnext/tree/docker-build) to serve [RunDiffusionXL](https://civitai.com/models/120964/rundiffusion-xl)

## Build

```shell
docker buildx build \
-t saladtechnologies/sdnext-rundiffusion-xl:latest \
--provenance=false \
--output type=docker \
.
```

## Run

```shell
docker run \
--gpus all \
-p 7860:7860 \
-e PORT=7860 \
-e HOST=0.0.0.0 \
saladtechnologies/sdnext-rundiffusion-xl:latest
```

For ipv6 networking, make sure you have the network created:
```shell
docker network create --ipv6 --subnet 2001:0DB8::/112 ip6net
```

and then run the container with the network and the host set to `[::]` (ipv6 all interfaces)
```shell
docker run \
--rm \
--gpus all \
-p 7860:7860 \
-e PORT=7860 \
-e HOST='[::]' \
--network="ip6net" \
saladtechnologies/sdnext-rundiffusion-xl:latest
```

## Enable Refiner

```shell
curl -X 'POST' \
  'http://localhost:7860/sdapi/v1/options' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "sd_model_refiner": "refiner/refiner.safetensors"
}'
```

## Test

```shell
curl -X 'POST' \
  'http://localhost:7860/sdapi/v1/txt2img' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "prompt": "iron man made of lava",
  "batch_size": 1,
  "steps": 20,
  "refiner_start": 20,
  "denoising_strength": 0.43,
  "cfg_scale": 7,
  "width": 896,
  "height": 1216,
  "send_images": true,
  "save_images": false,
  "enable_hr": true,
  "hr_second_pass_steps": 35,
  "hr_upscaler": "None"
}' \
 -o ./response.json
```

```shell
cat response.json | jq -r '.images[0]' | base64 -d > ironman.jpg
```