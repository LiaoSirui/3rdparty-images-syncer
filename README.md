<div align="center">
<h1 align="center"> 3rdparty-image-syncer </h1>
<p align="center">
第三方镜像同步工具
</p>
<p align="center">
  <img src="https://img.shields.io/badge/Maintainer-cyril@liaosirui.com-blue.svg">
  <img src="https://img.shields.io/badge/Language-Shell-green.svg">
  <img src="https://img.shields.io/badge/Dependencies-skepoe,harbor-yellow.svg">
</p>
</div>

- [使用说明](#使用说明)
- [设计简述](#设计简述)
- [更多文档](#更多文档)

## 使用说明

提供的脚本如下：

```text
scripts
├── common.sh          # 公共脚本部分
├── show-images.sh     # 显示所有的第三方镜像
├── show-raw-images.sh # 显示所有的原始第三方镜像
└── sync-image.sh      # 同步指定的镜像
```

使用只需要将镜像添加到 `source-images.list`：

```bash
docker/dockerfile:1.4.3
docker/dockerfile:1.4.3-labs
```

拷贝好镜像后，可以直接从 harbor 查看镜像，也可以使用如下的命令查看：

```bash
# 查看 amd64 架构的镜像
skopeo inspect --override-arch amd64 --tls-verify=false \
  docker://jcr.local.liaosirui.com:5000/third/docker.io/docker/dockerfile:1.4

# 查看 arm64 架构的镜像
skopeo inspect --override-arch arm64 --tls-verify=false \
  docker://jcr.local.liaosirui.com:5000/third/docker.io/docker/dockerfile:1.4
```

注意：这些镜像无论如何都不能在产品中直接使用，会有如下问题：

（1）镜像名称过长

（2）镜像中之所以包含原始镜像 url 是为了方便核对，这些信息不需要暴露

## 设计简述

镜像拷贝会执行如下的命令：

```bash
skopeo sync \
    --insecure-policy --src-tls-verify=false --dest-tls-verify=false \
    --dest-authfile /root/.docker/config.json \ # 使用 docker 的 config.json 进行认证
    --retry-times 10 \ # 失败重试 10 次
    --all \ # 拷贝所有镜像
    --scoped \ # 保留镜像命名结构
    --src docker --dest docker \
    rockylinux:9.0.20220720 jcr.local.liaosirui.com:5000/third
```

镜像同步后会转换出如下的地址：

```bash
# 注意，这里增加了 docker.io/library
rockylinux:9.0.20220720 -> \
  jcr.local.liaosirui.com:5000/third/docker.io/library/rockylinux:9.0.20220720

# 注意，这里增加了 docker.io
docker/dockerfile:1.4.3-labs -> \
  jcr.local.liaosirui.com:5000/third/docker.io/docker/dockerfile:1.4.3-labs

# 普通的镜像
k8s.gcr.io/pause:3.6 -> \
  jcr.local.liaosirui.com:5000/third/k8s.gcr.io/pause:3.6
quay.io/prometheus-operator/prometheus-operator:v0.47.0 -> \
  jcr.local.liaosirui.com:5000/third/quay.io/prometheus-operator/prometheus-operator:v0.47.0
```

## 更多文档

- [skopeo](https://github.com/containers/skopeo) is a command line utility that performs various operations on container images and image repositories
