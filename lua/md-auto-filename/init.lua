local utils = require("md-auto-filename.utils")

local M = {}

M.options = {
	filename_separator = '_',
	exclude_files = {},
	target_directories = {},
	max_line_read = 20,
}

function M.setup(opts)
	M.options = vim.tbl_extend('force', M.options, opts or {})
end


function M.rename()
	local current_buffer = vim.api.nvim_get_current_buf()
	local old_filename = vim.fn.expand('%:p')  -- Gets the absolute path of the current file

	-- If the filename is in the exclude list, do nothing
	if vim.tbl_contains(M.options.exclude_files, vim.fn.fnamemodify(old_filename, ':t')) then
		return
	end

	-- If `target_directories` option is set, do nothing if the file is outside of those directories
	if #M.options.target_directories> 0 then
		if not utils.is_file_in_dirctories(
			vim.fn.fnamemodify(old_filename, ':h'),
			M.options.target_directories
			) then return
		end
	end

	local title = utils.get_h1(current_buffer, M.options.max_line_read)
	if title then
		-- Replace whitespace characters by a safe separator
		local filename = title:gsub("%s+", M.options.filename_separator):lower() .. ".md"
		local new_filename = vim.fn.fnamemodify(old_filename, ':h') .. '/' .. filename

		if old_filename == new_filename then
			-- Do nothing if the filename didn't change
			return
		elseif vim.fn.filereadable(new_filename) ~= 0 then
			-- Display an error if the new filename is alreay used
			print("Filename already exists, cannot rename.")
			return
		else
			os.rename(old_filename, new_filename)

			utils.change_undo_filename(old_filename, new_filename)

      -- Save the current window ID and cursor position
      local currentWindow = vim.api.nvim_get_current_win()
      local currentCursor = vim.api.nvim_win_get_cursor(currentWindow)

			-- Keep undo history by renaming the undo file if it exists
			vim.cmd("edit " .. new_filename)  -- Open new file
			vim.cmd("filetype detect")  -- Apply MD formating
			vim.cmd("bwipeout " .. current_buffer)  -- Delete old buffer

      -- Restore the cursor position
      vim.api.nvim_win_set_cursor(currentWindow, currentCursor)

			return
		end
	end
end

vim.cmd([[
	command! MdAutoRename lua require('md-auto-filename').rename()
	augroup MDRename
	autocmd!
	autocmd BufWritePost *.md MdAutoRename
	augroup END
]])

return M

