using HorizonSideRobots
HSR=HorizonSideRobots

mutable struct Coordinates
    x::Int
    y::Int
end

mutable struct AbstractRobot
    robot::Robot
    direct::HorizonSide
    start::HorizonSide
    coord::Coordinates
    m::Int
    g::Int
end

HSR.isborder(robot,direct) = isborder(robot.robot,direct(robot.direct))
HSR.putmarker!(robot) = putmarker!(robot.robot)
HSR.ismarker(robot) = ismarker(robot.robot)
get_direct(robot::AbstractRobot) = robot.direct
get_start(robot::AbstractRobot) = robot.start

function around!(r)
    while true
        println(r.m, r.g)
        if ! HSR.isborder(r, s) && HSR.isborder(r, a)
            forward!(r)
        elseif HSR.isborder(r, s) && HSR.isborder(r, a)
            r.direct = b(r.direct)
        elseif ! HSR.isborder(r, a)
            r.direct = a(r.direct)
            forward!(r)
        end
        count(r)
        if r.coord.x == r.coord.y == 0 && get_start(r) == get_direct(r)
            break
        end
    end
end

function is_in_lab(r)
    if r.m < r.g
        print("Робот в лабиринте")
    else
        print("Робот вне лабиринта")
    end
end

function count(r)
    if HSR.isborder(r, a)
        r.g += 1
    end
end

function forward!(robot)
    r.m += 1
    move!(robot.robot, robot.direct)
    dir = get_direct(robot)
    HSR.move!(robot,dir)
end

function HSR.move!(robot::AbstractRobot, side::HorizonSide)
    if side==Nord
        robot.coord.y += 1
    elseif side==Sud
        robot.coord.y -= 1
    elseif side==Ost
        robot.coord.x += 1
    else
        robot.coord.x -= 1
    end
end

function Side_Int(side)
    if side == Nord
        return 0
    elseif  side == West
        return 1
    elseif  side == Sud
        return 2
    elseif  side == Ost
        return 3
    end
end

function s(side)
    return side
end

function inverse(side)
    s = Side_Int(side)
    return HorizonSide((s + 2) % 4)
end

function a(side)
    s = Side_Int(side)
    return HorizonSide((s + 1) % 4)
end

function b(side)
    s = Side_Int(side)
    return HorizonSide((s + 3) % 4)
end

function lab!(r)
    around!(r)
    is_in_lab(r)
    print(r.m, r.g)
end

r = AbstractRobot(Robot("untitled.sit",animate = true), West, West, Coordinates(0,0), 0, 0)

lab!(r)