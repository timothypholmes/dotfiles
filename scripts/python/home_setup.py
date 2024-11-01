import window_placement as wp

def main():
    screen_dims = wp.get_screen_dimensions()
    print(f"Available screens {screen_dims}")
    ultra_wide = screen_dims['S34J55x']
    vertical = screen_dims['HP E273q']

    # Ultra wide monitor dimensions
    ultra_width = ultra_wide[2]
    ultra_height = ultra_wide[3]

    # Vertical monitor dimensions
    vert_width = vertical[2]
    vert_height = vertical[3]

    vertical_x_offset = vertical[0]
    vertical_y_offset = vertical[1] - 170

    wp.get_current_running_process()

    # Position and resize windows
    wp.move_and_resize_window('Spotify', 0, 0, ultra_width // 3, ultra_height)
    wp.move_and_resize_window('Firefox', 0, 0, ultra_width // 2, ultra_height)
    wp.move_and_resize_window('ChatGPT', ultra_width // 3, 0, ultra_width // 3, ultra_height)
    wp.move_and_resize_window('Obsidian', ultra_width // 2, 0, ultra_width // 2, ultra_height)
    wp.move_and_resize_window('Electron', ultra_width // 2, 0, ultra_width // 2, ultra_height) #vscode/codium

    wp.move_and_resize_window('Finder', vertical_x_offset, vertical_y_offset, vert_width, vert_height // 3)
    wp.move_and_resize_window('iTerm2', vertical_x_offset, vertical_y_offset, vert_width, vert_height // 3)
    wp.move_and_resize_window('MSTeams', vertical_x_offset, vertical_y_offset + (vert_height // 3), vert_width, vert_height // 3)
    wp.move_and_resize_window('Microsoft Outlook', vertical_x_offset, vertical_y_offset + (2 * (vert_height // 3)), vert_width, vert_height // 3)

if __name__ == "__main__":
    main()
