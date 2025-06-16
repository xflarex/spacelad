extends Node

var score = 0
var screen_size
var asteroid_speed = 650

enum state{START_MENU, MAIN_GAME, BOSS_MODE, GAME_OVER, PAUSE_MENU}
var gamestate = state.START_MENU
var gamestate_previous = state.START_MENU
