# eclass for craftbukkit plugins

inherit java-utils-2

BUKKIT_PLUGIN_DIRECTORY="/usr/share/craftbukkit-server-plugins"
BUKKIT_PLUGIN_NAME="${PN#craftbukkit-plugin-}"
BUKKIT_PLUGIN_VERSION="${PV}"

craftbukkit-plugin_install_jar() {
        local dir

	[ -f "${1}" ] || die 

        dir="/usr/share/craftbukkit-server-plugins/${BUKKIT_PLUGIN_NAME}"
        dodir ${dir}

        insinto ${dir}
        doins ${1} ${PV}.jar
}
