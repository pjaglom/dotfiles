-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
    -- Custom Options
    require 'custom.plugins.options',


    -- The Primeagen Recs
    -- [[ Harpoon ]]
    require('custom.plugins.harpoon'),

    -- [[ Undotree ]]
    require('custom.plugins.undotree')
}
