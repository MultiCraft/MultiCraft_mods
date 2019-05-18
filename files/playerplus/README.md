MultiCraft game mod: PlayerPlus
Removed POVA, monoids support, knock-back, glitch.

This mod lets the player move faster when walking on ice, slows down the player
when walking on snow, makes touching a cactus hurt and suffocates player when
their head is inside a solid node... enjoy!

https://forum.minetest.net/viewtopic.php?t=10090&p=153667

- 0.1 - Initial release
- 0.2 - 3d_armor mod compatibility
- 0.3 - Optimized code
- 0.4 - Added suffocation when inside nodes
- 0.5 - Slow down when walking in water
- 0.6 - Code tidy and tweak, increased damage by cactus and suffocation
- 0.7 - Added global 'playerplus' table to hold node names gathered around player
- 0.8 - Player knock-back added
- 0.9 - 'on_walk_over' function support added for nodes
- 1.0 - Update to newer functions, requires Minetest 0.4.16 and above to run
- 1.1 - Added support for player_monoids mod (thanks tacotexmex)
- 1.2 - Added POVA support, tweaked code slightly
- 1.3 - Add setting under Advances to enable older sneak glitch movement

API:

Every second the mod checks which node the player is standing on, which node is
at foot and head level and stores inside a global table to be used by mods:

- playerplus[name].nod_stand
- playerplus[name].nod_foot
- playerplus[name].nod_head
