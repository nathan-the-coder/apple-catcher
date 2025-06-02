package loadr

import "core:fmt"
import "core:os"
import "core:strings"
import rl "vendor:raylib"

AssetStorage :: struct {
	textures: map[string]rl.Texture2D,
	fonts:  map[string]rl.Font,
	sounds: map[string]rl.Sound,
}

AssetHandler :: struct {
  ext: string,
  folder: string,
  add_proc: proc(^AssetStorage, string, cstring)
}

add_texture :: proc(asset_storage: ^AssetStorage, texture_name: string, texture_path: cstring) {
  texture := rl.LoadTexture(texture_path)
  map_insert(&asset_storage.textures, texture_name, texture)
}

add_sound :: proc(asset_storage: ^AssetStorage, sound_name: string, sound_path: cstring) {
  sound := rl.LoadSound(sound_path)
  map_insert(&asset_storage.sounds, sound_name, sound)
}

add_font :: proc(asset_storage: ^AssetStorage, font_name: string, font_path: cstring) {
  font := rl.LoadFont(font_path)
  map_insert(&asset_storage.fonts, font_name, font)
}

AssetManager :: struct {
	storage: AssetStorage,
  asset_handlers: [3]AssetHandler,
}

init :: proc(asset_manager: ^AssetManager, assets_path: string) {
	load_assets(asset_manager, assets_path)

  asset_manager.asset_handlers[0] = AssetHandler{
    ext = ".png",
    folder = "images",
    add_proc = add_texture,
  }

  asset_manager.asset_handlers[1] = AssetHandler{
    ext = ".mp3",
    folder = "sounds",
    add_proc = add_sound,
  }

  asset_manager.asset_handlers[1] = AssetHandler{
    ext = ".ttf",
    folder = "fonts",
    add_proc = add_font,
  }
}

remove_extension :: proc(filename: string, ext: string) -> string {
    base, _ := strings.replace(filename, ext, "", 1)
    return base
}


load_assets :: proc(asset_manager: ^AssetManager, path: string) {
	dir, err := os.open(path, os.O_RDONLY)
	if err != nil {
		panic("Failed to open directory")
	}
	infos, _ := os.read_dir(dir, 256)
	for info in infos {
		if info.is_dir {
			load_assets(asset_manager, info.fullpath)
		} else {
      for handler in asset_manager.asset_handlers {
        if strings.ends_with(info.name, handler.ext) {
          name := remove_extension(info.name, handler.ext)
          path := strings.clone_to_cstring(info.fullpath)

          if strings.contains(info.fullpath, handler.folder) {
            if !(name in asset_manager.storage.fonts) {
              fmt.eprintln("Duplicated assets detected, modifying name of the duplicate!")
              name = strings.concatenate([]string{name, "_1"})
            }

            handler.add_proc(&asset_manager.storage, name, path)
          }
        }
      }
		}
	}
}

get_texture :: proc(asset_manager: ^AssetManager, texture_name: string) -> rl.Texture2D {
  if !(texture_name in asset_manager.storage.textures) {
    fmt.eprintln("'%s' doesn't exists in storage.", texture_name)
  }
  return asset_manager.storage.textures[texture_name]
}

get_sound :: proc(asset_manager: ^AssetManager, sound_name: string) -> rl.Sound {
  return asset_manager.storage.sounds[sound_name]
}

get_font :: proc(asset_manager: ^AssetManager, font_name: string) -> rl.Font {
  return asset_manager.storage.fonts[font_name]
}

unload :: proc(asset_manager: ^AssetManager) {
  if len(asset_manager.storage.textures) != 0 {
    for _, texture in asset_manager.storage.textures {
      rl.UnloadTexture(texture)
    }
  }

  if len(asset_manager.storage.sounds) != 0 {
    for _, sound in asset_manager.storage.sounds {
      rl.UnloadSound(sound)
    }
  }

  if len(asset_manager.storage.fonts) != 0 {
    for _, font in asset_manager.storage.fonts {
      rl.UnloadFont(font)
    }
  }
}
