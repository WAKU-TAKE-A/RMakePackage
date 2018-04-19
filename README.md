# RMakePackage
[English messages - >](#en)   
[日本語のメッセージ - >](#ja) 

## <a name="en">Message

This is the R script of making a package.

When you are used to R, you will want to make a package.  
But making a package is difficult. The sequence is as follows.

1. Definition of the required function
1. Making a package template
1. Editing various files (very difficult)
1. Build

I created the script to make a package easily.  
It works well also in R-3.4.0.  

## How to use
(1) Install "[Rtools](https://cran.r-project.org/bin/windows/Rtools/)". Add the path of "Rtools\bin".

(2) Make sure that the following files in the same folder.

  * _DESCRIPTION.txt
  * _INDEX.csv
  * _RMakePackage.r
  * r files
  * rd files (If necessary)

(3) Fix properly the following files.

  * _DESCRIPTION.txt
  * _INDEX.csv
    - Don't forget the description of the package itself.
    - Start a new line in the last line.

(4) Start R by administrator.

(5) run _RMakePackage.r

![MyGIF](https://github.com/WAKU-TAKE-A/RMakePackage/wiki/img/how_to_use_RMakePackage.gif)

## Remark

* funcA.r, funcB.r and funcC.r are sample scripts for demo.
* To run once again, restart R after run remove.packages().

## <a name="ja">メッセージ

これは、統計解析Rのパッケージを作成するためのスクリプトです。

統計解析Rに使いなれてくるとMy関数が増えてきて、パッケージ化したくなると思います。  
でもRのパッケージを作るのは、なかなか難しいです。一連の流れとしては、以下の通りです。

1. 必要な関数の定義
1. package.skelton()でパッケージの雛形を作成
1. 様々なファイルの編集（これが非常に大変です）
1. ビルド

パッケージを簡単に作成するためのスクリプトを作成しましたので公開します。

最近はR-Studioで作る方法もたびたび見かけます。  
興味のある方はGoogleで「Rstudio パッケージ  作成」を検索してみると良いと思います。

私のスクリプトは複雑なことはできませんが、  
本体以外はRtoolsさえあれば良い点と、手順が簡単な点が、気に入ってます。  
R-3.0.2あたりからR-3.3.1までに少しずつ改良を重ねたものです。  
R-3.4.0においても正常に動いています。

## 使い方
(1) [Rtools](https://cran.r-project.org/bin/windows/Rtools/)をインストールし、Rtools\binのパスを通す。

![MyGIF](https://raw.githubusercontent.com/WAKU-TAKE-A/RMakePackage/master/img/how_to_use_RMakePackage.gif)

(2) 以下のファイルが同一のフォルダにあることを確認します。

  * _DESCRIPTION.txt
  * _INDEX.csv
  * _RMakePackage.r
  * rファイル（作った関数の入ったもの）
  * rdファイル（ドキュメント、必要であれば）

(3) 以下のファイルを適切に修正してください。

  * _DESCRIPTION.txt
  * _INDEX.csv
    - パッケージ自体の説明を忘れないこと
    - 最終行を改行していること

(4) 管理者権限でRを起動します。

(5) _RMakePackage.rを実行します。

  * ファイル ⇒ Rコードのソースを読込み

![MyGIF](https://raw.githubusercontent.com/WAKU-TAKE-A/RMakePackage/master/img/how_to_use_RMakePackage.gif)

## 注意点

* funcA.r、funcB.r、funcC.rはデモ用サンプルスクリプトです。
* 再度実行する場合は、remove.packages() ⇒ Rの再起動をしてから行ってください。
* winDialogTools.rは、私が昔に作成した簡易ダイアログ作成ツールです。
