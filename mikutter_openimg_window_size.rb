# -*- coding: utf-8 -*-

Plugin.create(:mikutter_openimg_window_size) do

  UserConfig[:openimg_window_size_width_percent] ||= 70
  UserConfig[:openimg_window_size_height_percent] ||= 70

  settings('画像ビューア') do
    settings('ウィンドウサイズ') do
      adjustment('幅 (%)', :openimg_window_size_width_percent, 1, 100)
      adjustment('高さ (%)', :openimg_window_size_height_percent, 1, 100)
    end
  end
  
end

class Plugin::Openimg::Window

  def default_size
    @size || [screen.width * (UserConfig[:openimg_window_size_width_percent] / 100.0),
              screen.height * (UserConfig[:openimg_window_size_height_percent] / 100.0)]
  end
  
end
