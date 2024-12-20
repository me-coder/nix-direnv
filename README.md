# About
This repo provides a sample environment for trying out direnv with nix-shell support in a containerized environment.

## Run the Nix container
In a PowerShell on Windows or any shell terminal on Linux run command.

Using Git Bash on Windows 11 here:
```bash
MINGW64 ~
$ docker run --rm -it --name=nix --mount="source=/c/Workspace/nix,target=/root/workspace,type=bind" -w=/root/workspace ghcr.io/nixos/nix:latest

bash-5.2# pwd
/root/workspace

bash-5.2# ls -Al /root/workspace/
total 5
drwxrwxrwx 1 root root 512 Dec  1 10:08 .direnv
-rwxrwxrwx 1 root root  24 Dec 20 07:40 .envrc
drwxrwxrwx 1 root root 512 Dec 20 08:48 .git
-rwxrwxrwx 1 root root   0 Dec  1 10:34 .gitignore
drwxrwxrwx 1 root root 512 Dec  1 07:41 .nix
drwxrwxrwx 1 root root 512 Dec 20 07:40 .vscode
-rwxrwxrwx 1 root root 697 Dec 20 09:13 README.md
drwxrwxrwx 1 root root 512 Dec  1 09:41 python
-rwxrwxrwx 1 root root 647 Dec 20 07:40 shell.nix
```

However, the nix shell is not yet initialized by `shell.nix` configuration, which can be verified using:
```bash
bash-5.2# ll
bash: ll: command not found
bash-5.2# gs
bash: gs: command not found
bash-5.2#
```

## Start nix-shell
Verify shell.nix is available in container directory:
```bash
bash-5.2# ls -Al shell.nix
-rwxrwxrwx 1 root root 647 Dec 20 07:40 shell.nix
```

Configure nix shell:
```
bash-5.2# nix-shell
unpacking 'https://github.com/NixOS/nixpkgs/tarball/nixos-24.11-small' into the Git cache...
these 34 paths will be fetched (22.28 MiB download, 121.40 MiB unpacked):
  /nix/store/nrl5m466dwdscvavf1nqzdnqhszjyy9n-acl-2.3.2
...
...
copying path '/nix/store/spb2bpcnw0gbbr4x94cq8xs9n72hipwj-stdenv-linux' from 'https://cache.nixos.org'...
direnv: loading ~/workspace/.envrc
direnv: export +BREADCRUMB

[nix-shell:~/workspace]# ll
total 8
drwxrwxrwx 1 root root  512 Dec  1 10:08 .direnv
-rwxrwxrwx 1 root root   24 Dec 20 07:40 .envrc
drwxrwxrwx 1 root root  512 Dec 20 09:21 .git
-rwxrwxrwx 1 root root   10 Dec 20 09:23 .gitignore
drwxrwxrwx 1 root root  512 Dec  1 07:41 .nix
drwxrwxrwx 1 root root  512 Dec 20 07:40 .vscode
-rwxrwxrwx 1 root root 2065 Dec 20 09:19 README.md
drwxrwxrwx 1 root root  512 Dec  1 09:41 python
-rwxrwxrwx 1 root root  647 Dec 20 07:40 shell.nix

[nix-shell:~/workspace]# gs
On branch main

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   .direnv/direnv.toml
        new file:   .envrc
        new file:   .gitignore
        new file:   .nix/local.nix
        new file:   .nix/python.nix
        new file:   .vscode/settings.json
        new file:   README.md
        new file:   python/.envrc
        new file:   shell.nix

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   .gitignore
        modified:   .vscode/settings.json
        modified:   README.md

[nix-shell:~/workspace]#
```

Notice that the custom aliases `gs` and `ll` set in `shell.nix` and `.nix/local.nix` respectively, are now functional in the nix configured shell.

Also, note that **python** is still unavailable.
```bash
[nix-shell:~/workspace]# python -version
bash: python: command not found

[nix-shell:~/workspace]# python3 -version
bash: python3: command not found
```

## Switch environments defined by dotfiles
Let's leverage the direnv to setup **Python** environment in underlying python directory.

```bash
[nix-shell:~/workspace]# cd python
direnv: loading ~/workspace/python/.envrc
direnv: using nix ../.nix/python.nix
this derivation will be built:
  /nix/store/dlbbgcqj1117v25qgm8hm86m9si7d7kc-python3-3.11.9-env.drv
building '/nix/store/dlbbgcqj1117v25qgm8hm86m9si7d7kc-python3-3.11.9-env.drv'...
created 259 symlinks in user environment
direnv: export +BREADCRUMB +DETERMINISTIC_BUILD +PYTHONHASHSEED +PYTHONNOUSERSITE +PYTHONPATH +_PYTHON_HOST_PLATFORM +_PYTHON_SYSCONFIGDATA_NAME ~CONFIG_SHELL ~HOST_PATH ~NIX_BUILD_TOP ~NIX_CFLAGS_COMPILE ~NIX_LDFLAGS ~PATH ~TEMP ~TEMPDIR ~TMP ~TMPDIR ~XDG_DATA_DIRS ~buildInputs ~builder ~out ~shellHook ~stdenv

[nix-shell:~/workspace/python]# python3 --version
Python 3.13.0b3
```

Also, notice that python is not available if we go back to the workspace directory:
```bash
[nix-shell:~/workspace/python]# cd ..
direnv: loading ~/workspace/.envrc
direnv: export +BREADCRUMB

[nix-shell:~/workspace]# python3 --version
bash: python3: command not found
```

Similar directory specific environments can be added using direnv by extending with reference to `python/.envrc` and `.nix/python.nix`.


# Reference
*  [What is direnv and how does it help?](https://direnv.net/)
*  [How to configure Nix to use a dotfile?](https://nix.dev/guides/recipes/direnv.html)