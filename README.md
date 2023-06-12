# md-auto-filename.nvim

md-auto-filename.nvim is a Neovim mirco plugin that enables automatic (re)naming of Markdown files based on their h1 heading.

## Installation

You can install MD-Auto-File-Rename.nvim using a plugin manager. Here's an example with Packer:

```lua
use 'arthur-remy/md-auto-filename.nvim'
```

## Configuration

The following options can be configured to customize the behavior of the plugin:
- `filename_separator` (default: '\_'): Character used to replace whitespace character in the Markdown title
- `exclude_files`: Files with filename matching names included in this list will not be automatically renamed
- `target_directories`: Automatic renaming is only applied for `.md` within those directories. If no directory is specified, automatic renaming will be apply regardless of the parent directrory
- `max_line_read` (default: 20): Maximum number of lines that will be read to search for the Markdown title. This is meant to reduce overhead on large files. Set `-1` to have remove the limit.

To set these options, you can use the `.setup()` function. Here is another example with Packer:

```lua
use {
    'arthur-remy/md-auto-filename.nvim',
    config = function() require('md-auto-filename').setup(
        filename_separator = '-',
        exclude_files = { 'readme.md', 'README.md' },
        target_directories = { '~/MyNotes' },
        max_line_read = 100,
}
```

