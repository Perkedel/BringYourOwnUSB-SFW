# Autumn Lamonte

a.k.a. Autumn Meow meow

## Famous Source Ports

- https://gitlab.com/AutumnMeowMeow/xtermdoom . Doom on Xterm itself, not X nor Wayland. Compatible with Xterming Terminal Emulators
    - use [`JDK 11`](https://adoptium.net/temurin/releases?version=11&os=any&arch=any) & [`ant`](https://ant.apache.org/bindownload.cgi) to compile. Apache Ant will pick whatever default Java version set on your dev system.
    - `ant` should be available on most distros. e.g., Debian & Ubuntu is `sudo apt install ant -y`.
    - also with `JDK 11`. e.g., Debian & Ubuntu is `sudo apt install openjdk-11-jdk -y`.
    - in Debian & Ubuntu you can use `update-java-alternatives --list` to list all installed Java versions.
        - watch the `/usr/lib` path!
        - To set which, use `--set` argument instead, followed with whatever `usr/lib` Java binary you'd like. **Do this with root!**. e.g. `sudo update-java-alternatives --set /usr/lib/jvm/java-1.11.0-openjdk-amd64`
    - ([mochadoom](https://mochadoom.sourceforge.net/)) IWAD file supports unfortunately seems to be hardcoded. **must be [`doom1.wad`](https://archive.org/details/DoomsharewareEpisode), `doom.wad`, `doom2.wad`, Xbox Live DOOM 2, `tnt.wad`, `plutonia.wad`**; No Freedoom support.
    - [Fork of mochadoom](https://github.com/AutumnMeowMeow/mochadoom) just to get it done. [original bin of mochadoom](https://sourceforge.net/projects/mochadoom/)