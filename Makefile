all: install

install:
		cp .vimrc ~/
		cp .tmux.conf ~/
		cp .gitconfig ~/

update:
		cp ~/.vimrc .
		cp ~/.tmux.conf .
		cp ~/.gitconfig .
