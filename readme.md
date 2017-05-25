slack `#general` message all delete.

```bash
$ sudo systemctl start docker
$ sudo docker pull syui/slack-message-delete
$ sudo docker run -it syui/slack-message-delete
$ slack-message-delete $TOKEN
or
$ echo $TOKEN > ~/.config/slack/api.txt
$ slack-message-delete
```
