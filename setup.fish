#!/run/current-system/sw/bin/fish

# not an actual setup script yet

# 1. create symlinks for fish functions
ln -f $HOME/dotfiles/fish/functions/nv.fish $HOME/.config/fish/functions/nv.fish # navi pen200
ln -f $HOME/dotfiles/fish/functions/d.fish $HOME/.config/fish/functions/d.fish # docker alias (could use abbr but trips me out)

