package loadr

import "core:fmt"
import "core:os"
import "core:strings"
import rl "vendor:raylib"

AssetStorage :: struct {
	images: map[string]rl.Texture2D,
	fonts:  map[string]rl.Font,
	sounds: map[string]rl.Sound,
}

add_image :: proc(asset_storage: ^AssetStorage, img_name: string, img: rl.Image) {
  texture := rl.LoadTextureFromImage(img) 
  map_insert(&asset_storage.images, img_name, texture)
}

add_sound :: proc(asset_storage: ^AssetStorage, sound_name: string, sound: rl.Sound) {
  map_insert(&asset_storage.sounds, name, sound)
}

add_fonts :: proc(asset_storage: ^AssetStorage, font_name: string, font: rl.Font) {
  map_insert(&asset_storage.fonts, name, font)
}

AssetManager :: struct {
	storage: AssetStorage,
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
			if strings.ends_with(info.name, ".png") {
				asset_name, _ := strings.replace(info.name, ".png", "", 0)
        asset_path := strings.clone_to_cstring(info.fullpath)
				if strings.contains(info.fullpath, "images") {
          add_image(&asset_manager.storage, asset_name, rl.LoadImage(asset_path))

				}
			} else if strings.ends_with(info.name, ".mp3") {
				asset_name, _ := strings.replace(info.name, ".mp3", "", 0)
        asset_path := strings.clone_to_cstring(info.fullpath)
				if strings.contains(info.fullpath, "sounds") {
          add_sound(&asset_manager.storage, asset_name, rl.LoadSound(asset_path))
				}
			} else if strings.ends_with(info.name, ".ttf") {
				asset_name, _ := strings.replace(info.name, ".ttf", "", 0)
        asset_path := strings.clone_to_cstring(info.fullpath)
				if strings.contains(info.fullpath, "sounds") {
          add_sound(&asset_manager.storage, asset_name, rl.LoadSound(asset_path))
				}
			}
		}
	}
}
init :: proc(asset_manager: ^AssetManager, assets_path: string) {
	load_assets(asset_manager, assets_path)

  for name, tex in asset_manager.storage.images {
    fmt.println("Loaded image:", name)
  }
  for name, sound in asset_manager.storage.sounds {
      fmt.println("Loaded sound:", name)
  }
}

get_image :: proc(asset_manager: ^AssetManager, img_name: string) -> rl.Texture2D {
  return asset_manager.storage.images[img_name]
}

get_sound :: proc(asset_manager: ^AssetManager, sound_name: string) -> rl.Sound {
  return asset_manager.storage.sounds[sound_name]
}

get_fonts :: proc(asset_manager: ^AssetManager, font_name: string) -> rl.Font {
  return asset_manager.storage.fonts[font_name]
}
