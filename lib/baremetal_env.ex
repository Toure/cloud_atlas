defmodule MetalConfig do
	def baremetal_config() do
		:ok
	end
	
	def inventory_config() do
		@@doc """
		inventory config will generate a instackenv.json file
		based on 
		"""
	end

	def deploy_config_file do
		@doc """
		post baremetal config copy and source overcloud rc file.
		"""		
	end
end