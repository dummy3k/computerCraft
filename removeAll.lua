if not os.loadAPI("fox") then error("fox api") end

function lookAround()
  for i=1,4 do
    if turtle.compare(1) then
      fox.forward(1, "dig")
      lookAround()
      fox.back()
    end
    fox.turnLeft()
  end
  if fox.compareUp() then
    fox.digUp()
    fox.up()
    lookAround()
    fox.down()
  end
  if fox.compareDown() then
    fox.digDown()
    fox.down()
    lookAround()
    fox.up()
  end
end

lookAround()
