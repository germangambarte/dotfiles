import random

import pyray as rl


class Walker:
    x: int
    y: int

    def __init__(self, screen_width, screen_height) -> None:
        self.x = screen_width // 2
        self.y = screen_height // 2

    def show(self):
        rl.draw_pixel(self.x, self.y, rl.WHITE)

    def step(self):
        self.x += random.randint(-1, 1)
        self.y += random.randint(-1, 1)


SCREEN_WIDTH, SCREEN_HEIGHT = 1280, 720
rl.init_window(SCREEN_WIDTH, SCREEN_HEIGHT, "chO_introduction")
rl.set_target_fps(60)

walker = Walker(SCREEN_WIDTH, SCREEN_HEIGHT)

rl.begin_drawing()
rl.clear_background(rl.BLACK)
rl.end_drawing()

while not rl.window_should_close():
    rl.begin_drawing()
    walker.show()
    walker.step()
    rl.end_drawing()
