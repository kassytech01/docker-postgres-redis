# Build PostgreSQL and Redis with docker-compose

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

ローカルに「PostgreSQL+Redis」の環境をコマンド1発で構築することを目的に用意したプロジェクトです。dockerを使用することで環境の更新（データベースの切り替え）を素早く行える状態を実現します。

**補足：**  
OSが32bitの場合、RedisのDockerfileを一部書き換える必要があります。

## Installed Version

- PostgreSQL - 9.6.6
- Redis - 3.2.10

## Description

環境構築の方法は、以下の2通りから選択してください。

1. Vagrant＋docker-compose
2. docker-compose

## Usage - [1\. Vagrant＋docker-compose]

主に、Windows環境での利用を想定しています。

### Run

以下のコマンドを実行すれば、環境が立ち上がります。

```
$ vagrant up
```

dockerが標準インストールされている軽量Linuxの`CoreOS`に`docker-compose`をインストールして、PostgreSQLとRedisのDockerコンテナが自動起動するようになっています。

### Preparation

実行にはVagrantのインストールが必要です。

#### VirtualBoxをインストール

VirtualBoxをダウンロードして、インストールします。

- VirtualBox - <http://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html?ssSourceSiteId=otnjp>

#### Vagrantのインストール

Vagrantをダウンロードして、インストールします。

- Vagrant - <https://www.vagrantup.com/downloads.html>

#### Vagrant WinNFSdのインストール

synced_folderにnfsを使用しているので、Windowsは[Vagrant WinNFSd](https://github.com/winnfsd/vagrant-winnfsd)をインストールしてください。

```
$ vagrant plugin install vagrant-winnfsd
```

### Command Tips

仮想マシンを起動します。

```
$ vagrant up
```

仮想マシンを停止します。

```
$ vagrant halt
```

仮想マシンにsshログインします。

```
$ vagrant ssh
```

仮想マシンを破棄します。

```
$ vagrant destroy
```

ヘルプを表示します。

```
$ vagrant -h
```

## Usage - [2\. docker-compose]

主に、Unix系の環境での利用を想定しています。
以下は、Ubuntuでの利用を前提に記載しています。Macの場合など、適宜読み替えてください。

### Run

以下のコマンドを実行すれば、環境が立ち上がります。

```
$ docker-compose -f ./docker/docker-compose.yml up -d
```

PostgreSQLとRedisのDockerコンテナが自動起動するようになっています。

### Preparation

実行にはdockerとdocker-composeのインストールが必要です。

#### Docker CEのインストール

Dockerの公式サイトを参照して、インストールします。

- Get Docker CE for Ubuntu - https://docs.docker.com/install/linux/docker-ce/ubuntu/

```
# Dockerのインストールに必要なパッケージをインストール
$ sudo apt-get update
$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# GPGキーを追加
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Dockerリポジトリを追加
$ sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

# Docker CEをインストール
$ sudo apt-get update
$ sudo apt-get install docker-ce

# インストール確認
$ docker -v
Docker version 1.13.1, build ...
```

sudoなしで、dockerコマンドが実行できるように以下を実行します。

```
$ sudo usermod -aG docker $(whoami)
```

#### Docker Composeのインストール

```
$ sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose

# 確認
$ docker-compose --version
docker-compose version 1.19.0, build ...
```

### Command Tips

dockerを起動します（-d:バックグラウンド）。初回起動時のみビルドを実行します。

```
$ docker-compose -f ./docker/docker-compose.yml up -d
```

dockerを起動します（-d:バックグラウンド／--build：リビルド）

```
$ docker-compose -f ./docker/docker-compose.yml up -d --build
```

dockerを停止します（コンテナとネットワークも削除します）。

```
$ docker-compose down
```

コンテナの一覧を表示します。

```
$ docker-compose ps
```

## Detail

### 実行時の動作について

- データベースの初期化（initdb）

### 接続情報

ポートフォワーディングにて接続します。

**PostgreSQLの接続情報:**

Property | Value
:------- | :--------
HostName | localhost
Port     | 5432
User     | postgres
Password | postgres
Database | postgres

**Redisの接続情報**

Property | Value
:------- | :--------
HostName | localhost
Port     |
User     |
Password |
Database |

## Commands

**dockerにbashログイン**

```
$ vagrant ssh

# PostgreSQL
$ docker exec -it docker_database_1 bash

# Redis
$
```

**docker-compose実行時ログ**

```
$ vagrant ssh

# CoreOS login
$ cd /tmp/docker
$ ls docker-compose.yml
docker-compose.yml
$ docker-compose logs
```

**pg_dump**

```
# pg_dump実行
$ pg_dump -h localhost -p 5432 -U postgres -f dump postgres
or
$ docker exec docker_database_1 pg_dump -h localhost -p 5432 -U postgres -f dump postgres | docker cp docker_database_1:/dump /tmp/docker/

# .gz化（Windowsの場合は7-Zipなどを利用）
$ gzip dump
```

## Anything Else

動作確認した環境は以下の通りです。

### Vagrant＋docker-compose環境

* OS
  - Windows 10
* Software
  - VirtualBox 5.2.6
  - Vagrant 2.0.2
  - CoreOS alpha (1675.0.1)
  - docker 18.01.0-ce,
  - docker-compose 1.19.0

### docker-compose環境

* OS
  - Ubuntu 16.04LTS
* Software
  - docker 1.13.1
  - docker-compose 1.19.0

## Author

日経BP社 春日 峻（tkasuga）

## Licence

- [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
- 日本語訳 [licenses/Apache_License_2.0](https://ja.osdn.net/projects/opensource/wiki/licenses%2FApache_License_2.0)
