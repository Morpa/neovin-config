return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-telescope/telescope-ui-select.nvim" },
    opts = function(_, opts)
        opts.extensions = opts.extensions or {}
        opts.extensions["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
        }
        return opts
    end,
    config = function(_, opts)
        require("telescope").setup(opts)
        require("telescope").load_extension("ui-select")
    end,
}
