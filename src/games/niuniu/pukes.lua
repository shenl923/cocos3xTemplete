require 'games.niuniu.config'
Pukes = class('Pukes')

function Pukes:ctor()
    self:init()
end

function Pukes:init()
    local cards = {}
    for color = 1, 4 do
        for value = 1, 13 do
            table.insert(cards, {color=color, value=value})
        end 
    end
end 