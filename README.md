# 🚀 SCP for GitHub Actions

[GitHub Action](https://github.com/features/actions) for copying files and artifacts via SSH.

[![Actions Status](https://github.com/appleboy/scp-action/workflows/scp%20files/badge.svg)](https://github.com/appleboy/scp-action/actions)

**Important**: Only support **Linux** [docker](https://www.docker.com/) container.

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
    - uses: actions/checkout@master
    - name: copy file via ssh password
      uses: appleboy/scp-action@master
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USERNAME }}
        password: ${{ secrets.PASSWORD }}
        port: ${{ secrets.PORT }}
        source: "tests/a.txt,tests/b.txt"
        target: "test"
```

## Input variables

See the [action.yml](./action.yml) file for more detail information.

* host - scp remote host
* port - scp remote port, default is `22`
* username - scp username
* password - scp password
* passphrase - the passphrase is usually to encrypt the private key
* fingerprint - fingerprint SHA256 of the host public key, default is to skip verification
* timeout - timeout for ssh to remote host, default is `30s`
* command_timeout - timeout for scp command, default is `10m`
* key - content of ssh private key. ex raw content of ~/.ssh/id_rsa
* key_path - path of ssh private key
* target - target path on the server
* source - scp file list
* rm - remove target folder before upload data, default is `false`
* strip_components - remove the specified number of leading path elements.
* overwrite - use `--overwrite` flag with tar
* tar_tmp_path - temporary path for tar file on the dest host
* use_insecure_cipher - include more ciphers with use_insecure_cipher (see [#15](https://github.com/appleboy/scp-action/issues/15))

SSH Proxy Setting:

* proxy_host - proxy host
* proxy_port - proxy port, default is `22`
* proxy_username - proxy username
* proxy_password - proxy password
* proxy_passphrase - the passphrase is usually to encrypt the private key
* proxy_timeout - timeout for ssh to proxy host, default is `30s`
* proxy_key - content of ssh proxy private key.
* proxy_key_path - path of ssh proxy private key
* proxy_fingerprint - fingerprint SHA256 of the host public key, default is to skip verification
* proxy_use_insecure_cipher - include more ciphers with use_insecure_cipher (see [#15](https://github.com/appleboy/scp-action/issues/15))

## Setting up a SSH Key

Make sure to follow the below steps while creating SSH Keys and using them.
The best practice is create the SSH Keys on local machine not remote machine.
Login with username specified in Github Secrets. Generate a RSA Key-Pair:

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

* Put the public key in `.ssh/authorized_keys2`
* Change the permissions of `.ssh` to 700
* Change the permissions of `.ssh/authorized_keys2` to 640

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
  uses: appleboy/scp-action@master
  with:
    host: example.com
    username: foo
    password: bar
    port: 22
    source: "tests/a.txt,tests/b.txt"
    target: "test"
```

Copy file via a SSH key:

```yaml
- name: copy file via ssh key
  uses: appleboy/scp-action@master
  with:
    host: ${{ secrets.HOST }}
    username: ${{ secrets.USERNAME }}
    port: ${{ secrets.PORT }}
    key: ${{ secrets.KEY }}
    source: "tests/a.txt,tests/b.txt"
    target: "test"
```

Example configuration for ignore list:

```yaml
- name: copy file via ssh key
  uses: appleboy/scp-action@master
  with:
    host: ${{ secrets.HOST }}
    username: ${{ secrets.USERNAME }}
    port: ${{ secrets.PORT }}
    key: ${{ secrets.KEY }}
    source: "tests/*.txt,!tests/a.txt"
    target: "test"
```

Example configuration for multiple servers:

```diff
  uses: appleboy/scp-action@master
  with:
-   host: "example.com"
+   host: "foo.com,bar.com"
    username: foo
    password: bar
    port: 22
    source: "tests/a.txt,tests/b.txt"
    target: "test"
```

Remove the specified number of leading path elements:

```yaml
- name: remove the specified number of leading path elements
  uses: appleboy/scp-action@master
  with:
    host: ${{ secrets.HOST }}
    username: ${{ secrets.USERNAME }}
    key: ${{ secrets.KEY }}
    port: ${{ secrets.PORT }}
    source: "tests/a.txt,tests/b.txt"
    target: "foobar"
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

Protecting a Private Key. The purpose of the passphrase is usually to encrypt the private key. This makes the key file by itself useless to an attacker. It is not uncommon for files to leak from backups or decommissioned hardware, and hackers commonly exfiltrate files from compromised systems.

```diff
  - name: ssh key with passphrase
    uses: appleboy/scp-action@master
    with:
      host: ${{ secrets.HOST }}
      username: ${{ secrets.USERNAME }}
      key: ${{ secrets.SSH2 }}
+     passphrase: ${{ secrets.PASSPHRASE }}
      port: ${{ secrets.PORT }}
      source: "tests/a.txt,tests/b.txt"
      target: "test"
```
