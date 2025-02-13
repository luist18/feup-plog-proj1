:- consult('util.pl').
:- consult('menus.pl').
:- consult('board.pl').
:- consult('input.pl').
:- consult('movement.pl').
:- consult('dragons.pl').
:- consult('captures.pl').
:- consult('bot.pl').
:- consult('game.pl').
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).

:- init_random_state.
:- dynamic(current_state/1).

play :- main_menu.