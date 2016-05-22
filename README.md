## Introduction

`Ztrace` plugin allows to catch output of commands in background.
By issuing:

```zsh
ztstart 3
```

We inform `Ztrace` to catch output of `3` commands.

Video: https://asciinema.org/a/45530

[![asciicast](https://asciinema.org/a/45530.png)](https://asciinema.org/a/45530)

## Installation

### [Antigen](https://github.com/zsh-users/antigen)

Adding `antigen bundle psprint/ztrace` to your .zshrc file. Antigen will handle cloning the plugin for you automatically the next time you start zsh. You can also add the plugin to a running zsh with `antigen bundle psprint/ztrace` for testing before adding it to your `.zshrc`.

### [Oh-My-Zsh](http://ohmyz.sh/)

1. `cd ~/.oh-my-zsh/custom/plugins`
2. `git clone git@github.com:psprint/ztrace.git`
3. Add zsnapshot to your plugin list

### [Zgen](https://github.com/tarjoilija/zgen)

Add `zgen load psprint/ztrace` to your .zshrc file in the same function you're doing your other `zgen load` calls in.

## IRC Channel

Channel `#zplugin@freenode` is a support place for all author's projects. Connect to:
[chat.freenode.net:6697](ircs://chat.freenode.net:6697/%23zplugin) (SSL) or [chat.freenode.net:6667](irc://chat.freenode.net:6667/%23zplugin)
 and join #zplugin.

Following is a quick access via Webchat [![IRC](https://kiwiirc.com/buttons/chat.freenode.net/zplugin.png)](https://kiwiirc.com/client/chat.freenode.net:+6697/#zplugin)
