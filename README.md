# iOSアプリ開発 - UI実装であると嬉しいレシピブックおもしろ編に掲載するサンプル

## 1. 概要

こちらは、上記書籍にて紹介しているサンプルを収録したリポジトリになります。書籍内で解説の際に利用したサンプルコードの完成版のプロジェクトがそれぞれの章毎にありますので、書籍内の解説をより詳細に理解する際や開発中のアプリにおける実装時の参考等にご活用頂ければ嬉しく思います。

2022.07.16時点での収録サンプルのリポジトリに関しては下記のバージョンで実装したものになっております。

 * macOS Monterey 12.4
 * Xcode 13.4.1
 * Swift 5.6
 * CocoaPods 1.10.1

これまでの書籍ではUI実装のアイデアや具体的な手法についてフォーカスを当てた書籍を3冊執筆してきましたが、急遽Vol.3の前段として更に番外編として表現や動きが特徴的でかつ、ユーザーにもほんの少しだけ遊び心を与えるような楽しい感覚を抱かせてくれるようなUI実装に関する解説を「おもしろ編（番外編Vol.2）」として簡単でありますがまとめたものになります。Chapter1及びChapter2で紹介しているサンプル実装についてはUIKitをベースに構築したサンプルとなっていますが、Chapter3ではiOS13から登場したSwiftUIを利用して構築したサンプルとなっております。

これまでの実務の中で培ってきた知識や知見に加えて、一般的なiOSアプリに対しては利用可能なケースは限られてしまうかもしれませんが、アニメーションやインタラクションにひと工夫を加えることによって、見た目にも美しく触っていて思わず楽しくなりそうな感じのUI実装に関するサンプルを3点収録しております。

__プロジェクトを動作させるための事前準備:__

サンプルコードでは、ライブラリの管理ツールで第2章はCocoaPods・第3章ではSwift Package Managerを利用しております。

CocoaPodsのインストール方法や基本的な活用方法につきましては下記のリンク等を参考にすると良いかと思います。

+ [初心者向けCocoaPodsの使い方](http://developers.goalist.co.jp/entry/2017/04/20/180931)
+ [CocoaPodsの使い方-入門編](https://www.ukeyslabo.com/development/iosapplication/how-to-use-cocoapods-for-beginner/)
+ [CocoaPodsのPodfileの書き方](https://dev.digitrick.us/notes/podfilesyntax)

Swift Package Managerの基本的な活用方法につきましては下記のリンク等を参考にすると良いかと思います。

+ [Swift Package Managerの使い方](https://qiita.com/hironytic/items/09a4c16857b409c17d2c)

## 2. サンプル図解

こちらはの書籍で紹介しているサンプルにおける概略図になります。

### ⭐️第1章サンプル

本章では画面間の遷移をシームレスな感じで移動するような感じを演出するフォトギャラリーの様な表現について解説をしていきます。
カスタムトランジションを利用した画面遷移時において、遷移元と遷移先の情報をそれぞれ利用する必要がある点や、PanGestureRecognizerを利用した指の動きと連動したインタラクティブに画面を閉じる振る舞いを実現する形を実現する点やUIColllectionViewのレイアウトをカスタマイズして複雑なレイアウトを活用した複雑なレイアウトを構築する点に難しさがあるUI実装ではありますが、この部分の実装を上手に利用することによって様々なレイアウト表現に活用できるのではないかと思います。

![第1章サンプル図](https://github.com/fumiyasac/meals_2nd_ios_ui_recipe_showcase/blob/master/images/chapter_techbook_meals2_chapter1.jpg)

### ️⭐️第2章サンプル

本章ではヘルスケアや健康管理アプリや金融関係のアプリでも用いられる画面のTouchIDやFaceIDとも連携した画面のパスコードロック機能と自前での実装が少し手間がかかる表現について便利なライブラリを活用したUI実装を組み合わせた形の表現について解説をしていきます。
アプリがバックグラウンドに移行するタイミングで現在表示している画面上にパスコードロック画面をかける処理をSceneDelegate(AppDelegate)のライフサイクルメソッドを上手に利用することで実現する手法やパスコード入力時の細かなアニメーションやインタラクションをうまく加えるポイントや、ライブラリを上手に活用したUI実装等の点はヒントになるのではないかと思います。

![第2章サンプル図](https://github.com/fumiyasac/meals_2nd_ios_ui_recipe_showcase/blob/master/images/chapter_techbook_meals2_chapter2.jpg)

__利用しているライブラリ一覧:__

+ [SwipeCellKit](https://github.com/SwipeCellKit/SwipeCellKit)
+ [PanModal](https://github.com/slackhq/PanModal)

__Podfileの記載:__

```ruby
target 'PasscodeLockLayout' do
  use_frameworks!

  # Pods for PasscodeLockLayout
  # UI表現の際に利用するライブラリ
  pod 'SwipeCellKit'
  pod 'PanModal'
end
```

__ライブラリのインストール手順:__

```shell
# 今回利用するライブラリのインストール手順
$ cd 02_PasscodeLockLayout/PasscodeLockLayout/ 
$ pod install
```

### ⭐️第3章サンプル

本章ではiOS13から新しく登場した機能で、WWDCでも大きく話題となったSwiftUIを利用した簡単な画面とSwiftUIでは実現しにくいUI表現に対してライブラリを利用することで実現できる事例についての解説をしていきます。（※このサンプルではSwiftUI1.0を利用しています）
SwiftUIはまだ発表されてから1年程度なので、まだまだ発展途上の部分もありますが大きな可能性を秘めているものだと感じています。今回はUICollectionViewを利用した画面レイアウトではよくお目にかかる様な形のUI実装に対してライブラリを活用して補う形での実装方法や、実はSwiftUIの方が実装がシンプルに作れてしまうかもしれない初期位置からのスクロールでトップに配置したサムネイル画像がスクロール変化に伴ってパララックス表現がかかるような形のUI表現についてピックアップしています。

![第3章サンプル図](https://github.com/fumiyasac/meals_2nd_ios_ui_recipe_showcase/blob/master/images/chapter_techbook_meals2_chapter3.jpg)

__利用しているライブラリ一覧:__

※ 下記ライブラリについては「Swift Package Manager」を利用して導入しています。

+ [ASCollectionView](https://github.com/apptekstudios/ASCollectionView)
+ [WaterfallGrid](https://github.com/paololeonardi/WaterfallGrid)

## 3. その他サンプルに関することについて

その他、サンプルにおける気になる点や要望等がある場合は是非GithubのIssueやPullRequestをお送り頂けますと嬉しく思います。
本サンプルでは下記の部分に関しては、今回は対応していませんのでご注意下さい。

+ DarkModeの無効化（現在は強制的にLightModeにしています。）
