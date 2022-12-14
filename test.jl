using HorizonSideRobots
r=Robot("untitled.sit", animate=true)

mutable struct C
    x::Int
    y::Int
    k::Int
    l::HorizonSide
end

mutable struct inf
    m::Int
    g::Int
end

c = C(0,0,0,West)
i = inf(0, 0)

function task(r::Robot, x::Int, d::Int)
    if d == 2
        i.m += 1
        i.g += 1
    elseif d == 1
        i.m += 1
    elseif d == 0
        i.g += 1
    end
end

function find(r::Robot)
    for x in [0,1,2,3]
        if isborder(r, HorizonSide(x))
            c.l = HorizonSide(x)
            by(r, x)
        end
    end
end

function cond(side::HorizonSide)
    if side == Nord
        c.y += 1
    elseif side == Ost
        c.x += 1
    elseif side == Sud
        c.y -= 1
    elseif side == West
        c.x -= 1
    end

    if c.x == 0 && c.y == 0
        c.k += 1
    end
end

function by(r::Robot, x::Int)
    ai, bi = (x + 1) % 4, (x + 3) % 4
    a, b = HorizonSide(ai), HorizonSide(bi)
    side = HorizonSide(x)
    if c.k == 0
        if isborder(r, side) && (! isborder(r, a))
            task(r, x, 2)
            move!(r, a)
            cond(a)
            by(r, x)
        elseif isborder(r, side) && isborder(r, a)
            task(r, x, 0)
            by(r, ai)
        elseif ! isborder(r, side)
            task(r, x, 1)
            move!(r, side)
            cond(side)
            if isborder(r, b)
                by(r, bi)
            else
                task(r, x, 1)
                move!(r, b)
                cond(b)
                by(r, (x + 2) % 4)
            end
        end
    else
        if c.l != side
            c.k = 0
            by(r, x)
        end
    end
end

function answer()
    if i.m > i.g
        print("робот вне лабиринта")
    else
        print("робот в лабиринте")
    end
end

find(r)
answer()
