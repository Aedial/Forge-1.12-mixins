while true; do
	inotifywait -qe modify .
	rsync -a *.zs "$1"
done
