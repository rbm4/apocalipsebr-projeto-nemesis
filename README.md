# ApocalipseBR Nemesis Boss

Standalone Build 42 mod project by Hypothetic that ports the Nemesis and MrX outfit assets from the old B41 ResidentEvilNemesis mod and adds a server-side boss spawn controller.

Original B41 assets and concept credit: Nemeth.

## What is included

- Nemesis outfit registration for Build 42.
- MrX outfit registration for Build 42.
- FullSuit clothing item with the original defensive profile.
- A scripted server spawn system that builds pressure once per minute.
- Manual admin summon support through the vanilla `createhorde2` command.

## Scripted spawn behavior

- Every minute, the server increases a global Nemesis pressure meter.
- Once the pressure reaches the threshold, the server rolls a 10% spawn chance each minute.
- On success, Nemesis spawns around a random eligible player.
- Spawn distance is intentionally large enough to give the player time to react.
- While any live zombie with the `Nemesis` outfit exists, the scripted system will not create another one.

## Default tuning

- Pressure gain per minute: `3`
- Roll threshold: `30`
- Spawn roll after threshold: `10%`
- Spawn distance: `30` to `45` tiles from the target player
- Boss health: `4.5`

The tuning values live at the top of [apocalipsebrnemesisboss/common/media/lua/server/ApocNemesisBossSpawner.lua](apocalipsebrnemesisboss/common/media/lua/server/ApocNemesisBossSpawner.lua).

## Manual summon

Use the built-in admin command with the `Nemesis` outfit name:

```text
/createhorde2 -x 10600 -y 9800 -z 0 -count 1 -outfit Nemesis -health 4.5
```

You can also spawn MrX visually with:

```text
/createhorde2 -x 10600 -y 9800 -z 0 -count 1 -outfit MrX -health 2.0
```

That route gives you a direct boss summon for testing while the scripted system remains active.