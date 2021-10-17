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

module Plugin::OpenimgWindowSize
  module Overrides
    def default_size
      case UserConfig[:openimg_window_size_reference]
      when :full
        width = screen.width
        height = screen.height
      when :mainwindow
        gtk = Plugin.instance_exist?(:gtk) ? Plugin[:gtk] : Plugin[:gtk3]
        mainwindow = gtk.widgetof(Plugin::GUI::Window.instance(:default))
        geometry = Plugin::OpenimgWindowSize.get_monitor_geometry(screen, screen.get_monitor(mainwindow.window))
        width = geometry.width
        height = geometry.height
      when :manual
        monitor = UserConfig[:openimg_window_size_reference_manual_num]
        max_monitor = screen.n_monitors
        if monitor > max_monitor
          monitor = 0
        end

        geometry = Plugin::OpenimgWindowSize.get_monitor_geometry(screen, monitor)
        width = geometry.width
        height = geometry.height
      end

      @size || [width * (UserConfig[:openimg_window_size_width_percent] / 100.0),
                height * (UserConfig[:openimg_window_size_height_percent] / 100.0)]
    end
  end

  def self.get_monitor_geometry(screen, monitor)
    if screen.respond_to?(:monitor_geometry)
      screen.monitor_geometry(monitor)
    else
      screen.get_monitor_geometry(monitor)
    end
  end
end

if defined? Plugin::OpenimgGtk::Window
  Plugin::OpenimgGtk::Window.prepend(Plugin::OpenimgWindowSize::Overrides)
else
  Plugin::Openimg::Window.prepend(Plugin::OpenimgWindowSize::Overrides)
end
