extends Node

#Card-related events
signal card_drag_started(card_ui: CardUI)
signal card_drag_ended(card_ui: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card: Card)
signal card_tooltip_requested(card: Card)
signal tooltip_hide_requested

#Player related events
signal player_hand_drawn
signal player_hand_discarded
signal player_turn_ended
signal player_hit
signal player_died(player: Player)

#Enemy related events
signal enemy_action_completed(enemy: Enemy)
signal enemy_turn_ended
signal enemy_died(enemy: Enemy)

#battle related events
signal battle_over_screen_requested(text: String, type: BattleOverPanel.Type)
signal battle_won
signal game_over

# map related events
signal map_exited(room: Room)
signal room_enter_requested(room: MapRoom)

# shop related events
# signal shop_relic_bought(relic: Relic, gold_cost: int)
signal shop_card_bought(card: Card, gold_cost: int)
signal shop_exited

# rivers of reflection related events
signal rivers_of_reflection_exited

# battle reward related events
signal battle_reward_exited

# treasure room related events
signal treasure_room_exited
