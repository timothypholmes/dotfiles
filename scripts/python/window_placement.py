import subprocess
from AppKit import NSWorkspace, NSScreen
from Quartz import CGWindowListCopyWindowInfo, kCGWindowListOptionOnScreenOnly, kCGNullWindowID

def get_window_info():
    options = kCGWindowListOptionOnScreenOnly
    window_list = CGWindowListCopyWindowInfo(options, kCGNullWindowID)
    return window_list

def get_screen_dimensions():
    screens = NSScreen.screens()
    screen_dimensions = {}
    for screen in screens:
        frame = screen.frame()
        screen_dimensions[screen.localizedName()] = (frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
    return screen_dimensions

def move_and_resize_window(app_name, x, y, width, height):
    script = f'''
    tell application "System Events"
        set appWindows to every window of (first application process whose name is "{app_name}")
        repeat with win in appWindows
            set position of win to {{{x}, {y}}}
            set size of win to {{{width}, {height}}}
        end repeat
    end tell
    '''
    try:
        subprocess.run(['osascript', '-e', script])
        print(f"{app_name} moved to {x}, {y}, {width}, {height}")
    except subprocess.CalledProcessError as e:
        print(f"Error moving window for {app_name}: {e}")

def get_current_running_process():
    script = '''
    tell application "System Events"
        set appNames to name of every application process
    end tell
    '''
    result = subprocess.run(['osascript', '-e', script], capture_output=True, text=True)
    app_names = result.stdout.split(", ")
    filtered_names = [name for name in app_names if "com.apple.WebKit.WebContent" not in name and "plugin-container" not in name]
    for name in filtered_names:
        print(name)
