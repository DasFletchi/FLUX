# Project Forge/FLUX

# **What is Flux?**

FLUX is a multiplayer physics-driven sandbox where every system is in constant motion, breaking, evolving, and interacting in ways the player can exploit, stabilize, or completely ignore until everything collapses again. The Game is not only tailored towards engineers or one group. It is tailored if not all (holy ambitious) playerbases but more on that later. I first want you to to walk through a gameplay cycle that the player works through.

## **Gameplay Loop (Project Forge / FLUX)**

The gameplay loop of **FLUX** is a systemic, physics-driven progression from manual survival to large-scale industrial cooperation and emergent civilization-building.

### **1\. Primitive Survival & Manual Construction (Early Game)**

* **Gather:** Players spawn on a fragment (biome) and mine basic voxel resources (“Matter”). Matter is just every voxel without a function really. Those can be used for filler blocks or for building. The other 9 voxels, with actual functions can be crafted from this and will also inherit the same colour as the ground matter theyre made from. Those wont be crafted with a crafting menu. However i gotta refine this part still.  
* **Build:** Structures are placed voxel-by-voxel without automation. However the’re tools in the game to for example place hundreds of little voxels fast, like in the competitor game “Scrap Mechanic”  
* **Physics learning:** The world enforces a simple rule: mass and support matter. Heavier materials collapse if poorly supported under real-time physics simulation.

### **2\. Planning & Kinetic Automation (Mid Game)**

* **Holo-Canvas/Integrated into a tool that tries to be like Minecraft building mods like World Edit or Axiom:** Players pre-design machines using a holographic planning system. (if they want, this will be done with a special button or tool idk, same for moving objects, it’s gonna be a “Axiom” mod in minecraft just for this game)ONLY IN CREATIVE NOT IN SURVIVAL  
* **Materialization:** Designs are built physically using gathered resources.   
* **Mechanical systems:** Energy is transmitted through shafts and gears instead of cables, forming early mechanical automation networks.

### **3\. Exploration & Interdependence (Late Game)**

* **Fragment travel:** Players explore extreme biomes with unique physics conditions to obtain rare materials.  
* **Forced specialization:** Logistics and system complexity make cooperation and role separation more efficient than solo play, naturally forming trade networks and industrial roles.

### **4\. Mastery (Endgame)**

* **No XP system:** Progression is knowledge-based, not numerical. Maybe XP as a currency for upgrades, but nothing character bound like in RPG’s, MMO’s or Roguelites.  
* **Megastructures:** Players build large-scale machines, mobile cities, maybe even emergent computing systems using mechanical logic to dominate resources and infrastructure. (I still gotta say you can play this game Multiplayer, but you dont have to in this case imma take the homework that minecraft for decentralized multiplayer)

## **Physics Engine**

The Physics-Engine in use is gonna be **Godot Jolt**. In terms of big ahh systems with a lot of objects that constantly need collision checks, Jolt outperforms pretty much any other freely usable / open-source physics engine available right now. The reason for that is its modern architecture, which is heavily optimized around **multi-core and multithreaded processing**, meaning it doesn’t just dump all physics calculations onto a single core like it’s predecessor or Unitys Nvidia PhysX (dawg the name PhysX sounds so cool ngl) or rely on CUDA. Moving massive data pools from the CPU (procedural generation) to the GPU (physics calculations) wich causes a severe hardware pipeline bottleneck because it forces a high-frequency PCIe bus bottleneck and a catastrophic CPU-GPU synchronization lock. (OK I gotta be honest i didn’t know that, ts is from an LLM lol)

Instead, it distributes workloads efficiently across CPU cores, which becomes extremely important once FLUX starts simulating large environments with tons of interacting bodies, moving parts, and chaotic player-driven nonsense.

In practical terms, this means better performance under load, more stable frame times, and fewer situations where the physics engine decides to commit emotional damage and explode objects into orbit for no reason. 

## **Chemistry Engine**

Theres a 99% percent change im going to implement a physics engine like in Zelda TOTK (haven’t played, I’m not going to play it aswell) A lightweight, always-active thermodynamic layer that drives emergent material behavior through three orthogonal rules visible in \<1ms:

