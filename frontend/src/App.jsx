import { useState, useEffect } from 'react'  // Add useEffect here

const App = () => {
  const [posX, setPosX] = useState(6);
  const [posY, setPosY] = useState(8);

  useEffect(() => {
    const interval = setInterval(() => {
      fetch("http://localhost:8000/run")
      .then(res => res.json())
      .then(res => {
        setPosX(res.agents[0].pos[0]-1);
        setPosY(res.agents[0].pos[1]-1);  // This should be setPosY, not setPosX
      });
    }, 1000);

    return () => clearInterval(interval);
  }, [posX, posY]);

  return (
    <div>
      <svg width="800" height="500" style={{backgroundColor: "lightgray"}} xmlns="http://www.w3.org/2000/svg">
        <image x={255 + 25 * posX} y={9 + 25 * posY} width="24" height="24" href="ghost.png"/>
      </svg>
    </div>
  );
};

export default App;