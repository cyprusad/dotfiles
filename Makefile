all: install

install: 
		cp -rf .vim ~/
		cp .vimrc ~/
		cp .tmux.conf ~/

update: 
		cp -rf ~/.vim .
		cp ~/.vimrc .
		cp ~/.tmux.conf .
