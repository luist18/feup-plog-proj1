:- consult('util.pl').
:- consult('menus.pl').
:- consult('board.pl').
:- consult('input.pl').
:- consult('movement.pl').
:- consult('dragons.pl').
:- consult('captures.pl').
:- consult('game.pl').
:- use_module(library(lists)).
:- use_module(library(random)).

:- dynamic(current_state/1).

play :- main_menu.