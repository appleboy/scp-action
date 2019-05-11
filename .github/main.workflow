workflow "Send Notification" {
  on = "push"
  resolves = [
    "Copy multiple file",
  ]
}

action "Copy multiple file" {
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
