M = {}

function M.get_h1(buffer, max_lines)
  local lines = vim.api.nvim_buf_get_lines(buffer, 0, max_lines, false)
  for _, line in ipairs(lines) do
    local h1 = line:match("^#%s*(.+)")  -- Gets first heading 1 of the document
    if h1 then return h1
    end
  end
end

function M.is_file_in_dirctories(file_path, dir_list)
	local is_included = false
	for _, dir in ipairs(dir_list) do
		dir = vim.fn.expand(dir)  -- Required to support bash variables
		if file_path:sub(1, #dir) == dir then
			is_included = true
			break
		end
	end
	return is_included
end

function M.change_undo_filename(old_filename, new_filename)
	local old_undo_file = vim.o.undodir .. '/' .. old_filename:gsub('/', '%%')
	local new_undo_file = vim.o.undodir .. '/' .. new_filename:gsub('/', '%%')
	if vim.fn.filereadable(old_undo_file) == 1 then
		os.rename(old_undo_file, new_undo_file)
	end
end

return M

