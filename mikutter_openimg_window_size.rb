# -*- coding: utf-8 -*-

Plugin.create(:mikutter_openimg_window_size) do

  UserConfig[:openimg_window_size_width_percent] ||= 70
  UserConfig[:openimg_window_size_height_percent] ||= 70
  UserConfig[:openimg_window_size_reference] ||= :full
  UserConfig[:openimg_window_size_reference_manual_num] ||= 0

  settings('画像ビューア') do
    settings('ウィンドウサイズ') do
      adjustment('幅 (%)', :openimg_window_size_width_percent, 1, 100)
      adjustment('高さ (%)', :openimg_window_size_height_percent, 1, 100)
      select('サイズの基準', :openimg_window_size_reference) do
        option(:full, 'デスクトップ全体')
        option(:mainwindow, 'メインウィンドウがあるディスプレイ')
        option(:manual, 'ディスプレイ番号を指定') do
          adjustment('ディスプレイ番号', :openimg_window_size_reference_manual_num, 0, 99)
        end
      end
    end
  end
  
end

class Plugin::Openimg::Window

  def default_size
    case UserConfig[:openimg_window_size_reference]
    when :full
      width = screen.width
      height = screen.height
    when :mainwindow
      mainwindow = Plugin[:gtk].widgetof(Plugin::GUI::Window.instance(:default))
      geometry = screen.monitor_geometry(screen.get_monitor(mainwindow.window))
      width = geometry.width
      height = geometry.height
    when :manual
      monitor = UserConfig[:openimg_window_size_reference_manual_num]
      max_monitor = screen.n_monitors
      if monitor > max_monitor
        monitor = 0
      end

      geometry = screen.monitor_geometry(monitor)
      width = geometry.width
      height = geometry.height
    end

    @size || [width * (UserConfig[:openimg_window_size_width_percent] / 100.0),
              height * (UserConfig[:openimg_window_size_height_percent] / 100.0)]
  end
  
end
