"This code is split int three parts:
the agent, the model and the visualization service."

using Agents
using Agents: add_agent!

"declaring a new type of agent called ghost and the grid agent is saying is 2-dimentional  "
@agent struct Ghost(GridAgent{2})
    type::String = "Ghost" #custom property 
end

#the behaviour function for the agent 
function agent_step!(agent, model)
    randomwalk!(agent, model) # -> updated 
end

"starting a eholr model of an agent "
function initialize_model()
    #a 5x5 grid with walls (prediodic false) and manhattan metric (up,down, left,right)
    space = GridSpace((5,5); periodic = false, metric = :manhattan) 
    model = StandardABM(Ghost, space; agent_step!) #calls the struct agent ghost, space we just created and movement 
    return model
end

model = initialize_model()
a = Agents.add_agent!(Ghost, pos=(3, 3), model) #adds ghost to the simulation