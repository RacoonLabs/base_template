Export
To export new builds for Android, we have can use a builds/ folder on the project root. This folder is ignored by git, so it is sure to put files there without tracking.

Workflow
Main Branch
The main branch will be the branch considered the main branch of the project. That is to say. All code stored in main is fully functional code.

Other branches
To add new functionality, a new branch must be created, from the most updated version of main. To do this, a specific name will be used that is declarative regarding the functionality to be developed.

EJ: If I am going to create a Puzzle for scenario 1 then the workflow is as follows:

With Git, I hover over main.
I do a Pull to make sure I have the most up-to-date version of main.
From that point, I create a branch called puzzle-scenario-1 (all lowercase, with a hyphen instead of a space)
Being in the new branch, I develop the desired functionality.
For each Commit made, a Push must be made so that the remote repository is updated.
When the functionality is finished and everything has been Pushed, create a Pull Request from the puzzle-scenario-1 branch to main
The information requested in the pull request template must be completed when opening it.
Once the code has been reviewed by a peer, and approved by them, a Merge Pull request can be made to main
Commits
Each project commit must be Atomic and descriptive, that is:

Atomic: the changes made between one commit and another should be as small as possible, from simply changing some words and colors, to creating a small scene.

Descriptive: Commits have associated messages. The message of each commit must describe in a simple and concise way what changes it contains. As a rule: If to name the commit I have to put a text that explains 3 different changes, it is a commit that is not atomic. ex: "Character colors, level 1 text and enemy movement speed have been modified" --> Very large commit ex: "Character scene created" --> Atomic Commit

Convention Guide
Code: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html Folders: https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html

Project structure convention:
BEEF://
├── assets
│ ├── character
│ │ ├── character_sheet.png
│ ├── enemy
│ │ ├── enemy_sheet.png
├── scenes
│ ├── character
│ │ ├── character.tscn
│ │ ├── character.gd
│ ├── enemy
│ │ ├── enemy.tscn
│ │ ├── enemy.gd
│ ├── level_1
│ │ ├── level_1.tscn
│ │ ├── level_1.gd
│ │ ├── ui_level_1
│ │ │ ├── ui_level_1.tscn
│ │ │ ├── ui_level_1.gd

Naming convention

Folders and files: snake_case - lowercase and underscore. ex: red_enemy
Name Nodes: UpperCamelCase - first letter of each word capitalized. ex: AreaDetection -> Important!
Variables: snake_case - first letter of each capitalized word, except the first. ex: var can_fire: boolean = true
functions: snake_case - lowercase and underscore. ex: func perform_shot():
signals: snake_case - lowercase and underscore. ex: signal lost_life
Clarification: The names mentioned above do not have accents or special characters such as Ñ. In this case, omit them or use their corresponding normal character. The names of each element must be clear about what the usefulness of said element is. [If this is not respected, when exporting to mobile the compilation will not work even if it does locally]
