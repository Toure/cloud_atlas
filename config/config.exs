# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for third-
# party users, it should be done in your mix.exs file.

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
config :rhel_portal_reg,
	REG_METHOD: "portal",
    REG_USER: :username,
	REG_PASSWORD: :password,
	REG_POOL_ID: :pool_id,
	REG_REPOS: "rhel-7-server-rpms rhel-7-server-extras-rpms rhel-ha-for-rhel-7-server-rpms rhel-7-server-optional-rpms rhel-7-server-openstack-6.0-rpms"

config :rhel_sat_reg,
	REG_METHOD:	"satellite",
	REG_SAT_URL: :satellite_url, #http://<satellite-hostname>
	REG_ORG: :satellite_org,
	REG_ACTIVATION_KEY: :activation_key

config :storage_opts,
	CEPHSTORAGESCALE: 1,
	CINDER_ISCSI:	1

config :dib_image,
	DIB_LOCAL_IMAGE: "rhel-guest-image-7.1-20150224.0.x86_64.qcow2"

config :install_urls,
	epel:	"http://mirrors.einstein.yu.edu/epel/7/x86_64/e/epel-release-7-5.noarch.rpm",
	rdo: 	"https://rdoproject.org/repos/openstack-kilo/rdo-release-kilo.rpm"

config :virt_conf,
	NODE_COUNT: 3 #This will be used to allow for a seperate node for CEPH under the virtual deployment.