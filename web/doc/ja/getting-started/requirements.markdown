---
layout: doc_ja
title: 必要要件
previous: はじめに
previous_url: getting-started
next: Rubinius のビルド
next_url: getting-started/building
---

このページに示すプログラムとライブラリがインストールされていることを確認してください。
また、オペレーティングシステム毎の特別な要件について、該当するサブセクションを参照してください。

次のプログラムやライブラリへの記述は、あくまで Rubinius をビルドするための情報です。
御使用のOSやパッケージマネージャによっては、別のパッケージを利用できるかもしれません。

  * [GCC and G++ 4.x](http://gcc.gnu.org/)
  * [GNU Bison](http://www.gnu.org/software/bison/)
  * [MRI Ruby 1.8.7+](http://www.ruby-lang.org/)
    システムに Ruby 1.8.7 がインストールされていない場合、 [RVM](https://rvm.beginrescueend.com/) を使ってインストールすることを御検討下さい。
  * [Rubygems](http://www.rubygems.org/)
  * [Git](http://git.or.cz/)
  * [ZLib](http://www.zlib.net/)
  * pthread - このライブラリは、OSによってインストールされている必要があります。
  * [gmake](http://savannah.gnu.org/projects/make/)
  * [rake](http://rake.rubyforge.org/) `[sudo] gem install rake`


### Apple OS X

Apple の OS X 上にビルド環境を構築する最も簡単な方法は、XCode Tools と 
Utilities をインストールすることです。
インストールすると、/Developer/Applications/Utilities/CrashReporterPrefs.app の 
developer mode crash reporting を有効にできます。


### Debian/Ubuntu

  * ruby-dev or ruby1.8-dev
  * libreadline5-dev
  * zlib1g-dev
  * libssl-dev

### Fedora/CentOS

  * ruby-devel
  * readline-devel
  * zlib-devel
  * openssl-devel

### FreeBSD

Rubinius は、FreeBSD の ports ツリーに lang/rubinius という port をもっています。
この port に関する情報は [FreshPorts](http://www.freshports.org/lang/rubinius/) で得ることができます。
一度インストールした後、この port は、全ての依存するものを自動的にインストールします。
