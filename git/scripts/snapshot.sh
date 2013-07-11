[ -d "$tgtRepo" ] || { git init -q "$tgtRepo"; git --git-dir="$tgtRepo/.git" config core.autocrlf false; touch -d "1974-01-01 00:00:00" "$tgtRepo/.git/ts"; }
	if echo $tgtPath | grep -E '_git/(modules/[^/]+/)?index' > /dev/null
	then
		echo "found a index file"
		git --git-dir="$(dirname $src)" ls-files --cached -s > "$tgt"
		continue
	fi
	if echo $tgtPath | grep -E '_git/(modules/[^/]+/)?objects/[0-9a-f]{2}/[0-9a-f]{38}$' > /dev/null
	then
		echo "found a object file"
		git --git-dir="$(dirname $src)/../.." cat-file -p ${tgtPath: -41:2}${tgtPath: -38:38} > "$tgt"
		continue
	fi