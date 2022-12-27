#!/data/data/com.termux/files/usr/bin/bash
myuid=$(/system/bin/id -u)
line_counter=0
interations=$1
if [ ! -z $interations ] && [ ! -z "$(grep -E '^[0-9]+$' <<< "$interations")" ]]; then
	echo "error: First argument not a number" >&2; exit 1
fi
GREEN="\e[32m"
ENDCOLOR="\e[0m"
UUID=$(cat /proc/sys/kernel/random/uuid)
while [[ "$UUID_" != "$UUID" ]]; do
	UUID_=$UUID
	for file in aid_passwd aid_group aid_context; do
		if [ -f $file.$UUID_ ]; then
			UUID_=$(cat /proc/sys/kernel/random/uuid)
			break
		fi
	done
done
UUID="$UUID_"
unset UUID_
sgrep () {
	str=$1
	shift
	echo "$str" | grep $@
}
#stdout=/proc/$$/fd/1
separate () {
	if [ $# -gt 1 ]; then
		local uid_name_=$uid_name uid_id_=$uid_id gid_name_=$gid_name gid_id_=$gid_id context_=$context
		for value in $@; do
			[ -n "$value" ] && eval "$(uid_name=$uid_name uid_id=$uid_id gid_name=$gid_name gid_id=$gid_id context=$context separate $value)"
			if [[ "$context" != "$context_" ]] && [[ "$context" != "" ]]; then
				echo "$context" >> aid_context.$UUID
				context_=$context
			fi
			if [[ "$uid_name" != "" ]]  && [[ "$gid_name" != "" ]] && [[ "$gid_id" != "" ]]; then
				if [[ "$uid_name" != "$uid_name_" ]] || [[ "$gid_name" != "$gid_name_" ]] || [[ "$gid_id" != "$gid_id_" ]]; then
					echo "$gid_name:x:$gid_id:$uid_name" >> aid_group.$UUID
					if [[ "$uid_id" != "" ]]; then
						if [[ "$uid_id" != "$uid_id_" ]]; then
							echo "$uid_name:x:$uid_id:$gid_id:$gid_name:/:/bin/bash" >> aid_passwd.$UUID
							uid_id_=$uid_id
						fi
					fi
					uid_name_=$uid_name
					gid_name_=$gid_name
					gid_id_=$gid_id
				fi
			fi
		done
	else
		if [ -n "$( sgrep "$1" -E '(uid|gid)' )" ]; then
			echo $1 | sed -r 's/^(uid|gid)=([0-9]*)\(([^)]*)\)$/\1_id=\2 \1_name=\3/g' | xargs -n1
		elif [ -n "$( sgrep "$1" -E '^context' )" ]; then
			echo $1 | sed -r 's/^(context)=([^ ]*)/\1=\2/g' | xargs -n1
		elif [ -n "$( sgrep "$1" -E '^groups' )" ]; then
			notunset=1 separate $(echo $1 | sed 's/^groups=/gid=/g' | sed 's/,/ gid=/g')
		fi
	fi
	if [ -z "$notunset" ]; then
		unset uid_name uid_id gid_name gid_id context
	fi
}
unset user
for uid in $(seq 0 19999); do
	if [ ! -z $interations ]; then
		if [ $line_counter -gt $interations ]; then
			break
		fi
		line_counter=$(($line_counter + 1))
	fi
	#uid=0(root) gid=0(root) groups=0(root) context=u:r:untrusted_app_27:s0:c15,c257,c512,c768
	if [[ "$myuid" == "$uid" ]]; then
		user="$(/system/bin/id 2>/dev/null)"
	else
		user="$(/system/bin/id $uid 2>/dev/null)"
	fi
	if [ -n $uset ]; then
		separate $user
	fi
	unset user
done
for file in aid_passwd aid_group aid_context; do
	if [ -f $file.$UUID ]; then
		mv $file.$UUID $file.$UUID.tmp && ( cat $file.$UUID.tmp | uniq > $file.$UUID ) && rm $file.$UUID.tmp
		echo "$GREEN_-_-_- [ File $file.$UUID creation done ] -_-_-_: $ENDCOLOR"
		cat $file.$UUID
		echo "$GREEN_-_-_- [ File $file.$UUID eof ] -_-_-_: $ENDCOLOR"
	fi
done
