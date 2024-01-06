#ifndef KEYBOARD_H
#define KEYBOARD_H
    #include <termios.h>
    #include <linux/input.h>

    #define KEYBOARD_MAX_DEVICES 128
    /// dchar* KEYBOARD_NOKEYS="---\0";

    typedef struct Keyboard {
        int num_devices;
        struct termios oldt;
        struct termios newt;
        char **device_paths;
        int *index000;
        char key_state[KEY_MAX];
        int device;
        struct input_event ev;
    } Keyboard;

    Keyboard* keyboard_new();
    int is_keyboard(const char *device_path);
    int find_keyboard_devices(char **device_paths);
    int keyboard_refresh(Keyboard *self);
    int keyboard_contains(Keyboard *self, const char *keys);
    // return NULL when no key is pressed
    char* keyboard_get_pressed(Keyboard *self);
    int keyboard_deinit(Keyboard *self);

#endif