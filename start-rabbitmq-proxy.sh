#!/usr/bin/env bash
set -Eeuo pipefail

proxy_name="${PROXY_NAME:-floci-amqp-proxy}"
proxy_port="${PROXY_PORT:-5672}"
rabbitmq_port="${RABBITMQ_PORT:-5672}"

if ! command -v docker >/dev/null 2>&1; then
  echo "Error: docker is not installed or is not on PATH." >&2
  exit 1
fi

mapfile -t rabbitmq_containers < <(
  docker ps \
    --filter "ancestor=rabbitmq:3-management" \
    --format '{{.ID}}'
)

if [[ "${#rabbitmq_containers[@]}" -eq 0 ]]; then
  echo "Error: no running container was found from image rabbitmq:3-management." >&2
  exit 1
fi

if [[ "${#rabbitmq_containers[@]}" -gt 1 ]]; then
  echo "Error: more than one rabbitmq:3-management container is running:" >&2
  printf '  %s\n' "${rabbitmq_containers[@]}" >&2
  echo "Stop the extra container or set RABBITMQ_CONTAINER_ID." >&2
  exit 1
fi

rabbitmq_container="${RABBITMQ_CONTAINER_ID:-${rabbitmq_containers[0]}}"

if ! docker inspect "$rabbitmq_container" >/dev/null 2>&1; then
  echo "Error: RabbitMQ container '$rabbitmq_container' does not exist." >&2
  exit 1
fi

rabbitmq_network="$(docker inspect \
  --format '{{range $network, $settings := .NetworkSettings.Networks}}{{println $network}}{{end}}' \
  "$rabbitmq_container" | head -n 1)"

if [[ -z "$rabbitmq_network" ]]; then
  echo "Error: could not determine the RabbitMQ container network." >&2
  exit 1
fi

if docker ps --filter "name=^/${proxy_name}$" --format '{{.Names}}' | grep -Fxq "$proxy_name"; then
  echo "Proxy '$proxy_name' is already running."
  exit 0
fi

docker rm "$proxy_name" >/dev/null 2>&1 || true

echo "Starting proxy '$proxy_name' on network '$rabbitmq_network'..."
docker run -d \
  --name "$proxy_name" \
  --network "$rabbitmq_network" \
  -p "${proxy_port}:5672" \
  alpine/socat \
  "TCP-LISTEN:5672,fork,reuseaddr" \
  "TCP:${rabbitmq_container}:${rabbitmq_port}"

echo "RabbitMQ proxy is listening on host port ${proxy_port}."
