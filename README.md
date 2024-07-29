# inceptionの最終成果物はなに？
``make``とコマンドを打つと、サービス提供の準備がされる。  
結果、https://sotanaka.42.fr/ にアクセスすと、作成したサイトにアクセスできる。  
<img width="528" alt="Screenshot 2024-07-29 at 10 48 24" src="https://github.com/user-attachments/assets/b262fd3f-9074-43e3-8937-600f72ba2d4e">

またBonusでは、(私の設計だと)https://adminer.42.fr/ にアクセスするとadminerからデータベースにアクセスできる。  
<img width="635" alt="Screenshot 2024-07-29 at 10 50 06" src="https://github.com/user-attachments/assets/6298bac3-dddd-4452-9730-d49ae1bd18e8">

# Dockerとはなにか
軽量な仮想化マシン、といったん考えよう。  
## 仮想化の技術の1つ
- ホスト型仮想化(VM/VertualBox/etc.)
- ハイパーバイザー型仮想化
- コンテナ型仮想化（Docker）　　
  
Born2BeRootでは、ホスト型仮想化（ホストOS > 仮想化ソフトウエア > **ゲストOS**　> ゲスト用ソフト）を利用していた。  
Dockerはコンテナ型仮想化（ホストOS > 仮想化ソフトウエア > ゲスト用ソフト）という感じ。  
  
## ホスト型とコンテナ型の”違い”と”メリット”
### 違い
- コンテナ型仮想化(Docker)では、ゲストOSが不要  
え、じゃあなんのOSで動いてるの？というと、ホストOSが持っているLinuxカーネルを間借りして動いている。  
MacやWindowsのDockerEngineにはLinuxOSが搭載されいる、という感じ  
- Dockerでは、Linuxをベースとしたシステム設計になる

### メリット
- 動作が軽い  
- 同じ環境を他のハードでも再現しやすい  
つまり、「私はMac」「うちはWin」「ワイはDebian」みたいな時に、OSの違いを乗り越えて、Docker上（同じ環境の上）で開発や確認ができる。  

