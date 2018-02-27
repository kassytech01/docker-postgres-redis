# Build PostgreSQL and Redis with docker-compose

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

ローカルに「PostgreSQL+Redis」の環境をコマンド1発で構築することを目的に用意したプロジェクトです。dockerを使用することで環境の更新（データベースの切り替え）を素早く行えます。

**補足：**  
※OSが32bitの場合、RedisのDockerfileを一部書き換える必要があります。

## Installed Version

- PostgreSQL - 9.6.6
- Redis - 3.2.10

## Description

環境構築の方法は、以下の2通りから選択してください。

1. Vagrant＋docker-compose（主にWindows環境を想定）
2. docker-compose（主にUnix系の環境を想定）

## Usage - [1\. Vagrant＋docker-compose]

主に、Windows環境での利用を想定しています。

### Run

以下のコマンドを実行します。

```
$ vagrant up
```

dockerが標準インストールされている軽量Linuxの`CoreOS`に`docker-compose`がインストールされ、PostgreSQLとRedisのDockerコンテナが自動起動するようになっています。

### Preparation

実行にはVagrantの実行環境が必要です。

#### VirtualBoxをインストール

- VirtualBox - http://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html?ssSourceSiteId=otnjp

#### Vagrantのインストール

- Vagrant - https://www.vagrantup.com/downloads.html

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

以下のコマンドを実行します。

```
$ docker-compose -f ./docker/docker-compose.yml up -d
```

PostgreSQLとRedisのDockerコンテナが自動起動するようになっています。

### Preparation

実行にはdocker-composeの実行環境が必要です。

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

#### データベースの初期化（initdb）

Docker PostgreSQLの公式イメージは、DBを初期化する仕組みが導入されています。

##### 動作の仕組み

/docker-entrypoint-initdb.dに.sqlや.sh、.sql.gzを置いておけば初回起動時に実行してくれます。

**公式イメージ：**
https://hub.docker.com/_/postgres/

`docker-entrypoint.sh`
```
for f in /docker-entrypoint-initdb.d/*; do
    case "$f" in
        *.sh)     echo "$0: running $f"; . "$f" ;;
        *.sql)    echo "$0: running $f"; "${psql[@]}" -f "$f"; echo ;;
        *.sql.gz) echo "$0: running $f"; gunzip -c "$f" | "${psql[@]}"; echo ;;
        *)        echo "$0: ignoring $f" ;;
    esac
    echo
done
```

そこで、このプロジェクトでは、./postgresql/initにデータベース初期化用の実行ファイルとデータを格納しておきます。


```
+ docker-commpose.yml
+- postgresql/
　+- init/
    + 1_dump.sql.gz
    + 2_create_table.sql
    + 3_import.sh
```



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
Port     | 6379
User     |
Password |

## Commands

**dockerにbashログイン**

```
$ vagrant ssh

# PostgreSQLコンテナにログイン
$ docker exec -it docker_database_1 bash

# Redisコンテナにログイン
$ docker exec -it docker_redis_1 bash
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
