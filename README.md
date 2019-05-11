# 🚀 SCP for GitHub Actions

[GitHub Action](https://developer.github.com/actions/) for copying files and artifacts via SSH.

<img src="./images/facebook-message.png">

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

### Example

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
