# 🚀 SCP for GitHub Actions

[GitHub Action](https://github.com/features/actions) for copying files and artifacts via SSH.

[![Actions Status](https://github.com/appleboy/scp-action/workflows/scp%20files/badge.svg)](https://github.com/appleboy/scp-action/actions)

**Important**: Only supports **Linux** [docker](https://www.docker.com/) containers.

## Usage

Copy files and artifacts via SSH:

```yaml
name: scp files
on: [push]
jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: copy file via ssh password
        uses: appleboy/scp-action@v0.1.7
        with:
          host: ${{ secrets.HOST }}
          username: ${{ secrets.USERNAME }}
          password: ${{ secrets.PASSWORD }}
          port: ${{ secrets.PORT }}
          source: "tests/a.txt,tests/b.txt"
          target: your_server_target_folder_path
```

## Input variables

See the [action.yml](./action.yml) file for more detail information.

| Variable            | Description                                                                                                 | Default Value |
| ------------------- | ----------------------------------------------------------------------------------------------------------- | ------------- |
| host                | SCP remote host                                                                                             | -             |
| port                | SCP remote port                                                                                             | `22`          |
| username            | SCP username                                                                                                | -             |
| password            | SCP password                                                                                                | -             |
| passphrase          | The passphrase is usually used to encrypt the private key                                                   | -             |
| protocol            | The IP protocol to use. Valid values are `tcp`, `tcp4`, or `tcp6`.                                          | `tcp`         |
| fingerprint         | Fingerprint SHA256 of the host public key. Default is to skip verification                                  | -             |
| timeout             | Timeout for SSH to remote host                                                                              | `30s`         |
| command_timeout     | Timeout for SCP command                                                                                     | `10m`         |
| key                 | Content of SSH private key. e.g., raw content of ~/.ssh/id_rsa                                              | -             |
| key_path            | Path of SSH private key                                                                                     | -             |
| target              | Target path on the server, must be a directory (**required**)                                               | -             |
| source              | SCP file list (**required**)                                                                                | -             |
| rm                  | Remove target folder before uploading data                                                                  | `false`       |
| strip_components    | Remove the specified number of leading path elements                                                        | -             |
| overwrite           | Use `--overwrite` flag with tar, overwrite existing files when extracting                                   | -             |
| tar_tmp_path        | Temporary path for tar file on the destination host                                                         | -             |
| tar_exec            | Path to tar executable on the destination host                                                              | `tar`         |
| tar_dereference     | Use `--dereference` flag with tar, follow symlinks; archive and dump the files they point to                | -             |
| use_insecure_cipher | Include more ciphers with use_insecure_cipher (see [#15](https://github.com/appleboy/scp-action/issues/15)) | -             |

SSH Proxy Setting:

| Variable                  | Description                                                                                                 | Default Value |
| ------------------------- | ----------------------------------------------------------------------------------------------------------- | ------------- |
| proxy_host                | Proxy host                                                                                                  | -             |
| proxy_port                | Proxy port                                                                                                  | `22`          |
| proxy_username            | Proxy username                                                                                              | -             |
| proxy_password            | Proxy password                                                                                              | -             |
| proxy_protocol            | The IP protocol to use. Valid values are `tcp`, `tcp4`, or `tcp6`.                                          | `tcp`         |
| proxy_passphrase          | The passphrase is usually used to encrypt the private key                                                   | -             |
| proxy_timeout             | Timeout for SSH to proxy host                                                                               | `30s`         |
| proxy_key                 | Content of SSH proxy private key                                                                            | -             |
| proxy_key_path            | Path of SSH proxy private key                                                                               | -             |
| proxy_fingerprint         | Fingerprint SHA256 of the host public key. Default is to skip verification                                  | -             |
| proxy_use_insecure_cipher | Include more ciphers with use_insecure_cipher (see [#15](https://github.com/appleboy/scp-action/issues/15)) | -             |

## Setting up a SSH Key

Make sure to follow the steps below when creating and using SSH keys.
The best practice is to create the SSH keys on the local machine, not the remote machine.
Log in with the username specified in GitHub Secrets and generate an RSA key pair:

```bash
# rsa
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# ed25519
ssh-keygen -t ed25519 -a 200 -C "your_email@example.com"
```

Add newly generated key into Authorized keys. Read more about authorized keys [here](https://www.ssh.com/ssh/authorized_keys/).

```bash
# rsa
cat .ssh/id_rsa.pub | ssh b@B 'cat >> .ssh/authorized_keys'

# d25519
cat .ssh/id_ed25519.pub | ssh b@B 'cat >> .ssh/authorized_keys'
```

Copy Private Key content and paste in Github Secrets.

```bash
# rsa
clip < ~/.ssh/id_rsa

# ed25519
clip < ~/.ssh/id_ed25519
```

See the detail information about [SSH login without password](http://www.linuxproblem.org/art_9.html).

**A note** from one of our readers: Depending on your version of SSH you might also have to do the following changes:

- Put the public key in `.ssh/authorized_keys2`
- Change the permissions of `.ssh` to 700
- Change the permissions of `.ssh/authorized_keys2` to 640

### If you are using OpenSSH

If you are currently using OpenSSH and are getting the following error:

```bash
ssh: handshake failed: ssh: unable to authenticate, attempted methods [none publickey]
```

Make sure that your key algorithm of choice is supported.
On Ubuntu 20.04 or later you must explicitly allow the use of the ssh-rsa algorithm. Add the following line to your OpenSSH daemon file (which is either `/etc/ssh/sshd_config` or a drop-in file under `/etc/ssh/sshd_config.d/`):

```bash
CASignatureAlgorithms +ssh-rsa
```

Alternatively, `ed25519` keys are accepted by default in OpenSSH. You could use this instead of rsa if needed:

```bash
ssh-keygen -t ed25519 -a 200 -C "your_email@example.com"
```

## Example

Copy file via a SSH password:

```yaml
- name: copy file via ssh password
  uses: appleboy/scp-action@v0.1.7
  with:
    host: example.com
    username: foo
    password: bar
    port: 22
    source: "tests/a.txt,tests/b.txt"
    target: your_server_target_folder_path
```

Using the environment variables

```yaml
- name: copy file via ssh password
  uses: appleboy/scp-action@v0.1.7
  with:
    host: ${{ env.HOST }}
    username: ${{ env.USERNAME }}
    password: ${{ secrets.PASSWORD }}
    port: ${{ env.PORT }}
    source: "tests/a.txt,tests/b.txt"
    target: ${{ env.TARGET_PATH }}
```

Copy file via a SSH key:

```yaml
- name: copy file via ssh key
  uses: appleboy/scp-action@v0.1.7
  with:
    host: ${{ secrets.HOST }}
    username: ${{ secrets.USERNAME }}
    port: ${{ secrets.PORT }}
    key: ${{ secrets.KEY }}
    source: "tests/a.txt,tests/b.txt"
    target: your_server_target_folder_path
```

Example configuration for ignore list:

```yaml
- name: copy file via ssh key
  uses: appleboy/scp-action@v0.1.7
  with:
    host: ${{ secrets.HOST }}
    username: ${{ secrets.USERNAME }}
    port: ${{ secrets.PORT }}
    key: ${{ secrets.KEY }}
    source: "tests/*.txt,!tests/a.txt"
    target: your_server_target_folder_path
```

Example configuration for multiple servers:

```diff
  uses: appleboy/scp-action@v0.1.7
  with:
-   host: "example.com"
+   host: "foo.com,bar.com"
    username: foo
    password: bar
    port: 22
    source: "tests/a.txt,tests/b.txt"
    target: your_server_target_folder_path
```

Example configuration for exclude custom files:

```yaml
  uses: appleboy/scp-action@v0.1.7
  with:
    host: "example.com"
    username: foo
    password: bar
    port: 22
-   source: "tests/*.txt"
+   source: "tests/*.txt,!tests/a.txt,!tests/b.txt"
    target: your_server_target_folder_path
```

Upload artifact files to remote server:

```yaml
deploy:
  name: deploy artifact
  runs-on: ubuntu-latest
  steps:
    - name: checkout
      uses: actions/checkout@v4

    - run: echo hello > world.txt

    - uses: actions/upload-artifact@v4
      with:
        name: my-artifact
        path: world.txt

    - uses: actions/download-artifact@v4
      with:
        name: my-artifact
        path: distfiles

    - name: copy file to server
      uses: appleboy/scp-action@v0.1.7
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USERNAME }}
        key: ${{ secrets.KEY }}
        port: ${{ secrets.PORT }}
        source: distfiles/*
        target: your_server_target_folder_path
```

Remove the specified number of leading path elements:

```yaml
- name: remove the specified number of leading path elements
  uses: appleboy/scp-action@v0.1.7
  with:
    host: ${{ secrets.HOST }}
    username: ${{ secrets.USERNAME }}
    key: ${{ secrets.KEY }}
    port: ${{ secrets.PORT }}
    source: "tests/a.txt,tests/b.txt"
    target: your_server_target_folder_path
    strip_components: 1
```

Old target structure:

```sh
foobar
  └── tests
    ├── a.txt
    └── b.txt
```

New target structure:

```sh
foobar
  ├── a.txt
  └── b.txt
```

Only copy files that are newer than the corresponding destination files:

```yaml
changes:
  name: test changed-files
  runs-on: ubuntu-latest
  steps:
    - name: checkout
      uses: actions/checkout@v4

    - name: Get changed files
      id: changed-files
      uses: tj-actions/changed-files@v35
      with:
        since_last_remote_commit: true
        separator: ","

    - name: copy file to server
      uses: appleboy/scp-action@v0.1.7
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USERNAME }}
        key: ${{ secrets.KEY }}
        port: ${{ secrets.PORT }}
        source: ${{ steps.changed-files.outputs.all_changed_files }}
        target: your_server_target_folder_path
```

Protecting a Private Key. The purpose of the passphrase is usually to encrypt the private key. This makes the key file by itself useless to an attacker. It is not uncommon for files to leak from backups or decommissioned hardware, and hackers commonly exfiltrate files from compromised systems.

```diff
  - name: ssh key with passphrase
    uses: appleboy/scp-action@v0.1.7
    with:
      host: ${{ secrets.HOST }}
      username: ${{ secrets.USERNAME }}
      key: ${{ secrets.SSH2 }}
+     passphrase: ${{ secrets.PASSPHRASE }}
      port: ${{ secrets.PORT }}
      source: "tests/a.txt,tests/b.txt"
      target: your_server_target_folder_path
```

When copying files from a Linux runner to a Windows server, you should:

1. Download git for Windows
2. Change the default OpenSSH shell to git bach with the following powershell command.
3. Set `tar_dereference` and `rm` variable to `true` in the YAML file
4. Avoid putting the `port` value through a variable
5. Convert the target path to a Unix path: `/c/path/to/target/`

Change the default OpenSSH shell to git bach with the following powershell command.

```powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "$env:Programfiles\Git\bin\bash.exe" -PropertyType String -Force
```

Convert the target path to a Unix path: `/c/path/to/target/`

```diff
  - name: Copy to Windows
      uses: appleboy/scp-action@v0.1.7
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USERNAME }}
        key: ${{ secrets.SSH_PRIVATE_KEY }}
        port: 22
        source: 'your_source_path'
-       target: 'C:\path\to\target'
+       target: '/c/path/to/target/'
+       tar_dereference: true
+       rm: true
```
