# Tarnhelm URL Cleaner Daemon for Androi

https://github.com/lz233/Tarnhelm

https://tarnhelm.project.ac.cn/

Tarnhelm is a Daemon for your Android that helps you clean URL / sauce links you're about to share. It uses methods to take off those nasty tracking parts & other junk parts of the sauce, so you can elegantly share those sauces to your peers.

Its regex feature is very powerful that it can make Tarnhelm to automatically manipulate & brush clean URLs based on Tarnhelm regex rule catches. **You can use it as a disguised sauce decoder too!**

## Rules 规则库

Here are rules!!!

For more rules, checkout its [**official repository** here](https://tarnhelm.project.ac.cn/rules.html). You can copy each of their `tarnhelm://` URL by copying the `a`'s `href` on the title header of each Rule. Then paste them in their correct category (between `Parameters`, `Regexes`, & `Redirects`)

<!-- To copy the `tarnhelm://` rule, simply copy its element header. say title is `Doom`, copy that `Doom` `a` URL header.   -->
To copy the `tarnhelm://` rule, simply copy the provided `tarnhelm://` URL beneath each rule title.  
Paste it accordingly (in their correct category between `Parameters`, `Regexes`, & `Redirects`) to your tarnhelm app, `Rules` menu.

### Parameters 参数规则

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

#### GitHub Unreadme

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
tarnhelm://rule?regex=eyJhIjoiUGl4aXYgQnJ1dGFsaXR5IiwiYiI6WyIoKFB8cClpeGl2fPCfhb%2FvuI8pKDp8KShcXHN8KSJdLCJjIjpbImh0dHBzOlwvXC9waXhpdi5uZXRcL2FydHdvcmtzXC8iXSwiZCI6IkpPRUx3aW5kb3dzNyJ9
```

Brutally convert disguised Pixiv sauces back into its former glory of artworks URL. You can now write down the disguise and then let the people decode it!

```txt
Regexes 正则:
    ((P|p)ixiv|🅿️)(:|)(\s|)
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
