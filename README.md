# Forge-1.12-mixins

This repository is a small collection of ZenScript mixins I made for Minecraft Forge 1.12. Each script is intended to be dropped into a pack using Zen Utils (mixin loader) to apply the fixes/features.

## Requirements

- Zen Utils (mixin loader) — these scripts use `#loader mixin` and ZenScript-style mixin declarations, so the mixin loader provided by Zen Utils (or an equivalent ZenScript mixin loader) must be available in the environment.
- The mods these mixins target should be present (examples below refer to Astral Sorcery and Bewitchment), but the scripts will just not apply if they are missing.

## Installation / Steps

1. Place the `.zs` files under your scripts folder, for example:

   scripts/mixin/
   - AstralRelayHalo.zs
   - AstralRelayRenderFix.zs
   - SigilTableJEITransfer.zs

2. Ensure Zen Utils (or your chosen mixin loader) is enabled so ZenScript mixins are loaded at startup.
3. Start Minecraft and verify the changes in the relevant UIs/tiles (see file descriptions for what to check).

## Files and what they do

- `AstralRelayHalo.zs`
  - Adds a translucent, animated golden halo rendered around the Spectral Relay for next item in an Iridescent Altar's crafting task. As the ghost item can be hard to differentiate from the relay's held item, this visual aid helps indicate which relay is the right one.

- `AstralRelayRenderFix.zs`
  - Replaces the TESR (Tile Entity Special Renderer) render for Spectral Relays so items that use TEISR-style rendering (for example DivineRPG statues) render correctly.

- `SigilTableJEITransfer.zs`
  - Adds JEI recipe transfer and a click area for Bewitchment's Sigil Table GUI. This means you will see the "+" button in JEI when viewing Sigil Table recipes, and clicking it will transfer the ingredients into the Sigil Table GUI. Clicking the arrow area in the Sigil Table GUI will open JEI to the Sigil Table recipes.

- `ApiaryBonk.zs` + `ApiaryBonkTooltip.zs`
  - Hit an Industrial Apiary with a stick to refresh the flower detection. As the detection is somewhat broken and can take upwards of dozens of minutes to update, this provides a quick way to force it to recheck the flowers around it.

- `ApiaryBonkHand.zs` + `ApiaryBonkHandTooltip.zs`
  - Same as above, but instead of using a stick, you can simply hit the apiary with an empty hand. Incompatible with `ApiaryBonk.zs`, as both modify the same method.

- `PerkGemDelayedRoll.zs`
  - Changes the behavior of Perk Gems so that they do not roll their perk immediately once in inventory. Instead, right-clicking the gem will roll the perk. This prevents accidental perk rolls when picking up or moving the gem in inventory.

- `RollingMachinePreventLockedOverflowMixin.zs`
  - Prevents inserting items into empty slots of a locked Rolling Machine, to avoid overflow into non-recipe slots.

## License

Use and adapt as you like. If you redistribute, a short credit is appreciated.
