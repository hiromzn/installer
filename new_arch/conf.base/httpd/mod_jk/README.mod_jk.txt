
7.2  mod_jkモジュールのビルド方法

RHEL上で動作するApache用mod_jkモジュールは、バイナリで公開されたものが無いため、ソースコードからビルドする必要があります。ここでは、mod_jkモジュールのビルド方法について説明します。

7.2.1  mod_jkビルド用環境準備

mod_jkをビルドするためは、httpd-devel、apr-devel、apr、apr-util-devel、apr-util各のパッケージが必要になります。ビルド環境マシンにこれらのパッケージが入っていない場合は、次のようにして、各パッケージをインストールします。

# yum install httpd-devel apr-devel apr apr-util-devel apr-util

Cコンパイラ等、開発ツールが導入されていない場合は、以下を実行して開発ツールを導入してください。

# yum groupinstall "Development Tools"

7.2.2  mod_jkソースの入手

http://tomcat.apache.org/download-connectors.cgiの"JK 1.2.40 Source Release tar.gz" のリンクから、ソースをダウンロードします。

7.2.3  mod_jkモジュールのビルド

入手したtomcat-connectors-1.2.40-src.tar.gzを次のようにしてビルドします。

(以下任意のディレクトリ上での作業となります)
$ tar xvfz tomcat-connectors-1.2.40-src.tar.gz
$ cd tomcat-connectors-1.2.40-src/native
$ ./configure  --with-apxs=/usr/bin/apxs
…
$ make
…
$ ls apache-2.0/mod_jk.so
apache-2.0/mod_jk.so

native/apache-2.0の下に作成されるmod_jk.soがmod_jkのバイナリモジュールになります。これを運用環境上にコピーの上使用します。

