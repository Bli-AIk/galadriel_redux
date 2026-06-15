local Arena = battle.mainarena
local Player = battle.Player
local SPR_ENEMY = battle.SPR_ENEMY
local wave = {
    ENDED = false,
    objects = {}
}

local DIALOGUE_HEAD = "[voice:g.wav][fontSize:13][colorHEX:000000][font:speechbubble.ttf]"
local stb = false

Player.canMove = false

-- 想用哈希表来着但是突然意识到好像不需要哦
--[[
 local bullets = {}

local function AddBullet(bullet, name)
    name = name or "default"
    bullets[name] = bullet
    return bullet
end
]]

function startbattle()
    -- 抱歉今天不行
    -- battle.Player.canMove = true
    stb = true

    -- 生成那个圈
    local cx, cy = Player.sprite.x, Player.sprite.y -- 圆心坐标
    local dist = 60                                 -- 半径
    for i = 1, 12 do
        local angle = i * 30                        -- 0, 30, 60, ... 360 度
        local radians = math.rad(angle)

        local x = cx + math.cos(radians) * dist
        local y = cy + math.sin(radians) * dist
        ---[[
        local bul = sprites.CreateSprite("Galadriel/bullet_star.png", 20)
        bul:MoveTo(x, y)
        bul.isBullet = true
        bul.visible = false
        table.insert(wave.objects, bul)
        -- AddBullet(bul, "ring_" .. i)
        --]]
    end
end

function DialogueSetSprite(spr)
    return "[noskip][function:SetEnemySprite|" .. spr .. "][next]"
end

function SetEnemySprite(spr)
    SPR_ENEMY:Set("Galadriel/" .. spr)
end

local pst = typers.CreateText({
    DIALOGUE_HEAD .. "...\n[wait:20]...\n[wait:20]...",
    DialogueSetSprite("core_awake_1.png"),
    DIALOGUE_HEAD .. "WHO GOES THERE?\n[wait:10]INTRUDER.\n[wait:10]PRESENT YOURSELF.",
    DIALOGUE_HEAD .. "OH.[wait:10] IT'S YOU.\n[wait:10]COME TO FINALLY\nDESTROY ME?",
    DIALOGUE_HEAD .. "HOW UNFORTUNATE[wait:10].[wait:10].[wait:10].[wait:10]\nFOR YOU.",
    DialogueSetSprite("core_awake_2.png"),
    DIALOGUE_HEAD .. "I'VE HAD PLENTY OF\nTIME TO REST AND\nREGAIN MY STRENGTH.",
    DIALOGUE_HEAD .. "ARE YOU READY FOR\nOUR LAST DUEL?",
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
battle.SPR_SHIELD:SetStencils({ mask })

local variable = 0
local spawn_timer = 0
local current_bullet_count = 1

local state = "fade_in"

function wave.update(dt)
    mask:Follow(Arena.black)

    for i = #wave.objects, 1, -1 do
        local obj = wave.objects[i]
        if (obj.logic) then
            obj:logic(dt)
        end
        obj.rotation = obj.rotation - 1
    end

    if (stb) then
        spawn_timer = spawn_timer + dt
        variable = variable + dt

        if (spawn_timer > 0.085 and state == "fade_in") then
            local i = ((current_bullet_count - 1) * 5) % 12 + 1
            local bul = wave.objects[i]
            bul.visible = true
            bul.rotation = 0
            current_bullet_count = current_bullet_count + 1
            spawn_timer = 0
            audio.PlaySound("snd_menu_0.wav", 0.5)
            if i == 8 then
                state = "wait"
            end
        end


        if (variable > 50) then
            EndWave()
        end
    end
end

function wave.draw()
end

return wave
