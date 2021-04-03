# [Tidy](https://yuji-forio.herokuapp.com/)

# アプリ概要

サービス名: Tidy (タイディ)

ものを減らし、心を豊かにするヒントを共有する投稿サイト

・ものを減らすための悩みを投稿し、他の方からアドバイスをもらう

・ものを減らすためのアイデアやおすすめ商品を投稿する

全て独学で開発いたしました。

<br>

![Tidy](https://user-images.githubusercontent.com/76397425/112713424-43897100-8f18-11eb-899a-975c1e4d69b8.png)

## URL

https://yuji-forio.herokuapp.com/

# 使用技術

- フロントエンド
  - HTML/SCSS
  - Javascript
- バックエンド
  - Ruby:2.6.3
  - Rails:6.1.3
- インフラ・開発環境
  - Heroku
  - MySQL:8.0.23
  - Puma 5.2.2
- テスト・静的コード解析
  - Rspec
  - Rubocop_Airbnb

<br>

# 開発した背景

私は、社会人になってから引っ越しをする機会が数回あり、引っ越しの手間をへらすため、ものを減らしたいと思いました。そして、SNS や本で断捨離する方法やポイントを学び、ものを減らすことができ、引っ越しすることが負担ではなくなりました。

<br>

その話を聞いた友人が、部屋にものが多いから手伝ってほしいとお願いされ、ものを減らす方法をレクチャーし、主に 3 つの効果があり、心に余裕が生まれたと感動されました。

・掃除する時間やものを探す時間が減った

・余計なものを買わなくなり金銭面に余裕がでた

・スッキリして気分がいい

<br>

以上の経験から

1．部屋が散らかる、片付け方や物の減らし方がわからない方などを対象に、

「悩みを共有し、アドバイスをもらう」

<br>

2．ミニマリストやものを減らすためのおすすめの商品やアイデアを発信したい

「ものを減らすためのアイデアやおすすめ商品が投稿できる」

<br>

2 つの機能面をもつサービスの開発に至りました。

<br>

# 機能一覧

- ユーザーに関する機能

  - ログイン、ログアウト機能
  - 簡単ログイン機能
  - twitter, facebook, google アカウント利用によるログイン機能
  - ユーザー一覧表示機能

- 記事に関する機能

  - 投稿機能
  - 画像ファイルのアップロード機能
  - ページネーション機能
  - フリーワード検索機能
  - タグ機能
  - ソート機能(SQL 文を用いて実装)

- フォロー機能(Ajax）

- いいね機能(Ajax）
  - いいねした投稿一覧表示機能
- コメント機能(Ajax）
- レスポンシブ対応
- 通知機能

<br>

# 機能詳細

## ユーザーに関する機能

- ユーザー登録、ログイン、ログアウト、ユーザー情報編集
- プロフィール作成、編集、詳細表示機能

<br>

## 記事に関する機能

- 投稿一覧表示、記事詳細表示、記事投稿、記事編集、記事削除機能
  - 記事投稿、編集機能については、Action text gem を使用し、UX の向上を図った
  - 画像ファイルのアップロード機能は、Active Storage と AWS S3 を採用
  - 投稿一覧機能については、ページネーション機能を実装。kaminari gem を使用
- タグ機能
  - gem は使用せず、Tag テーブルを使用
  - タグを付けて登録することができる
  - タグをクリックすると同じタグが付けられた投稿一覧を表示することができる
- ソート機能
  - いいね順には、生の SQL 文を用いて実装
- 記事検索機能
  - ransack gem を使用
  - 記事のタイトル,タグ、投稿者に紐付いた記事のみを文字列で検索できる

<br>

## フォロー機能（Ajax）

- フォロー、フォロー解除機能
  - フォローしたユーザーのフォロワー数が変化する機能は、Ajax 処理
- フォロー、フォロワー一覧表示機能
- フォロー、フォロワーの投稿一覧機能

<br>

## いいね機能（Ajax）

- 記事にいいねを押す機能
  - いいねを押した記事のいいね数が変化する機能は、Ajax 処理
- 自分がいいねを押した投稿一覧表示機能

<br>

## コメント機能（Ajax）

- 記事毎にコメント投稿、削除、表示機能
  - Ajax 処理

<br>

## その他

- Git flow を意識した開発
- Git チーム開発を意識した issue・プルリクエストの活用
- Git コミットメッセージから issue を開けるよう issue 番号の紐付け
- 定期的にアウトプット
  - [Twitter](https://twitter.com/3iTM4Um3zzGIcgF)
  - [Qiita](https://qiita.com/holdout0521)

<br>

## 追加機能予定
- ユーザーごとにお気に入りアイテム登録機能
- ビューの一部をSPA化(Vue.js)

<br>

# 注力した点

**Rspec でのテスト量**

アプリケーションにおいて、正常に動作しないことやバグは避けなければなりません。
それを防ぐためにも Rspec でのテストの必要性は高いと考えており、約 140 個のテストを作成し、手動で不具合がないかの確認をする工数の削減に繋げることができました。
また、テスト作成後、既存のコードをリファクタリングした際に、1 クリックで正常に動作するかを確認でき、安心してリファクタリングを進めることができました。

テストするうえで、特に下記を意識して記述しました。

- 読みやすいコードにしつつ、適度に DRY にする
- 期待する結果をはっきりわかりやすく記述する
- 起きて欲しいことと起きてほしくないこと両方をテストする
- 1 つのテストで期待する結果は 1 つにする
- 閾値の境界値をテストする

<br>

**N+1 問題の解決**

N+1 問題である SQL が多量に実行されパフォーマンスの低下は、サーバーの負担や読み込み時間に影響する問題であります。
SQL の実行回数をいかに減らせるか、実際の SQL の発行文を確認しつつ、試行錯誤しました。その結果として、gem の bullet でアラームが出ることなく、SQL の発行を最低限に抑え、読み込み時間も減らせることができました。

<br>

# ER 図

![ER図](https://user-images.githubusercontent.com/76397425/112716055-65d6bb00-8f27-11eb-8910-fb846af9aa82.png)
