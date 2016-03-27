all: install

install: 
		cp .vimrc ~/
		cp .tmux.conf ~/

update: 
		cp ~/.vimrc .
		cp ~/.tmux.conf .
