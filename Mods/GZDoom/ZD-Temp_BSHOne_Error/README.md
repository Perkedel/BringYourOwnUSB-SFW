# (ZDOOM) BSH1 Missing Frame B rotation Error (SFW)

| Detail | Value |
| - | - |
| For | GZDoom & Derivatives |
| Requires | [`gz_bigcity.pk3`](https://www.doomworld.com/forum/topic/126802-gz_bigcity-a-gzdoom-city-sandbox-map-update-115-released-1952022/) |
| Conflicts with / Replaces | [`id24red.wad`](https://store.steampowered.com/app/2280/DOOM__DOOM_II/) (as you don't have it) |

Temporary patch for GZDoom today's DRTeam builds & last archived VKDoom build if you had [`gz_bigcity.pk3`](https://www.doomworld.com/forum/topic/126802-gz_bigcity-a-gzdoom-city-sandbox-map-update-115-released-1952022/), latest [GZDoom Dev](https://devbuilds.drdteam.org/gzdoom/) or [VKDoom](https://github.com/dpjudas/VkDoom), and received `BSH1` sprite missing rotation frame error.

![GZDoom latest dev today complains for missing rotation frame in BSH1 sprite](/docs/image/bsh1_error.png)  
![So does with unfortunately now archived latest VKDoom](/docs/image/bsh1_error_vkdoom.png)

We just yoinked the same [Gothic's collected Bushes](https://www.realm667.com/repository/prop-stop/vegetation#preview) (Yoinked by Xaser, Jimmy & Minigunner, also osjclatchford, edited by Gothic), add the B onto here. Basically, we take this sharp tree as it is [`id24red.wad`](https://store.steampowered.com/app/2280/DOOM__DOOM_II/)'s that tree, rename to such like within `id24res.wad`. the `BSH1B0.png` sprite there is.  
`B0` means all frames of `B` be like it. so if they ask `B4` and data doesn't have it, go back to `B0`, etc. etc. idk.

Oh wait. Frame `C` and others too?!

And yes, somehow this now dev version complains if any of the frame part missing just 1 rotation image. bruh. idk how to make Issue report right now. so yeah.

## Install

This mod is meant for temporary workaround & will be deprecated fast.

- If you loaded `gz_bigcity.pk3` & don't have `id24res.wad`
    - **Load this mod on wherever position**.
    - Ensure you have `BSH1B0` & `BSH1C0` here. It's `BSH1B0.png` & `BSH1C0.png` respectively.
- If you already have `id24res.wad`
    - **Ignore this mod**. id24 already has those trees & bushes.

## Verdict

Yeaa problem!

## Return to BringYourOwnUSB-SFW

[Click Here](https://github.com/Perkedel/BringYourOwnUSB-SFW)