rm ~/.zshrc
ln -s "$(pwd)/.zshrc" ~/.zshrc

rm ~/.config/starship.toml
ln -s "$(pwd)/starship.toml" ~/.config/starship.toml

rm ~/.tmux.conf
ln -s "$(pwd)/.tmux.conf" ~/.tmux.conf

rm ~/alacritty/alacritty.yml
ln -s "$(pwd)/alacritty.yml" ~/alacritty/alacritty.yml
