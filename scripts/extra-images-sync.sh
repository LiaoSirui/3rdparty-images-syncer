#!/usr/bin/env bash

export SKOPEO_SYNC_COMMAND=(
    "skopeo" "sync"
    "--insecure-policy"
    "--src-tls-verify=false" "--dest-tls-verify=false"
    "--dest-authfile=/root/.docker/config.json"
    "--retry-times=10"
    "--all"
    # "--scoped"
    "--src" "docker" "--dest" "docker"
)

: "${DEVOPS_3RDPARTY_REPO:="harbor.alpha-quant.com.cn:5000/3rd_party"}"
export DEVOPS_3RDPARTY_REPO

# "${SKOPEO_SYNC_COMMAND[@]}" registry.k8s.io/coredns/coredns:v1.10.1 "${DEVOPS_3RDPARTY_REPO}"/registry.k8s.io
# "${SKOPEO_SYNC_COMMAND[@]}" registry.k8s.io/etcd:3.5.6-0 "${DEVOPS_3RDPARTY_REPO}"/registry.k8s.io
# "${SKOPEO_SYNC_COMMAND[@]}" registry.k8s.io/kube-apiserver:v1.26.1 "${DEVOPS_3RDPARTY_REPO}"/registry.k8s.io
# "${SKOPEO_SYNC_COMMAND[@]}" registry.k8s.io/kube-controller-manager:v1.26.1 "${DEVOPS_3RDPARTY_REPO}"/registry.k8s.io
# "${SKOPEO_SYNC_COMMAND[@]}" registry.k8s.io/kube-proxy:v1.26.1 "${DEVOPS_3RDPARTY_REPO}"/registry.k8s.io
# "${SKOPEO_SYNC_COMMAND[@]}" registry.k8s.io/kube-scheduler:v1.26.1 "${DEVOPS_3RDPARTY_REPO}"/registry.k8s.io
# "${SKOPEO_SYNC_COMMAND[@]}" registry.k8s.io/pause:"3.9" "${DEVOPS_3RDPARTY_REPO}"/registry.k8s.io
