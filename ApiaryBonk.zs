#modloaded gendustry
#loader mixin

import native.net.bdew.gendustry.machines.apiary.BlockApiary;
import native.net.bdew.gendustry.machines.apiary.TileApiary;
import native.forestry.api.apiculture.IBeekeepingLogic;

import native.net.minecraft.entity.player.EntityPlayer;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.util.EnumHand;
import native.net.minecraft.util.text.TextComponentString;
import native.net.minecraft.util.math.BlockPos;
import native.net.minecraft.world.World;


// I hate Scala jars

#mixin {targets: "net.bdew.gendustry.machines.apiary.BlockApiary$"}
zenClass ApiaryBonkMixin {
    // SRG HEAD: Block#onBlockClicked -> func_180649_a
    // Not mixin because it isn't in the base BlockApiary class
    function func_180649_a(worldIn as World, pos as BlockPos, playerIn as EntityPlayer) as void {

        val heldItem as ItemStack = playerIn.getHeldItem(EnumHand.MAIN_HAND);
        if (!worldIn.isRemote && heldItem.getItem().getRegistryName().toString() == "minecraft:stick") {
            // Bonk action: refresh apiary
            val tile as TileApiary = worldIn.getTileEntity(pos) as TileApiary;
            val logic as IBeekeepingLogic = tile.getBeekeepingLogic();
            logic.clearCachedValues();

            // Chat message
            val message as TextComponentString = TextComponentString("§aBonk! Apiary flowers refreshed.");
            playerIn.sendStatusMessage(message, true);
        }
    }
}

