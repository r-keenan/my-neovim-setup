vim.pack.add {'https://github.com/f-person/git-blame.nvim'}

require('gitblame').setup{
    enabled = true,
    message_template = ' <date> • <author>',
    date_format = '%r',
    virtual_text_column = 0,
}
