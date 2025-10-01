"This code is split int three parts:
the agent, the model and the visualization service."

using Agents
using Agents: add_agent!
using Agents: add_agent!, allagents, run!, randomwalk!, move_agent!


"declaring a new type of agent called ghost and the grid agent is saying is 2-dimentional  "
@agent struct Ghost(GridAgent{2})
    type::String = "Ghost" #custom property 
end

matrix = [
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0;
    0 1 0 1 0 0 0 1 1 1 0 1 0 1 0 1 0;
    0 1 1 1 0 1 0 0 0 0 0 1 0 1 1 1 0;
    0 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 0;
    0 1 0 1 0 1 0 0 0 0 0 1 1 1 0 1 0;
    0 1 1 1 0 1 0 1 1 1 0 1 0 1 0 1 0;
    0 1 0 1 0 1 0 1 1 1 0 1 0 1 0 1 0;
    0 1 0 1 1 1 0 0 1 0 0 1 0 1 1 1 0;
    0 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 0;
    0 1 1 1 0 1 0 0 0 0 0 1 0 1 1 1 0;
    0 1 0 1 0 1 0 1 1 1 0 0 0 1 0 1 0;
    0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
]

#the behaviour function for the agent 
# A* pathfinding implementation
function find_path(start, goal, matrix)
    if matrix[goal[2], goal[1]] != 1
        return nothing
    end
    
    open_set = [start]
    came_from = Dict()
    g_score = Dict(start => 0)
    f_score = Dict(start => abs(start[1] - goal[1]) + abs(start[2] - goal[2]))
    
    while !isempty(open_set)
        current = open_set[1]
        current_f = f_score[current]
        for node in open_set
            if f_score[node] < current_f
                current = node
                current_f = f_score[node]
            end
        end
        
        if current == goal
            path = [current]
            while haskey(came_from, current)
                current = came_from[current]
                push!(path, current)
            end
            return reverse(path)
        end
        
        filter!(x -> x != current, open_set)
        
        neighbors = [
            (current[1], current[2] - 1),
            (current[1], current[2] + 1),
            (current[1] - 1, current[2]),
            (current[1] + 1, current[2])
        ]
        
        for neighbor in neighbors
            if neighbor[1] < 1 || neighbor[1] > size(matrix)[2] ||
               neighbor[2] < 1 || neighbor[2] > size(matrix)[1] ||
               matrix[neighbor[2], neighbor[1]] != 1
                continue
            end
            
            tentative_g = g_score[current] + 1
            
            if !haskey(g_score, neighbor) || tentative_g < g_score[neighbor]
                came_from[neighbor] = current
                g_score[neighbor] = tentative_g
                f_score[neighbor] = tentative_g + abs(neighbor[1] - goal[1]) + abs(neighbor[2] - goal[2])
                
                if !(neighbor in open_set)
                    push!(open_set, neighbor)
                end
            end
        end
    end
    
    return nothing
end

function agent_step!(agent, model)
    target = (9, 7)
    path = find_path(agent.pos, target, matrix)
    
    if path !== nothing && length(path) > 1
        move_agent!(agent, path[2], model)
    end
end

"starting a eholr model of an agent "
function initialize_model()
    #a 5x5 grid with walls (prediodic false) and manhattan metric (up,down, left,right)
    space = GridSpace((17,14); periodic = false, metric = :manhattan) 
    model = StandardABM(Ghost, space; agent_step!) #calls the struct agent ghost, space we just created and movement 
    return model
end

model = initialize_model()
a = Agents.add_agent!(Ghost, pos=(2, 2), model) #adds ghost to the simulation