local Arena = battle.mainarena
local Player = battle.Player
local SPR_ENEMY = battle.SPR_ENEMY

local wave = {
    ENDED = false,
    objects = {}
}

local DIALOGUE_HEAD = "[voice:g.wav][fontSize:13][colorHEX:000000][font:speechbubble.ttf]"

function DialogueSetSprite(spr)
    return "[noskip][function:SetEnemySprite|" .. spr .. "][next]"
end

function SetEnemySprite(spr)
    SPR_ENEMY:Set("Galadriel/" .. spr)
end

local pst = typers.CreateText({
    DIALOGUE_HEAD .. "...\n[wait:10]...\n[wait:10]...",
    DialogueSetSprite("core_awake_1.png"),
    DIALOGUE_HEAD .. "CAN YOU FIND\nTHE GREEN\nBULLET?",
    "[noskip][function:startbattle][next]"
}, { 400 - 2, 131 }, 200, { 210, 100 }, "manual")
pst:ShowBubble("left", 0.5)


local function EndWave()
    wave.ENDED = true
    arenas.clear()
    for i = #wave.objects, 1, -1 do
        local obj = wave.objects[i]
        obj:Destroy()
        table.remove(wave.objects, i)
    end
end

Arena:Resize(155, 130)
Player.sprite:MoveTo(320, 320)

local mask = masks.New("rectangle", 320, 320, 155, 130, 0, 1)

function wave.update(dt)
    mask:Follow(Arena.black)

    for i = #wave.objects, 1, -1 do
        local obj = wave.objects[i]
        if (obj.logic) then
            obj:logic(dt)
        end
    end
end

function wave.draw()
end

return wave
