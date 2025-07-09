for f in $(find . -type f); do
	noDotSlash=${f#"./"}
	if [[ "$noDotSlash" =~ ".git" ]] || [[ "$noDotSlash" == "README.md" ]] || [[ "$noDotSlash" == "diff_with_local.sh" ]] || [[ "$noDotSlash" == ".bashrc" ]]; then
		continue
	fi

	git diff "$noDotSlash" ~/"$noDotSlash" 2> /dev/null
done

cs2autoexec=~/".steam/debian-installation/steamapps/common/Counter-Strike Global Offensive/game/csgo/cfg/autoexec.cfg"
if test -f "$cs2autoexec"; then
	git diff cs2-config/autoexec.cfg "$cs2autoexec"
else
	echo "WARNING: Missing CS2 autoexec.cfg file at:"
	echo "$cs2autoexec"
fi

tf2autoexec=~/".steam/debian-installation/steamapps/common/Team Fortress 2/tf/cfg/autoexec.cfg"
if test -f "$tf2autoexec"; then
	git diff tf2-config/autoexec.cfg "$tf2autoexec"
else
	echo "WARNING: Missing TF2 autoexec.cfg file at:"
	echo "$cs2autoexec"
fi
