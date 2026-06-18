# [Game Name TBD]

A medieval lane-defense game inspired by Plants vs. Zombies. Deploy units like Knights, Archers, and more to defend your castle against waves of enemies — spending Gold to fund your defenses.

> **This game is currently in active development.** Expect frequent changes.

---

## Concept

Players place defensive units along lanes to stop waves of medieval enemies from reaching their base. Gold is earned passively and spent strategically to build the right defense for each wave.

---

## Built With

- [Godot 4](https://godotengine.org/) (GDScript)

---

##  Project Structure

```
res://
├── assets/         # Sprites, audio, fonts
├── scenes/         # Game scenes (units, enemies, UI, levels)
├── scripts/        # GDScript files
├── resources/      # .tres data files (unit stats, wave configs)
└── autoloads/      # Global singletons (GameManager, GoldManager, etc.)
```

---

## Getting Started

### Prerequisites

- [Godot 4](https://godotengine.org/download/) (latest stable release)
- Windows (primary development platform)

### Running the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
   ```
2. Open Godot 4
3. Click **Import** and select the `project.godot` file from the cloned folder
4. Hit **Play** (F5) to run

---

## Roadmap

- [ ] Core lane grid and unit placement system
- [ ] Gold income and spending mechanic
- [ ] First playable unit (Knight)
- [ ] First enemy type and wave spawning
- [ ] Win/lose conditions
- [ ] Multiple units and enemy types
- [ ] Level progression
- [ ] UI polish and main menu
- [ ] Itch.io release

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Acknowledgements

Inspired by *Plants vs. Zombies* by PopCap Games.
