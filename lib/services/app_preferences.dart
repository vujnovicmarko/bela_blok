import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AppPreferences {
  static const String _themePrefKey = "theme_mode";
  static const String _targetKey = "target";
  static const String _startingDealerKey = "starting_dealer";
  static const String _playingDirectionKey = "playing_direction";
  static const String _isActiveGamesExpandedKey = "is_active_games_expanded";
  static const String _isFinishedGamesExpandedKey =
      "is_finished_games_expanded";
  static const String _player1IdKey = "player1_id";
  static const String _player2IdKey = "player2_id";
  static const String _player3IdKey = "player3_id";
  static const String _player4IdKey = "player4_id";

  static const int defaultTarget = 1001;
  static const String defaultStartingDealer = "random";
  static const String defaultPlayingDirection = "counter-clockwise";
  static const bool defaultIsActiveGamesExpanded = true;
  static const bool defaultIsFinishedGamesExpanded = false;

  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTheme = prefs.getString(_themePrefKey);

    if (savedTheme == "light") return ThemeMode.light;

    if (savedTheme == "dark") return ThemeMode.dark;

    return ThemeMode.system;
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_themePrefKey, mode.name);
  }

  static Future<int> getTarget() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_targetKey) ?? defaultTarget;
  }

  static Future<void> setTarget(int target) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_targetKey, target);
  }

  static Future<String> getStartingDealer() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_startingDealerKey) ?? defaultStartingDealer;
  }

  static Future<void> setStartingDealer(String dealer) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_startingDealerKey, dealer);
  }

  static Future<String> getPlayingDirection() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_playingDirectionKey) ?? defaultPlayingDirection;
  }

  static Future<void> setPlayingDirection(String direction) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_playingDirectionKey, direction);
  }

  static Future<bool> getIsActiveGamesExpanded() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_isActiveGamesExpandedKey) ??
        defaultIsActiveGamesExpanded;
  }

  static Future<void> setIsActiveGamesExpanded(bool isExpanded) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_isActiveGamesExpandedKey, isExpanded);
  }

  static Future<bool> getIsFinishedGamesExpanded() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_isFinishedGamesExpandedKey) ??
        defaultIsFinishedGamesExpanded;
  }

  static Future<void> setIsFinishedGamesExpanded(bool isExpanded) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_isFinishedGamesExpandedKey, isExpanded);
  }

  static Future<int?> getPlayer1Id() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_player1IdKey);
  }

  static Future<void> setPlayer1Id(int? playerId) async {
    final prefs = await SharedPreferences.getInstance();

    if (playerId != null) {
      await prefs.setInt(_player1IdKey, playerId);
    } else {
      await prefs.remove(_player1IdKey);
    }
  }

  static Future<int?> getPlayer2Id() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_player2IdKey);
  }

  static Future<void> setPlayer2Id(int? playerId) async {
    final prefs = await SharedPreferences.getInstance();

    if (playerId != null) {
      await prefs.setInt(_player2IdKey, playerId);
    } else {
      await prefs.remove(_player2IdKey);
    }
  }

  static Future<int?> getPlayer3Id() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_player3IdKey);
  }

  static Future<void> setPlayer3Id(int? playerId) async {
    final prefs = await SharedPreferences.getInstance();

    if (playerId != null) {
      await prefs.setInt(_player3IdKey, playerId);
    } else {
      await prefs.remove(_player3IdKey);
    }
  }

  static Future<int?> getPlayer4Id() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_player4IdKey);
  }

  static Future<void> setPlayer4Id(int? playerId) async {
    final prefs = await SharedPreferences.getInstance();

    if (playerId != null) {
      await prefs.setInt(_player4IdKey, playerId);
    } else {
      await prefs.remove(_player4IdKey);
    }
  }
}