## Ref
[仮想化とは:「Docker よくわからない」を終わりにする本](https://zenn.dev/suzuki_hoge/books/2022-03-docker-practice-8ae36c33424b59/viewer/1-2-virtualization)  
[仕組みと使い方がわかる Docker&Kubernetesのきほんのきほん](https://amzn.to/4eK0uVv)  

# Dockerで利用する技術、ポイント
それぞれ簡単に解説する。  
## container
特定のコマンドを実行するために作られる、**ホストマシン上の隔離された領域**のこと。  
仮想マシン的な機能、という理解で大きな問題はない。  
例えば、コンテナの中で、ホストOSとは異なるverのpythonをインストールして、プログラムを実行することもできる。  
他にはホストOSとは異なるディストリビューション（Debian／Aplineなど）も使いたい放題。  
実際は、LinuxのNamespaceという機能で分離された１プロセスでしかない。  
　　
## image
コンテナを立ち上げるためのパッケージ。  
OS、インストールされているソフトなどが全て含まれていると思えばよい（なので容量が大きい）。  
imageがあれば、インターネット通信を切ってもコンテナを立ち上げることができる。  
次のような情報が含まれている。  
- ベース（ディストリビューションのようなもの）  
- ソフト（Pythonやwordpressなど）  
- 環境変数（wordpressを立ち上げるためのユーザー情報など）  
- どういう設定ファイルを配置しているか  
- デフォルト命令（wordpress startなど）はなにか  
よく利用されるイメージは、DockerHubに公開されているので、そこからダウンロードすればOk。    
## Dockerfile
imageを、カスタマイズして生成できる機能（ファイル）。  
既存の公開されたイメージは便利ではあるものの、自分の用途のためにはカスタマイズする必要があるかもしれない。  
例えば、nginxとMariaDBがセットになって、かつBraveも入ったコンテナを利用したいけど、そんなのは既存ではないなあ。とか。  
この時に、ワガママなイメージを生成できるのがDockerfileで、記述はムズイと思うけど便利かもしれない。  
  
inceptionの文脈では、nginxなどは既存のイメージがあるが、既存のイメージは利用できない（debian/alpineのみ可）。  
　From debian:xx  
　RUN apt-get install nginx brave(適当)  
のように記述して、ワガママイメージを生成することになる。
    
以下は各ソフトの公式Dockerfile。これらを見ると、どんなコマンドでどんな他のソフトもダウンロードしているか少しわかる（ほとんどわからない）  
[nginx](https://github.com/nginxinc/docker-nginx/blob/a6f7d140744f8b15ff4314b8718b3f022efc7f43/mainline/debian/Dockerfile)  
[MariaDB](https://github.com/MariaDB/mariadb-docker/blob/11135d071fd1fe355b1f7fa99b9d3b4a59bb5225/11.5-ubi/Dockerfile)  
[WordPress](https://github.com/docker-library/wordpress/blob/3f1a0cab9f2f938bbc57f5f92ec11eeea4511636/latest/php8.1/apache/Dockerfile)  
[adminer](https://github.com/TimWolla/docker-adminer/blob/c9c54b18f79a66409a3153a94f629ea68f08647c/4/Dockerfile)  
  
### .dockerignore
Dockerfileからイメージを生成するときに、.dockerignoreを2つの目的で利用する。  
まず理解したいのは、イメージを生成する時には、ビルドのルート（~.ymlのあるディレクトリと思えばOK）以下の、全てのデータが一旦転送される、ということ。  
この時に、イメージの生成に必要のないファイルが含まれていても、問答無用で転送される。  
これがデータの大きいファイルだったら、イメージ生成のプロセスがムダに遅延することになる。  
そこで、.dockerignoreが有効になる。以下2つの大きな目的がある。  
1. イメージ生成効率の向上  
イメージ生成には不要なデータを.dockerignoreに記述することで、データ転送が減り、イメージ生成効率が向上する。  
1. セキュリティの向上（副次的な効果）  
イメージ生成の時に、本当はイメージに含めたくない、パスワードなどのセンシティブなファイルがあったとする。  
これを誤って、Dockerfileでコピーや参照しないように、.dockerignoreに記述する。  
もしも、ignoreされたファイルをイメージに含めようとすると、転送されていないファイルなので、イメージ生成プロセスでエラーになる。  
[.dockerignoreが効かない？.gitignoreとは書き方が違うよ！](https://qiita.com/yucatio/items/f5d23043228cc35fc763)  
[.dockerignoreに記載すべきファイルとは](https://shisho.dev/blog/posts/how-to-use-dockerignore/)  

## docker volume
データ永続化の仕組み。  
コンテナは頻繁に破棄する前提みたい。ソフトのセキュリティアップデートとかしやすいのかな。  
なので、データを保管するMariaDBが入ったコンテナも捨てることがある。  
このとき、コンテナ内にデータがあると、必要なデータも全部消えちゃう。  
なので、コンテナ上ではなく、ホストPC上にデータ保存領域をもっとこうぜ、みたいなもの。  
  
そしてコンテナ外のデータ保管領域は大きく2種類ある。  
### Volume
Volumeは、Dockerが管理する領域。  
管理とは、ディレクトリの作成、参照、編集などのライフサイクルをDockerが握るということ。  
``docker volume rm xx``コマンドで、データをすっぱり消すことができる。  
もちろん、ホストPCのどこかにあるので、ホストPCからも存在は確認できる。しかし編集や削除をホストPCからすると、Dockerの知らぬところで発生した変更なので、予期せぬ動作を起こすこともあるみたい。  
そして、Dockerをアンインストールしたら消える（と思う）。  
### Bind
Bindは、ホストPCが管理する領域。  
コンテナを立ち上げるときに、ホストPCの保管先（からコンテナ内のディレクトリの共有先）を自分で指定する。  
これによって、コンテナ内の/home/mydirexx/が、ホストの/tmp/dockerxx/をハードリンクとして持っているような状態になる。  
Volumeと管理の観点で異なっており、コンテナからも参照や編集が可能である。  
ただ、``docker volume rm``してもデータは消えない。  
  
[余談]  
inceptionではまったポイントは、複数のコンテナのバインド先をホストの1つのディレクトリにしていたこと。  
これによって、先にイメージのビルドプロセスで作成したファイルが、コンテナの立ち上げ時には消えてしまっていました。。(別のコンテナの内容で上書きされる)  
コンテナによってバインド先は分けましょう。  

## docker network
[３部: ネットワーク](https://zenn.dev/suzuki_hoge/books/2022-03-docker-practice-8ae36c33424b59/viewer/3-7-network)  
[Compose の ネットワーク機能](https://docs.docker.jp/compose/networking.html)  
## docker-compose
初心者向けチュートリアルでは、コマンドで``docker run xx``から始まり、``docker image build xx``やそれらに付随する、オプション（ポートやパスワード）設定を行っていると思います。  
docker-composeはそれらのコマンドを、何回も打つのめんどくさいし、1つのファイルにまとめて記述しちゃおう。みたいな機能（ファイル）です。  
[３部: Docker Compose](https://zenn.dev/suzuki_hoge/books/2022-03-docker-practice-8ae36c33424b59/viewer/3-8-docker-compose)  
[Docker を理解するためのポイント:「Docker よくわからない」を終わりにする本](https://zenn.dev/suzuki_hoge/books/2022-03-docker-practice-8ae36c33424b59/viewer/2-1-points)  

# SSL/TLS
## 目的
- 暗号化  
データを暗号化し、第三者が読み取れないようにする  
- 認証  
通信相手が正当な相手であることを確認する（自己署名証明証はブラウザが警告することが多い）  
- データの完全性  
データが送受信される途中で改ざんされていないことを保証する  
## 違い　SSL (Secure Sockets Layer)とTLS (Transport Layer Security)
SSLの次世代規格がTLSです。  
SSLに根本的に脆弱性があったので、SSLのバージョンアップではなく、TLSという形になったようです。  
これ以上に深く踏み込むことは一旦避けた。  
## 仕組み(暗号方式)
SSL/TLSでは、公開鍵暗号方式と共通鍵暗号方式の両方が使われます。  
### 公開鍵暗号方式
公開鍵は、誰にでも渡して良い鍵です。  
秘密鍵は、誰にも渡してはいけない鍵です。  
データの送信者は、受信者の公開鍵を使って、通信を暗号化します。  
しかし、暗号化したデータは公開鍵を利用しても、復号はできません。  
暗号化したデータを復号できるのは、秘密鍵だけです。なので、受信者だけが、暗号化したデータを復号できます。  
TLSでは、通信の最初に”これからデータのやり取りをしたいからよろしく！”といって、データ要求者とデータ保持者で握手するプロセスがあります。  
この時に、公開鍵暗号を利用します。ここでやり取りされるデータは、”共通鍵はXXXXね”、という内容です。  
この内容も公開鍵暗号方式を利用しているので、共通鍵が漏れることはありません。  
  
### 共通鍵暗号方式
で、握手した後のデータの送受信では、公開鍵ではなく、共通鍵を使って暗号化・復号を行います。  
全部のデータ送受信で公開鍵暗号方式を使えばいいやん、とも思いますが、共通鍵を用いる方が、データの暗号化や復号がスピーディーなのだそう。  
ここは、そういうアルゴリズムのプログラムなんだな、くらいの理解にとどめた。  

## 通信方法のオーバービュー
では、通信方法をざっと確認
1. 公開鍵暗号方式
- 通信の開始時に使用される 
- サーバーとクライアントが共通鍵を安全に交換するために使用される  
2. 共通鍵暗号方式:
- 通信経路が確立された後に使用される  
- データの暗号化と復号を効率的に行える  
## セキュリティ証明書
TLSプロトコルを支える、デジタル文書です。  
### デジタル証明書である
- 特定の組織やドメインの身元を証明するためのデジタル文書  
- SSL/TLS証明書とも呼ばれ、通信の暗号化と認証に使用される  
### 構成要素
- 公開鍵：　先述  
- 秘密鍵：　先述  
- 署名：　証明書の正当性を保証する証明書発行機関 (CA: Certificate Authority) の署名  
- その他：　組織名、ドメイン名、有効期限など  
### 発行機関
Let's Encrypt, DigiCert, GlobalSignなど
### 自己署名証明書
- 自分自身で署名した証明書で、開発やテスト用途に使用  
- 信頼性は低いため、公開環境では推奨されない  
- ブラウザが警告を出すので、利用者が不審がって、サイトの信頼性が落ちる  
### Ref  
[自己署名証明書（オレオレ証明書）によるHTTPSローカル環境の構築](https://qiita.com/taitai22_1/items/019845da881733d522c2)  
[OpenSSL で SSL 自己証明書を発行する手順](https://weblabo.oscasierra.net/openssl-gencert-1/)  
[Nginxに自己署名証明書を設定してHTTPS接続してみる](https://qiita.com/ohakutsu/items/814825a76b5299a96661)   

# 各コンテナの役割
## [nginx](https://kinsta.com/jp/knowledgebase/what-is-nginx/)
.phpで動作するサイトについては、wordpressに処理を依頼するリバースプロキシとして機能するんだと思う。  
それ以外のスタティックなデータに対しては、データをwordpressを介さずに提供する、でいいのかな。  
inceptionの文脈では、サーバー機能、リバースプロキシ機能を知る、か。    
[リバースプロキシとは？](https://www.cloudflare.com/ja-jp/learning/cdn/glossary/reverse-proxy/)  
[remote_addrとかx-forwarded-forとかx-real-ipとか](https://christina04.hatenablog.com/entry/2016/10/25/190000)  

## [WordPress](https://online.dhw.co.jp/kuritama/about-wordpress/)
.phpでソースコードが記述された、サイト作成、管理の.phpの集合体。つまり、PIDを持って動作するようなアプリではない。  
サイト作成で広く利用される。  
inceptionの文脈では、サイト構築が簡単にできるツールの利用方法を知る、か。  
[PHPとは─WordPressでの使われ方を解説](https://kinsta.com/jp/knowledgebase/what-is-php/)  
.php形式の
## [MariaDB](MariaDBとは？MySQLとの違いや、特徴・強み)  
データベースソフトウエア。  
リレーショナル型データベースで、一般的にはテキスト、数値などの、表対応するような**構造化されたデータ**の保存に利用される。  
inceptionの文脈では、データベースとは何か、どのような利用用途かを知る、か。  
[データベースに直接画像を保存することの メリット・デメリット](https://www.kenschool.jp/blog/?p=6025)  
[画像データを MySQL に格納するとどうなるか](https://qiita.com/saoyagi2/items/0e59ac576100899b42cc)  

# CLI
コンテナにはOSしかダウンロードできていない状態から、サイトの表示までを自動化する必要がある。  
なので、ソフトのダウンロードや初期設定はDockerfileや.ymlに必ず実行するコマンドとして、全て記述しなければならない。  
例：nginxの設定ファイル、MariaDBのユーザー設定、Wordpressのユーザーやサイト設定  
## nginx
ソフトリストを最新にする→nginx/opensslをインストール→自己署名証明書を作成→confファイルを要件に合わせる→nginxを起動  

[nginxのインストール](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/)  
[自己署名証明書の識別名の入力を自動化1](https://qiita.com/3244/items/780469306a3c3051c9fe#%E8%AD%98%E5%88%A5%E5%90%8D%E3%81%AE%E5%85%A5%E5%8A%9B%E3%82%92%E8%87%AA%E5%8B%95%E5%8C%96%E3%81%99%E3%82%8B)  
[自己署名証明書の識別名の入力を自動化2](https://kazuhira-r.hatenablog.com/entry/2023/04/15/193035)  

## MariaDB
リストを最新にする→MariaDBをインストール→port/bind-addressを設定→MaridDBに新しいデータベースとユーザーを作成→mariadbをスタート  
[MySQLの使い方](https://www.javadrive.jp/mysql/)  

## WordPress
リストを最新にする→wgetやphp-fpmのインストール→wpのDLと解凍→wp-cliのDLと解凍  
[wordpressのDLと解凍](https://developer.wordpress.org/advanced-administration/before-install/howto-install/#step-1-download-and-extract)  
[wp-cliのインストール](https://wp-cli.org/ja/)  
[wpのインストール(初期設定)](https://developer.wordpress.org/cli/commands/core/install/)  
[docker-composeへの記述](https://hub.docker.com/_/wordpress)  
[WP-CLIでユーザーを作成する](https://qiita.com/motchi0214/items/b51f5b30b4bd479ff53f)  

## Adminer
[How to download Adminer1](https://unix.stackexchange.com/questions/420668/how-to-download-adminer-with-wget)  
[How to download Adminer2](https://kinsta.com/jp/blog/adminer/)  

# クラスターでの操作
## 仮想マシンの設定
わたしはDebianを利用した。(ユーザー名もパスワードもdebian。ルートユーザーは作成してない)  
ufwをインストールしてssh接続を許可（ホストから操作しないなら不要）  
VirtualBoxのポストフォーワーディングも設定  
sshdとufwを起動  
makeをインストール  
.envファイルを作成（scpを利用してホストからコピーした）  

## Dockerの設定
[Docker Engine インストール（Debian 向け）](https://matsuand.github.io/docs.docker.jp.onthefly/engine/install/debian/)  
現在のユーザーをdockerのグループに追加して適用 ``sudo usermod -aG docker debian``  

## ホストからゲストへのデータコピー（レビュー用にcloneしたディレクトリ）
``scp -r -P 8042 /path/of/host/* debian@127.0.0.1:/path/to/guest/``  
  
# サブジェクト通りにできているかの検証方法
* Each service has to run in a dedicated container.  
.ymlの記述、コンテナを稼働させて``docker container ls -a``で確認  
* the containers must be built either from the penultimate stable version of Alpine or Debian  
https://hub.docker.com/_/debian  
で'-slim'で検索して、最新のより1つ古いバージョンであることを確認  
* A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only  
Dockerfileのinstall記述と``openssl s_client -connect sotanaka.42.fr:443 -tls1_2"``  
* A Docker container that contains WordPress + php-fpm (it must be installed and configured) only without nginx.  
Dockerfileのinstall記述と``nginx``  
* A Docker container that contains MariaDB only without nginx.  
同上  
* A volume that contains your WordPress database.  
[WEBデータとデータベース](https://www.xserver.ne.jp/bizhp/wordpress-mysql/#wordpress%E3%81%AE%E5%BE%A9%E5%85%83%E3%81%AB%E3%81%AF%E3%83%87%E3%83%BC%E3%82%BF%E3%83%99%E3%83%BC%E3%82%B9%E3%81%AE%E3%83%90%E3%83%83%E3%82%AF%E3%82%A2%E3%83%83%E3%83%97%E3%83%87%E3%83%BC%E3%82%BF%E3%82%82%E5%BF%85%E8%A6%81)  
管理者画面からイメージファイルをアップロードして、ホストのバインドしたディレクトリからファイルを見にいく感じかな。  
* A second volume that contains your WordPress website files.  
新規の記事を作成して、mariadbのデータベースに追加されているかを見に行けばいいと思う。  
``mariadb``  
``USE wordpress;``  
``SELECT ID, post_title, post_content, post_date FROM wp_posts WHERE post_type = 'post' ORDER BY post_date DESC;``  
* A docker-network that establishes the connection between your containers.  
``docker network ls``で.ymlから作成されたネットワークを確認して
``docker network inspect srcs_net_inception``で、接続されてるコンテナを確認する  
* Your containers have to restart in case of a crash.  
wordpressのコンテナで、``kill -9 1 x(php-fpm -d)``を行ってコンテナをクラッシュさせる。  
[Dockerのrestart policyごとの違いを表でまとめてみる](https://ysk24ok.github.io/2019/08/07/docker_restart_policy.html)  
* recommended to use any hacky patch based on ’tail -f’  
Dockerfileなどで、コンテナ起動時のスクリプトを確認する。  
コンテナは、ある目的を持って動作する1つの機能であると考える。  
そう考えると、``tail -f``のような、コンテナの目的にない動作で、コンテナを存命させることはコンテナの目的を達成してないし、リソースの無駄になる。  
今回作ったコンテナを目的通りに存命させ続けるデフォルトの方法は、nginx、php-fpm、mariadbなどのプロセスを監視（他のコンテナなどからの接続待機）状態でスタートしておくことである。  
[個人的に覚えておきたい集 tailコマンド](https://qiita.com/fy406/items/10d61ec9bfb648e0624e)  
* Of course, using network:  host or --link or links:  is forbidden.  
セキュリティ懸念や古い方法だから使うなってことか？  
[いい加減docker-composeでlinksを使うのをやめてnetworkでコンテナ間名前解決をする](https://qiita.com/dyoshikawa/items/05d627b962da35f7d5b6)  
[ホスト・ネットワークの使用](https://docs.docker.jp/network/host.html)  
[【Docker Network 第３章】-net = hostオプションを理解する](https://qiita.com/MetricFire/items/b731c84975bd9894748d)  
* Read about PID 1
[PID 1問題](https://text.superbrothers.dev/200328-how-to-avoid-pid-1-problem-in-kubernetes/)  
* WordPress database, there must be two users  
ユーザー設定のスクリプトと、実際のwp-adminでのログイン。
* Your volumes will be available in the /home/login/data.  
* Set up Adminer.  
