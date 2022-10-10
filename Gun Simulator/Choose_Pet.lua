-- All Pets: https://media.discordapp.net/attachments/927401123692818452/1028856960306651178/unknown.png?width=193&height=159

local main = require(game:GetService("Players").LocalPlayer.PlayerScripts.Client.cmain.datum)
local set_con = syn_context_set or setthreadcontext

local function call(func, ...)
   set_con(2)
   func(...)
   set_con(7)
end

local pet_func = main.Pets.AttemptOpenEgg
call(pet_func, 'AtomicEgg')
