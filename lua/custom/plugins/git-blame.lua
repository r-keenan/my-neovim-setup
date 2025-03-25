return {
  'f-person/git-blame.nvim',
  event = 'VeryLazy',
  opts = {
    enabled = true,
    message_template = ' <date> • <author> • <<sha>>',
    date_format = '%r',
    virtual_text_column = 1,
  },
}
