Xiami_Radio
======================================

A Xiami radio player by command-line on ruby.

鉴于 V2ex 上有复数个豆瓣的各种版本各种功能的播放工具，我大虾米拿去一比真是冷清得不行。

（ **Pia!(ｏ ‵-′)ノಥ_ಥ ** 你丫忒夸张了吧，仔细看看还是有的 ）

之前也在 V2 表示会折腾个 Ruby 版的虾米，于是就有了这个 ruby 的 **虾米电台** ，虽然好像已经过了很久了

## Features

* 支持用户登录
* 支持选择电台
* 支持 320k (无需会员)
* 支持收藏到虾米音乐库
* 播放记录上传虾米
* 附带自动签到脚本一份

## Usage

```
$ gem install xiami_radio
```

and then

```
$ xiaomi_radio
```

you can also pass `-d` to make it run in background

```
# run xiaomi_radio in background
$ xiaomi_radio -d

# play next song
$ xiaomi_radio next

# stop
$ xiaomi_radio stop
```

Enjoy yourself ~

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



  [1]: https://github.com/georgi/audite