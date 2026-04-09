+++
date = '2025-11-27T10:20:21Z'
draft = true
title = 'How I Programmed on Android'
lastmod = '2026-04-09T12:17:12Z'
tags = ["postgresql", "linux", "go", "neovim", "cli", "android", "tmux", "termux", "pgweb"]
+++

## Initial Steps

Downloaded [F-Droid](https://f-droid.org/en/) and installed Termux and Termux API.

## Setting Up Termux for Development

Update packages

```bash
pkg update && pkg upgrade
```

### Add Android Integration

Allow termux to access phone storage. Phone storage will be available at: `/storage/shared/`.

```bash
termux-setup-storage
```

For syncing the android's clipboard with termux's. It comes with the companion app (Termux API, installed from F-Droid).

```bash
pkg install termux-api
```

## Installing Linux on Android

Install `proot-distro` for this task.

> At this point, it is advised to use a wireless keyboard and mouse for ease of use.

```bash
pkg install proot-distro
```

Check for the available distros:

```bash
pd list
```

Installing arch linux

```bash
pd install archlinux
```

After installation, login into the archlinux shell:

{{< alert "circle-info" >}}
There is no GUI, only CLI. GUI can be added later, but it is not part of this document.
{{< /alert >}}

```bash
pd login archlinux
```

## Setting Up Archlinux

Update your repositories:

```bash
pacman -Syu
```

Install the needed software for development.

```bash
pacman -S go neovim
```

In addition to neovim, add any tools for productive developer experience.

```bash
pacman -S git make unzip gcc tmux ripgrep fd wget curl tar fzf
```

{{< alert "circle-info" >}}
Update `$PATH` variable where necessary.
{{< /alert >}}

Configuring git globally:

```bash
git config --global user.name "full name"
git config --global user.email "email@email.com"
git config --global init.defaultBranch main
```

To setup ssh for working with remote repos, github provides an excellent guide here:

- [Generating an SSH key and adding it to the key agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
- [Add a New SSH Key to Github Account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

Pull neovim config from any remote repo

```bash
git clone https://github.com/davesaah/nvim.git ~/.config/nvim
```

Get the tmux config as well.

```bash
git clone https://github.com/davesaah/tmux.git
cp tmux/.tmux.conf ~/
```

## Creating and Using Postgres

Install postgres

```bash
pkg install postgresql
```

Initialiaze the database

```bash
initdb -D $PREFIX/var/lib/postgres/data
```

Create a postgres user: it throws an error of server not running, look at the command below to start the server.

```bash
createuser --interactive
```

Create a postgres database:

```bash
createdb local # local can be any name
```

Then start the database:

```bash
pg_ctl -D /data/data/com.termux/files/usr/var/lib/postgres/data -l logfile start
```

To stop it, you run a similar command:

```bash
pg_ctl -D /data/data/com.termux/files/usr/var/lib/postgres/data -l logfile stop
```

As a lazy programmer, place this into a bash script so you don't think about it.

Login into the database:

```bash
psql local
```

Make the following updates:

- Add password for the created user (identified by the placeholder, `user_name`).
- Make the user the owner of local (or the name of the database created).

```sql
ALTER USER user_name WITH ENCRYPTED PASSWORD 'password';
ALTER DATABASE local OWNER TO user_name;
```

Exit the postgres shell by typing `exit` or the classic, `CTRL-D`.

Managing a database without a GUI can be a pain sometimes, so setup one. Now, the advantage of termux is that though one cannot run native linux GUI applications, one can always run web servers.
Install **pgweb**, which is a web UI for managing postgres.

{{< alert "circle-info" >}}
*pgweb* can be installed in termux shell or archlinux shell. It doesn't matter.
{{< /alert >}}

Prerequities:

- Install Go. That was done previously so you can safely ignore it.
- Add the `GO_BIN` directory to `$PATH`.

Installing pgweb

```bash
go install github.com/sosedoff/pgweb@latest
```

When it is done, run the command:

```bash
pgweb
```

Navigate to [http://localhost:8081](http://localhost:8081). You will see a beautiful interface that can be installed as a PWA:

## Bonus

What about docker? Docker needs kernel access to work and android devices without root will fail to intall docker. But… a virtual machine can be installed to run docker. However, the device needs to have more RAM, at least 8GB for a smooth workflow.

Follow oofnikj's [guide](https://gist.github.com/oofnikj/e79aef095cd08756f7f26ed244355d62) if you are interested.
