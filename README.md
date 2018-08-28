# Dotfiles
A repository of my dotfiles which I share between my computers.

# Installation
[GNU-Stow](https://www.gnu.org/software/stow/) is used to add all symbolic links.

Clone the repository to your home directory, cd into it, then run `stow program` for each subdirectory to add symbolic links to the configuration files. To remove the links, just run `stow -D program`.
