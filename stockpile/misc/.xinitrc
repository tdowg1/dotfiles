#!/bin/bash

#xmodmap .xmodmap-apple-keyboard.A1243

test -r $HOME/.Xmodmap && xmodmap $HOME/.Xmodmap
