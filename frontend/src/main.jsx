import React, { useEffect, useState } from "react";
import { createRoot } from "react-dom/client";
import "./style.css";

function App() {
  const [health, setHealth] = useState(null);
  useEffect(() => { fetch("/api/health").then(r => r.json()).then(setHealth); }, []);
  return <main><p>DISAL compatibility test</p><h1>React + FastAPI monorepo is live</h1><pre>{JSON.stringify(health, null, 2)}</pre></main>;
}
createRoot(document.getElementById("root")).render(<App />);
