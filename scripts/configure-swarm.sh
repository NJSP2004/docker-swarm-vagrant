
#!/usr/bin/env bash
set -euo pipefail

ROLE="${1:?Informe o papel do nó}"
NODE_IP="${2:?Informe o IP do nó}"

TOKEN_FILE="/vagrant/.swarm-worker-token"
MANAGER_IP="192.168.56.10"

if [[ "$ROLE" == "master" ]]; then
    if ! docker info --format '{{.Swarm.LocalNodeState}}' | grep -qx 'active'; then
        docker swarm init --advertise-addr "$NODE_IP"
    fi

    umask 077
    docker swarm join-token -q worker > "$TOKEN_FILE"
    chmod 600 "$TOKEN_FILE" 2>/dev/null || true

elif [[ "$ROLE" == "worker" ]]; then
    if ! docker info --format '{{.Swarm.LocalNodeState}}' | grep -qx 'active'; then
        for attempt in $(seq 1 30); do
            if [[ -s "$TOKEN_FILE" ]]; then
                break
            fi
            sleep 2
        done

        if [[ ! -s "$TOKEN_FILE" ]]; then
            echo "Token do Swarm não encontrado: $TOKEN_FILE" >&2
            exit 1
        fi

        TOKEN="$(cat "$TOKEN_FILE")"
        docker swarm join \
            --token "$TOKEN" \
            "${MANAGER_IP}:2377"
    fi
else
    echo "Papel inválido: $ROLE" >&2
    exit 1
fi
