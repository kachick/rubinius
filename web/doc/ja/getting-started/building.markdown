---
layout: doc_ja
title: Rubinius のビルド
previous: 必要要件
previous_url: getting-started/requirements
next: Rubinius の実行
next_url: getting-started/running-rubinius
---

実行するだけであれば、インストールの手間を掛けずにソースディレクトリからビルドする事も可能です。
以下の記事では、インストール手順と、ソースディレクトリからビルドする手順の両方を解説します。

Rubinius は JITコンパイラ として LLVM を使用します。 また、 C++ RTTI (run-time type
 information) を有効にした上でビルドされた、特定バージョンの LLVM に依存します。
依存先として有効な LLVM がインストールされているかどうかは、 configure スクリプトが自動的に
チェックします。
なんらかの理由でシステムへインストール済みの LLVM へRubiniusのビルドを依存させられ無い場合、
以下の記事中で configure スクリプトを実行する箇所に `--skip-system` オプションを加えて
下さい。


### ソースコードの入手

Rubinius のソースコードは、 tarball や GitHub のプロジェクトページ等から入手可能です。  
[tarballはこちらから！](https://github.com/rubinius/rubinius/tarball/master)

Git を使う場合:

  1. カレントディレクトリを、貴方の開発用ディレクトリに変更して下さい
  2. `git clone git://github.com/rubinius/rubinius.git`


### Rubinius のインストール

アプリケーションを実行するために Rubinius を利用しようとしているのであれば、
インストールまで済ませてしまうのも良い選択です。
とはいえ、そういった場合でもソースディレクトリから利用することが可能です。
その方法ついては、次のセクションで解説します。

ここでお勧めするインストール方法では、 `sudo` や superuser 権限は必要ありません。

インストール手順：

  1. `./configure --prefix=/path/to/install/dir`
  2. `rake install`
  3. 環境変数 PATH へ、Rubinius の _bin_ ディレクトリを追加しましょう 


### ソースディレクトリから動かす方法

Rubinius自体の開発へ参加される場合は、こちらを選びましょう。

  1. `./configure`
  2. `rake`

Rubinius を取りあえず試すだけであれば、 環境変数 PATH へ Rubinius の _bin_
ディレクトリを追加する事をお勧めしています。

ですが、 Rubinius 自体を開発する場合、 _このパスを追加してはいけません_ 。
Rubinius のビルドシステムは、 `ruby` や `rake` を Rubinius の実行ファイルへリンクします。
Rubinius のビルド中は、 Ruby の実行環境と切り離されていることが求められます。

### デバッグ

VM のデバッグを行われる場合、デバッガ(GDB等)を用いる等、最適化オプションを外して
コンパイルしたいと思われるかもしれません。
その時には、環境変数 DEV を設定した上でビルドして下さい。

例: `DEV=1 rake build`
