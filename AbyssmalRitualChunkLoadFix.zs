#modloaded abyssalcraft
#loader mixin

import native.java.util.ArrayList;

import mixin.CallbackInfoReturnable;

// Clean up partially populated pedestals list due to chunk loading order, so it can be repopulated correctly
#mixin {targets: "com.shinoow.abyssalcraft.common.blocks.tile.tileEntityRitualAltar"}
zenClass AbyssmalRitualChunkLoadFixMixin {
    #mixin Shadow
    var pedestals as ArrayList;

    #mixin Inject
    #{
    #   method: "canPerform",
    #   at: { value: "HEAD" },
    #   cancellable: true
    #}
    function cleanInvalidPedestalsState(cir as CallbackInfoReturnable) as void {
        val count as int = pedestals.size();
        if (0 < count && count < 8) pedestals.clear();  // 8 is valid, 0 means uninitialized
    }
}
