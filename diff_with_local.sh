for f in $(find . -type f); do
	noDotSlash=${f#"./"}
	if [[ "$noDotSlash" =~ ".git" ]] || [[ "$noDotSlash" == "README.md" ]] || [[ "$noDotSlash" == "diff_with_local.sh" ]]; then
		continue
	fi
	git diff "$noDotSlash" ~/"$noDotSlash" 2> /dev/null
done
