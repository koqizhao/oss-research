
server = true

retry_join = ["192.168.56.11"]
bootstrap_expect = 1

ui = true

client_addr = "0.0.0.0"
bind_addr = "{{GetInterfaceIP \"enp0s8\"}}"
