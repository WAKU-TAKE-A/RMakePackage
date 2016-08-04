# RMkePackage
[日本語のメッセージ - >](#ja)  
[English messages - >](#en)  

## <a name="ja">メッセージ
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

使い方は[こちら](https://github.com/WAKU-TAKE-A/RMkePackage/wiki/Home)を参照してください。

## <a name="en">Message
When you are used to R, you will want to make a package.  
But making a package is difficult. The sequence is as follows.

1. Definition of the required function
1. Making a package template
1. Editing various files (very difficult)
1. Build

I created the script to make a package.  
[Here](https://github.com/WAKU-TAKE-A/RMkePackage/wiki/Home_en) is How to use it.