| Rule | What the Player Sees | What It Unlocks |
| :---- | :---- | :---- |
| **Heat** | Objects glow, smoke, then burn/melt | Engine cooling, forge design, biome survival, gliders with termodynamics |
| **Phase** | Solid → liquid → gas at thresholds | Fluid dynamics, steam power, gas explosions |
| **Reaction** | Fire \+ wood \= ash; rust weakens metal | Catalyst chains, corrosion traps, fuel mixing |

**Integration:** When `T ≥ T_melt`, a voxel transitions from Jolt RigidBody to fluid particle. Structural constraints break automatically. No scripted collapse, the physics engine simply loses the material property that held the structure together. This allows for a whole another dimension of peak, bc now you can for example fly up with a makeshift glider from light material, or build a massive oven and use it as a launcher to get over the map quickly (not the biomes with high g ofc but more on the biomes later). There wil also be Thermodynamics added into a later state of the game

## **Fragment System (Working Concept)**

The game is structured around a **Fragment system**, where the world is divided into separated, floating regions instead of one continuous map. These Fragments can be thought of as distinct biomes or floating islands, spatially isolated from each other.

Exploration between Fragments is intentionally designed to introduce risk and decision-making. Travel is not trivial, creating a sense of cost or “wager” when moving between regions. This separation is intended to make transitions meaningful rather than routine. 

To support long-term progression, players are encouraged to either **automate resource acquisition** across multiple Fragments or engage in **player-driven trade systems** to obtain materials from distant regions. However, no Fragment will be completely locked out from any specific resource. Instead, resource availability will be influenced through **adjusted spawn rates and distribution parameters**, allowing for regional identity without hard restrictions.

This system is designed to balance exploration, logistics, and economy, pushing players toward cooperation, automation, or strategic movement rather than isolated self-sufficiency. I believe that this system can make Exploration more fun instead of just “I fly around a bit with my elytra”. I’ll keep my best not to make this annoying. But now lets actually get to the biomes/fragment types.

| Biome / Fragment | Gravity (g) | Temp (°C) | Wind | Atmosphere | Core Mechanic | Survival Challenge | Engineering Opportunity |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| **Meadow** | 1.0 | 20 | Moderate | Standard | Baseline | None | Basic farms, windmills |
| **Highland** | 1.5 | 10 | Strong | Thin | Altitude physics | Structures need more support; | Extreme wind power |
| **Abyss** | 0.3 | 5 | Still | Dense fog | Low-G | Hard to control momentum | Floating cities; zero-G factories |
| **Forge** | 1.2 | 800 | Hot updrafts | Toxic ash | Geothermal | heat, | Free energy from lava |
| **Frost** | 1.1 | −50 | Icy gusts | Cryogenic | Freezing | Fluids freeze; metal brittles; hypothermia | Ice roads;permafrost  |
| **Mist** | 1.0 | 15 | None | Saturated | Zero visibility | Zero visibility | Sonar systems shit idk |
| **Shatter** | 0.8 | 40 | Unstable | Ionized | Seismic stress | quakes | Quake powered generator |
| **Sink** | 2.0 | 60 | Heavy | Pressurized | Crushing depth | Extreme weight; sinking into terrain | Ultra-dense armor; pressure-forged alloys |
| **Drift** | Variable | −20 | Chaotic | Thin | Temporal shear | Gravity shifts unpredictably | Momentum-harvesting engines; |
| **Bloom** | 0.9 | 35 | Pollinated | Bioluminescent | Organic overgrowth | Fast-growing flora breaches structures; spore corrosion | Bio-reactors; living architecture; self-repairing materials ig, depends very heavy on chemistry engine |

## **Raytraced Audio Engine**

