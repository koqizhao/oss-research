echo "using: $*"

for p in $*
do
	echo "starting: $p"
	./random -listen-address=:$p &
	echo "started: $p"
done
