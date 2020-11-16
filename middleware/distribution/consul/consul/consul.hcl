
datacenter = "DC"
data_dir = "DATA_DIR"
encrypt = "GOSSIP_KEY"
ca_file = "BASE_DIR/conf/consul-agent-ca.pem"
cert_file = "BASE_DIR/conf/DC-server-consul-0.pem"
key_file = "BASE_DIR/conf/DC-server-consul-0-key.pem"
verify_incoming = true
verify_outgoing = true
verify_server_hostname = true

acl = {
  enabled = false
  default_policy = "allow"
  enable_token_persistence = true
}

performance {
  raft_multiplier = 1
}
