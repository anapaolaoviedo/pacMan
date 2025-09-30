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
function agent_step!(agent, model)
    pos = agent.pos  # pos is (x, y) where x=column, y=row
    possible_moves = []
    
    # Up (decrease row)
    new_pos = (pos[1], pos[2] - 1)
    if new_pos[2] >= 1 && new_pos[2] <= size(matrix)[1] && new_pos[1] >= 1 && new_pos[1] <= size(matrix)[2]
        if matrix[new_pos[2], new_pos[1]] == 1  # Note: matrix[row, col]
            push!(possible_moves, new_pos)
        end
    end
    
    # Down (increase row)
    new_pos = (pos[1], pos[2] + 1)
    if new_pos[2] >= 1 && new_pos[2] <= size(matrix)[1] && new_pos[1] >= 1 && new_pos[1] <= size(matrix)[2]
        if matrix[new_pos[2], new_pos[1]] == 1
            push!(possible_moves, new_pos)
        end
    end
    
    # Left (decrease column)
    new_pos = (pos[1] - 1, pos[2])
    if new_pos[2] >= 1 && new_pos[2] <= size(matrix)[1] && new_pos[1] >= 1 && new_pos[1] <= size(matrix)[2]
        if matrix[new_pos[2], new_pos[1]] == 1
            push!(possible_moves, new_pos)
        end
    end
    
    # Right (increase column)
    new_pos = (pos[1] + 1, pos[2])
    if new_pos[2] >= 1 && new_pos[2] <= size(matrix)[1] && new_pos[1] >= 1 && new_pos[1] <= size(matrix)[2]
        if matrix[new_pos[2], new_pos[1]] == 1
            push!(possible_moves, new_pos)
        end
    end
    
    # Move to a random valid position
    if !isempty(possible_moves)
        new_pos = rand(possible_moves)
        move_agent!(agent, new_pos, model)
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