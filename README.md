# Build PostgreSQL and Redis with docker-compose

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

ローカル環境に「PostgreSQL+Redis」をコマンド1発で構築します。

## Description

`docker-compose`を使用して環境を構築します。環境構築の方法は、以下の2通りから選択してください。

1. Vagrant＋docker-compose
2. docker-compose

ローカル環境の構築にdockerを使用することで、環境の更新（データベースの破棄と構築）を素早く行うことができるようになります。

## Installed Version

- PostgreSQL - 9.6.6
- Redis XXXXXXXXXXXXXXXXXXXXXXXX

## Usage

### **1\. Vagrant＋docker-compose環境**

```
$ vagrant up
```

dockerが標準インストールされている軽量Linuxの`CoreOS`を使用します。CoreOSに`docker-compose`をインストールして、PostgreSQLとRedisのDockerコンテナが自動起動するようになっています。

**Note:** 実行には[Vagrantのインストール](#Installation)が必要です。

### **2\. docker-compose環境**

```
$ docker-compose -f ./docker/docker-compose.yml up -d
```

PostgreSQLとRedisのDockerコンテナが自動起動するようになっています。

**Note:** 実行にはdocker-composeのインストールが必要です。

### 実行時の動作

### 接続情報

- PostgreSQLの接続情報

Property | Value
:------- | :--------
HostName | localhost
Port     | 5432
User     | postgres
Password | postgres
Database | postgres

### Installation

#### Vagrant

Vagrantをダウンロードして、インストールを実施します。

- Vagrant - <https://www.vagrantup.com/downloads.html>

synced_folderにnfsを使用しているので、Windowsは[Vagrant WinNFSd](https://github.com/winnfsd/vagrant-winnfsd)をインストールしてください。

```
$ vagrant plugin install vagrant-winnfsd
```

Vagrantを起動します。

```
$ vagrant up
```

## 各コマンド

- dockerにbashログイン

```
$ vagrant ssh
$ docker exec -it docker_database_1 bash
```

- pg_dump

```
$ c:\develop\nmo\PostgreSQL\9.6\bin\pg_dump -h localhost -p 5432 -U postgres -f dump postgres
$ gzip dump
```

## Anything Else

動作確認した環境は以下の通りです。

- Vagrant＋docker-compose環境：Windows 10
- docker-compose：Ubuntu 16.04LTS

## Author

日経BP社 春日 峻（tkasuga）

## Licence

- [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
- 日本語訳 [licenses/Apache_License_2.0](https://ja.osdn.net/projects/opensource/wiki/licenses%2FApache_License_2.0)