Raytraced Audio is cool n’ shit :3. And i think it really fits the vibe of all of this stuff [I Built Raytraced Audio for Godot](https://www.youtube.com/watch?v=A6bPUXTlic8)

## **Blocks**

Meadow (starter Biome)

Dirt:1,400 kg/m³  
Grass: 150–300 kg/m³  
Oak: 150–300 kg/m³   
Sandstone: 2.100 kg/m³  
Loam: 1.400 kg/m³

## 

## 

## 

##  **Broad Feature list**

### **Core Physics & Voxel System**

- [ ] **Custom Jolt Voxel Shape** — Direct ZXY-buffer collision, no mesh generation, ray-voxel intersection  
- [ ] **Voxel Slice Manager** — 16×16×16 chunks, Static/Mutable/Custom compound shape switching  
- [ ] **AABB Wake System** — Sleep/wake rigidbodies on voxel modification, for better Performance.  
- [ ] **Deterministic ID Generator** — (player\_id \&lt;\&lt; 32\) | spawn\_sequence, cross-client sync  
- [ ] **Fixed-Timestep Physics Driver** — Lockstep-ready, 60/120 Hz, no delta variation

### **Chemistry Engine**

- [ ] **Thermal Diffusion Grid** — Sparse voxel temperature field, dT/dt solver  
- [ ] **Phase Transition Handler** — RigidBody ↔ fluid particle ↔ gas particle state machine  
- [ ] **Material Property LUT** — T\_ignite, T\_melt, k\_thermal, ρ\_density per material ID  
- [ ] **Reaction Cascade System** — Fire spread, oxidation chains (keep it low)  
- [ ] **Physics type stuff** — Thermodynamics, par esemple convection

### **Fluid & Gas Dynamics**

- [ ] **SPH Fluid Solver** — Smoothed particle hydrodynamics for molten/liquid states  
- [ ] **Gas Pressure Field** — Eulerian grid for steam/explosive gas, pressure wave propagation  
- [ ] **Pump/Pipe Network** — Graph-based flow simulation, volumetric throughput

### **Multiplayer & Networking**

- [ ] Pocket System — 2×2×2 km spatial partitioning, buffer zone body duplication  
- [ ] **Input Lockstep Buffer** — Deterministic input queue, slowest-client pacing  
- [ ] **Client Prediction \+ Rollback** — 30-frame history, resimulation on server correction  
- [ ] **Snapshot Interpolator** — Ghost bodies for distant pockets, 1 Hz → visual interpolation  
- [ ] **Cross-Pocket Entity Migration** — Serialze/deserialize body \+ constraints at boundaries

### **World & Biome Generation**

- [ ] **Fragment Generator** — Procedural biome parameter fields (g, T\_env, wind, atmosphere)  
- [ ] **Tether System** — Physics constraints linking floating fragments, stress/fracture simulation  
- [ ] **Origin Shifter** — Camera-relative world repositioning for infinite coordinate precision

### **Building & Construction**

- [ ] **Holo-Canvas Renderer** — Transparent preview voxels, no collision, mirror/flip tools  
- [ ] **Materialization Queue** — Progressive physical spawn from blueprint, resource validation  
- [ ] **Bulk Placement Tool** — Line/box/sphere voxel brushes, Scrap Mechanic-style rapid building

### **AI & Ecosystem**

- [ ] **Silicate Core-Drive AI** — Goal: seek energy sources, pathfind via physics navmesh  
- [ ] **Faction Behavior Tree** — Raid patterns, siege tactics, territorial claim logic  
- [ ] **Ecology Simulator** — Flora growth, resource depletion, predator-prey cycles

### **UI & Feedback**

- [ ] **Thermal Vision Overlay** — Color-map temperature display for engineering diagnostics  
- [ ] **Stress Analysis View** — Structural integrity heatmap, failure prediction lines  
- [ ] **Kinetic Network HUD** — Real-time RPM/torque/efficiency readouts on hover

### **Serialization & Persistence**

- [ ] **Deterministic World Save** — Binary snapshot, ordered body spawn, constraint reconstruction  
- [ ] **Blueprint Codec** — Compress Holo-Canvas designs to shareable/player-tradable format  
- [ ] **Incremental Chunk Delta** — Only serialize modified slices, not full world

### **Audio (for the end, cuz polish although it’s prolly the easiest to do)**

- [ ] **Procedural Mechanical Audio** — RPM-dependent gear whine, shaft resonance, metal stress  
- [ ] **Thermal Audio Layer** — Crackling wood, hissing steam, expanding metal pings

Wait thats actually a lot :(