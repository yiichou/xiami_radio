Xiami_FM -  Listen ur xiamicai radio in Ruby
======================================

鉴于 V2ex 上有复数个豆瓣的各种版本各种功能的播放工具，我大虾米拿去一比真是冷清得不。

（ **Pia!(ｏ ‵-′)ノಥ_ಥ **你丫忒夸张了吧，仔细看看还是有的 ）

之前也在 V2 表示会折腾个 Ruby 版的虾米，于是就有了这个 ruby 的 **虾米猜** ，虽然好像已经过了很久了

## Features

* 使用 cookie 里面的 member_auth 来登录
* 支持 320k
* 支持收藏到虾米音乐库
* 播放记录上传虾米
* 附带自动签到脚本一份

## Usage

明显还没做完，所以没打 gem 包

使用方法：

打开 `xiami_fm.rb` 填入配置 ，然后

```
ruby xiami_fm.rb
```

## Requirements

* Portaudio >= 19
* Mpg123 >= 1.14
* Audite

## OSX Install

```
brew install portaudio
brew install mpg123
```


## Debian / Ubuntu Install
```
apt-get install libjack0 libjack-dev
apt-get install libportaudiocpp0 portaudio19-dev libmpg123-dev
```

## Audite

使用了 [Audite][1] 作为播放组件

鉴于 Audite 的 gem 包比较老旧，所以直接采用了 github 上面的版本，并进行了少量的改动


  [1]: https://github.com/georgi/audite
