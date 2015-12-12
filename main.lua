director:startRendering()

local current_level = 2

local maps = {}
local map1 = {}
map1["goalx"] = 50
map1["goaly"] = 70
map1["happyboyx"] = 50
map1["happyboyy"] = 70

local map2 = {}
map2["goalx"] = 170
map2["goaly"] = 0
map2["happyboyx"] = 100
map2["happyboyy"] = 100

local map3 = {}
map3["goalx"] = 140
map3["goaly"] = 10
map3["happyboyx"] = 80
map3["happyboyy"] = 90

maps[1] = map1
maps[2] = map2
maps[3] = map3


chosen_map = maps[current_level]

sky = director:createSprite({x=0,y=0,source="sky.png"})

up = director:createSprite({x=20,y=420,source="up.png"})
right = director:createSprite({x=40,y=400,source="right.png"})
left = director:createSprite({x=0,y=400,source="left.png"})
down = director:createSprite({x=20,y=380,source="down.png"})

happyBoyChar = director:createSprite({x=chosen_map['happyboyx'], y = chosen_map['happyboyy'], source="happy_boy_char.png"})

function collisions(event)
	if event.phase == "began" then
		happyBoyChar.physics:setLinearVelocity(0, 0)
	end
end

block1 = director:createSprite({x=100,y=320,source="block.png"})
physics:addNode(block1, {type = 'static'})
block1:addEventListener("collision", collisions)
block2 = director:createSprite({x=240,y=240,source="block.png"})
physics:addNode(block2, {type = 'static'})
block2:addEventListener("collision", collisions)

currentLevelLabel = director:createLabel({x=50, y=director.displayHeight-50, text = "Current Level: " .. current_level, color=color.black})

function enterGoal(event)
	if event.phase == "began" then
		happyBoyChar.physics:setLinearVelocity(0, 0)		
		current_level = current_level + 1
		currentLevelLabel.text = "Current Level: " .. current_level
		winScreen = director:createLabel({x=70, y=350, text = "YOU WIN!!", color=color.black})		
		-- if new high score ... 
		-- TODO: add congratulations/option screen to move onto next level
	end
end
physics:setGravity(0, 0)
physics:setTimeScale(0.1)

local goal = director:createSprite({x=chosen_map['goalx'], y = chosen_map['goaly'], source="goal.png"})
physics:addNode(goal, {type = 'static'})
goal:addEventListener("collision", enterGoal)

physics:addNode(happyBoyChar)

math.randomseed(os.time())

function checkHappyBoyPosition()
	if happyBoyChar.x < 0 or happyBoyChar.x > director.displayWidth or happyBoyChar.y < 0 or happyBoyChar.y > director.displayHeight then
		loseScreen = director:createLabel({x=70, y=350, text = "YOU LOSE NOOB", color=color.black})
		-- TODO: try again button/restart button/main menu button
	end
end
function moveUp(event)
	if event.phase == "began" then
        happyBoyChar.physics:setLinearVelocity(0, 500)		
	end
end
function moveRight(event)
	if event.phase == "began" then
        happyBoyChar.physics:setLinearVelocity(500, 0)		
	end
end
function moveLeft(event)
	if event.phase == "began" then
        happyBoyChar.physics:setLinearVelocity(-500, 0)		
	end
end
function moveDown(event)
	if event.phase == "began" then
        happyBoyChar.physics:setLinearVelocity(0, -500)		
	end
end

happyBoyTimer = system:addTimer(checkHappyBoyPosition, 0.5, 0)
 
function touch(event)
    if event.phase == "ended" then
        local ball = director:createSprite({x=director.displayWidth/2, y=0, xAnchor=0.5, xAnchor=0.5, source="happy_boy_char.png", color=color.red})
        physics:addNode(ball, {radius=30})
        ball.physics:setLinearVelocity((event.x-director.displayWidth/2)*2, event.y*2)
    end
end

up:addEventListener("touch", moveUp)
right:addEventListener("touch", moveRight)
left:addEventListener("touch", moveLeft)
down:addEventListener("touch", moveDown)
