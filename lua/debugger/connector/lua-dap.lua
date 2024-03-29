local dap = _G.safe_require("dap")
if not dap then
	return
end

local M = {}

function M.setup()
	dap.adapters.nlua = function(callback, config)
		callback({
			type = "server",
			host = config.host or "127.0.0.1",
			port = config.port or 8086,
		})
	end

	dap.configurations.lua = {
		{
			type = "nlua",
			request = "attach",
			name = "Attach to running Neovim instance",
			host = function()
				local value = vim.fn.input("Host [127.0.0.1]: ")
				if value ~= "" then
					return value
				end
				return "127.0.0.1"
			end,
			port = function()
				local val = tonumber(vim.fn.input("Port: ", "8086"))
				assert(val, "Please provide a port number")
				return val
			end,
			console = "integratedTerminal",
		},
	}
	-- print("lua-dap is setupped!")
end

return M
