all: install

install:
		cp .vimrc ~/
		cp .tmux.conf ~/
		cp .gitconfig ~/
		cp .irbrc ~/

update:
		cp ~/.vimrc .
		cp ~/.tmux.conf .
		cp ~/.gitconfig .
		cp ~/.irbrc .
