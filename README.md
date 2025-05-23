# 🐟 Fish School Simulation - Godot Engine

This project is a real-time fish school (shoal) simulation made with the Godot Engine. Inspired by the natural flocking behavior of fish, it simulates lifelike group movement using simple behavioral rules.

## 🎮 Demo

Each fish is an autonomous agent that follows three core rules:
- **Separation**: avoid crowding neighbors
- **Alignment**: steer towards average heading of neighbors
- **Cohesion**: move towards the average position of neighbors

The combination of these behaviors creates a natural, emergent group motion.

https://user-images.githubusercontent.com/your-demo-link.gif

---

## 🔧 Features

- 🧠 Autonomous agent behavior (Boids-like)
- 🎯 Realistic flocking with adjustable parameters
- ⚡ Optimized for real-time performance
- 🛠️ Modular GDScript for easy customization
- 📏 Editor-exposed variables (speed, perception radius, etc.)

---

## 🐍 How It Works

The simulation is based on simple vector math for each fish:

```gdscript
var velocity = Vector2.ZERO
velocity += separation()
velocity += alignment()
velocity += cohesion()
