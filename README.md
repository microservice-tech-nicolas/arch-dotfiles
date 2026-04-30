# arch-dotfiles

Nicolas personal dotfiles — managed via bare git clone.

## Fresh install

```sh
git clone --bare git@github.com:microservice-tech-nicolas/arch-dotfiles.git "$HOME/.dotfiles"
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot checkout
dot config --local status.showUntrackedFiles no
```

Add the alias permanently to your shell:

```sh
echo "alias dot='git --git-dir=\$HOME/.dotfiles --work-tree=\$HOME'" >> ~/.zshrc
```
