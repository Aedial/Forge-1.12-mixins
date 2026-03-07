#modloaded cyclicmagic
#loader mixin

import native.net.minecraft.block.Block;
import native.net.minecraft.block.state.IBlockState;
import native.net.minecraft.item.Item;
import native.net.minecraft.item.ItemStack;
import native.net.minecraft.nbt.NBTTagCompound;
import native.net.minecraft.tileentity.TileEntity;
import native.net.minecraft.util.math.BlockPos;
import native.net.minecraft.world.World;
import native.net.minecraft.entity.player.EntityPlayer;
import native.net.minecraft.util.text.TextComponentString;
import native.net.minecraft.util.EnumHand;
import native.com.lothrazar.cyclicmagic.item.tiletransporter.ItemChestSackEmpty;
import native.com.lothrazar.cyclicmagic.util.UtilChat;
import native.com.lothrazar.cyclicmagic.util.UtilItemStack;
import native.com.lothrazar.cyclicmagic.util.UtilPlaceBlocks;

import mixin.CallbackInfo;

// Instead of dropping the filled sack, try adding it to the player's inventory first
#mixin {targets: "com.lothrazar.cyclicmagic.item.tiletransporter.ItemChestSackEmpty"}
zenClass SackDropRedirectMixin {

    #mixin Static
    #mixin Inject
    #{
    #   method: "gatherTileEntity",
    #   at: { value: "HEAD" },
    #   cancellable: true
    #}
    function gatherTileEntityReplacement(position as BlockPos, player as EntityPlayer, world as World, tile as TileEntity, ci as CallbackInfo) as void {
        // Early exit conditions (same as original)
        if (tile == null) {
            ci.cancel();
            return;
        }

        val state as IBlockState = world.getBlockState(position);

        // Write tile entity data
        val tileData as NBTTagCompound = NBTTagCompound();
        tile.writeToNBT(tileData);

        // Build item NBT data (using same keys as ItemChestSack)
        val itemData as NBTTagCompound = NBTTagCompound();
        itemData.setString("blockname", state.getBlock().getTranslationKey());
        itemData.setTag("tile", tileData);
        itemData.setInteger("block", Block.getIdFromBlock(state.getBlock()));
        itemData.setInteger("blockstate", state.getBlock().getMetaFromState(state));

        // Find which hand holds the empty sack
        var hand as EnumHand = EnumHand.MAIN_HAND;
        var held as ItemStack = player.getHeldItem(hand);
        if (held == null || !(held.getItem() instanceof ItemChestSackEmpty)) {
            hand = EnumHand.OFF_HAND;
            held = player.getHeldItem(hand);
        }

        if (held == null || held.getCount() <= 0) {
            ci.cancel();
            return;
        }

        if (!(held.getItem() instanceof ItemChestSackEmpty)) {
            ci.cancel();
            return;
        }

        val emptySack as ItemChestSackEmpty = held.getItem() as ItemChestSackEmpty;
        val fullSackItem as Item = emptySack.getFullSack();
        if (fullSackItem == null) {
            ci.cancel();
            return;
        }

        // Try to destroy the block
        if (!UtilPlaceBlocks.destroyBlock(world, position)) {
            UtilChat.sendStatusMessage(player, "chest_sack.error.pickup");
            world.setBlockState(position, state);
            ci.cancel();
            return;
        }

        // Create the filled sack
        val drop as ItemStack = ItemStack(fullSackItem);
        drop.setTagCompound(itemData);

        // Shrink the empty sack (potentially freeing up inventory space)
        if (!player.capabilities.isCreativeMode && held.getCount() > 0) {
            held.shrink(1);
            if (held.getCount() <= 0) player.setHeldItem(hand, ItemStack.EMPTY);
        }

        // Try to add the filled sack to inventory first
        player.inventory.addItemStackToInventory(drop);
        
        // Check if the stack was actually consumed - if not, drop it
        if (!drop.isEmpty()) player.dropItem(drop, false);

        ci.cancel();
    }
}
