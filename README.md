<div align="center">

## ` H a p t i c X   E n g i n e `
experimental UI/2D engine written in Nim with ♥

![Nim language](https://img.shields.io/badge/Nim-2b2e3b?style=for-the-badge&logo=nim&logoColor=f1fa8c)
![Open GL](https://img.shields.io/badge/Open%20GL-2b2e3b?style=for-the-badge&logo=opengl&logoColor=f1fa8c)

[![wakatime](https://wakatime.com/badge/user/eaf11f95-5e2a-4b60-ae6a-38cd01ed317b/project/2c4b13a1-b570-4d8a-81a4-272e5773f087.svg?style=for-the-badge)](https://wakatime.com/badge/user/eaf11f95-5e2a-4b60-ae6a-38cd01ed317b/project/2c4b13a1-b570-4d8a-81a4-272e5773f087)

[![Testing](https://github.com/HapticX/engine/actions/workflows/tests.yml/badge.svg)](https://github.com/HapticX/engine/actions/workflows/tests.yml)

</div>


## Install
### Install dependencies
#### Win/MacOS
Put all of these libraries in `./nimble/bin/` folder:
- [SDL2](https://github.com/libsdl-org/SDL)
- [SDL2-ttf](https://github.com/libsdl-org/SDL_ttf/)
- [SDL2-mixer](https://github.com/libsdl-org/SDL_mixer)
- [SDL2-image](https://github.com/libsdl-org/SDL_image)
#### Unix
```bash
sudo apt install --fix-missing -y libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev
```

### Install engine
```bash
nimble install https://github.com/HapticX/engine
```
