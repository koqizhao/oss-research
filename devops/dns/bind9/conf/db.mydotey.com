;
; BIND data file for local loopback interface
;
$TTL	604800
@	IN	SOA	mydotey.com. root.mydotey.com. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
@	IN	NS	ns.mydotey.com.
@	IN	A	192.168.56.11
ns	IN	A	192.168.56.11
sns	IN	A	192.168.56.12
cns	IN	A	192.168.56.13
cns	IN	A	192.168.56.14
server1	IN	A	192.168.56.11
server2	IN	A	192.168.56.12
server3	IN	A	192.168.56.13
server4	IN	A	192.168.56.14
server5	IN	A	192.168.56.15