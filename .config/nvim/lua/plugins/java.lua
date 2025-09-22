return {
    {
        "javiorfo/nvim-wildcat",
        lazy = true,
        cmd = { "WildcatRun", "WildcatUp", "WildcatInfo" },
        dependencies = { "javiorfo/nvim-popcorn" },
        opts = {
            -- Not necessary. Only if you want to change the setup
            -- The following are the default values

            console_size = 15,
            jboss = {
                home = "JBOSS_HOME",
                app_base = "standalone/deployments",
                default = false,
            },
            tomcat = {
                home = "CATALINA_HOME",
                app_base = "webapps",
                default = true,
            },
        },
    },
}
