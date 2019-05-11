workflow "Copy File Via SSH" {
  on = "push"
  resolves = [
    "Copy file via ssh password",
    "Copy file via ssh key",
  ]
}

action "Copy file via ssh password" {
  uses = "appleboy/scp-action@master"
  env = {
    SOURCE = "tests/a.txt,tests/b.txt"
    TARGET = "/home/actions/test"
  }
  secrets = [
    "HOST",
    "USERNAME",
    "PASSWORD",
  ]
}

action "Copy file via ssh key" {
  uses = "appleboy/scp-action@master"
  env = {
    SOURCE = "tests/a.txt,tests/b.txt"
    TARGET = "/home/actions/test"
  }
  secrets = [
    "HOST",
    "USERNAME",
    "KEY",
  ]
}
