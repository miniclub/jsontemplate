# 概要
JSONテンプレートエンジン。
OutputToDeviceメソッドを実行することで、XDATA に記述されたjsonテンプレートにプロパティ値を挿入し、結果のJSONデータを標準出力に出力します。

# プロパティ値の記載方法
## \#(..プロパティ名)\#
プロパティ値を挿入します。
プロパティがJSONTemplate.Baseを継承している場合、そのクラスのJSON出力を実行します
プロパティがlist形式の場合、JSON配列となり、その要素にプロパティ値が挿入されます。
## \#(..#パラメータ名)\#
パラメータ値を挿入します。
## \#(..@プロパティ名)\#
指定されたプロパティに対してOutputReferenceを実行し、ReferenceTemplateで記載されたJSONデータを出力します。

# 使用方法
## 作成時
2) JSONTemplate.Baseを継承したクラスを作成
3) Templateをオーバーライドし、JSONテンプレートを作成
4) 挿入したいデータに合わせてプロパティを作成

## 使用時
1) 作成したクラスのインスタンスを作成
2) プロパティに値を設定
3) OutputToDeviceメソッドを実行



# 収録クラス

## JSONTemplate.Base
テンプレートの基底クラス
## JSONTEmplate.Generator
テンプレートの
