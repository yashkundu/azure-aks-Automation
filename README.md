## Usage/Examples

We will be using Ubuntu Linux Container\
Create a config.toml file in home directory.

```toml
[core]
listen=80
apiport=9900
enableServerStats=false
limitMaxConn=0
readTimeout=0
writeTimeout=0
idleTimeout=0

[limitReq]
enable=false

[proxy]

[[proxy.routes]]
endpoint="/"
match=1
balancer=0

[[proxy.routes.backends]]
url="http://localhost:3000"
varName="rhime"
```

Then start falcon as a systemd service.

```command
    falcon -config=/home/ubuntu/config.toml
```

Copy this scripts into the home home directory and run :

```command
./server.sh
```

You can modify the \*.html files according to your style
