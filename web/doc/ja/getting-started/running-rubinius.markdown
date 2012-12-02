---
layout: doc_ja
title: Rubinius の実行
previous: Rubinius のビルド
previous_url: getting-started/building
next: Troubleshooting
next_url: getting-started/troubleshooting
---

一度これらの手順を踏んでインストールできたのであれば、 早速 Rubinius が動くことを確認できます:

    rbx -v

大抵の場合、 Rubinius は Ruby と同じコマンドライン操作で動きます。:

    rbx -e 'puts "Hello!"'

'code.rb'というファイル名のスクリプトを実行する場合:

    rbx code.rb

IRBを使う場合:

    rbx

If you added the Rubinius bin directory to your PATH, Rubinius should perform
just as you would expect from MRI. There are commands for `ruby`, `rake`,
`gem`, `irb`, `ri`, and `rdoc`.

You can add the Rubinius bin directory to your PATH only when you want to use
Rubinius. This way, it will not interfere with your normally installed Ruby
when you do not want to use Rubinius.
