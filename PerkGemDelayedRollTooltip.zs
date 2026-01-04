#modloaded astralsorcery
#loader mixin
#sideonly client

import native.net.minecraft.item.ItemStack;
import native.net.minecraftforge.event.entity.player.ItemTooltipEvent;
import native.net.minecraftforge.fml.common.eventhandler.SubscribeEvent;

import native.hellfirepvp.astralsorcery.common.item.gem.ItemPerkGem;

import mixin.CallbackInfo;

#mixin {targets: "hellfirepvp.astralsorcery.common.event.listener.EventHandlerMisc"}
zenClass PerkGemDelayedRollTooltipMixin {
    #mixin Inject
    #{
    #   method: "onToolTip",
    #   at: { value: "TAIL" }
    #}
    function addPerkGemRollTooltip(event as ItemTooltipEvent, ci as CallbackInfo) as void {
        val stack as ItemStack = event.getItemStack();
        if (stack.isEmpty()) return;
        if (!(stack.getItem() instanceof ItemPerkGem)) return;

        if (ItemPerkGem.getModifiers(stack).isEmpty()) {
            event.getToolTip().add("§3Right-click to roll perks on this gem.");
        }
    }
}
