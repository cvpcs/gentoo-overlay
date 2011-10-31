
if [[ -z "$1" ]]; then
	NAME="main"
	echo "Server name not specified. Defaulting to \"${NAME}\"." >&2
else
	NAME="$1"
	echo "Using server name \"${NAME}\"." >&2
fi

if [[ "$(whoami)" == "@GAMES_USER_DED@" ]]; then
	gjl_pwd="/var/lib/craftbukkit/${NAME}"
else
	gjl_pwd="${HOME}/.craftbukkit/servers/${NAME}"
fi

echo "Server directory is ${gjl_pwd}." >&2
mkdir -p "${gjl_pwd}/plugins"

