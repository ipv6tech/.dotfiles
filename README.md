
Installs dotfiles and a bunch of packages that don't install with the Debian cloud image:

```sh
curl https://raw.githubusercontent.com/ipv6tech/.dotfiles/main/.scripts/dotfile-init.sh | bash
```

To add and track changes to dotfiles via your new dotfiles shell alias.

```sh
dotfiles add ~/dir/file
dotfiles commit -m "adding file for ..."
dotfiles push
```

With help from:
https://medium.com/@ritvikmarwaha/change-your-shell-to-zsh-on-a-remote-server-with-or-without-root-access-c4339804caab
https://mjones44.medium.com/storing-dotfiles-in-a-git-repository-53f765c0005d
https://www.anand-iyer.com/blog/2018/a-simpler-way-to-manage-your-dotfiles
