workflow "Copy File Via SSH" {
  on = "push"
  resolves = [
    "Copy file via ssh password",
    "Copy file via ssh key",
    "Add source in args",
    "Add secret in args",
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

action "Add source in args" {
  uses = "appleboy/scp-action@master"
  env = {
    TARGET = "/home/actions/test1234"
  }
  secrets = [
    "HOST",
    "USERNAME",
    "KEY",
  ]
  args = ["--source", "tests/a.txt", "--source", "tests/b.txt"]
}

action "Add secret in args" {
  uses = "appleboy/scp-action@master"
  env = {
    TARGET = "/home/actions/test1234"
  }
  secrets = [
    "HOST",
    "KEY",
  ]
  args = [
    "--username", "$USERNAME",
    "--source", "tests/a.txt",
    "--source", "tests/b.txt",
  ]
}
