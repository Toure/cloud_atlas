defmodule CloudAtlas do
	import System
	import Application
	import MetalConfig, only: :functions
	import VirtConfig, only: :functions
	
	@@moduledoc """
	Rdo Director is a module which will allow for quick initial environment
	setup and deployment of undercloud.
	"""


	def configure_shell(env_name) do
		@@doc """
		configure shell environment variables through env_name dictionary
		then returns status.
		"""
		put_env(env_name)
		:ok
	end
	
	def deployment_config(dt) do
		@@doc """
		deployment_config will determine based on input "dt"
		the type of deployment [Virtual or Baremetal]
		"""
		case dt do
			:virt -> virt_config # some function here to kick of virtual setup.
			:barem -> baremetal_config # some function here to kick off baremetal setup.
	end

	def distro_config(os_name) do
		@@doc """
		distro_config will determine the Linux distribution and
		set the correct environment variable.
		"""
		case os_name do
			:rhel -> put_env("NODE_DIST", "rhel7")
			:centos -> put_env("NODE_DIST", "centos7")
			_ -> raise(ArgumentError, message: "The OS you have specified is not supported \n --> #{os_name} <--")
	end

	def repository_config(repo_type) do
		@@doc """
		repository_config will configure either against a satellite server
		or subscription manager.

		"""
		case repo_type do
			:portal -> setenv(:rhel_portal_reg)
			:satellite -> setenv(:rhel_sat_reg)
			_ -> raise(ArgumentError, message: "invalid argument #{repo_type}")
		end	
	end

	def user_config(name) do
		@@doc """
		user_config will add the stack user to the system and configure
		permissions for sudo.
		"""
		if {_, 0} = cmd(useradd, [name]) do
			{_, passwd_ret} = cmd("echo", ["dog8code", "|", "passwd","--stdin" name])
		end

		if 0 = passwd_ret do
			{_, sudo_ret} = cmd("echo", ["stack ALL=(root) NOPASSWD:ALL", "|", "sudo", "tee", "-a", "/etc/sudoers.d/stack"])
			if 0 = sudo_ret do
				cmd("sudo", ["chmod", "0440", "/etc/sudoers.d/stack"])
			end
		end
	end

	def image_prep do
		@doc """
		image_prep will build overcloud-full images (*.qcow2, *.initrd, *.vmlinuz), 
		deploy-ramdisk-ironic images (*.initramfs, *.kernel), discovery-ramdisk images 
		(*.initramfs, *.kernel) and testing fedora-user.qcow2 (which is always Fedora based).
		on success this function will complete the image import.
		"""
		if {_, 0} = cmd("instack-build-images", []) do
			cmd("instack-prepare-for-overcloud", [])
		end		
	end

	def overcloud_deploy(deployment_opts \\ ["--tuskar"]) do
		@doc """
		deploy the overcloud structure based on options passed to function default option is
		use tuskar.
		"""
		cmd("instack-deploy-overcloud", ["#{deployment_opts}"])
	end	

	def node_register(inventory_file) do
		@doc """
		node_register requires a instackenv.json path/file object to complete 
		initial registration of overcloud nodes.
		"""
		if {_, 0} = cmd("instack-ironic-deployment", ["--nodes-json", "#{instackenv.json}" ,"--register-nodes"]) do
			cmd("instack-ironic-deployment", ["--discover-nodes"])
		end		
	end

	def flavor_config do
		@doc """
		create initial flavor for overcloud deployment.
		"""
		cmd("instack-ironic-deployment", ["--setup-flavors"])
	end

	def heat_config(cli_opts) do
		@doc """
		heat config will allow user to issue cli instructions to heat example: heat stack-delete overcloud.
		"""
		ret = cmd("heat", cli_opts)
		return ret
	end
	
	def overcloud_redeploy do
		@doc """
		overcloud redeploy will reset and rediscover nodes for a new overcloud installation.
		"""
		if {_, 0} = heat_config(["stack-delete", "overcloud"]) do
			cmd("heat", ["stack-list"])
			cmd("instack-ironic-deployment", ["--discover-nodes"])
			overcloud_deploy
		end		
	end

	def yum-config-manager(reponame) do
		@doc """
		yum config manager will install remote repositories which are passed via reponame which is
		the url location of the repo. ie: yum-config-manager --add-repo http://www.example.com/example.repo
		"""
		cmd("yum", ["--add-repo",reponame])		
	end

	def yum_install(packagename) do
		@doc """
		yum_install will provide a common interface to install any package during the deployment stages.
		"""
		cmd("yum", ["-y", "install" packagename])		
	end
	
	defp setenv(env_var) do
		@@doc """
		setenv takes a collection and sets the environment
		variables according to the key and values.
		"""
		Enum.map(get_all_env(env_var), fn(k, v) -> put_env(k, v))
		:ok
	end
end
