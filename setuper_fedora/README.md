# Auto setup linux installation

## T480 Chromium video acceleration problem fix

### Check driver

```bash
sudo dnf -y install libva-utils
vainfo
```

### Enable rpmfusion

```bash
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
```

### Enable openh264

```bash
sudo dnf config-manager --enable fedora-cisco-openh264
```

### Install driver

```bash
sudo dnf install intel-media-driver
```

### Check driver

```bash
vainfo
```

## Links
* https://github.com/palikar/dotfiles/tree/master/setuper
