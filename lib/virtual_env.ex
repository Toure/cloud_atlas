defmodule VirtConfig do
	def virt_setup() do
		@@doc """
		virt_config will run all necessary functions to complete
		virtual environment installation.
		"""
		cmd("instack-virt-setup",[])
	end

	def  do
		
	end
	
end