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

## Secrets

* `PASSWORD` - ssh server password
* `KEY` - ssh server private key
