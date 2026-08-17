class_name LayerConfig
extends Node



enum TEAM {PLAYER, ENEMY}


const PLAYER_LAYER := 1 << 10
const ENEMY_LAYER := 1 << 11
const WALL_LAYER := 1 << 12

## 獲取自己碰撞層
static func scan_self(team: TEAM)-> int:
	if team == TEAM.PLAYER:
		return PLAYER_LAYER
	return ENEMY_LAYER

## 獲取敵對碰撞層
static func scan_enemy(team: TEAM)-> int:
	if team == TEAM.PLAYER:
		return ENEMY_LAYER
	return PLAYER_LAYER

static func scan_wall()-> int: return WALL_LAYER
