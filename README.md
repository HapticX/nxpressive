<div align="center">

## ` N X p r e s s i v e `
experimental UI/2D engine written in Nim with :heart:

![Nim language](https://img.shields.io/badge/>=1.0.0-1b1e2b?style=for-the-badge&logo=nim&logoColor=f1fa8c&label=Nim&labelColor=2b2e3b)
![Open GL](https://img.shields.io/badge/Open%20GL-2b2e3b?style=for-the-badge&logo=opengl&logoColor=f1fa8c)
![Vulkan](https://img.shields.io/badge/Vulkan-2b2e3b?style=for-the-badge&logo=vulkan&logoColor=f1fa8c)
![SDL2](https://img.shields.io/badge/SDL2-2b2e3b?style=for-the-badge&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAAAXNSR0IArs4c6QAAAo5JREFUeF7tmDtOAzEQhj2AuAAlDT0H4A40AZpUSBSUBIkuEURECa+aINEg0dCkikjDHag5AAWXiBTWaBErHOPHeB2HeD0po/HY/uaf8cwCS/wHid+fEQBSQOIEKAUSFwAVQUoBSoHECVAKJC4AegUoBSgFKkCg/rzL82sMakNnRTsvWEReBCB1BeSqlFVQH+08Mg4HtrSoRArIAAoYRbqaIFQOgFyjZqqAVq//XW1Vv+t2YwqmyTZfL9urfMo+xDVilAHgkHP+4Hr53B6tANuFxEthbMXDqmCofOgAqODZIl+sQQHAXqg4INbeBMEHAPbyKAW4XMYHgJwWNgBTUecc6qO9TPwPC8GqgCgACM+gK4TSAORoi/npAk08MGfs6abd2M//c1HA1LPH+TsD2Pjx+zmoDVdM3aszgDLVW1X1dZBMaaTb+08T9NMZYuaDfwNgi3IZBYh5j50PKgsAO7Q5A8A0MS7R0zU7WB/YSOuAlAJQONPlJPbwqjQoUwOw0VbZeQHQqaFSAHTFyqeLE9f6poBP9FGdYG50enG/nvHJh2kzWx+ATZeFS4Hi0q3eXcYY16ZM5QH8grCPxJWrAbL0Z9nFRVEDVLnf7PbfANimqhhiFWCyw/qYSxHUbeIbvaQBNLu3RwDQl+Eu3CuQR8n1k1XZcVhsrFx9YKbUIJ0gtgZgctX2lGL7EMxehY2xFe50Oqvj5bUx1mHoT2JzB+AiQ5/oqWYKl70xE2qpadDlED4AsDVm7grADEI+0YNssn11fvKCfWZ1dkvAty7Pjl+xqSraWcfhMk5jWkMAYopWiLOSAkJQjcknKSCmaIU4KykgBNWYfJICYopWiLOSAkJQjcknKSCmaIU4a/IK+AKpP99QxkaIhgAAAABJRU5ErkJggg==&logoColor=f1fa8c)

[![wakatime](https://wakatime.com/badge/user/eaf11f95-5e2a-4b60-ae6a-38cd01ed317b/project/2c4b13a1-b570-4d8a-81a4-272e5773f087.svg?style=for-the-badge)](https://wakatime.com/badge/user/eaf11f95-5e2a-4b60-ae6a-38cd01ed317b/project/2c4b13a1-b570-4d8a-81a4-272e5773f087)

[![Testing](https://github.com/HapticX/engine/actions/workflows/tests.yml/badge.svg?style=for-the-badge)](https://github.com/HapticX/engine/actions/workflows/tests.yml)

</div>

## Why HapticX? :new_moon_with_face:
It's simple to use and have a lot of sugar in syntax :eyes:.

### Features :sparkles:
- Support `C`/`Cpp`/`ObjC`/`JS` backends;
- Support earlier versions (`1.0.0` and above);
- Support graphics backends:
  - `OpenGL`/`Vulkan` for `C`/`Cpp`/`ObjC`;
  - `WebGl` for `JS`.
- Event handling via `@` macro;

## Why Nim? :crown:
It's simple to use and has flexible syntax :smiley:


## Install :inbox_tray:
### Dependencies
- Win/MacOS
  Put all of these libraries in `./nimble/bin/` folder:
  - [SDL2](https://github.com/libsdl-org/SDL)
  - [SDL2-ttf](https://github.com/libsdl-org/SDL_ttf/)
  - [SDL2-mixer](https://github.com/libsdl-org/SDL_mixer)
  - [SDL2-image](https://github.com/libsdl-org/SDL_image)

  Also Install [GLEW library](https://glew.sourceforge.net/)  
  And [Vulkan SDK](https://vulkan.lunarg.com/sdk/home#windows)

- Unix
  - SDL2
    ```bash
    sudo apt install --fix-missing -y libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev
    ```
  - [Vulkan SDK](https://vulkan.lunarg.com/sdk/home#linux)
    ```bash
    wget -qO- https://packages.lunarg.com/lunarg-signing-key-pub.asc | sudo tee /etc/apt/trusted.gpg.d/lunarg.asc
    sudo wget -qO /etc/apt/sources.list.d/lunarg-vulkan-1.3.239-jammy.list https://packages.lunarg.com/vul1.3.239/lunarg-vulkan-1.3.239-jammy.list
    sudo apt update
    sudo apt install -y vulkan-sdk
    ```
  - [GLEW library](https://glew.sourceforge.net/) 
    ```bash
    sudo apt install -y libglew-dev
    ``` 
### Engine
```bash
nimble install https://github.com/HapticX/engine
```

## What's Next? :bulb:
Even more features! and bugs :bug:

## Contributing :dizzy:
You can help to fix bugs and errors if you want :v:
