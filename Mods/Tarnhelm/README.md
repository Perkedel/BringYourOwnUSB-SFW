# Tarnhelm URL Cleaner Daemon for Android

https://github.com/lz233/Tarnhelm

https://tarnhelm.project.ac.cn/

Tarnhelm is a Daemon for your Android that helps you clean URL / sauce links you're about to share. It uses methods to take off those nasty tracking parts & other junk parts of the sauce, so you can elegantly share those sauces to your peers.

Its regex feature is very powerful that it can make Tarnhelm to automatically manipulate & brush clean URLs based on Tarnhelm regex rule catches. **You can use it as a disguised sauce decoder too!**

## Tutorial

[Here manual how to make rules](https://tarnhelm.project.ac.cn/en/manual.html)

To use Tarnhelm, [simply install the app](https://github.com/lz233/Tarnhelm/releases/latest). Then, [setup your Shizuku](https://shizuku.rikka.app/) to get ADB right on the same phone / tablet. Tarnhelm uses ADB (Shizuku) to manipulate your most recent clipboard that contains your URL or anything you set in rules to its replaced clean sauce or whatever you replace with. No more need to Root your phone (which btw, many manufacturers especially Samsung already setup various kinds of breakages when its rooted anyway).

- Install Tarnhelm & Shizuku
- Setup Shizuku (non rooted)
    - Open Shizuku & choose methods to start Shizuku daemon.
    - If your phone supports wireless ADB, you can do so with this option of `Start via Wireless debugging`. Follow the instruction `Step-by-step guide` as Shizuku will become the *virtual dev PC* named `shizuku` just to start itself.
    - Otherwise, use any compatible PC (Windows, Linux, Mac) and run the ADB command shown, e.g.: `adb shell sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh`.
        - Connect your phone / tablet via USB.
        - Get ADB on Windows with chocolatey `sudo choco install adb` or [Android Studio](https://developer.android.com/studio). If somehow none of the step works or available, you can use this [Minimum ADB Fastboot kit](https://androiddatahost.com/265a2)
        - Get ADB on Linux from built-in repo, e.g. Debian is `sudo apt install adb -y`, Arch is `sudo pacman -Syu adb` btw, etc.
- Allow Tarnhelm to Shizuku all the time
    - Shizuku
    - `Authorized ### applications`
    - Authorize `Tarnhelm` by enabling that.
- If your phone / tablet rooted & you have LSposed, you can use that instead. Note, sometimes it may fail especially for KernelSU based root like with [BlissOS-Androidx86](https://sourceforge.net/projects/blissos-x86/). If that somehow fail, then you can fall back to Shizuku, and then as well make Shizuku autostart itself on boot by Root (`Start (for rooted devices)`).
- Import or make your Parameters, Rules, & Redirects. We got few examples below, check em out!

## Rules 规则库

Here are rules!!!

For more rules, checkout its [**official repository** here](https://tarnhelm.project.ac.cn/rules.html). You can copy each of their `tarnhelm://` URL by copying the `a`'s `href` on the title header of each Rule. Then paste them in their correct category (between `Parameters`, `Regexes`, & `Redirects`)

<!-- To copy the `tarnhelm://` rule, simply copy its element header. say title is `Doom`, copy that `Doom` `a` URL header.   -->
<!-- To copy the `tarnhelm://` rule, simply copy the provided `tarnhelm://` URL beneath each rule title.   -->
To copy the `tarnhelm://` rule, simply copy the provided `tarnhelm://` URL beneath each rule title or its header of the rule.  
Paste it accordingly (in their correct category between `Parameters`, `Regexes`, & `Redirects`) to your tarnhelm app, `Rules` menu.  
Or you can try click its header title of the rule & select `Tarnhelm` if prompted `Open with`.

### Parameters 参数规则

#### Template Parameters

```
tarnhelm:// URL here
```

Here Paramter Template. This is to whitelist or blacklist tarnhelm reactionary action when something happened in clipboard.

```
Domain 域名: 
Mode 模式: Whitelist 白名单 / Blacklist 黑名单
Parameter 参数:
    
Author 作者:
Example Input 输入: 

Example Output 输出:

```

### [Doomworld](tarnhelm://rule?parameter=eyJhIjoiRG9vbXdvcmxkIiwiZSI6Ind3dy5kb29td29ybGQuY29tIiwiZiI6MCwiZyI6WyIiXSwiZCI6IkpPRUx3aW5kb3dzNyJ9)

```
tarnhelm://rule?parameter=eyJhIjoiRG9vbXdvcmxkIiwiZSI6Ind3dy5kb29td29ybGQuY29tIiwiZiI6MCwiZyI6WyIiXSwiZCI6IkpPRUx3aW5kb3dzNyJ9
```

Enable something happening for `www.doomworld.com` stuffs.

```
Domain 域名: www.doomworld.com
Mode 模式: Whitelist 白名单
Parameter 参数:

Author 作者: JOELwindows7
Example Input 输入:
    https://www.doomworld.com/idgames/?id=8339/?#review-157885
Example Output 输出:
    https://www.doomworld.com/idgames/
```

### [`idgames://`](tarnhelm://rule?parameter=eyJhIjoiaWRnYW1lcyBwcm90b2NvbCIsImUiOiJpZGdhbWVzOlwvXC8iLCJmIjowLCJnIjpbIiJdLCJkIjoiSk9FTHdpbmRvd3M3In0%3D)

```
tarnhelm://rule?parameter=eyJhIjoiaWRnYW1lcyBwcm90b2NvbCIsImUiOiJpZGdhbWVzOlwvXC8iLCJmIjowLCJnIjpbIiJdLCJkIjoiSk9FTHdpbmRvd3M3In0%3D
```

Enable something happening for `idgames://` stuffs

### Regex 正则规则

#### Template Regex

```
tarnhelm:// URL here!
```

Use this template for sharing your tanrhelm URL.

```txt
Regexes 正则:

Replacement 替换:

Author 作者:

Example Input 输入:

Example Output 输出:
 
```

#### [GitHub Unreadme](tarnhelm://rule?regex=eyJhIjoiR2l0SHViIHVuUkVBRE1FIiwiYiI6WyIoaHR0cHM%2FOlwvXC8pKHd3d1xcLik%2FKGdpdGh1YlxcLmNvbSkoXC9bQS1aYS16MC05Xy1dKykoXC9bQS1aYS16MC05Xy1dKykoXFw%2FdGFiPVtBLVphLXowLTlfLV0rKSJdLCJjIjpbIiQxJDIkMyQ0JDUiXSwiZCI6IkpPRUx3aW5kb3dzNywgaW5zcGlyZWQgZnJvbSBIaW5hdGFLYXRvIn0%3D)

```
tarnhelm://rule?regex=eyJhIjoiR2l0SHViIHVuUkVBRE1FIiwiYiI6WyIoaHR0cHM%2FOlwvXC8pKHd3d1xcLik%2FKGdpdGh1YlxcLmNvbSkoXC9bQS1aYS16MC05Xy1dKykoXC9bQS1aYS16MC05Xy1dKykoXFw%2FdGFiPVtBLVphLXowLTlfLV0rKSJdLCJjIjpbIiQxJDIkMyQ0JDUiXSwiZCI6IkpPRUx3aW5kb3dzNywgaW5zcGlyZWQgZnJvbSBIaW5hdGFLYXRvIn0%3D
```

remove `?=tab` off of your `github.com` sauces! If you copy the sauce from URL bar, it may leave this residual selected auto-readme tab beneath the file list.

```
Regexes 正则:
    (https?://)(www\.)?(github\.com)(/[A-Za-z0-9_-]+)(/[A-Za-z0-9_-]+)(\?tab=[A-Za-z0-9_-]+)
Replacement 替换:
    $1$2$3$4$5
Author 作者:
    JOELwindows7, inspired from HinataKato
Example Input 输入:
    https://github.com/lz233/Tarnhelm?tab=readme-ov-file
    https://github.com/Perkedel/Lah-Mboh?tab=readme-ov-file
Example Output 输出:
    https://github.com/lz233/Tarnhelm
    https://github.com/Perkedel/Lah-Mboh
```

#### Doomworld to idgames

Sorry, we failed to regex this out atm. The *new* & *legacy* idgames page URL structure is drastically different & incompatible with each other. e.g.:

- A (input) = https://www.doomworld.com/files/file/8339-washington-monument/?&tab=reviews#review-157885
- B (target) = https://www.doomworld.com/idgames/levels/doom2/v-z/washmonu

The page on the newer (`A` & it succ) directly converts each & every WAD submission into an article where its title is the only URL without foldering it, much like the legacy (`B` tho ancient but it's Frutiger Aero enough!) where it is structured neatly by the [idgames librarians at Gamers.org](https://gamers.org). Let's also not forget other politcal optics these days regarding this rabbithole, but that's for another video. [**Anyways**](https://lcsign.com/)..,

We have other URL cleaner rules ahead!

#### [idgamesify Doomworld idgames to protocol](tarnhelm://rule?regex=eyJhIjoiRG9vbXdvcmxkIElkZ2FtZXNpZmllciIsImIiOlsiKGh0dHBzPzpcXFwvXFxcLykod3d3XFwuKT8oZG9vbXdvcmxkXFwuY29tKShcXFwvZmlsZXNcXFwvZmlsZSkoXFxcLykoWzAtOV0rKShbQS1aYS16MC05LV9dKyk%2FKFxcXC9cXD9cXCZbQS1aYS16MC05LV9dKz1bQS1aYS16MC05LV9dKyk%2FKCNbQS1aYS16MC05LV9dKyk%2FIl0sImMiOlsiaWRnYW1lczpcL1wvJDYiXSwiZCI6IkpPRUx3aW5kb3dzNyJ9)

```
tarnhelm://rule?regex=eyJhIjoiRG9vbXdvcmxkIElkZ2FtZXNpZmllciIsImIiOlsiKGh0dHBzPzpcXFwvXFxcLykod3d3XFwuKT8oZG9vbXdvcmxkXFwuY29tKShcXFwvZmlsZXNcXFwvZmlsZSkoXFxcLykoWzAtOV0rKShbQS1aYS16MC05LV9dKyk%2FKFxcXC9cXD9cXCZbQS1aYS16MC05LV9dKz1bQS1aYS16MC05LV9dKyk%2FKCNbQS1aYS16MC05LV9dKyk%2FIl0sImMiOlsiaWRnYW1lczpcL1wvJDYiXSwiZCI6IkpPRUx3aW5kb3dzNyJ9
```

Convert *new but succ* idgames viewer into `idgames://` URL sauce. Make it so to atleast avoid *new & succ* Doomworld idgames page, and hopefully lets you reach *old but stroncc* idgames or maybe other compatible client that supports this protocol.

```
Regexes 正则:
    (https?:\/\/)(www\.)?(doomworld\.com)(\/files\/file)(\/)([0-9]+)([A-Za-z0-9-_]+)?(\/\?\&[A-Za-z0-9-_]+=[A-Za-z0-9-_]+)?(#[A-Za-z0-9-_]+)?
Replacement 替换:
    idgames://$6
Author 作者:
    JOELwindows7
Example Input 输入:
    https://www.doomworld.com/files/file/8339-washington-monument/?&tab=reviews#review-157885
Example Output 输出:
    idgames://8339
```

Successful [regexr dev here](https://regexr.com/8hca1)

#### [Legacify Doomworld idgames into OLD but stroncc](tarnhelm://rule?regex=eyJhIjoiRG9vbXdvcmxkIExlZ2FjaWZpZXIiLCJiIjpbIihodHRwcz86XFxcL1xcXC8pKHd3d1xcLik%2FKGRvb213b3JsZFxcLmNvbSkoXFxcL2ZpbGVzXFxcL2ZpbGUpKFxcXC8pKFswLTldKykoW0EtWmEtejAtOS1fXSspPyhcXFwvXFw%2FXFwmW0EtWmEtejAtOS1fXSs9W0EtWmEtejAtOS1fXSspPygjW0EtWmEtejAtOS1fXSspPyJdLCJjIjpbImh0dHBzOlwvXC93d3cuZG9vbXdvcmxkLmNvbVwvaWRnYW1lc1wvP2lkPSQ2Il0sImQiOiJKT0VMd2luZG93czcifQ%3D%3D)

```
tarnhelm://rule?regex=eyJhIjoiRG9vbXdvcmxkIExlZ2FjaWZpZXIiLCJiIjpbIihodHRwcz86XFxcL1xcXC8pKHd3d1xcLik%2FKGRvb213b3JsZFxcLmNvbSkoXFxcL2ZpbGVzXFxcL2ZpbGUpKFxcXC8pKFswLTldKykoW0EtWmEtejAtOS1fXSspPyhcXFwvXFw%2FXFwmW0EtWmEtejAtOS1fXSs9W0EtWmEtejAtOS1fXSspPygjW0EtWmEtejAtOS1fXSspPyJdLCJjIjpbImh0dHBzOlwvXC93d3cuZG9vbXdvcmxkLmNvbVwvaWRnYW1lc1wvP2lkPSQ2Il0sImQiOiJKT0VMd2luZG93czcifQ%3D%3D
```

Convert *new but succ* idgames viewer into *Old but stroncc* `https://www.doomworld.com/idgames/` URL sauce. Let's just gamble if this just this ID number alone means something. So atleast you see sauce & decide how'd you Rip & WAD it this mod later.

```
Regexes 正则:
    (https?:\/\/)(www\.)?(doomworld\.com)(\/files\/file)(\/)([0-9]+)([A-Za-z0-9-_]+)?(\/\?\&[A-Za-z0-9-_]+=[A-Za-z0-9-_]+)?(#[A-Za-z0-9-_]+)?
Replacement 替换:
    https://www.doomworld.com/idgames/?id=$6
Author 作者:
    JOELwindows7
Example Input 输入:
    https://www.doomworld.com/files/file/8339-washington-monument/?&tab=reviews#review-157885
Example Output 输出:
    https://www.doomworld.com/idgames/?id=8339
```

#### [Unidgamesify the protocol into a Doomworld idgames sauce viewer](tarnhelm://rule?regex=eyJhIjoiVW5pZGdhbWVzaWZ5IGlkZ2FtZXMgaW50byBEb29td29ybGQgaWRnYW1lcyIsImIiOlsiKGlkZ2FtZXM6XFxcL1xcXC8pKFswLTldKykiXSwiYyI6WyJodHRwczpcL1wvd3d3LmRvb213b3JsZC5jb21cL2lkZ2FtZXNcLz9pZD0kMiJdLCJkIjoiSk9FTHdpbmRvd3M3In0%3D)

```
tarnhelm://rule?regex=eyJhIjoiVW5pZGdhbWVzaWZ5IGlkZ2FtZXMgaW50byBEb29td29ybGQgaWRnYW1lcyIsImIiOlsiKGlkZ2FtZXM6XFxcL1xcXC8pKFswLTldKykiXSwiYyI6WyJodHRwczpcL1wvd3d3LmRvb213b3JsZC5jb21cL2lkZ2FtZXNcLz9pZD0kMiJdLCJkIjoiSk9FTHdpbmRvd3M3In0%3D
```

Convert `idgames://` into *Old but stroncc* `https://www.doomworld.com/idgames/` URL sauce. Let's be honest, nobody or much less would know or care about `idgames://` protocol right? Right?.. idk.

```
Regexes 正则:
    (idgames:\/\/)([0-9]+)
Replacement 替换:
    https://www.doomworld.com/idgames/?id=$2
Author 作者:
    JOELwindows7
Example Input 输入:
    idgames://8339
Example Output 输出:
    https://www.doomworld.com/idgames/?id=8339
```

[regexr of this](https://regexr.com/8hcap)

If this feels unpleasant, You may skip / disable this.

#### Skip idgames into HTTPS download link in Germany

```
tarnhelm://rule?regex=eyJhIjoiU2tpcCBEb29td29ybGQgaWRnYW1lcyBpbnRvIEhUVFBTIEdlcm1hbnkiLCJiIjpbIihodHRwcz86XFxcL1xcXC8pKHd3d1xcLik%2FKGRvb213b3JsZFxcLmNvbSkoXFxcL2lkZ2FtZXMpKFxcXC9bQS1aYS16MC05LV9cXFwvXSspIl0sImMiOlsiaHR0cHM6XC9cL3d3dy5xdWFkZGljdGVkLmNvbVwvZmlsZXMkNCQ1LnppcCJdLCJkIjoiSk9FTHdpbmRvd3M3In0%3D
```

Skip Doomworld old idgames viewer to download the file right now from Germany mirror. Guess it's fine right, coz all idgames wad must have `WADINFO` in the WAD or `.txt` WADINFO by the WAD right? You spread it, along with the info file, you're good, yeah! 

```
Regexes 正则:
    (https?:\/\/)(www\.)?(doomworld\.com)(\/idgames)(\/[A-Za-z0-9-_\/]+)
Replacement 替换:
    https://www.quaddicted.com/files$4$5.zip
Author 作者:
    JOELwindows7
Example Input 输入:
    https://www.doomworld.com/idgames/levels/doom2/v-z/washmonu
Example Output 输出:
    https://www.quaddicted.com/files/idgames/levels/doom2/v-z/washmonu.zip
```

[dev regexr](regexr.com/8hcbb)

If this feels way too fast to download file soon, You may temporarily disable this for a while.

#### Remove vglink filter off of Doomer Boards

```
```

Remove Doomer Boards VGlink filter to the 3rd party website.

```txt
Regexes 正则:

Replacement 替换:

Author 作者:

Example Input 输入:

Example Output 输出:

```

#### Unshort YouTube Shorts

```
tarnhelm://rule?regex=eyJhIjoiVW5zaG9ydCBZb3VUdWJlIFNob3J0cyIsImIiOlsiKGh0dHBzPzpcL1wvKSh5b3V0dWJlXFwuY29tKShcL3Nob3J0cykoXC9bYS16QS1aMC05Xy1dKykoXFw%2Fc2k9W0EtWmEtejAtOV8tXSspIl0sImMiOlsiJDF5b3V0dS5iZSQ0Il0sImQiOiJKT0VMd2luZG93czcsIGJhc2VkIG9uIEhpbmF0YUthdG8ifQ%3D%3D
```

Fuck it. Unshort your YouTube Short to make it play in regular player instead!

```
Regexes 正则:
    (https?://)(youtube\.com)(/shorts)(/[a-zA-Z0-9_-]+)(\?si=[A-Za-z0-9_-]+)
Replacement 替换:
    $1youtu.be$4
Author 作者:
    JOELwindows7, based on HinataKato
Example Input 输入:
    https://youtube.com/shorts/B6v6N7pyL90
Example Output 输出:
    https://youtu.be/B6v6N7pyL90
```

If this rule feels undesirable, you may skip / disable this rule

#### Pixiv Brutality

```
tarnhelm://rule?regex=eyJhIjoiUGl4aXYgQnJ1dGFsaXR5IiwiYiI6WyIoKFB8cClpeGl2fPCfhb%2FvuI8pKDp8KShcXHN8KShbMC05Xy1dKykiXSwiYyI6WyJodHRwczpcL1wvcGl4aXYubmV0XC9hcnR3b3Jrc1wvIl0sImQiOiJKT0VMd2luZG93czcifQ%3D%3D
```

Brutally convert disguised Pixiv sauces back into its former glory of artworks URL. You can now write down the disguise and then let the people decode it!

```txt
Regexes 正则:
    ((P|p)ixiv|🅿️)(:|)(\s|)([0-9_-]+)
Replacement 替换:
    https://pixiv.net/artworks/
Author 作者:
    JOELwindows7
Example Input 输入:
    pixiv 77096628
    Pixiv: 77096628
    🅿️ 77096628
    🅿️:77096628
Example Output 输出:
    https://pixiv.net/artworks/77096628
    https://pixiv.net/artworks/77096628
    https://pixiv.net/artworks/77096628
    https://pixiv.net/artworks/77096628
```


### Redirects 重定向规则
