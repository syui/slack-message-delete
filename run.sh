mkdir -p ./bin
cd ./bin
curl -sL https://github.com/stedolan/jq/releases/download/jq-1.4/jq-linux-x86_64 -o jq-64
curl -sL https://github.com/stedolan/jq/releases/download/jq-1.4/jq-linux-x86 -o jq-32
sudo systemctl start docker
cd ..
sudo docker build -t syui/slack-message-delete
sudo docker run -it syui/slack-message-delete
