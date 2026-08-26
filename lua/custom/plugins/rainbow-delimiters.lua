vim.pack.add { 'https://github.com/HiPhish/rainbow-delimiters.nvim' }

require 'rainbow-delimiters.setup'.setup {
        strategy = {
            [''] = 'rainbow-delimiters.strategy.global',
            commonlisp = 'rainbow-delimiters.strategy.local',
        },
        query = {
            [''] = 'rainbow-delimiters',
            latex = 'rainbow-blocks',
        },
        highlight = {
            'RainbowDelimiterRed',
            'RainbowDelimiterYellow',
            'RainbowDelimiterBlue',
            'RainbowDelimiterOrange',
            'RainbowDelimiterGreen',
            'RainbowDelimiterViolet',
            'RainbowDelimiterCyan',
        },
        blacklist = {'c', 'cpp'},
}
