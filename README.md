# 🚀 SCP for GitHub Actions

[GitHub Action](https://developer.github.com/actions/) for copying files and artifacts via SSH.

<img src="./images/copy-multiple-file.png">

## Usage

copy files and artifacts via SSH as blow.

```
action "Copy multiple file" {
  uses = "appleboy/scp-action@master"
  env = {
    HOST = "example.com"
    USERNAME = "foo"
    PASSWORD = "bar"
    PORT = "22"
    SOURCE = "tests/a.txt,tests/b.txt"
    TARGET = "/home/foo/test"
  }
  secrets = [
    "PASSWORD",
  ]
}
```

## Environment variables

* HOST - ssh server host
* PORT - ssh server port
* USERNAME - ssh server username
* PASSWORD - ssh server password
* KEY - ssh server private key
* TARGET - target folder
* SOURCE - scp file list

### Example

Copy file via ssh password

```
action "Copy multiple file" {
  uses = "appleboy/scp-action@master"
  env = {
    HOST = "example.com"
    USERNAME = "foo"
    PORT = "22"
    SOURCE = "tests/a.txt,tests/b.txt"
    TARGET = "/home/foo/test"
  }
  secrets = [
    "PASSWORD",
  ]
}
```

Copy file via ssh key

```
action "Copy file via ssh key" {
  uses = "appleboy/scp-action@master"
  env = {
    HOST = "example.com"
    USERNAME = "foo"
    PORT = "22"
    SOURCE = "tests/c.txt,tests/d.txt"
    TARGET = "/home/actions/test"
  }
  secrets = [
    "KEY",
  ]
}
```

Example configuration for ignore list:

```
action "reqular expression list" {
  uses = "appleboy/scp-action@master"
  env = {
    HOST = "example.com"
    USERNAME = "foo"
    PORT = "22"
    SOURCE = "tests/*.txt,!tests/a.txt"
    TARGET = "/home/actions/test"
  }
  secrets = [
    "KEY",
  ]
}
```

Example configuration for multiple server

```diff
action "reqular expression list" {
  uses = "appleboy/scp-action@master"
  env = {
-   HOST = "example.com"
+   HOST = "foo.com,bar.com"
    USERNAME = "foo"
    PORT = "22"
    SOURCE = "tests/*.txt,!tests/a.txt"
    TARGET = "/home/actions/test"
  }
  secrets = [
    "KEY",
  ]
}
```

Example configuration for custom secret for ssh password

```
action "Add secret in args" {
  uses = "appleboy/scp-action@master"
  env = {
    TARGET = "/home/actions/test1234"
  }
  secrets = [
    "HOST",
    "TEST_USERNAME",
    "TEST_PASSWORD",
    "KEY",
  ]
  args = [
    "--username", "$TEST_USERNAME",
    "--password", "$TEST_PASSWORD",
    "--source", "tests/a.txt",
    "--source", "tests/b.txt",
  ]
}
```

see the detail of `drone-scp` command

```
   --host value, -H value             Server host [$PLUGIN_HOST, $SCP_HOST, $SSH_HOST, $HOST]
   --port value, -P value             Server port, default to 22 (default: "22") [$PLUGIN_PORT, $SCP_PORT, $SSH_PORT, $PORT]
   --username value, -u value         Server username [$PLUGIN_USERNAME, $PLUGIN_USER, $SCP_USERNAME, $SSH_USERNAME, $USERNAME]
   --password value, -p value         Password for password-based authentication [$PLUGIN_PASSWORD, $SCP_PASSWORD, $SSH_PASSWORD, $PASSWORD]
   --timeout value                    connection timeout (default: 0s) [$PLUGIN_TIMEOUT, $SCP_TIMEOUT]
   --command.timeout value, -T value  command timeout (default: 1m0s) [$PLUGIN_COMMAND_TIMEOUT, $SSH_COMMAND_TIMEOUT]
   --key value, -k value              ssh private key [$PLUGIN_KEY, $SCP_KEY, $SSH_KEY, $KEY]
   --key-path value, -i value         ssh private key path [$PLUGIN_KEY_PATH, $SCP_KEY_PATH, $SSH_KEY_PATH]
   --target value, -t value           Target path on the server [$PLUGIN_TARGET, $SCP_TARGET, $TARGET]
   --source value, -s value           scp file list [$PLUGIN_SOURCE, $SCP_SOURCE, $SOURCE]
   --rm, -r                           remove target folder before upload data [$PLUGIN_RM, $SCP_RM, $RM]
   --proxy.ssh-key value              private ssh key of proxy [$PLUGIN_PROXY_SSH_KEY, $PLUGIN_PROXY_KEY, $PROXY_SSH_KEY, $PROXY_KEY]
   --proxy.key-path value             ssh private key path of proxy [$PLUGIN_PROXY_KEY_PATH, $PROXY_SSH_KEY_PATH]
   --proxy.username value             connect as user of proxy (default: "root") [$PLUGIN_PROXY_USERNAME, $PLUGIN_PROXY_USER, $PROXY_SSH_USERNAME, $PROXY_USERNAME]
   --proxy.password value             user password of proxy [$PLUGIN_PROXY_PASSWORD, $PROXY_SSH_PASSWORD, $PROXY_PASSWORD]
   --proxy.host value                 connect to host of proxy [$PLUGIN_PROXY_HOST, $PROXY_SSH_HOST, $PROXY_HOST]
   --proxy.port value                 connect to port of proxy (default: "22") [$PLUGIN_PROXY_PORT, $PROXY_SSH_PORT, $PROXY_PORT]
   --proxy.timeout value              proxy connection timeout (default: 0s) [$PLUGIN_PROXY_TIMEOUT, $PROXY_SSH_TIMEOUT]
   --strip.components value           Remove the specified number of leading path elements. (default: 0) [$PLUGIN_STRIP_COMPONENTS, $TAR_STRIP_COMPONENTS]
   --tar.exec tar                     Alternative tar executable to on the dest host (default: "tar") [$PLUGIN_TAR_EXEC, $SCP_TAR_EXEC]
   --debug                            remove target folder before upload data [$PLUGIN_DEBUG, $DEBUG]
```

## Secrets

* `PASSWORD` - ssh server password
* `KEY` - ssh server private key
